import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  final _eventTitleController = TextEditingController();
  final _eventDetailController = TextEditingController();
  String _selectedCategory = 'Chanjo';

  void _showAddEventModal(BuildContext context) {
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
                    const Text('Weka TUKIO / CHANJO kwenye Kalenda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen)),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 16),

                // Category Selector
                const Text('Aina ya Tukio', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  items: ['Chanjo', 'Chakula', 'Daktari', 'Usafi wa Banda', 'Mafunzo']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => _selectedCategory = val);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 14),

                // Title
                const Text('Jina la Tukio au Chanjo', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _eventTitleController,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Mfano: Chanjo ya Gumboro (Wiki ya 2)',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 14),

                // Date Selector
                const Text('Tarehe ya Tukio', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                            const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryGreen),
                            const SizedBox(width: 10),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.primaryGreen),
                            ),
                          ],
                        ),
                        const Text('Chagua Tarehe', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Instructions / Detail
                const Text('Maelezo Ziada (Instructions)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _eventDetailController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Mfano: Kunywesha asubuhi saa 1:00 AM.',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_eventTitleController.text.isEmpty) return;

                      final appState = Provider.of<AppState>(context, listen: false);
                      final newVaccine = VaccinationItem(
                        id: 'v_${DateTime.now().millisecondsSinceEpoch}',
                        diseaseName: _eventTitleController.text.trim(),
                        vaccineName: _selectedCategory,
                        targetAge: 'Ratiba ya Kalenda',
                        scheduledDate: _selectedDate,
                        instructions: _eventDetailController.text.isEmpty ? 'Ratiba maalum ya shamba.' : _eventDetailController.text.trim(),
                      );
                      appState.addVaccinationSchedule(newVaccine);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppTheme.primaryGreen,
                          content: Text(
                            'Tukio limewekwa kwenye kalenda na Taarifa (Notification) imetumwa kikamilifu!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.notifications_active_rounded),
                    label: const Text('HIFADHI NA TUMA TAARIFA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
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
    final upcomingVaccines = appState.vaccinations;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventModal(context),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert_rounded),
        label: const Text('Weka Ratiba / Chanjo', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        Text(
                          'Matukio & Chanjo ${upcomingVaccines.length} Zilizopangwa',
                          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Ratiba na Matukio Yaliyopangwa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingVaccines.length,
              itemBuilder: (context, index) {
                final v = upcomingVaccines[index];
                bool isDone = v.isCompleted;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDone ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDone ? Icons.check_circle_rounded : Icons.notifications_active_rounded,
                        color: isDone ? AppTheme.primaryGreen : AppTheme.amberGold,
                      ),
                    ),
                    title: Text(
                      v.diseaseName,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF111827)),
                    ),
                    subtitle: Text(
                      '${v.vaccineName} • Tarehe: ${v.scheduledDate.day}/${v.scheduledDate.month}/${v.scheduledDate.year}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                    ),
                    trailing: Text(
                      v.targetAge,
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryGreen, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
