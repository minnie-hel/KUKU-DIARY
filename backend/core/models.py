import uuid

from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    phone = models.CharField(max_length=32, unique=True, null=True, blank=True)
    email = models.EmailField(blank=True, default='')

    class Meta:
        db_table = 'users'


class UserSettings(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='settings')
    is_dark_mode = models.BooleanField(default=False)
    language = models.CharField(max_length=8, default='sw')
    vaccine_notifications = models.BooleanField(default=True)
    disease_alerts = models.BooleanField(default=True)
    market_alerts = models.BooleanField(default=True)

    class Meta:
        db_table = 'user_settings'


class VerificationCode(models.Model):
    PURPOSE_REGISTER = 'register'
    PURPOSE_LOGIN = 'login'
    PURPOSE_RESET = 'reset'
    PURPOSE_CHOICES = (
        (PURPOSE_REGISTER, 'Register'),
        (PURPOSE_LOGIN, 'Login'),
        (PURPOSE_RESET, 'Reset password'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    identifier = models.CharField(max_length=255)
    code = models.CharField(max_length=6)
    purpose = models.CharField(max_length=16, choices=PURPOSE_CHOICES)
    extra_data = models.JSONField(default=dict, blank=True)
    expires_at = models.DateTimeField()
    is_used = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'verification_codes'
        indexes = [models.Index(fields=['identifier', 'purpose', 'is_used'])]


class FarmProfile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='farm')
    farmer_name = models.CharField(max_length=255, blank=True, default='')
    email = models.EmailField(blank=True, default='')
    phone = models.CharField(max_length=32, blank=True, default='')
    farm_name = models.CharField(max_length=255, blank=True, default='')
    location = models.CharField(max_length=255, blank=True, default='')
    latitude = models.FloatField(default=0)
    longitude = models.FloatField(default=0)
    farm_size = models.CharField(max_length=64, blank=True, default='')
    chicken_type = models.CharField(max_length=128, blank=True, default='')
    total_chickens = models.IntegerField(default=0)
    housing_system = models.CharField(max_length=128, blank=True, default='')
    status = models.CharField(max_length=64, default='Salama / Operational')
    qr_code_data = models.CharField(max_length=128, blank=True, default='')
    setup_complete = models.BooleanField(default=False)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'farm_profiles'

    def save(self, *args, **kwargs):
        if self.setup_complete and not self.qr_code_data:
            slug = (self.farm_name or 'FARM').replace(' ', '').upper()[:24]
            self.qr_code_data = f'KUKU-DIARY-FARM-{slug}-{str(self.id)[:8].upper()}'
        super().save(*args, **kwargs)


class PoultryBatch(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='poultry_batches')
    breed = models.CharField(max_length=128)
    quantity = models.IntegerField()
    age = models.CharField(max_length=64, blank=True, default='')
    date_purchased = models.DateTimeField()
    supplier = models.CharField(max_length=255, blank=True, default='')
    notes = models.TextField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'poultry_batches'
        ordering = ['-created_at']


class ProductionLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='production_logs')
    date = models.DateTimeField()
    eggs = models.IntegerField(default=0)
    feed_kg = models.FloatField(default=0)
    water_liters = models.FloatField(default=0)
    mortality = models.IntegerField(default=0)
    bird_avg_weight_kg = models.FloatField(default=0)
    expenses_tsz = models.FloatField(default=0)
    notes = models.TextField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'production_logs'
        ordering = ['date']


class FeedInventoryItem(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='feed_inventory')
    name = models.CharField(max_length=255)
    current_stock_kg = models.FloatField(default=0)
    total_capacity_kg = models.FloatField(default=500)
    type = models.CharField(max_length=64)
    cost_per_kg = models.FloatField(default=0)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'feed_inventory'
        ordering = ['name']


class VaccinationItem(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='vaccinations')
    disease_name = models.CharField(max_length=255)
    vaccine_name = models.CharField(max_length=255)
    target_age = models.CharField(max_length=64, blank=True, default='')
    scheduled_date = models.DateTimeField()
    is_completed = models.BooleanField(default=False)
    instructions = models.TextField(blank=True, default='')
    item_type = models.CharField(max_length=32, default='vaccine')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'vaccinations'
        ordering = ['scheduled_date']


class MarketplaceItem(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    seller = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='marketplace_items')
    title = models.CharField(max_length=255)
    category = models.CharField(max_length=64)
    price = models.FloatField()
    unit = models.CharField(max_length=64)
    description = models.TextField(blank=True, default='')
    seller_name = models.CharField(max_length=255)
    seller_phone = models.CharField(max_length=32, blank=True, default='')
    location = models.CharField(max_length=255, blank=True, default='')
    image = models.ImageField(upload_to='marketplace/', blank=True, null=True)
    image_url = models.URLField(blank=True, default='')
    is_for_sale = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'marketplace_items'
        ordering = ['-created_at']


