from django import forms
from django.contrib.auth import authenticate, login, logout
from django.core.paginator import Paginator
from django.db.models import Q, Sum
from django.shortcuts import get_object_or_404, redirect, render
from django.utils.crypto import get_random_string
from django.views.decorators.http import require_http_methods

from .models import (
    AppNotification,
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
    VaccinationItem,
    VetConsultation,
    VetProfile,
)


LANGS = ('sw', 'en', 'fr')

GROUPS = {
    'people': {'sw': 'Watu', 'en': 'People', 'fr': 'Personnes'},
    'records': {'sw': 'Rekodi za shamba', 'en': 'Farm records', 'fr': 'Registres'},
    'market': {'sw': 'Soko', 'en': 'Market', 'fr': 'Marché'},
    'health': {'sw': 'Afya', 'en': 'Health', 'fr': 'Santé'},
    'content': {'sw': 'Maudhui', 'en': 'Content', 'fr': 'Contenu'},
}

UI = {
    'sw': {
        'admin': 'Msimamizi',
        'dashboard': 'Dashibodi',
        'logout': 'Toka',
        'create': 'Ongeza',
        'print': 'Chapisha',
        'search': 'Tafuta',
        'clear': 'Futa chujio',
        'previous': 'Iliyotangulia',
        'next': 'Inayofuata',
        'empty': 'Hakuna rekodi bado.',
        'back': 'Rudi kwenye orodha',
        'save': 'Hifadhi',
        'edit': 'Hariri',
        'delete': 'Futa',
        'view': 'Angalia',
        'actions': 'Vitendo',
        'confirm_delete': 'Unataka kufuta rekodi hii?',
        'birds': 'kuku wamerekodiwa katika mashamba yote.',
        'sign_in': 'Ingia kwenye usimamizi',
        'username': 'Jina la mtumiaji',
        'password': 'Neno la siri',
        'submit': 'Ingia',
        'bad_login': 'Jina la mtumiaji au neno la siri si sahihi.',
        'all': 'Zote',
        'language': 'Lugha',
    },
    'en': {
        'admin': 'Admin',
        'dashboard': 'Dashboard',
        'logout': 'Logout',
        'create': 'Create',
        'print': 'Print',
        'search': 'Search',
        'clear': 'Clear',
        'previous': 'Previous',
        'next': 'Next',
        'empty': 'No records yet.',
        'back': 'Back to list',
        'save': 'Save',
        'edit': 'Edit',
        'delete': 'Delete',
        'view': 'View',
        'actions': 'Actions',
        'confirm_delete': 'Delete this record?',
        'birds': 'birds recorded across all farms.',
        'sign_in': 'Admin sign in',
        'username': 'Username',
        'password': 'Password',
        'submit': 'Sign in',
        'bad_login': 'Staff username or password is incorrect.',
        'all': 'All',
        'language': 'Language',
    },
    'fr': {
        'admin': 'Admin',
        'dashboard': 'Tableau de bord',
        'logout': 'Déconnexion',
        'create': 'Créer',
        'print': 'Imprimer',
        'search': 'Rechercher',
        'clear': 'Effacer',
        'previous': 'Précédent',
        'next': 'Suivant',
        'empty': 'Aucun enregistrement.',
        'back': 'Retour à la liste',
        'save': 'Enregistrer',
        'edit': 'Modifier',
        'delete': 'Supprimer',
        'view': 'Voir',
        'actions': 'Actions',
        'confirm_delete': 'Supprimer cet enregistrement ?',
        'birds': 'poulets enregistrés dans toutes les fermes.',
        'sign_in': 'Connexion administrateur',
        'username': "Nom d'utilisateur",
        'password': 'Mot de passe',
        'submit': 'Se connecter',
        'bad_login': "Nom d'utilisateur ou mot de passe incorrect.",
        'all': 'Tous',
        'language': 'Langue',
    },
}

