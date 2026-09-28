import random
from datetime import timedelta

from django.conf import settings
from django.contrib.auth import authenticate, get_user_model
from django.db.models import Q
from django.utils import timezone
from rest_framework import mixins, status, viewsets
from django.contrib.auth.hashers import make_password
from rest_framework.authtoken.models import Token
from rest_framework.decorators import action, api_view, authentication_classes, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .ai import compute_today_summary, diagnose_from_symptoms, farm_or_none, generate_ai_response
from .models import (
    AppNotification,
    ChatMessage,
    CommunityComment,
    CommunityLike,
    CommunityPost,
    FarmProfile,
    FeedInventoryItem,
    FinanceRecord,
    MarketplaceItem,
    PoultryBatch,
    ProductionLog,
    ServiceProvider,
    SickChickenReport,
    TrainingModule,
    UserSettings,
    VaccinationItem,
    VerificationCode,
    VetConsultation,
    VetProfile,
)
from .serializers import (
    AppNotificationSerializer,
    ChangePasswordSerializer,
    ChatMessageSerializer,
    CommunityPostSerializer,
    FarmProfileSerializer,
    FeedInventoryItemSerializer,
    FinanceRecordSerializer,
    ForgotPasswordSerializer,
    LoginSerializer,
    MarketplaceItemSerializer,
    OtpSerializer,
    PoultryBatchSerializer,
    ProductionLogSerializer,
    RegisterSerializer,
    ResetPasswordSerializer,
    ServiceProviderSerializer,
    SickChickenReportSerializer,
    TrainingModuleSerializer,
    UserSettingsSerializer,
    VaccinationItemSerializer,
    VetConsultationSerializer,
    VetProfileSerializer,
)

User = get_user_model()


def _normalize_identifier(value):
    return (value or '').strip()


def _create_otp(identifier, purpose, extra_data=None):
    VerificationCode.objects.filter(identifier=identifier, purpose=purpose, is_used=False).update(is_used=True)
    code = f'{random.randint(0, 999999):06d}'
    record = VerificationCode.objects.create(
        identifier=identifier,
        code=code,
        purpose=purpose,
        extra_data=extra_data or {},
        expires_at=timezone.now() + timedelta(minutes=getattr(settings, 'OTP_EXPIRY_MINUTES', 10)),
    )
    return record


def _otp_payload(otp):
    data = {
        'identifier': otp.identifier,
        'purpose': otp.purpose,
        'expires_at': otp.expires_at,
        'message': 'Verification code created. Enter the 6-digit OTP to continue.',
    }
    if settings.DEBUG:
        data['otp'] = otp.code
    return data


def _issue_auth_payload(user):
    token, _ = Token.objects.get_or_create(user=user)
    farm = farm_or_none(user)
    settings_obj, _ = UserSettings.objects.get_or_create(user=user)
    return {
        'token': token.key,
        'user_id': str(user.id),
        'setup_complete': bool(farm and farm.setup_complete),
        'settings': UserSettingsSerializer(settings_obj).data,
    }


def _get_or_create_farm(user):
    farm, _ = FarmProfile.objects.get_or_create(
        user=user,
        defaults={
            'farmer_name': user.get_full_name() or user.username,
            'email': user.email or '',
            'phone': user.phone or '',
        },
    )
    return farm


def _notify(user, title, message, ntype):
    return AppNotification.objects.create(user=user, title=title, message=message, type=ntype)


def _create_farmer_account(farmer_name, phone, email, hashed_password):
    username = (email or phone)[:150]
    user = User(
        username=username,
        email=email or '',
        first_name=farmer_name or '',
        phone=phone,
    )
    user.password = hashed_password
    user.save()
    UserSettings.objects.get_or_create(user=user)
    FarmProfile.objects.get_or_create(
        user=user,
        defaults={'farmer_name': farmer_name or '', 'email': email or '', 'phone': phone},
    )
    ChatMessage.objects.create(
        user=user,
        sender='kuku_ai',
        text=(
            f'Habari {farmer_name or user.username}! '
            'Mimi ni KukuAI - Msaidizi wako wa digitali wa ufugaji kuku. '
            'Una swali gani leo kuhusu afya, utagaji au lishe ya kuku wako?'
        ),
    )
    return user


