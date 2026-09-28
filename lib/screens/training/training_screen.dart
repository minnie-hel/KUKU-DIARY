import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Brooding',
    'Feeding',
    'Disease Prevention',
    'Housing',
    'Incubation',
    'Business Skills',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    final filteredModules = _selectedCategory == 'All'
        ? appState.trainingModules
        : appState.trainingModules.where((m) => m.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Mafunzo ya Ufugaji' : 'Poultry Training'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Horizontal Filter Bar
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (ctx, idx) {
                final cat = _categories[idx];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(
                      _getCategoryLabel(cat, isSw),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selectedColor: AppTheme.primaryGreen,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Training Content List
          Expanded(
            child: filteredModules.isEmpty
                ? Center(
                    child: Text(
                      isSw ? 'Hakuna mafunzo katika jamii hii kwa sasa' : 'No training contents found for this category',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredModules.length,
                    itemBuilder: (context, index) {
                      final item = filteredModules[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getContentTypeColor(item.contentType),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(_getContentTypeIcon(item.contentType), size: 16, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.contentType,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    item.durationOrReadTime,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.summary,
                                style: const TextStyle(fontSize: 15, height: 1.3, color: Colors.black87),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _openTrainingDetails(context, item, isSw),
                                      icon: const Icon(Icons.menu_book_rounded, size: 20),
                                      label: Text(
                                        isSw ? 'Soma / Tazama' : 'Read / Watch',
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  if (item.quizQuestions != null && item.quizQuestions!.isNotEmpty) ...[
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      onPressed: () => _startQuizDialog(context, item, isSw),
                                      icon: const Icon(Icons.quiz_rounded, size: 20),
                                      label: Text(
                                        isSw ? 'Fanya Quiz' : 'Quiz',
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.amberGold,
                                        foregroundColor: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(String cat, bool isSw) {
    if (!isSw) return cat;
    switch (cat) {
      case 'All':
        return 'Yote';
      case 'Brooding':
        return 'Kulea Vifaranga';
      case 'Feeding':
        return 'Lishe & Chakula';
      case 'Disease Prevention':
        return 'Kuzuia Magonjwa';
      case 'Housing':
        return 'Ujenzi wa Banda';
      case 'Incubation':
        return 'Utotoleshaji';
      case 'Business Skills':
        return 'Biashara & Masoko';
      default:
        return cat;
    }
  }

  Color _getContentTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Colors.red;
      case 'article':
        return AppTheme.primaryGreen;
      case 'pdf':
        return Colors.orange.shade800;
      case 'quiz':
        return AppTheme.amberGold;
      default:
        return AppTheme.infoBlue;
    }
  }

  IconData _getContentTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.play_circle_fill_rounded;
      case 'article':
        return Icons.article_rounded;
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'quiz':
        return Icons.psychology_rounded;
      default:
        return Icons.image_rounded;
    }
  }

  void _openTrainingDetails(BuildContext context, TrainingModule item, bool isSw) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 28),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(height: 20),
              if (item.contentType == 'Video') ...[
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 60),
                        const SizedBox(height: 8),
                        Text(
                          isSw ? 'Bonyeza kucheza Video ya Mafunzo' : 'Tap to play Training Video',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                item.contentDetails,
                style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(isSw ? 'Funga Mafunzo' : 'Close Module', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startQuizDialog(BuildContext context, TrainingModule item, bool isSw) {
    int selectedOption = -1;
    int currentQuestionIndex = 0;
    int score = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final q = item.quizQuestions![currentQuestionIndex];

          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${isSw ? 'Jaribio' : 'Quiz'} (${currentQuestionIndex + 1}/${item.quizQuestions!.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.psychology_rounded, color: AppTheme.amberGold, size: 28),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.question,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                ...List.generate(
                  q.options.length,
                  (optIdx) => RadioListTile<int>(
                    title: Text(q.options[optIdx], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    value: optIdx,
                    groupValue: selectedOption,
                    activeColor: AppTheme.primaryGreen,
                    onChanged: (val) {
                      setState(() {
                        selectedOption = val!;
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: selectedOption == -1
                    ? null
                    : () {
                        if (selectedOption == q.correctOptionIndex) {
                          score++;
                        }
                        if (currentQuestionIndex + 1 < item.quizQuestions!.length) {
                          setState(() {
                            currentQuestionIndex++;
                            selectedOption = -1;
                          });
                        } else {
                          Navigator.pop(ctx);
                          _showQuizResults(context, score, item.quizQuestions!.length, isSw);
                        }
                      },
                child: Text(
                  currentQuestionIndex + 1 < item.quizQuestions!.length
                      ? (isSw ? 'Swali Linalofuata' : 'Next Question')
                      : (isSw ? 'Maliza Jaribio' : 'Finish Quiz'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showQuizResults(BuildContext context, int score, int total, bool isSw) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSw ? 'Matokeo ya Jaribio' : 'Quiz Score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars_rounded, color: AppTheme.amberGold, size: 64),
            const SizedBox(height: 12),
            Text(
              '$score / $total',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 8),
            Text(
              score == total
                  ? (isSw ? 'Hongera sana! Umejibu maswali yote kwa usahihi.' : 'Excellent work! You got full score.')
                  : (isSw ? 'Jaribio zuri. Endelea kujifunza ili kuongeza uelewa.' : 'Good attempt! Keep learning to improve.'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isSw ? 'Sawa' : 'OK', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