class ServiceProvider(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    category = models.CharField(max_length=128)
    location = models.CharField(max_length=255)
    phone = models.CharField(max_length=32)
    rating = models.CharField(max_length=32, default='0')
    description = models.TextField(blank=True, default='')

    class Meta:
        db_table = 'service_providers'
        ordering = ['name']


class TrainingModule(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    title = models.CharField(max_length=255)
    category = models.CharField(max_length=64)
    content_type = models.CharField(max_length=32)
    duration_or_read_time = models.CharField(max_length=64, blank=True, default='')
    summary = models.TextField(blank=True, default='')
    content_details = models.TextField(blank=True, default='')
    video_url = models.URLField(blank=True, default='')
    quiz_questions = models.JSONField(default=list, blank=True)

    class Meta:
        db_table = 'training_modules'
        ordering = ['title']


class CommunityPost(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='community_posts')
    author_name = models.CharField(max_length=255)
    author_location = models.CharField(max_length=255, blank=True, default='')
    title = models.CharField(max_length=255)
    content = models.TextField()
    image = models.ImageField(upload_to='community/', blank=True, null=True)
    image_url = models.URLField(blank=True, default='')
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'community_posts'
        ordering = ['-timestamp']


class CommunityComment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    post = models.ForeignKey(CommunityPost, on_delete=models.CASCADE, related_name='comment_rows')
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='community_comments')
    author_name = models.CharField(max_length=255)
    text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'community_comments'
        ordering = ['created_at']


class CommunityLike(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    post = models.ForeignKey(CommunityPost, on_delete=models.CASCADE, related_name='likes')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='community_likes')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'community_likes'
        unique_together = ('post', 'user')


class FinanceRecord(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='finance_records')
    type = models.CharField(max_length=32)
    category = models.CharField(max_length=64)
    amount = models.FloatField()
    date = models.DateTimeField()
    description = models.TextField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'finance_records'
        ordering = ['-date']


class AppNotification(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='notifications')
    title = models.CharField(max_length=255)
    message = models.TextField()
    time = models.DateTimeField(auto_now_add=True)
    type = models.CharField(max_length=32)
    is_read = models.BooleanField(default=False)

    class Meta:
        db_table = 'notifications'
        ordering = ['-time']


class ChatMessage(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='chat_messages')
    sender = models.CharField(max_length=32)
    text = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
    is_vet_recommendation = models.BooleanField(default=False)
    image = models.ImageField(upload_to='chat/', blank=True, null=True)
    image_url = models.URLField(blank=True, default='')

    class Meta:
        db_table = 'chat_messages'
        ordering = ['timestamp']


class VetProfile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    specialty = models.CharField(max_length=255, blank=True, default='')
    location = models.CharField(max_length=255, blank=True, default='')
    rating = models.FloatField(default=0)
    review_count = models.IntegerField(default=0)
    phone = models.CharField(max_length=32, blank=True, default='')
    is_available = models.BooleanField(default=True)

    class Meta:
        db_table = 'vet_profiles'
        ordering = ['-rating', 'name']


class VetConsultation(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='vet_consultations')
    vet = models.ForeignKey(VetProfile, on_delete=models.SET_NULL, null=True, blank=True, related_name='consultations')
    vet_name = models.CharField(max_length=255)
    consultation_type = models.CharField(max_length=64)
    requested_time = models.DateTimeField()
    symptoms_or_notes = models.TextField(blank=True, default='')
    status = models.CharField(max_length=64, default='Pending')
    doctor_prescription = models.TextField(blank=True, default='')
    uploaded_media = models.FileField(upload_to='consultations/', blank=True, null=True)
    uploaded_media_url = models.URLField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'vet_consultations'
        ordering = ['-created_at']


class SickChickenReport(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='sick_chicken_reports')
    timestamp = models.DateTimeField(auto_now_add=True)
    symptoms_text = models.TextField()
    image = models.ImageField(upload_to='diagnoses/', blank=True, null=True)
    image_or_video_url = models.URLField(blank=True, default='')
    diagnosed_disease = models.CharField(max_length=255)
    confidence_level = models.CharField(max_length=16)
    recommended_action = models.TextField()
    recommended_medicines = models.JSONField(default=list)
    urgency = models.CharField(max_length=32)

    class Meta:
        db_table = 'sick_chicken_reports'
        ordering = ['-timestamp']
