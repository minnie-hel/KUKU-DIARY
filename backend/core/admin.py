from django.contrib import admin
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


@admin.register(User)
class UserAdmin(DjangoUserAdmin):
    list_display = ('username', 'email', 'phone', 'first_name', 'is_staff')
    fieldsets = DjangoUserAdmin.fieldsets + (('Contact', {'fields': ('phone',)}),)


admin.site.register(UserSettings)
admin.site.register(VerificationCode)
admin.site.register(FarmProfile)
admin.site.register(PoultryBatch)
admin.site.register(ProductionLog)
admin.site.register(FeedInventoryItem)
admin.site.register(VaccinationItem)
admin.site.register(MarketplaceItem)
admin.site.register(ServiceProvider)
admin.site.register(TrainingModule)
admin.site.register(CommunityPost)
admin.site.register(CommunityComment)
admin.site.register(CommunityLike)
admin.site.register(FinanceRecord)
admin.site.register(AppNotification)
admin.site.register(ChatMessage)
admin.site.register(VetProfile)
admin.site.register(VetConsultation)
admin.site.register(SickChickenReport)

admin.site.site_header = 'KUKU DIARY Admin'
admin.site.site_title = 'KUKU DIARY'
admin.site.index_title = 'Database: kuku'
