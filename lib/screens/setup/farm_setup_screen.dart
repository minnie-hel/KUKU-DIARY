import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class FarmSetupScreen extends StatefulWidget {
  const FarmSetupScreen({super.key});

  @override
  State<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends State<FarmSetupScreen> {
  final _farmNameController = TextEditingController();
  final _farmerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _chickenCountController = TextEditingController();
  final _flockAgeController = TextEditingController();

  String _selectedChickenType = 'Kuku wa Mayai (Layers)';
  String _selectedHousingKey = 'Mfumo wa Sakafu (Deep Litter)';
  double _latitude = 0;
  double _longitude = 0;
  bool _isGpsFetching = false;
  bool _isSaving = false;

  final List<String> _chickenTypes = [
    'Kuku wa Kienyeji',
    'Kuku Bora wa Kienyeji',
    'Kuku wa Mayai (Layers)',
    'Kuku wa Nyama (Broilers)',
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
    {
      'key': 'Nyingine (Other)',
      'title': 'Nyingine',
      'sub': 'Mfumo mwingine wa banda.',
    },
  ];

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<AppState>(context, listen: false).farmProfile;
    _farmNameController.text = profile.farmName;
    _farmerNameController.text = profile.farmerName;
    _phoneController.text = profile.phone;
    _locationController.text = profile.location;
    _chickenCountController.text = profile.totalChickens > 0 ? '${profile.totalChickens}' : '';
    _flockAgeController.text = profile.farmSize;
    if (_chickenTypes.contains(profile.chickenType)) _selectedChickenType = profile.chickenType;
    if (_housingCards.any((c) => c['key'] == profile.housingSystem)) _selectedHousingKey = profile.housingSystem;
    _latitude = profile.latitude;
    _longitude = profile.longitude;
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _farmerNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _chickenCountController.dispose();
    _flockAgeController.dispose();
    super.dispose();
  }

  Future<void> _fetchGps() async {
    setState(() => _isGpsFetching = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Ruhusa ya GPS imekataliwa.');
      }
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        if (_locationController.text.trim().isEmpty) {
          _locationController.text =
              'Lat ${position.latitude.toStringAsFixed(4)}, Long ${position.longitude.toStringAsFixed(4)}';
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eneo la GPS limechukuliwa kikamilifu!')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isGpsFetching = false);
    }
  }

  Future<void> _finishSetup() async {
    if (_farmNameController.text.trim().isEmpty || _chickenCountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jaza jina la shamba na idadi ya kuku.')),
      );
      return;
    }
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() => _isSaving = true);
    try {
      await appState.updateFarmSetup(
        farmName: _farmNameController.text.trim(),
        location: _locationController.text.trim(),
        chickenType: _selectedChickenType,
        totalChickens: int.tryParse(_chickenCountController.text.trim()) ?? 0,
        housingSystem: _selectedHousingKey,
        latitude: _latitude,
        longitude: _longitude,
        farmSize: _flockAgeController.text.trim(),
        farmerName: _farmerNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
              const Text(
                'Tuambie Kuhusu Shamba Lako',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 24),

              _buildFieldLabel(Icons.home_work_outlined, 'Jina la Shamba Lako'),
              TextField(
                controller: _farmNameController,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: _buildInputDecoration('Mf. Kuku Bora Farm'),
              ),
              const SizedBox(height: 20),

              _buildFieldLabel(Icons.person_outline_rounded, 'Jina la Mfugaji'),
              TextField(
                controller: _farmerNameController,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: _buildInputDecoration('Mf. Juma Hamisi'),
              ),
              const SizedBox(height: 20),

              _buildFieldLabel(Icons.phone_android_rounded, 'Namba ya Simu'),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: _buildInputDecoration('Mf. 0712345678'),
              ),
              const SizedBox(height: 20),

              _buildFieldLabel(Icons.location_on_outlined, 'Mahali Shamba Lilipo (Mkoa / Wilaya)'),
              TextField(
                controller: _locationController,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: _buildInputDecoration(
                  'Mf. Kibaha, Pwani',
                  suffixIcon: IconButton(
                    tooltip: 'Chukua GPS',
                    icon: _isGpsFetching
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(
                            Icons.my_location_rounded,
                            color: _latitude != 0 ? AppTheme.primaryGreen : const Color(0xFF0284C7),
                            size: 24,
                          ),
                    onPressed: _isGpsFetching ? null : _fetchGps,
                  ),
                ),
              ),
              if (_latitude != 0 || _longitude != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'GPS: ${_latitude.toStringAsFixed(5)}, ${_longitude.toStringAsFixed(5)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen),
                  ),
                ),
              const SizedBox(height: 20),

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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(Icons.numbers_rounded, 'Idadi ya Kuku'),
                        TextField(
                          controller: _chickenCountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                          decoration: _buildInputDecoration('Mf. 450'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(Icons.calendar_today_rounded, 'Umri wa Kundi'),
                        TextField(
                          controller: _flockAgeController,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: _buildInputDecoration('Mf. Wiki 12'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

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
                    onTap: () => setState(() => _selectedHousingKey = card['key']!),
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

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _finishSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSaving ? 'INAHIFADHI...' : 'HIFADHI NA ENDELEA',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 24),
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
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
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
