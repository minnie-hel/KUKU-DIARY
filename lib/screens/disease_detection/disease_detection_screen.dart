import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final TextEditingController _symptomsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  bool _isAnalyzing = false;
  SickChickenReport? _currentResult;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(source: source);
      if (photo != null) {
        setState(() {
          _selectedImagePath = photo.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Picha haikuchukuliwa: $e')),
      );
    }
  }

  void _runAiDiagnosis() {
    if (_symptomsController.text.isEmpty && _selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tafadhali piga picha, pakia video au eleza dalili za kuku wako kwanza.'),
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _currentResult = null;
    });

    Future.delayed(const Duration(milliseconds: 1500), () async {
      try {
        final appState = Provider.of<AppState>(context, listen: false);
        final report = await appState.performAIDiagnosis(_symptomsController.text, _selectedImagePath);
        if (!mounted) return;
        setState(() {
          _isAnalyzing = false;
          _currentResult = report;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.infoBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.infoBlue.withValues(alpha: 0.3)),
              ),
              child: Text(
                isSw
                    ? 'Utambuzi wa AI ni wa awali tu na hauchukui nafasi ya daktari wa mifugo.'
                    : 'AI screening is preliminary and does not replace professional veterinary diagnosis.',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.infoBlue),
              ),
            ),
            const SizedBox(height: 12),
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGreen, AppTheme.primaryGreen.withValues(alpha: 0.85)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology_rounded, color: AppTheme.amberGold, size: 48),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSw ? 'Msaidizi wa Akili Bandia (AI)' : 'AI Poultry Health Scanner',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSw
                              ? 'Piga picha ya kuku, macho, pua au kinyesi, au eleza dalili ili kugundua ugonjwa papo hapo.'
                              : 'Take a picture of the bird, droppings, or describe symptoms for instant AI diagnosis.',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Options: Take Photo, Upload Photo, Upload Video
            Text(
              isSw ? '1. Piga au Pakia Picha / Video ya Kuku' : '1. Capture Photo or Video of Chicken',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_rounded, size: 24),
                    label: Text(isSw ? 'Piga Picha' : 'Camera', style: const TextStyle(fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded, size: 24),
                    label: Text(isSw ? 'Pakia Picha' : 'Gallery', style: const TextStyle(fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.infoBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_selectedImagePath != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isSw ? 'Picha imechaguliwa kwa ajili ya uchunguzi' : 'Photo selected for AI analysis',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.red),
                      onPressed: () => setState(() => _selectedImagePath = null),
                    ),
                  ],
                ),
              ),

            // Describe Symptoms Text Input
            Text(
              isSw ? '2. Eleza Dalili Zinazoonekana' : '2. Describe Observed Symptoms',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _symptomsController,
              maxLines: 3,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: isSw
                    ? 'Mfano: Kuku anakohoa, ana kamasi puani, na kinyesi chake ni cha kijani kibichi au cha damu...'
                    : 'E.g., Chicken coughing, watery discharge from eyes, green/bloody droppings...',
              ),
            ),
            const SizedBox(height: 20),

            // Diagnose Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _runAiDiagnosis,
                icon: _isAnalyzing
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Icon(Icons.saved_search_rounded, size: 28),
                label: Text(
                  _isAnalyzing
                      ? (isSw ? 'AI Inachunguza Picha...' : 'AI Analyzing Photo...')
                      : (isSw ? 'KAGUA AFYA YA KUKU (AI DIAGNOSIS)' : 'RUN AI DIAGNOSIS'),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.amberGold,
                  foregroundColor: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Diagnosis Result Card
            if (_currentResult != null) ...[
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: _currentResult!.urgency.contains('Dharura') ? Colors.red : AppTheme.primaryGreen,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${isSw ? 'Uharaka' : 'Urgency'}: ${_currentResult!.urgency}',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${isSw ? 'Uhakika' : 'Confidence'}: ${_currentResult!.confidenceLevel}',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isSw ? 'Ugonjwa Uliogundulika:' : 'Diagnosed Disease:',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _currentResult!.diagnosedDisease,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                      const Divider(height: 24),
                      Text(
                        isSw ? 'Hatua Inayopendekezwa:' : 'Recommended Action:',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentResult!.recommendedAction,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isSw ? 'Dawa Zinazoshauriwa:' : 'Suggested Medicines:',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _currentResult!.recommendedMedicines
                            .map(
                              (med) => Chip(
                                backgroundColor: AppTheme.lightGreen,
                                avatar: const Icon(Icons.medication_rounded, size: 18, color: AppTheme.primaryGreen),
                                label: Text(med, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            appState.setActiveDrawerModule('veterinary');
                          },
                          icon: const Icon(Icons.medical_services_rounded, color: AppTheme.primaryGreen),
                          label: Text(
                            isSw ? 'ZUNGUMZA NA DAKTARI WA MIFUGO' : 'CONTACT VETERINARIAN NOW',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.primaryGreen, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
    );
  }
}
