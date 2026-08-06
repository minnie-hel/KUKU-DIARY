import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class FarmSetupScreen extends StatefulWidget {
  const FarmSetupScreen({super.key});

  @override
  State<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends State<FarmSetupScreen> {
  final _farmNameController = TextEditingController(text: 'Kuku Bora Farm');
  final _locationController = TextEditingController(text: 'Kibaha, Pwani');
  final _chickenCountController = TextEditingController(text: '450');

  String _selectedChickenType = 'Kuku wa Mayai (Layers)';
  String _selectedHousingKey = 'Mfumo wa Sakafu (Deep Litter)';
  bool _isGpsFetching = false;

  final List<String> _chickenTypes = [
    'Kuku wa Mayai (Layers)',
    'Kuku wa Nyama (Broilers)',
    'Kuku wa Kienyeji',
    'Kuku Chotara / Mixed',
  ];

  final List<Map<String, String>> _housingCards = [
    {
      'key': 'Mfumo wa Sakafu (Deep Litter)',
      'title': 'Banda la Sakafu',
      'sub': 'Sakafu yenye pumba au maranda ya mbao.',
    },
    {
      'key': 'Banda la Betri (Battery Cage)',
      'title': 'Banda la Betri / Cage',
      'sub': 'Mfumo wa nyavu za chuma wa kuku wa mayai.',
    },
    {
      'key': 'Mfumo wa Huria (Free Range)',
      'title': 'Mfumo wa Huria',
      'sub': 'Kuku wanatembea nje mchana kutafuta chakula.',
    },
    {
      'key': 'Nusu Huria (Semi-Intensive)',
      'title': 'Mfumo wa Nusu Huria',
      'sub': 'Mchanganyiko wa banda na eneo la nje.',
    },
  ];

  void _fetchGps() {
    setState(() {
      _isGpsFetching = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isGpsFetching = false;
          _locationController.text = 'Kibaha (Lat: -6.77, Long: 38.92)';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eneo la GPS limechukuliwa kikamilifu!')),
        );
      }
    });
  }

  void _finishSetup() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.updateFarmSetup(
      farmName: _farmNameController.text.trim(),
      location: _locationController.text.trim(),
      chickenType: _selectedChickenType,
      totalChickens: int.tryParse(_chickenCountController.text) ?? 450,
      housingSystem: _selectedHousingKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Usajili wa Shamba',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar (HATUA YA 1 KATI YA 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'HATUA YA 1 KATI YA 3',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '33% IMEKAMILIKA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.33,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                ),
              ),
              const SizedBox(height: 24),

              // Title in Swahili
              const Text(
                'Tuambie Kuhusu Shamba Lako',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 24),

              // Jina la Shamba
              _buildFieldLabel(Icons.home_work_outlined, 'Jina la Shamba Lako'),
              TextField(
                controller: _farmNameController,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: _buildInputDecoration('Mf. Kuku Bora Farm'),
              ),
              const SizedBox(height: 20),

              // Eneo / Mahali Shamba Lilipo + GPS Pin
              _buildFieldLabel(Icons.location_on_outlined, 'Mahali Shamba Lilipo (Mkoa / Wilaya)'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      decoration: _buildInputDecoration(
                        'Mf. Kibaha, Pwani',
                        suffixIcon: IconButton(
                          icon: _isGpsFetching
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.my_location_rounded, color: Color(0xFF0284C7), size: 24),
                          onPressed: _fetchGps,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Aina ya Kuku
              _buildFieldLabel(Icons.pets_outlined, 'Aina ya Kuku Wanaofugwa'),
              DropdownButtonFormField<String>(
                initialValue: _selectedChickenType,
                decoration: _buildInputDecoration(''),
                items: _chickenTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedChickenType = val);
                },
              ),
              const SizedBox(height: 20),

              // Idadi ya Kuku Bandani
              _buildFieldLabel(Icons.numbers_rounded, 'Idadi ya Kuku Wote Bandani'),
              TextField(
                controller: _chickenCountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                decoration: _buildInputDecoration(
                  'Mf. 450',
                  suffixWidget: const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Text(
                      'Kuku',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.primaryGreen),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Mfumo wa Banda Selection Cards
              _buildFieldLabel(Icons.grid_view_rounded, 'Aina ya Banda Lako (Housing System)'),
              const SizedBox(height: 8),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.45,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _housingCards.length,
                itemBuilder: (context, index) {
                  final card = _housingCards[index];
                  final isSelected = _selectedHousingKey == card['key'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedHousingKey = card['key']!;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryGreen : const Color(0xFFD1D5DB),
                          width: isSelected ? 2.5 : 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.home_work_outlined,
                            color: isSelected ? AppTheme.primaryGreen : const Color(0xFF6B7280),
                            size: 22,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            card['title']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: isSelected ? AppTheme.primaryGreen : const Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            card['sub']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4B5563),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // HIFADHI NA ENDELEA Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _finishSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'HIFADHI NA ENDELEA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryGreen),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {Widget? suffixIcon, Widget? suffixWidget}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
      suffix: suffixWidget,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2.5),
      ),
    );
  }
}
