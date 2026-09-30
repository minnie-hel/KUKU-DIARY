from django.contrib import admin
from django.db.models import Sum
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin

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
    User,
    UserSettings,
    VaccinationItem,
    VerificationCode,
    VetConsultation,
    VetProfile,
)


class FarmProfileInline(admin.StackedInline):
    model = FarmProfile
    extra = 0
    can_delete = False
    fields = (
        'farmer_name', 'farm_name', 'phone', 'email', 'location',
        'latitude', 'longitude', 'chicken_type', 'total_chickens',
        'housing_system', 'farm_size', 'status', 'setup_complete', 'qr_code_data',
    )


@admin.register(User)
class UserAdmin(DjangoUserAdmin):
    list_display = ('username', 'first_name', 'phone', 'email', 'farm_label', 'bird_count', 'date_joined', 'is_active', 'is_staff')
    list_filter = ('is_active', 'is_staff', 'date_joined')
    search_fields = ('username', 'first_name', 'last_name', 'email', 'phone', 'farm__farm_name', 'farm__farmer_name')
    ordering = ('-date_joined',)
    inlines = (FarmProfileInline,)
    fieldsets = DjangoUserAdmin.fieldsets + (('Contact', {'fields': ('phone',)}),)

    @admin.display(description='Farm')
    def farm_label(self, obj):
        farm = getattr(obj, 'farm', None)
        return farm.farm_name if farm else '-'

    @admin.display(description='Birds')
    def bird_count(self, obj):
        farm = getattr(obj, 'farm', None)
        return farm.total_chickens if farm else 0


@admin.register(FarmProfile)
class FarmProfileAdmin(admin.ModelAdmin):
    list_display = ('farm_name', 'farmer_name', 'phone', 'location', 'chicken_type', 'total_chickens', 'housing_system', 'setup_complete', 'updated_at')
    list_filter = ('chicken_type', 'housing_system', 'setup_complete')
    search_fields = ('farm_name', 'farmer_name', 'phone', 'location', 'user__username', 'user__email')
    raw_id_fields = ('user',)


@admin.register(PoultryBatch)
class PoultryBatchAdmin(admin.ModelAdmin):
    list_display = ('user', 'breed', 'quantity', 'age', 'supplier', 'date_purchased')
    search_fields = ('breed', 'supplier', 'user__username', 'user__phone', 'user__farm__farm_name')
    list_filter = ('breed',)
    raw_id_fields = ('user',)


@admin.register(ProductionLog)
class ProductionLogAdmin(admin.ModelAdmin):
    list_display = ('user', 'date', 'eggs', 'mortality', 'feed_kg', 'water_liters', 'expenses_tsz')
    list_filter = ('date',)
    search_fields = ('user__username', 'user__phone', 'user__farm__farm_name', 'notes')
    raw_id_fields = ('user',)


@admin.register(FeedInventoryItem)
class FeedInventoryItemAdmin(admin.ModelAdmin):
    list_display = ('user', 'name', 'type', 'current_stock_kg', 'cost_per_kg', 'updated_at')
    search_fields = ('name', 'type', 'user__username', 'user__phone', 'user__farm__farm_name')
    raw_id_fields = ('user',)


@admin.register(VaccinationItem)
class VaccinationItemAdmin(admin.ModelAdmin):
    list_display = ('user', 'vaccine_name', 'disease_name', 'scheduled_date', 'is_completed', 'item_type')
    list_filter = ('is_completed', 'item_type')
    search_fields = ('vaccine_name', 'disease_name', 'user__username', 'user__phone', 'user__farm__farm_name')
    raw_id_fields = ('user',)


@admin.register(FinanceRecord)
class FinanceRecordAdmin(admin.ModelAdmin):
    list_display = ('user', 'type', 'category', 'amount', 'date')
    list_filter = ('type', 'category')
    search_fields = ('category', 'description', 'user__username', 'user__phone', 'user__farm__farm_name')
    raw_id_fields = ('user',)


@admin.register(MarketplaceItem)
class MarketplaceItemAdmin(admin.ModelAdmin):
    list_display = ('title', 'seller', 'category', 'price', 'unit', 'location', 'is_for_sale', 'created_at')
    list_filter = ('category', 'is_for_sale')
    search_fields = ('title', 'seller_name', 'seller_phone', 'location', 'seller__username')
    raw_id_fields = ('seller',)


