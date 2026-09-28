from django.core.management.base import BaseCommand

from core.models import ServiceProvider, TrainingModule, VetProfile


class Command(BaseCommand):
    help = 'Load platform catalog data (vets, service providers, training) into the kuku database.'

    def handle(self, *args, **options):
        vets = [
            {
                'name': 'Dr. Elizabeth Mwangi',
                'specialty': 'Daktari wa Ndege na Kuku',
                'location': 'Kibaha, Pwani',
                'rating': 4.9,
                'review_count': 42,
                'phone': '+255 754 111 222',
                'is_available': True,
            },
            {
                'name': 'Dr. Hassan Juma',
                'specialty': 'Mtaalamu wa Magonjwa ya Kuku',
                'location': 'Dar es Salaam',
                'rating': 4.8,
                'review_count': 38,
                'phone': '+255 788 333 444',
                'is_available': True,
            },
        ]
        for item in vets:
            VetProfile.objects.update_or_create(name=item['name'], defaults=item)

        providers = [
            {
                'name': 'Dr. Elizabeth Mwangi (Daktari wa Mifugo)',
                'category': 'Veterinary Doctors',
                'location': 'Kibaha, Pwani',
                'phone': '+255 754 111 222',
                'rating': '4.9 ⭐',
                'description': 'Mtaalamu aliyehitimu wa magonjwa ya kuku na ndege. Huduma za dharura masaa 24.',
            },
            {
                'name': 'Mifugo Feeds Ltd (Muuzaji wa Vyakula)',
                'category': 'Feed Suppliers',
                'location': 'Ubungo, Dar es Salaam',
                'phone': '+255 715 333 444',
                'rating': '4.8 ⭐',
                'description': 'Vyakula vya kuku wa aina zote: Starter, Grower, na Layer Mash vyenye ubora wa viwango.',
            },
            {
                'name': 'TanBroilers Hatchery (Kituo cha Vifaranga)',
                'category': 'Hatcheries',
                'location': 'Morogoro',
                'phone': '+255 788 555 666',
                'rating': '4.9 ⭐',
                'description': 'Uzalishaji wa vifaranga wa siku 1 wa kuku wa nyama na mayai wenye chanjo kamili.',
            },
            {
                'name': 'Express Agro Transporters (Usafirishaji)',
                'category': 'Transporters',
                'location': 'Dar es Salaam & Pwani',
                'phone': '+255 713 777 888',
                'rating': '4.7 ⭐',
                'description': 'Magari yaliyotengenezwa maalum kusafirisha vifaranga, kuku na trei za mayai kwa usalama.',
            },
            {
                'name': 'Jubilee Agro Insurance (Bima ya Ufugaji)',
                'category': 'Insurance Providers',
                'location': 'Dar es Salaam',
                'phone': '+255 752 999 000',
                'rating': '4.6 ⭐',
                'description': 'Bima ya kuzuia hasara za majanga, milipuko ya magonjwa na vifo vya kuku shambani.',
            },
            {
                'name': 'FINCA Microfinance (Mikopo ya Ufugaji)',
                'category': 'Financial Services',
                'location': 'Kibaha & Dar es Salaam',
                'phone': '+255 800 110 022',
                'rating': '4.5 ⭐',
                'description': 'Mikopo ya masharti nafuu kwa ajili ya kufanikisha ujenzi wa mabanda na ununuzi wa chakula.',
            },
        ]
        for item in providers:
            ServiceProvider.objects.update_or_create(name=item['name'], defaults=item)

        modules = [
            {
                'title': 'Mbinu Bora za Kulea Vifaranga (Brooding Period)',
                'category': 'Brooding',
                'content_type': 'Video',
                'duration_or_read_time': '8 Min Video',
                'summary': 'Jifunze jinsi ya kuandaa joto, taa na maji ya sukari kwa vifaranga wa siku 1-14.',
                'content_details': (
                    'Katika wiki mbili za kwanza, vifaranga hawana uwezo wa kudhibiti joto la miili yao. '
                    'Ni muhimu kutumia taa za joto, kuhakikisha sakafu ina maranda makavu na kutoa maji yenye glucose.'
                ),
                'video_url': 'https://www.youtube.com/embed/sample1',
                'quiz_questions': [
                    {
                        'question': 'Joto bora kwa vifaranga wa siku ya kwanza bandani ni kiasi gani?',
                        'options': ['20°C - 25°C', '32°C - 35°C', '40°C - 45°C'],
                        'correct_option_index': 1,
                    },
                    {
                        'question': 'Kitu gani kinapaswa kuwekwa kwenye maji siku ya kwanza vifaranga wanapowasili?',
                        'options': ['Chumvi nyingi', 'Glucose au Sukari kidogo', 'Dawa ya mafua'],
                        'correct_option_index': 1,
                    },
                ],
            },
            {
                'title': 'Lishe Sahihi na Kanuni za Kutengeneza Chakula cha Kuku',
                'category': 'Feeding',
                'content_type': 'Article',
                'duration_or_read_time': 'Dakika 5 Kusoma',
                'summary': 'Kuelewa viwango vya protini, nishati na calcium vinavyohitajika kwa kila umri.',
                'content_details': (
                    'Kuku wa mayai wanahitaji angalau 16-18% ya protini na 3.5-4% ya calcium (chokaa) '
                    'ili kutaga mayai yenye ganda gumu. Kuku wa nyama wanahitaji protini kubwa (20-22%) katika wiki za kwanza.'
                ),
                'video_url': '',
                'quiz_questions': [],
            },
            {
                'title': 'Kuzuia Magonjwa Bandani (Biosecurity Guidelines)',
                'category': 'Disease Prevention',
                'content_type': 'PDF',
                'duration_or_read_time': 'Mwongozo wa Kurasa 4',
                'summary': 'Hatua za kuzuia wageni, kutumia dawa za kukanyaga langoni na usafi wa vyombo.',
                'content_details': (
                    'Asilimia 80% ya magonjwa ya kuku yanatoka nje ya banda. '
                    'Weka footbath ya dawa mlangoni na usiruhusu wageni kuingia bila kuvaa nguo za kazi.'
                ),
                'video_url': '',
                'quiz_questions': [],
            },
            {
                'title': 'Ujenzi wa Banda Bora la Kuku lenye Hewa Safi',
                'category': 'Housing',
                'content_type': 'Images',
                'duration_or_read_time': 'Picha 12 na Maelezo',
                'summary': 'Michoro na vipimo vya banda lisilochochea joto kali au baridi.',
                'content_details': (
                    'Banda lazima lielemee upande wa Mashariki-Magharibi kuzuia jua kuingia moja kwa moja. '
                    'Kuta ziwe na urefu wa futi 3 za tofali na iliyobaki iwe wavu.'
                ),
                'video_url': '',
                'quiz_questions': [],
            },
        ]
        for item in modules:
            TrainingModule.objects.update_or_create(title=item['title'], defaults=item)

        self.stdout.write(self.style.SUCCESS('Catalog data saved to the kuku database.'))