COLUMNS = {
    'username': {'sw': 'Mtumiaji', 'en': 'Username', 'fr': 'Utilisateur'},
    'first_name': {'sw': 'Jina', 'en': 'Name', 'fr': 'Nom'},
    'phone': {'sw': 'Simu', 'en': 'Phone', 'fr': 'Téléphone'},
    'email': {'sw': 'Barua pepe', 'en': 'Email', 'fr': 'E-mail'},
    'is_active': {'sw': 'Hai', 'en': 'Active', 'fr': 'Actif'},
    'date_joined': {'sw': 'Alijiunga', 'en': 'Joined', 'fr': 'Inscrit'},
    'farm_name': {'sw': 'Shamba', 'en': 'Farm', 'fr': 'Ferme'},
    'farmer_name': {'sw': 'Mfugaji', 'en': 'Farmer', 'fr': 'Éleveur'},
    'location': {'sw': 'Mahali', 'en': 'Location', 'fr': 'Lieu'},
    'chicken_type': {'sw': 'Aina ya kuku', 'en': 'Chicken type', 'fr': 'Type de poulet'},
    'total_chickens': {'sw': 'Kuku wote', 'en': 'Chickens', 'fr': 'Poulets'},
    'setup_complete': {'sw': 'Imekamilika', 'en': 'Setup done', 'fr': 'Configuré'},
    'user': {'sw': 'Mfugaji', 'en': 'Farmer', 'fr': 'Éleveur'},
    'breed': {'sw': 'Aina', 'en': 'Breed', 'fr': 'Race'},
    'quantity': {'sw': 'Idadi', 'en': 'Quantity', 'fr': 'Quantité'},
    'age': {'sw': 'Umri', 'en': 'Age', 'fr': 'Âge'},
    'supplier': {'sw': 'Muuzaji', 'en': 'Supplier', 'fr': 'Fournisseur'},
    'date_purchased': {'sw': 'Tarehe ya ununuzi', 'en': 'Purchased', 'fr': 'Acheté'},
    'date': {'sw': 'Tarehe', 'en': 'Date', 'fr': 'Date'},
    'eggs': {'sw': 'Mayai', 'en': 'Eggs', 'fr': 'Œufs'},
    'mortality': {'sw': 'Vifo', 'en': 'Mortality', 'fr': 'Mortalité'},
    'feed_kg': {'sw': 'Chakula (kg)', 'en': 'Feed (kg)', 'fr': 'Aliment (kg)'},
    'expenses_tsz': {'sw': 'Gharama', 'en': 'Expenses', 'fr': 'Dépenses'},
    'name': {'sw': 'Jina', 'en': 'Name', 'fr': 'Nom'},
    'type': {'sw': 'Aina', 'en': 'Type', 'fr': 'Type'},
    'current_stock_kg': {'sw': 'Stoki (kg)', 'en': 'Stock (kg)', 'fr': 'Stock (kg)'},
    'cost_per_kg': {'sw': 'Bei kwa kg', 'en': 'Cost per kg', 'fr': 'Prix par kg'},
    'vaccine_name': {'sw': 'Chanjo', 'en': 'Vaccine', 'fr': 'Vaccin'},
    'disease_name': {'sw': 'Ugonjwa', 'en': 'Disease', 'fr': 'Maladie'},
    'scheduled_date': {'sw': 'Tarehe', 'en': 'Date', 'fr': 'Date'},
    'is_completed': {'sw': 'Imekamilika', 'en': 'Done', 'fr': 'Fait'},
    'category': {'sw': 'Kundi', 'en': 'Category', 'fr': 'Catégorie'},
    'amount': {'sw': 'Kiasi', 'en': 'Amount', 'fr': 'Montant'},
    'title': {'sw': 'Kichwa', 'en': 'Title', 'fr': 'Titre'},
    'seller': {'sw': 'Muuzaji', 'en': 'Seller', 'fr': 'Vendeur'},
    'price': {'sw': 'Bei', 'en': 'Price', 'fr': 'Prix'},
    'is_for_sale': {'sw': 'Inauzwa', 'en': 'For sale', 'fr': 'En vente'},
    'created_at': {'sw': 'Imewekwa', 'en': 'Created', 'fr': 'Créé'},
    'vet_name': {'sw': 'Daktari', 'en': 'Doctor', 'fr': 'Vétérinaire'},
    'consultation_type': {'sw': 'Aina', 'en': 'Type', 'fr': 'Type'},
    'status': {'sw': 'Hali', 'en': 'Status', 'fr': 'Statut'},
    'requested_time': {'sw': 'Muda', 'en': 'Requested', 'fr': 'Demandé'},
    'diagnosed_disease': {'sw': 'Ugonjwa', 'en': 'Disease', 'fr': 'Maladie'},
    'urgency': {'sw': 'Dharura', 'en': 'Urgency', 'fr': 'Urgence'},
    'confidence_level': {'sw': 'Uhakika', 'en': 'Confidence', 'fr': 'Confiance'},
    'timestamp': {'sw': 'Muda', 'en': 'Time', 'fr': 'Heure'},
    'specialty': {'sw': 'Utaalamu', 'en': 'Specialty', 'fr': 'Spécialité'},
    'is_available': {'sw': 'Anapatikana', 'en': 'Available', 'fr': 'Disponible'},
    'rating': {'sw': 'Kiwango', 'en': 'Rating', 'fr': 'Note'},
    'content_type': {'sw': 'Aina', 'en': 'Type', 'fr': 'Type'},
    'duration_or_read_time': {'sw': 'Muda', 'en': 'Duration', 'fr': 'Durée'},
    'is_read': {'sw': 'Imesomwa', 'en': 'Read', 'fr': 'Lu'},
    'time': {'sw': 'Muda', 'en': 'Time', 'fr': 'Heure'},
    'author_name': {'sw': 'Mwandishi', 'en': 'Author', 'fr': 'Auteur'},
    'author': {'sw': 'Akaunti', 'en': 'Account', 'fr': 'Compte'},
}


