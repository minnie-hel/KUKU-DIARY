from django.conf import settings
from rest_framework import serializers

from .models import (
    AppNotification,
    ChatMessage,
    CommunityComment,
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
    User,
    UserSettings,
    VaccinationItem,
    VetConsultation,
    VetProfile,
)


def media_url(request, file_field, fallback=''):
    if file_field:
        url = file_field.url
        if request:
            return request.build_absolute_uri(url)
        return f"{settings.PUBLIC_BASE_URL}{url}"
    return fallback or ''


class UserSettingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserSettings
        fields = (
            'is_dark_mode',
            'language',
            'vaccine_notifications',
            'disease_alerts',
            'market_alerts',
        )


class FarmProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = FarmProfile
        fields = (
            'farmer_name',
            'email',
            'phone',
            'farm_name',
            'location',
            'latitude',
            'longitude',
            'farm_size',
            'chicken_type',
            'total_chickens',
            'housing_system',
            'status',
            'qr_code_data',
            'setup_complete',
        )
        read_only_fields = ('qr_code_data', 'setup_complete')


class PoultryBatchSerializer(serializers.ModelSerializer):
    class Meta:
        model = PoultryBatch
        fields = ('id', 'breed', 'quantity', 'age', 'date_purchased', 'supplier', 'notes')
        read_only_fields = ('id',)


class ProductionLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductionLog
        fields = (
            'id',
            'date',
            'eggs',
            'feed_kg',
            'water_liters',
            'mortality',
            'bird_avg_weight_kg',
            'expenses_tsz',
            'notes',
        )
        read_only_fields = ('id',)


class FeedInventoryItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = FeedInventoryItem
        fields = ('id', 'name', 'current_stock_kg', 'total_capacity_kg', 'type', 'cost_per_kg')
        read_only_fields = ('id',)


class VaccinationItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = VaccinationItem
        fields = (
            'id',
            'disease_name',
            'vaccine_name',
            'target_age',
            'scheduled_date',
            'is_completed',
            'instructions',
            'item_type',
        )
        read_only_fields = ('id',)


class MarketplaceItemSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = MarketplaceItem
        fields = (
            'id',
            'title',
            'category',
            'price',
            'unit',
            'description',
            'seller_name',
            'seller_phone',
            'location',
            'image_url',
            'is_for_sale',
        )
        read_only_fields = ('id', 'seller_name', 'seller_phone', 'location')

    def get_image_url(self, obj):
        return media_url(self.context.get('request'), obj.image, obj.image_url)

    def create(self, validated_data):
        request = self.context.get('request')
        image_url = ''
        if request is not None:
            image_url = request.data.get('image_url') or ''
        return super().create({**validated_data, 'image_url': image_url})


class ServiceProviderSerializer(serializers.ModelSerializer):
    class Meta:
        model = ServiceProvider
        fields = ('id', 'name', 'category', 'location', 'phone', 'rating', 'description')


class TrainingModuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = TrainingModule
        fields = (
            'id',
            'title',
            'category',
            'content_type',
            'duration_or_read_time',
            'summary',
            'content_details',
            'video_url',
            'quiz_questions',
        )


class CommunityPostSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    likes_count = serializers.SerializerMethodField()
    comments = serializers.SerializerMethodField()
    is_liked = serializers.SerializerMethodField()

    class Meta:
        model = CommunityPost
        fields = (
            'id',
            'author_name',
            'author_location',
            'title',
            'content',
            'image_url',
            'timestamp',
            'likes_count',
            'comments',
            'is_liked',
        )
        read_only_fields = ('id', 'author_name', 'author_location', 'timestamp')

    def get_image_url(self, obj):
        return media_url(self.context.get('request'), obj.image, obj.image_url)

    def get_likes_count(self, obj):
        return obj.likes.count()

    def get_comments(self, obj):
        return [f'{c.author_name}: {c.text}' for c in obj.comment_rows.all()]

    def get_is_liked(self, obj):
        request = self.context.get('request')
        if not request or not request.user.is_authenticated:
            return False
        return obj.likes.filter(user=request.user).exists()


class FinanceRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = FinanceRecord
        fields = ('id', 'type', 'category', 'amount', 'date', 'description')
        read_only_fields = ('id',)


class AppNotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = AppNotification
        fields = ('id', 'title', 'message', 'time', 'type', 'is_read')
        read_only_fields = ('id', 'time')


class ChatMessageSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = ChatMessage
        fields = ('id', 'sender', 'text', 'timestamp', 'is_vet_recommendation', 'image_url')
        read_only_fields = ('id', 'timestamp')

    def get_image_url(self, obj):
        return media_url(self.context.get('request'), obj.image, obj.image_url)


class VetProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = VetProfile
        fields = ('id', 'name', 'specialty', 'location', 'rating', 'review_count', 'phone', 'is_available')


class VetConsultationSerializer(serializers.ModelSerializer):
    uploaded_media_url = serializers.SerializerMethodField()
    vet_id = serializers.UUIDField(source='vet.id', read_only=True)

    class Meta:
        model = VetConsultation
        fields = (
            'id',
            'vet_id',
            'vet_name',
            'consultation_type',
            'requested_time',
            'symptoms_or_notes',
            'status',
            'doctor_prescription',
            'uploaded_media_url',
        )
        read_only_fields = ('id', 'status', 'doctor_prescription')

    def get_uploaded_media_url(self, obj):
        return media_url(self.context.get('request'), obj.uploaded_media, obj.uploaded_media_url)


class SickChickenReportSerializer(serializers.ModelSerializer):
    image_or_video_url = serializers.SerializerMethodField()

    class Meta:
        model = SickChickenReport
        fields = (
            'id',
            'timestamp',
            'symptoms_text',
            'image_or_video_url',
            'diagnosed_disease',
            'confidence_level',
            'recommended_action',
            'recommended_medicines',
            'urgency',
        )
        read_only_fields = ('id', 'timestamp')

    def get_image_or_video_url(self, obj):
        return media_url(self.context.get('request'), obj.image, obj.image_or_video_url)


class RegisterSerializer(serializers.Serializer):
    farmer_name = serializers.CharField(max_length=255)
    phone = serializers.CharField(max_length=32)
    email = serializers.EmailField(required=False, allow_blank=True, default='')
    password = serializers.CharField(min_length=6, write_only=True)
    confirm_password = serializers.CharField(min_length=6, write_only=True)

    def validate(self, attrs):
        if attrs['password'] != attrs['confirm_password']:
            raise serializers.ValidationError({'confirm_password': 'Passwords do not match.'})
        phone = attrs['phone'].strip()
        email = (attrs.get('email') or '').strip().lower()
        if User.objects.filter(phone=phone).exists():
            raise serializers.ValidationError({'phone': 'This phone number is already registered.'})
        if email and User.objects.filter(email__iexact=email).exists():
            raise serializers.ValidationError({'email': 'This email is already registered.'})
        attrs['phone'] = phone
        attrs['email'] = email
        return attrs


class LoginSerializer(serializers.Serializer):
    identifier = serializers.CharField()
    password = serializers.CharField(write_only=True)


class OtpSerializer(serializers.Serializer):
    identifier = serializers.CharField()
    code = serializers.CharField(max_length=6, min_length=4)
    purpose = serializers.CharField(required=False, default='register')


class ForgotPasswordSerializer(serializers.Serializer):
    identifier = serializers.CharField()


class ResetPasswordSerializer(serializers.Serializer):
    identifier = serializers.CharField()
    code = serializers.CharField(max_length=6)
    new_password = serializers.CharField(min_length=6)


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField()
    new_password = serializers.CharField(min_length=6)
