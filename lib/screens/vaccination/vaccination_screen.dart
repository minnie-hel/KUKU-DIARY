import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({super.key});

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _diseaseController = TextEditingController(text: 'Chanjo ya Ndui ya Kuku (Fowl Pox)');
  final _vaccineController = TextEditingController(text: 'Pox-Vac Injection');
  final _targetAgeController = TextEditingController(text: 'Wiki ya 3 (Siku ya 21)');
  final _instructionsController = TextEditingController(text: 'Weka kwenye maji ya kunywa asubuhi au choma kwa sindano ya mabawa.');
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _diseaseController.dispose();
    _vaccineController.dispose();
    _targetAgeController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _showAddVaccineModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.event_available_rounded, color: AppTheme.primaryGreen, size: 28),
                        SizedBox(width: 10),
                        Text('Panga Chanjo Mpya', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 16),

                // Disease Name
                const Text('Aina ya Ugonjwa au Chanjo', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _diseaseController,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Mfano: Chanjo ya Kideri (Newcastle)',
                    prefixIcon: const Icon(Icons.medical_services_outlined, color: AppTheme.primaryGreen),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
                  ),
                ),
                const SizedBox(height: 14),

                // Vaccine Name
                const Text('Jina la Dawa / Chanjo', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _vaccineController,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Mfano: Lasota / HB1 / Gumboro',
                    prefixIcon: const Icon(Icons.medication_outlined, color: Color(0xFF0284C7)),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 14),

                // Target Age
                const Text('Umri wa Kuku Bandani', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _targetAgeController,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Mfano: Siku ya 7 au Wiki ya 3',
                    prefixIcon: const Icon(Icons.pets_outlined, color: AppTheme.amberGold),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 14),

                // Date Picker Selector
                const Text('Tarehe ya Kuchoma Chanjo', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setModalState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryGreen, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryGreen, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.primaryGreen),
                            ),
                          ],
                        ),
                        const Text('Badili Tarehe', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Instructions
                const Text('Maelekezo ya Matumizi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _instructionsController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Mfano: Weka kwenye maji safi ya kunywa asubuhi kabla ya jua kali.',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_diseaseController.text.isEmpty) return;

                      final appState = Provider.of<AppState>(context, listen: false);
                      final newVaccine = VaccinationItem(
                        diseaseName: _diseaseController.text.trim(),
                        vaccineName: _vaccineController.text.trim(),
                        targetAge: _targetAgeController.text.trim(),
                        scheduledDate: _selectedDate,
                        instructions: _instructionsController.text.trim(),
                        isCompleted: false,
                      );

                      appState.addVaccinationSchedule(newVaccine);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppTheme.primaryGreen,
                          content: Text(
                            'Ratiba ya Chanjo imewasilishwa kwenye Kalenda na Taarifa (Notification) imetumwa kikamilifu!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: const Icon(Icons.notifications_active_rounded, size: 24),
                    label: const Text('HIFADHI NA TUMA NOTIFICATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVaccineModal(context),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert_rounded, size: 24),
        label: const Text('Panga Chanjo Mpya', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryGreen,
              unselectedLabelColor: const Color(0xFF6B7280),
              indicatorColor: AppTheme.primaryGreen,
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              tabs: const [
                Tab(icon: Icon(Icons.event_repeat_rounded, size: 22), text: 'Chanjo Zinazokuja'),
                Tab(icon: Icon(Icons.history_rounded, size: 22), text: 'Zilizokamilika'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVaccineList(context, appState, isCompleted: false),
                _buildVaccineList(context, appState, isCompleted: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineList(BuildContext context, AppState appState, {required bool isCompleted}) {
    final filtered = appState.vaccinations.where((v) => v.isCompleted == isCompleted).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              isCompleted ? 'Hakuna chanjo zilizopita bado.' : 'Hakuna chanjo mpya zinazokusubiri kwenye kalenda!',
              style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final originalIndex = appState.vaccinations.indexOf(item);

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                        color: isCompleted ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isCompleted ? AppTheme.primaryGreen : AppTheme.amberGold),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle_rounded : Icons.alarm_rounded,
                            size: 16,
                            color: isCompleted ? AppTheme.primaryGreen : const Color(0xFFB45309),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.targetAge,
                            style: TextStyle(
                              color: isCompleted ? AppTheme.primaryGreen : const Color(0xFFB45309),
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.scheduledDate.day}/${item.scheduledDate.month}/${item.scheduledDate.year}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF4B5563)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Text(
                  item.diseaseName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dawa / Chanjo: ${item.vaccineName}',
                  style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF6B7280)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.instructions,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF374151), height: 1.3, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      appState.toggleVaccinationCompleted(originalIndex);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isCompleted ? 'Chanjo imerudishwa kwenye orodha!' : 'Chanjo imewekwa alama ya LIMEKAMILIKA!',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    icon: Icon(isCompleted ? Icons.undo_rounded : Icons.check_circle_rounded, size: 20),
                    label: Text(isCompleted ? 'RUDISHA NYUMA' : 'WEKA ALAMA IMEKAMILIKA', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted ? Colors.grey : AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