def _text(table, lang, key):
    row = table.get(key) or {}
    return row.get(lang) or row.get('sw') or key.replace('_', ' ').title()


def _section(key, labels, group, model, columns, search, filters=()):
    return {
        'key': key,
        'labels': labels,
        'group': group,
        'model': model,
        'columns': columns,
        'search': search,
        'filters': filters,
    }


SECTIONS = [
    _section('farmers', {'sw': 'Wafugaji', 'en': 'Farmers', 'fr': 'Éleveurs'}, 'people', User, ['username', 'first_name', 'phone', 'email', 'is_active', 'date_joined'], ['username', 'first_name', 'phone', 'email'], ['is_active']),
    _section('farms', {'sw': 'Mashamba', 'en': 'Farms', 'fr': 'Fermes'}, 'people', FarmProfile, ['farm_name', 'farmer_name', 'phone', 'location', 'chicken_type', 'total_chickens', 'setup_complete'], ['farm_name', 'farmer_name', 'phone', 'location'], ['chicken_type', 'setup_complete']),
    _section('batches', {'sw': 'Makundi', 'en': 'Flocks', 'fr': 'Troupeaux'}, 'records', PoultryBatch, ['user', 'breed', 'quantity', 'age', 'supplier', 'date_purchased'], ['breed', 'supplier'], ['breed']),
    _section('production', {'sw': 'Uzalishaji', 'en': 'Production', 'fr': 'Production'}, 'records', ProductionLog, ['user', 'date', 'eggs', 'mortality', 'feed_kg', 'expenses_tsz'], ['notes'], []),
    _section('feed', {'sw': 'Chakula', 'en': 'Feed stock', 'fr': 'Aliments'}, 'records', FeedInventoryItem, ['user', 'name', 'type', 'current_stock_kg', 'cost_per_kg'], ['name', 'type'], ['type']),
    _section('vaccinations', {'sw': 'Chanjo', 'en': 'Vaccinations', 'fr': 'Vaccinations'}, 'records', VaccinationItem, ['user', 'vaccine_name', 'disease_name', 'scheduled_date', 'is_completed'], ['vaccine_name', 'disease_name'], ['is_completed']),
    _section('finance', {'sw': 'Fedha', 'en': 'Finance', 'fr': 'Finances'}, 'market', FinanceRecord, ['user', 'type', 'category', 'amount', 'date'], ['category', 'description'], ['type']),
    _section('marketplace', {'sw': 'Soko', 'en': 'Marketplace', 'fr': 'Marché'}, 'market', MarketplaceItem, ['title', 'seller', 'category', 'price', 'location', 'is_for_sale', 'created_at'], ['title', 'seller_name', 'location'], ['category', 'is_for_sale']),
    _section('consultations', {'sw': 'Maombi ya daktari', 'en': 'Vet requests', 'fr': 'Demandes véto'}, 'health', VetConsultation, ['user', 'vet_name', 'consultation_type', 'status', 'requested_time'], ['vet_name', 'symptoms_or_notes'], ['status', 'consultation_type']),
    _section('reports', {'sw': 'Kuku wagonjwa', 'en': 'Sick birds', 'fr': 'Volailles malades'}, 'health', SickChickenReport, ['user', 'diagnosed_disease', 'urgency', 'confidence_level', 'timestamp'], ['diagnosed_disease', 'symptoms_text'], ['urgency']),
    _section('vets', {'sw': 'Madaktari', 'en': 'Doctors', 'fr': 'Vétérinaires'}, 'health', VetProfile, ['name', 'specialty', 'phone', 'location', 'is_available', 'rating'], ['name', 'specialty', 'phone', 'location'], ['is_available']),
    _section('training', {'sw': 'Mafunzo', 'en': 'Training', 'fr': 'Formation'}, 'content', TrainingModule, ['title', 'category', 'content_type', 'duration_or_read_time'], ['title', 'summary'], ['category']),
    _section('providers', {'sw': 'Watoa huduma', 'en': 'Service providers', 'fr': 'Prestataires'}, 'content', ServiceProvider, ['name', 'category', 'phone', 'location', 'rating'], ['name', 'phone', 'location'], ['category']),
    _section('notifications', {'sw': 'Arifa', 'en': 'Notifications', 'fr': 'Notifications'}, 'content', AppNotification, ['user', 'title', 'type', 'is_read', 'time'], ['title', 'message'], ['type', 'is_read']),
    _section('community', {'sw': 'Jumuiya', 'en': 'Community', 'fr': 'Communauté'}, 'content', CommunityPost, ['title', 'author_name', 'author', 'timestamp'], ['title', 'content', 'author_name'], []),
]

