import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  double _userProgress = 0.65; // 65% completed

  final List<Map<String, dynamic>> _lessons = [
    {
      'title': 'Jinsi ya Kuandaa Banda la Kuku wa Mayai',
      'category': 'Usimamizi wa Banda',
      'duration': 'Dakika 12',
      'type': 'video',
      'description': 'Jifunze vipimo sahihi vya banda, mzunguko wa hewa na maandalizi ya mazingira kabla ya kuingiza vifaranga.',
      'views': '2.4k Views',
    },
    {
      'title': 'Kilimo cha Azolla na Lishe Mbadala ya Kuku',
      'category': 'Lishe & Vyakula',
      'duration': 'Dakika 18',
      'type': 'video',
      'description': 'Jinsi ya kuotesha Azolla nyumbani kwako kupunguza gharama za chakula cha kuku kwa 40%.',
      'views': '5.1k Views',
    },
    {
      'title': 'Utambuzi wa Mapema wa Ugonjwa wa Kideri',
      'category': 'Magonjwa & Tiba',
      'duration': 'Dakika 10',
      'type': 'video',
      'description': 'Njia sahihi za kuchoma chanjo na kutambua dalili za Kideri mapema mno.',
      'views': '3.8k Views',
    },
    {
      'title': 'Mwongozo wa Uwekaji Kumbukumbu za Shamba',
      'category': 'Biashara & Masoko',
      'duration': 'Dakika 8',
      'type': 'article',
      'description': 'Makala maalum inayoeleza jinsi ya kuhesabu faida na hasara katika kila awamu ya utagaji.',
      'views': '1.9k Readers',
    },
  ];

  void _openLesson(Map<String, dynamic> lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),

            // Video Player Simulator Box
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.play_circle_fill_rounded, color: AppTheme.amberGold, size: 64),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lesson['duration'] as String, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        const Text('HD 1080p', style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              lesson['title'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Chip(label: Text(lesson['category'] as String, style: const TextStyle(fontSize: 11))),
                const SizedBox(width: 8),
                Text(lesson['views'] as String, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),

            const Text('Maelezo ya Somo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text(
              lesson['description'] as String,
              style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 14),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _userProgress = (_userProgress + 0.1).clamp(0.0, 1.0);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Somo limekamilika! Maendeleo yako yameongezeka.')),
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('WEKA ALAMA YA SOMO LIMEKAMILIKA'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Learning Progress Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Maendeleo Yako ya Masomo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${(_userProgress * 100).toInt()}%', style: const TextStyle(color: AppTheme.amberGold, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _userProgress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    color: AppTheme.amberGold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Umekamilisha masomo 8 kati ya 12 katika kozi hii.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Categories Chips
          const Text('Kipengele cha Elimu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('Masomo Yote', true),
                _buildCategoryChip('Lishe & Vyakula', false),
                _buildCategoryChip('Magonjwa & Tiba', false),
                _buildCategoryChip('Usimamizi wa Banda', false),
                _buildCategoryChip('Biashara', false),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Lessons List
          const Text('Masomo na Video za Mafunzo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _lessons.length,
            itemBuilder: (context, index) {
              final lesson = _lessons[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lesson['type'] == 'video' ? Colors.red.shade100 : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      lesson['type'] == 'video' ? Icons.play_arrow_rounded : Icons.article_rounded,
                      color: lesson['type'] == 'video' ? Colors.red : Colors.blue,
                      size: 28,
                    ),
                  ),
                  title: Text(lesson['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text('${lesson['category']} • ${lesson['duration']}'),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _openLesson(lesson),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.primaryGreen,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        onSelected: (val) {},
      ),
    );
  }
}
