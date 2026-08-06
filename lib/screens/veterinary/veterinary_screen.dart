import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class VeterinaryScreen extends StatefulWidget {
  const VeterinaryScreen({super.key});

  @override
  State<VeterinaryScreen> createState() => _VeterinaryScreenState();
}

class _VeterinaryScreenState extends State<VeterinaryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _symptomsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _capturedImagePath;
  SickChickenReport? _currentAiResult;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _capturedImagePath = photo.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Picha ya kuku imechukuliwa kwa kamera!')),
          );
        }
      }
    } catch (e) {
      _pickFromGallery();
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _capturedImagePath = image.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Picha imechaguliwa kutoka galari!')),
          );
        }
      }
    } catch (err) {
      setState(() {
        _capturedImagePath = 'picha_kuku_mgonjwa.jpg';
      });
    }
  }

  void _runAiDiagnosis() {
    if (_symptomsController.text.isEmpty && _capturedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tafadhali piga picha au chagua picha ya kuku kwanza.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);
      final result = appState.performAIDiagnosis(
        _symptomsController.text.isEmpty ? 'Kuku ana dalili za mafua na kukataa kula' : _symptomsController.text,
        _capturedImagePath,
      );
      setState(() {
        _isAnalyzing = false;
        _currentAiResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryGreen,
              unselectedLabelColor: const Color(0xFF6B7280),
              indicatorColor: AppTheme.primaryGreen,
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              tabs: const [
                Tab(icon: Icon(Icons.camera_alt_rounded, size: 24), text: '📸 Piga Picha Afya'),
                Tab(icon: Icon(Icons.medication_rounded, size: 24), text: '💊 Dawa & Daktari'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Instant AI Health Analysis (Kiswahili)
                _buildReportSickTab(context, appState),

                // Tab 2: Vet Home & Medicines
                _buildVetHomeTab(context, appState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSickTab(BuildContext context, AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Instant Health Analysis Header Card (Swahili)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology_rounded, color: AppTheme.primaryGreen, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Utambuzi wa Ugonjwa kwa AI',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.primaryGreen),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Piga picha au chagua picha ya kuku mgonjwa, majeraha au kinyesi upate ushauri wa haraka na dawa.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF374151), height: 1.4, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Chagua au Piga Picha ya Kuku',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 14),

          // 2. CAPTURE & UPLOAD OPTIONS (2 Clean Large Buttons: Camera & Gallery)
          Row(
            children: [
              // Camera Button
              Expanded(
                child: InkWell(
                  onTap: _capturePhoto,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.camera_alt_rounded, size: 36, color: Colors.white),
                        SizedBox(height: 8),
                        Text(
                          'Piga Picha Kamera',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Gallery Upload Button
              Expanded(
                child: InkWell(
                  onTap: _pickFromGallery,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.photo_library_rounded, size: 36, color: Color(0xFF1F2937)),
                        SizedBox(height: 8),
                        Text(
                          'Pakia kutoka Galari',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF1F2937)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Photo Preview Thumbnail
          if (_capturedImagePath != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen, width: 2),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _capturedImagePath!.startsWith('/') && File(_capturedImagePath!).existsSync()
                        ? Image.file(File(_capturedImagePath!), width: 56, height: 56, fit: BoxFit.cover)
                        : Container(
                            width: 56,
                            height: 56,
                            color: AppTheme.primaryGreen,
                            child: const Icon(Icons.pets_rounded, color: Colors.white, size: 30),
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen, size: 18),
                            SizedBox(width: 6),
                            Text('Picha ya Kuku Chuguliwa', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(_capturedImagePath!.split('/').last, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.red, size: 24),
                    onPressed: () {
                      setState(() {
                        _capturedImagePath = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // 3. DESCRIBE SYMPTOMS SECTION
          const Text(
            'Eleza Dalili za Kuku (Kama Zipo)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _symptomsController,
            maxLines: 3,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Mf. Kuku ana mafua, kamasi, anakohoa, au ameacha kula...',
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2.5)),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSymptomChip('Mafua & Kamasi'),
              _buildSymptomChip('Kinyesi cha Damu'),
              _buildSymptomChip('Kupinda Shingo'),
              _buildSymptomChip('Kukataa Kula'),
            ],
          ),
          const SizedBox(height: 24),

          // 4. RUN DIAGNOSIS BUTTON
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _runAiDiagnosis,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              icon: _isAnalyzing
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : const Icon(Icons.psychology_rounded, size: 26),
              label: Text(
                _isAnalyzing ? 'KAGUA UGONJWA KWA AI...' : 'GUNDUA UGONJWA KWA AI',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // AI Output Result Card
          if (_currentAiResult != null) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.primaryGreen, width: 2.5),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.smart_toy_rounded, color: AppTheme.primaryGreen, size: 28),
                          SizedBox(width: 8),
                          Text('Ripoti ya AI ya Ugonjwa', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'Uhakika: ${_currentAiResult!.confidenceLevel}',
                          style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w900, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 1.5),
                  Text(
                    'Ugonjwa Uliogundulika: ${_currentAiResult!.diagnosedDisease}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFDC2626)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hatua za Kuchukua: ${_currentAiResult!.recommendedAction}',
                    style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                  ),
                  const SizedBox(height: 14),
                  const Text('Dawa Zinazoshauriwa:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _currentAiResult!.recommendedMedicines
                        .map((med) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen, size: 18),
                                  const SizedBox(width: 8),
                                  Text(med, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _showBookVetDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.phone_in_talk_rounded),
                      label: const Text('PIGA SIMU KWA DAKTARI WA KUKU', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomChip(String label) {
    final isSelected = _symptomsController.text.contains(label);
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF1F2937), fontWeight: FontWeight.w800, fontSize: 13)),
      selected: isSelected,
      selectedColor: AppTheme.primaryGreen,
      backgroundColor: const Color(0xFFF3F4F6),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _symptomsController.text += (_symptomsController.text.isEmpty ? '' : ', ') + label;
          }
        });
      },
    );
  }

  Widget _buildVetHomeTab(BuildContext context, AppState appState) {
    final vets = appState.vets;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Madaktari wa Kuku Wanaopatikana',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vets.length,
            itemBuilder: (context, index) {
              final vet = vets[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.15),
                        child: const Icon(Icons.person_rounded, color: AppTheme.primaryGreen, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vet.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                            const SizedBox(height: 2),
                            Text('${vet.specialty} • ${vet.location}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text('${vet.rating} (${vet.reviewCount} reviews)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showBookVetDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Piga Simu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showBookVetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.phone_in_talk_rounded, color: AppTheme.primaryGreen, size: 28),
            SizedBox(width: 10),
            Text('Wasiliana na Daktari', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Daktari wa kuku atakupigia simu mara moja kupitia namba yako ya simu. Je, uko tayari?',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ghairi', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ombi lako la Daktari limetumwa! Atakupigia hivi karibuni.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: const Text('PIGA SIMU SASA', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