class RegisterView(APIView):
    """Create the farmer account immediately and return an auth token (no OTP step)."""

    permission_classes = [AllowAny]

    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data
        phone = _normalize_identifier(data['phone'])
        email = _normalize_identifier(data.get('email'))

        if User.objects.filter(phone=phone).exists():
            return Response({'detail': 'An account with this phone number already exists.'}, status=status.HTTP_400_BAD_REQUEST)
        if email and User.objects.filter(email__iexact=email).exists():
            return Response({'detail': 'An account with this email already exists.'}, status=status.HTTP_400_BAD_REQUEST)

        user = _create_farmer_account(data['farmer_name'], phone, email, make_password(data['password']))
        return Response(_issue_auth_payload(user), status=status.HTTP_201_CREATED)


class VerifyOtpView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = OtpSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        identifier = _normalize_identifier(serializer.validated_data['identifier'])
        code = serializer.validated_data['code']
        purpose = serializer.validated_data.get('purpose') or VerificationCode.PURPOSE_REGISTER

        otp = (
            VerificationCode.objects.filter(identifier=identifier, purpose=purpose, is_used=False, code=code)
            .order_by('-created_at')
            .first()
        )
        if not otp or otp.expires_at < timezone.now():
            return Response({'detail': 'Invalid or expired OTP.'}, status=status.HTTP_400_BAD_REQUEST)

        otp.is_used = True
        otp.save(update_fields=['is_used'])

        if purpose == VerificationCode.PURPOSE_REGISTER:
            payload = otp.extra_data
            user = _create_farmer_account(
                payload.get('farmer_name', ''),
                payload.get('phone') or identifier,
                payload.get('email', ''),
                payload.get('password') or make_password(User.objects.make_random_password()),
            )
            return Response(_issue_auth_payload(user), status=status.HTTP_201_CREATED)

        if purpose == VerificationCode.PURPOSE_LOGIN:
            user = User.objects.filter(Q(phone=identifier) | Q(email__iexact=identifier) | Q(username=identifier)).first()
            if not user:
                return Response({'detail': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)
            return Response(_issue_auth_payload(user))

        return Response({'detail': 'OTP verified.', 'identifier': identifier})


class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        identifier = _normalize_identifier(serializer.validated_data['identifier'])
        password = serializer.validated_data['password']
        user = User.objects.filter(Q(phone=identifier) | Q(email__iexact=identifier) | Q(username=identifier)).first()
        if user:
            user = authenticate(request, username=user.username, password=password)
        if not user:
            return Response({'detail': 'Invalid phone/email or password.'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(_issue_auth_payload(user))


class RequestOtpView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        identifier = _normalize_identifier(request.data.get('identifier'))
        purpose = request.data.get('purpose') or VerificationCode.PURPOSE_LOGIN
        if not identifier:
            return Response({'detail': 'identifier is required.'}, status=status.HTTP_400_BAD_REQUEST)
        if purpose == VerificationCode.PURPOSE_LOGIN:
            if not User.objects.filter(Q(phone=identifier) | Q(email__iexact=identifier)).exists():
                return Response({'detail': 'No account found for this phone/email.'}, status=status.HTTP_404_NOT_FOUND)
        otp = _create_otp(identifier, purpose)
        return Response(_otp_payload(otp))


class ForgotPasswordView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = ForgotPasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        identifier = _normalize_identifier(serializer.validated_data['identifier'])
        if not User.objects.filter(Q(phone=identifier) | Q(email__iexact=identifier)).exists():
            return Response({'detail': 'No account found for this phone/email.'}, status=status.HTTP_404_NOT_FOUND)
        otp = _create_otp(identifier, VerificationCode.PURPOSE_RESET)
        return Response(_otp_payload(otp))


class ResetPasswordView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = ResetPasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        identifier = _normalize_identifier(serializer.validated_data['identifier'])
        code = serializer.validated_data['code']
        otp = (
            VerificationCode.objects.filter(
                identifier=identifier, purpose=VerificationCode.PURPOSE_RESET, is_used=False, code=code
            )
            .order_by('-created_at')
            .first()
        )
        if not otp or otp.expires_at < timezone.now():
            return Response({'detail': 'Invalid or expired OTP.'}, status=status.HTTP_400_BAD_REQUEST)
        user = User.objects.filter(Q(phone=identifier) | Q(email__iexact=identifier)).first()
        if not user:
            return Response({'detail': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)
        user.set_password(serializer.validated_data['new_password'])
        user.save(update_fields=['password'])
        otp.is_used = True
        otp.save(update_fields=['is_used'])
        Token.objects.filter(user=user).delete()
        return Response(_issue_auth_payload(user))


class ChangePasswordView(APIView):
    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        if not request.user.check_password(serializer.validated_data['old_password']):
            return Response({'detail': 'Old password is incorrect.'}, status=status.HTTP_400_BAD_REQUEST)
        request.user.set_password(serializer.validated_data['new_password'])
        request.user.save(update_fields=['password'])
        Token.objects.filter(user=request.user).delete()
        token = Token.objects.create(user=request.user)
        return Response({'token': token.key, 'message': 'Password changed.'})


class LogoutView(APIView):
    def post(self, request):
        Token.objects.filter(user=request.user).delete()
        return Response({'message': 'Logged out.'})


class BootstrapView(APIView):
    def get(self, request):
        user = request.user
        farm = _get_or_create_farm(user)
        settings_obj, _ = UserSettings.objects.get_or_create(user=user)
        ctx = {'request': request}
        return Response(
            {
                'farm_profile': FarmProfileSerializer(farm).data,
                'today_summary': compute_today_summary(user),
                'settings': UserSettingsSerializer(settings_obj).data,
                'poultry_batches': PoultryBatchSerializer(PoultryBatch.objects.filter(user=user), many=True).data,
                'production_logs': ProductionLogSerializer(ProductionLog.objects.filter(user=user), many=True).data,
                'feed_inventory': FeedInventoryItemSerializer(FeedInventoryItem.objects.filter(user=user), many=True).data,
                'vaccinations': VaccinationItemSerializer(VaccinationItem.objects.filter(user=user), many=True).data,
                'marketplace_items': MarketplaceItemSerializer(MarketplaceItem.objects.all(), many=True, context=ctx).data,
                'service_providers': ServiceProviderSerializer(ServiceProvider.objects.all(), many=True).data,
                'training_modules': TrainingModuleSerializer(TrainingModule.objects.all(), many=True).data,
                'community_posts': CommunityPostSerializer(CommunityPost.objects.all(), many=True, context=ctx).data,
                'finance_records': FinanceRecordSerializer(FinanceRecord.objects.filter(user=user), many=True).data,
                'notifications': AppNotificationSerializer(AppNotification.objects.filter(user=user), many=True).data,
                'chat_messages': ChatMessageSerializer(ChatMessage.objects.filter(user=user), many=True, context=ctx).data,
                'vets': VetProfileSerializer(VetProfile.objects.all(), many=True).data,
                'vet_consultations': VetConsultationSerializer(
                    VetConsultation.objects.filter(user=user), many=True, context=ctx
                ).data,
                'sick_chicken_reports': SickChickenReportSerializer(
                    SickChickenReport.objects.filter(user=user), many=True, context=ctx
                ).data,
            }
        )


class FarmProfileView(APIView):
    def get(self, request):
        farm = _get_or_create_farm(request.user)
        return Response(FarmProfileSerializer(farm).data)

    def put(self, request):
        farm = _get_or_create_farm(request.user)
        serializer = FarmProfileSerializer(farm, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        farm = serializer.save()
        farm.setup_complete = True
        farm.save()
        return Response(FarmProfileSerializer(farm).data)

    def patch(self, request):
        return self.put(request)


class UserSettingsView(APIView):
    def get(self, request):
        obj, _ = UserSettings.objects.get_or_create(user=request.user)
        return Response(UserSettingsSerializer(obj).data)

    def put(self, request):
        obj, _ = UserSettings.objects.get_or_create(user=request.user)
        serializer = UserSettingsSerializer(obj, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)

    def patch(self, request):
        return self.put(request)


class OwnedViewSet(viewsets.ModelViewSet):
    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class PoultryBatchViewSet(OwnedViewSet):
    queryset = PoultryBatch.objects.all()
    serializer_class = PoultryBatchSerializer

    def perform_create(self, serializer):
        batch = serializer.save(user=self.request.user)
        farm = _get_or_create_farm(self.request.user)
        farm.total_chickens += batch.quantity
        farm.save(update_fields=['total_chickens'])


class ProductionLogViewSet(OwnedViewSet):
    queryset = ProductionLog.objects.all()
    serializer_class = ProductionLogSerializer

    def perform_create(self, serializer):
        log = serializer.save(user=self.request.user)
        if log.feed_kg:
            feed = FeedInventoryItem.objects.filter(user=self.request.user).order_by('-current_stock_kg').first()
            if feed:
                feed.current_stock_kg = max(feed.current_stock_kg - log.feed_kg, 0)
                feed.save(update_fields=['current_stock_kg'])
        if log.mortality:
            farm = farm_or_none(self.request.user)
            if farm:
                farm.total_chickens = max(farm.total_chickens - log.mortality, 0)
                farm.save(update_fields=['total_chickens'])


class FeedInventoryViewSet(OwnedViewSet):
    queryset = FeedInventoryItem.objects.all()
    serializer_class = FeedInventoryItemSerializer

    @action(detail=False, methods=['post'])
    def add_stock(self, request):
        feed_type = request.data.get('type') or request.data.get('feed_type')
        kg = float(request.data.get('kg_added') or request.data.get('current_stock_kg') or 0)
        if not feed_type:
            return Response({'detail': 'type is required.'}, status=status.HTTP_400_BAD_REQUEST)
        item = FeedInventoryItem.objects.filter(user=request.user, type__iexact=feed_type).first()
        if item:
            item.current_stock_kg += kg
            item.save(update_fields=['current_stock_kg'])
        else:
            item = FeedInventoryItem.objects.create(
                user=request.user,
                name=request.data.get('name') or f'{feed_type} Mash',
                current_stock_kg=kg,
                total_capacity_kg=float(request.data.get('total_capacity_kg') or 500),
                type=feed_type,
                cost_per_kg=float(request.data.get('cost_per_kg') or 1360),
            )
        return Response(FeedInventoryItemSerializer(item).data, status=status.HTTP_201_CREATED)


class VaccinationViewSet(OwnedViewSet):
    queryset = VaccinationItem.objects.all()
    serializer_class = VaccinationItemSerializer

    def perform_create(self, serializer):
        item = serializer.save(user=self.request.user)
        kind = 'Dawa' if item.item_type == 'deworming' else 'Chanjo'
        _notify(
            self.request.user,
            f'Kumbukumbu ya {kind}: {item.disease_name}',
            f'{item.disease_name} ({item.vaccine_name}) imewekwa kwenye kalenda kwa ajili ya {item.target_age}.',
            'Chanjo',
        )


class MarketplaceViewSet(viewsets.ModelViewSet):
    queryset = MarketplaceItem.objects.all()
    serializer_class = MarketplaceItemSerializer

    def perform_create(self, serializer):
        farm = _get_or_create_farm(self.request.user)
        serializer.save(
            seller=self.request.user,
            seller_name=farm.farmer_name or self.request.user.get_full_name() or self.request.user.username,
            seller_phone=farm.phone or self.request.user.phone or '',
            location=farm.location or '',
        )


class CommunityViewSet(viewsets.ModelViewSet):
    queryset = CommunityPost.objects.all()
    serializer_class = CommunityPostSerializer

    def perform_create(self, serializer):
        farm = _get_or_create_farm(self.request.user)
        serializer.save(
            author=self.request.user,
            author_name=farm.farmer_name or self.request.user.get_full_name() or self.request.user.username,
            author_location=farm.location or '',
        )

    @action(detail=True, methods=['post'])
    def like(self, request, pk=None):
        post = self.get_object()
        like = CommunityLike.objects.filter(post=post, user=request.user).first()
        if like:
            like.delete()
        else:
            CommunityLike.objects.create(post=post, user=request.user)
        return Response(CommunityPostSerializer(post, context={'request': request}).data)

    @action(detail=True, methods=['post'])
    def comments(self, request, pk=None):
        post = self.get_object()
        text = (request.data.get('text') or request.data.get('comment') or '').strip()
        if not text:
            return Response({'detail': 'Comment text is required.'}, status=status.HTTP_400_BAD_REQUEST)
        farm = _get_or_create_farm(request.user)
        CommunityComment.objects.create(
            post=post,
            author=request.user,
            author_name=farm.farmer_name or request.user.get_full_name() or request.user.username,
            text=text,
        )
        return Response(CommunityPostSerializer(post, context={'request': request}).data)


class FinanceViewSet(OwnedViewSet):
    queryset = FinanceRecord.objects.all()
    serializer_class = FinanceRecordSerializer


class NotificationViewSet(mixins.ListModelMixin, mixins.DestroyModelMixin, viewsets.GenericViewSet):
    queryset = AppNotification.objects.all()
    serializer_class = AppNotificationSerializer

    def get_queryset(self):
        return AppNotification.objects.filter(user=self.request.user)

    @action(detail=True, methods=['post'])
    def read(self, request, pk=None):
        item = self.get_object()
        item.is_read = True
        item.save(update_fields=['is_read'])
        return Response(AppNotificationSerializer(item).data)

    @action(detail=False, methods=['delete', 'post'])
    def clear(self, request):
        self.get_queryset().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ChatViewSet(mixins.ListModelMixin, viewsets.GenericViewSet):
    queryset = ChatMessage.objects.all()
    serializer_class = ChatMessageSerializer

    def get_queryset(self):
        return ChatMessage.objects.filter(user=self.request.user)

    def create(self, request):
        text = (request.data.get('text') or '').strip()
        if not text:
            return Response({'detail': 'text is required.'}, status=status.HTTP_400_BAD_REQUEST)
        user_msg = ChatMessage.objects.create(user=request.user, sender='user', text=text)
        reply_text = generate_ai_response(text)
        ai_msg = ChatMessage.objects.create(
            user=request.user,
            sender='kuku_ai',
            text=reply_text,
            is_vet_recommendation=any(w in text.lower() for w in ('ugonjwa', 'dawa', 'kufa')),
        )
        ctx = {'request': request}
        return Response(
            {
                'user_message': ChatMessageSerializer(user_msg, context=ctx).data,
                'ai_message': ChatMessageSerializer(ai_msg, context=ctx).data,
            },
            status=status.HTTP_201_CREATED,
        )


class VetViewSet(mixins.ListModelMixin, mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    queryset = VetProfile.objects.all()
    serializer_class = VetProfileSerializer


class VetConsultationViewSet(OwnedViewSet):
    queryset = VetConsultation.objects.all()
    serializer_class = VetConsultationSerializer

    def perform_create(self, serializer):
        vet_id = self.request.data.get('vet_id')
        vet = VetProfile.objects.filter(id=vet_id).first() if vet_id else None
        requested = serializer.validated_data.get('requested_time') or (timezone.now() + timedelta(hours=2))
        consultation = serializer.save(
            user=self.request.user,
            vet=vet,
            vet_name=serializer.validated_data.get('vet_name') or (vet.name if vet else ''),
            requested_time=requested,
            status='Imepokelewa (In Review)',
        )
        _notify(
            self.request.user,
            'Ombi la Huduma ya Daktari',
            f'Ombi lako la {consultation.consultation_type} na {consultation.vet_name} limepokelewa kwa ufanisi.',
            'Vet',
        )


class DiseaseReportViewSet(OwnedViewSet):
    queryset = SickChickenReport.objects.all()
    serializer_class = SickChickenReportSerializer

    @action(detail=False, methods=['post'])
    def diagnose(self, request):
        symptoms = (request.data.get('symptoms_text') or request.data.get('symptoms') or '').strip()
        if not symptoms:
            return Response({'detail': 'symptoms_text is required.'}, status=status.HTTP_400_BAD_REQUEST)
        result = diagnose_from_symptoms(symptoms)
        image = request.FILES.get('image')
        report = SickChickenReport.objects.create(
            user=request.user,
            symptoms_text=symptoms,
            image=image,
            **result,
        )
        return Response(
            SickChickenReportSerializer(report, context={'request': request}).data,
            status=status.HTTP_201_CREATED,
        )


class ServiceProviderViewSet(mixins.ListModelMixin, mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    queryset = ServiceProvider.objects.all()
    serializer_class = ServiceProviderSerializer


class TrainingViewSet(mixins.ListModelMixin, mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    queryset = TrainingModule.objects.all()
    serializer_class = TrainingModuleSerializer


@api_view(['GET'])
@authentication_classes([])
@permission_classes([AllowAny])
def health(request):
    return Response({'status': 'ok', 'service': 'kuku-diary', 'database': 'kuku'})
