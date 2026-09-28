from datetime import timedelta

from django.utils import timezone

from .models import FarmProfile, FeedInventoryItem, FinanceRecord, ProductionLog, SickChickenReport


def diagnose_from_symptoms(symptoms):
    text = (symptoms or '').lower()
    if any(word in text for word in ('kamasi', 'macho', 'mafua', 'sneeze', 'nasal')):
        return {
            'diagnosed_disease': 'Mafua ya Kuku (Infectious Coryza)',
            'confidence_level': '94%',
            'urgency': 'Kawaida',
            'recommended_action': (
                'Tenga kuku wagonjwa mara moja kwenye banda la karantini. '
                'Safisha vyombo vya maji kwa dawa ya kuua vijidudu.'
            ),
            'recommended_medicines': ['Tylosin Powder', 'Doxycycline 20%', 'Multivitamin Stress Pack'],
        }
    if any(word in text for word in ('damu', 'kinyesi cha damu', 'bloody', 'coccid')):
        return {
            'diagnosed_disease': 'Kuhara Damu (Coccidiosis)',
            'confidence_level': '96%',
            'urgency': 'Ya Dharura',
            'recommended_action': (
                'Badilisha pumba au maranda ya chini (litter) kwani yana unyevu. '
                'Weka dawa kwenye maji kwa siku 5 mfululizo.'
            ),
            'recommended_medicines': ['Amprolium 20%', 'ESB3 Powder', 'Vitamin K3'],
        }
    return {
        'diagnosed_disease': 'Kideri / Newcastle Disease (Hatua ya Awali)',
        'confidence_level': '89%',
        'urgency': 'Ya Dharura',
        'recommended_action': (
            'Choma chanjo kwa kuku salama waliobaki. '
            'Weka kuku wenye ugonjwa mbali na kundi kuu na uwasiliane na Daktari wa Mifugo.'
        ),
        'recommended_medicines': ['Lasota Vaccine', 'Antibiotics for Secondary Infection', 'Vitalytes Plus'],
    }


def generate_ai_response(prompt):
    p = (prompt or '').lower()
    if 'mayai' in p and any(w in p for w in ('kupungua', 'hawatagi', 'drop', 'lay')):
        return (
            'Kupungua kwa utagaji wa mayai kunaweza kusababishwa na:\n'
            '1. Mabadiliko ya chakula au chakula kisicho na protini ya kutosha (inahitajika 16-18%).\n'
            '2. Ukosefu wa maji safi na baridi.\n'
            '3. Msongo wa mawazo (Stress) mfano kelele au joto kali.\n'
            '4. Magonjwa kama Kideri (Newcastle) au Typhoid.\n\n'
            'Ushauri: Hakikisha chakula kina calcium (chokaa) na maji yapo wakati wote.'
        )
    if any(w in p for w in ('kula', 'hawali', 'appetite')):
        return (
            'Kuku kutokula kunaashiria dalili za awali za ugonjwa au joto kali bandani.\n'
            '1. Angalia kama wanakohoa au kutoa kamasi.\n'
            '2. Angalia kinyesi chao (kama ni cha kijani, cheupe au cha damu).\n'
            '3. Wape maji yaliyochanganywa na Multivitamin na Glucose mara moja.'
        )
    if any(w in p for w in ('kideri', 'newcastle')):
        return (
            'Kideri ni ugonjwa wa virusi hatari sana. Dalili ni pamoja na kuku kupinda shingo, '
            'kinyesi cha kijani kibichi na kupooza.\n\n'
            'Tiba: Hakuna tiba ya moja kwa moja ya virusi. Wape Multivitamin + Antibiotic '
            'kuzuia maambukizi ya sekondari. Hakikisha unawapa Chanjo ya Lasota mapema!'
        )
    if any(w in p for w in ('dawa', 'medicine', 'nini')):
        return (
            'Kabla ya kutoa dawa, ni muhimu kutambua chanzo cha tatizo. '
            'Kwa matatizo ya mfumo wa hewa (mafua), tumia Tylosin au Doxycycline. '
            'Kwa kinyesi cha damu (Coccidiosis), tumia Amprolium au ESB3.'
        )
    return (
        'Asante kwa swali lako. Kwa uzoefu wa KUKU DIARY, inashauriwa kufuatilia lishe bora, '
        'usafi wa banda, na chanjo kwa wakati. Kama dalili zinaendelea, tunashauri uweke miadi '
        'na Daktari wa Mifugo aliye karibu nawe.'
    )


def compute_today_summary(user):
    farm = farm_or_none(user)
    total = farm.total_chickens if farm else 0
    now = timezone.localtime()
    day_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    day_end = day_start + timedelta(days=1)

    logs = ProductionLog.objects.filter(user=user).order_by('date')
    today_logs = logs.filter(date__gte=day_start, date__lt=day_end)
    latest = logs.last()

    eggs = sum(item.eggs for item in today_logs) if today_logs.exists() else (latest.eggs if latest else 0)
    mortality_today = sum(item.mortality for item in today_logs)
    sick = SickChickenReport.objects.filter(user=user, timestamp__gte=day_start).count()
    healthy = max(total - sick - mortality_today, 0)
    feed_remaining = sum(item.current_stock_kg for item in FeedInventoryItem.objects.filter(user=user))
    income = sum(
        item.amount
        for item in FinanceRecord.objects.filter(user=user, type='Mapato', date__gte=day_start, date__lt=day_end)
    )
    productivity = (eggs / total * 100) if total > 0 else 0
    return {
        'eggs_collected': eggs,
        'healthy_chickens': healthy,
        'sick_chickens': sick,
        'mortality': mortality_today,
        'feed_remaining_kg': round(feed_remaining, 2),
        'today_income_tsz': income,
        'productivity_percentage': round(productivity, 1),
    }


def farm_or_none(user):
    try:
        return user.farm
    except FarmProfile.DoesNotExist:
        return None