SECTION_MAP = {item['key']: item for item in SECTIONS}


def _staff(view):
    def wrapper(request, *args, **kwargs):
        if not request.user.is_authenticated or not request.user.is_staff:
            return redirect('panel_login')
        return view(request, *args, **kwargs)

    return wrapper


def _lang(request):
    lang = request.session.get('admin_lang', 'sw')
    return lang if lang in LANGS else 'sw'


def _pack(section, lang):
    packed = dict(section)
    packed['label'] = _text(section['labels'], lang, section['key'])
    return packed


def _groups(lang):
    groups = []
    for section in SECTIONS:
        if not groups or groups[-1]['key'] != section['group']:
            groups.append({'key': section['group'], 'name': _text(GROUPS, lang, section['group']), 'items': []})
        groups[-1]['items'].append(_pack(section, lang))
    return groups


def _page(request, **extra):
    lang = _lang(request)
    extra['lang'] = lang
    extra['ui'] = UI[lang]
    extra['groups'] = _groups(lang)
    return extra


def _form_for(model):
    exclude = [model._meta.pk.name]
    for field in model._meta.fields:
        if getattr(field, 'auto_now', False) or getattr(field, 'auto_now_add', False):
            exclude.append(field.name)
    if model is User:
        exclude += ['password', 'last_login', 'is_superuser', 'is_staff', 'groups', 'user_permissions']

    class PanelForm(forms.ModelForm):
        new_password = forms.CharField(required=False, widget=forms.PasswordInput, label='Password')

        class Meta:
            model = model
            exclude = exclude

        def __init__(self, *args, **kwargs):
            super().__init__(*args, **kwargs)
            if model is not User:
                self.fields.pop('new_password', None)
            for field in self.fields.values():
                css = 'input'
                if isinstance(field.widget, forms.CheckboxInput):
                    css = 'check'
                elif isinstance(field.widget, forms.Textarea):
                    css = 'input area'
                field.widget.attrs['class'] = css

    return PanelForm


def _display(obj, name):
    value = getattr(obj, name)
    if hasattr(value, 'all'):
        return value
    return value if value not in (None, '') else '-'


def language_view(request):
    lang = request.GET.get('lang', 'sw')
    if lang in LANGS:
        request.session['admin_lang'] = lang
    nxt = request.GET.get('next', '/manage/')
    if not nxt.startswith('/manage'):
        nxt = '/manage/'
    return redirect(nxt)


def login_view(request):
    if request.user.is_authenticated and request.user.is_staff:
        return redirect('panel_home')
    ui = UI[_lang(request)]
    error = ''
    if request.method == 'POST':
        user = authenticate(
            request,
            username=request.POST.get('username', '').strip(),
            password=request.POST.get('password', ''),
        )
        if user is not None and user.is_staff:
            login(request, user)
            return redirect('panel_home')
        error = ui['bad_login']
    return render(request, 'manage/login.html', {'error': error, 'ui': ui, 'lang': _lang(request)})


def logout_view(request):
    logout(request)
    return redirect('panel_login')