@admin.register(VetConsultation)
class VetConsultationAdmin(admin.ModelAdmin):
    list_display = ('user', 'vet_name', 'consultation_type', 'status', 'requested_time', 'created_at')
    list_filter = ('status', 'consultation_type')
    search_fields = ('vet_name', 'symptoms_or_notes', 'doctor_prescription', 'user__username', 'user__phone')
    raw_id_fields = ('user', 'vet')


@admin.register(SickChickenReport)
class SickChickenReportAdmin(admin.ModelAdmin):
    list_display = ('user', 'diagnosed_disease', 'urgency', 'confidence_level', 'timestamp')
    list_filter = ('urgency',)
    search_fields = ('diagnosed_disease', 'symptoms_text', 'user__username', 'user__phone')
    raw_id_fields = ('user',)


@admin.register(VetProfile)
class VetProfileAdmin(admin.ModelAdmin):
    list_display = ('name', 'specialty', 'phone', 'location', 'is_available', 'rating')
    list_filter = ('is_available',)
    search_fields = ('name', 'specialty', 'phone', 'location')


@admin.register(AppNotification)
class AppNotificationAdmin(admin.ModelAdmin):
    list_display = ('user', 'title', 'type', 'is_read', 'time')
    list_filter = ('type', 'is_read')
    search_fields = ('title', 'message', 'user__username', 'user__phone')
    raw_id_fields = ('user',)


@admin.register(ChatMessage)
class ChatMessageAdmin(admin.ModelAdmin):
    list_display = ('user', 'sender', 'timestamp', 'is_vet_recommendation')
    list_filter = ('sender', 'is_vet_recommendation')
    search_fields = ('text', 'user__username', 'user__phone')
    raw_id_fields = ('user',)


@admin.register(CommunityPost)
class CommunityPostAdmin(admin.ModelAdmin):
    list_display = ('title', 'author_name', 'author', 'timestamp')
    search_fields = ('title', 'content', 'author_name', 'author__username')
    raw_id_fields = ('author',)


@admin.register(CommunityComment)
class CommunityCommentAdmin(admin.ModelAdmin):
    list_display = ('post', 'author_name', 'created_at')
    search_fields = ('text', 'author_name')
    raw_id_fields = ('post', 'author')


@admin.register(CommunityLike)
class CommunityLikeAdmin(admin.ModelAdmin):
    list_display = ('post', 'user', 'created_at')
    raw_id_fields = ('post', 'user')


@admin.register(TrainingModule)
class TrainingModuleAdmin(admin.ModelAdmin):
    list_display = ('title', 'category', 'content_type', 'duration_or_read_time')
    list_filter = ('category', 'content_type')
    search_fields = ('title', 'summary')


@admin.register(ServiceProvider)
class ServiceProviderAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'phone', 'location', 'rating')
    list_filter = ('category',)
    search_fields = ('name', 'phone', 'location')


@admin.register(UserSettings)
class UserSettingsAdmin(admin.ModelAdmin):
    list_display = ('user', 'language', 'is_dark_mode', 'vaccine_notifications', 'disease_alerts', 'market_alerts')
    raw_id_fields = ('user',)


@admin.register(VerificationCode)
class VerificationCodeAdmin(admin.ModelAdmin):
    list_display = ('identifier', 'purpose', 'is_used', 'expires_at', 'created_at')
    list_filter = ('purpose', 'is_used')
    search_fields = ('identifier',)


admin.site.site_header = 'KUKU DIARY'
admin.site.site_title = 'KUKU DIARY'
admin.site.index_title = 'Farm dashboard'

_original_index = admin.site.index


def _dashboard_index(request, extra_context=None):
    extra_context = extra_context or {}
    extra_context['kuku_stats'] = [
        ('Farmers', User.objects.filter(is_staff=False).count(), '/admin/core/user/'),
        ('Farms', FarmProfile.objects.count(), '/admin/core/farmprofile/'),
        ('Birds', FarmProfile.objects.aggregate(total=Sum('total_chickens'))['total'] or 0, '/admin/core/farmprofile/'),
        ('Production logs', ProductionLog.objects.count(), '/admin/core/productionlog/'),
        ('Vaccinations', VaccinationItem.objects.count(), '/admin/core/vaccinationitem/'),
        ('Vet cases', VetConsultation.objects.count(), '/admin/core/vetconsultation/'),
        ('Sick reports', SickChickenReport.objects.count(), '/admin/core/sickchickenreport/'),
        ('Market listings', MarketplaceItem.objects.count(), '/admin/core/marketplaceitem/'),
    ]
    return _original_index(request, extra_context)


admin.site.index = _dashboard_index