@_staff
def home(request):
    cards = []
    for section in SECTIONS:
        cards.append({
            'count': section['model'].objects.count(),
            'url_name': 'panel_list',
            'key': section['key'],
        })
    lang = _lang(request)
    for card in cards:
        card['label'] = _text(SECTION_MAP[card['key']]['labels'], lang, card['key'])
    birds = FarmProfile.objects.aggregate(total=Sum('total_chickens'))['total'] or 0
    return render(request, 'manage/home.html', _page(
        request,
        cards=cards,
        birds=birds,
        active='home',
    ))


@_staff
def object_list(request, key):
    section = SECTION_MAP[key]
    base = section['model'].objects.all()
    qs = base
    query = request.GET.get('q', '').strip()
    if query and section['search']:
        lookup = Q()
        for name in section['search']:
            lookup |= Q(**{f'{name}__icontains': query})
        qs = qs.filter(lookup)
    chosen = {}
    for name in section['filters']:
        value = request.GET.get(name, '')
        chosen[name] = value
        if value != '':
            qs = qs.filter(**{name: value})
    page = Paginator(qs, 20).get_page(request.GET.get('page'))
    records = [
        {'pk': obj.pk, 'cells': [_display(obj, name) for name in section['columns']]}
        for obj in page.object_list
    ]
    filter_options = []
    for name in section['filters']:
        field = section['model']._meta.get_field(name)
        options = []
        if field.choices:
            options = list(field.choices)
        elif field.get_internal_type() == 'BooleanField':
            yes_no = {'sw': ('Ndiyo', 'Hapana'), 'en': ('Yes', 'No'), 'fr': ('Oui', 'Non')}[_lang(request)]
            options = [('True', yes_no[0]), ('False', yes_no[1])]
        else:
            options = [(item, item) for item in base.order_by().values_list(name, flat=True).distinct()[:30] if item not in (None, '')]
        filter_options.append({'name': name, 'label': _text(COLUMNS, _lang(request), name), 'options': options, 'value': chosen[name]})
    lang = _lang(request)
    return render(request, 'manage/list.html', _page(
        request,
        section=_pack(section, lang),
        page=page,
        records=records,
        query=query,
        filters=filter_options,
        column_labels=[_text(COLUMNS, lang, name) for name in section['columns']],
        active=key,
    ))


@_staff
@require_http_methods(['GET', 'POST'])
def object_create(request, key):
    section = SECTION_MAP[key]
    form = _form_for(section['model'])(request.POST or None, request.FILES or None)
    if request.method == 'POST' and form.is_valid():
        obj = form.save(commit=False)
        if section['model'] is User:
            password = form.cleaned_data.get('new_password') or get_random_string(12)
            obj.set_password(password)
        obj.save()
        form.save_m2m()
        return redirect('panel_detail', key=key, pk=obj.pk)
    lang = _lang(request)
    return render(request, 'manage/form.html', _page(
        request,
        section=_pack(section, lang),
        form=form,
        active=key,
        mode=UI[lang]['create'],
    ))


@_staff
def object_detail(request, key, pk):
    section = SECTION_MAP[key]
    obj = get_object_or_404(section['model'], pk=pk)
    rows = []
    for field in section['model']._meta.fields:
        if field.name == 'password':
            continue
        rows.append((field.verbose_name, _display(obj, field.name)))
    lang = _lang(request)
    return render(request, 'manage/detail.html', _page(
        request,
        section=_pack(section, lang),
        obj=obj,
        rows=rows,
        active=key,
    ))


@_staff
@require_http_methods(['GET', 'POST'])
def object_edit(request, key, pk):
    section = SECTION_MAP[key]
    obj = get_object_or_404(section['model'], pk=pk)
    form = _form_for(section['model'])(request.POST or None, request.FILES or None, instance=obj)
    if request.method == 'POST' and form.is_valid():
        saved = form.save(commit=False)
        if section['model'] is User and form.cleaned_data.get('new_password'):
            saved.set_password(form.cleaned_data['new_password'])
        saved.save()
        form.save_m2m()
        return redirect('panel_detail', key=key, pk=saved.pk)
    lang = _lang(request)
    return render(request, 'manage/form.html', _page(
        request,
        section=_pack(section, lang),
        form=form,
        active=key,
        mode=UI[lang]['edit'],
    ))


@_staff
@require_http_methods(['POST'])
def object_delete(request, key, pk):
    section = SECTION_MAP[key]
    obj = get_object_or_404(section['model'], pk=pk)
    obj.delete()
    return redirect('panel_list', key=key)
