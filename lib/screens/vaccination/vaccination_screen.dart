import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Kalenda ya Chanjo & Dawa' : 'Vaccination & Deworming'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.amberGold,
          indicatorWeight: 4,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: isSw ? 'Chanjo' : 'Vaccines'),
            Tab(text: isSw ? 'Dawa & Deworming' : 'Deworming'),
            Tab(text: isSw ? 'Muonekano Kalenda' : 'Calendar View'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddScheduleDialog(context, appState, isSw),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add_alert_rounded, color: Colors.white, size: 26),
        label: Text(
          isSw ? 'Weka Remainder' : 'Add Reminder',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVaccinesTab(context, appState, isSw, filterType: 'vaccine'),
          _buildVaccinesTab(context, appState, isSw, filterType: 'deworming'),
          _buildCalendarViewTab(context, appState, isSw),
        ],
      ),
    );
  }

  Widget _buildVaccinesTab(BuildContext context, AppState appState, bool isSw, {required String filterType}) {
    final list = appState.vaccinations.where((v) => filterType == 'deworming' ? v.itemType == 'deworming' : v.itemType != 'deworming').toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final itemIndex = appState.vaccinations.indexOf(item);

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.diseaseName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                    ),
                    Checkbox(
                      value: item.isCompleted,
                      activeColor: AppTheme.primaryGreen,
                      onChanged: (val) {
                        appState.toggleVaccinationCompleted(itemIndex);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppTheme.lightGreen, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '${isSw ? 'Dawa/Chanjo' : 'Vaccine'}: ${item.vaccineName}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppTheme.amberGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        item.targetAge,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${isSw ? 'Tarehe' : 'Date'}: ${DateFormat('EEEE, dd MMMM yyyy').format(item.scheduledDate)}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  item.instructions,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarViewTab(BuildContext context, AppState appState, bool isSw) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(DateTime.now()),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                      const Icon(Icons.calendar_month_rounded, color: AppTheme.amberGold, size: 30),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('Jt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Jn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Jt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Al', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Ij', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Jm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Jp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.0),
                    itemCount: 31,
                    itemBuilder: (ctx, idx) {
                      final dayNum = idx + 1;
                      final isToday = dayNum == DateTime.now().day;
                      final hasVaccine = dayNum == 10 || dayNum == 25;
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isToday ? AppTheme.primaryGreen : (hasVaccine ? AppTheme.amberGold.withValues(alpha: 0.3) : Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '$dayNum',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isToday || hasVaccine ? FontWeight.bold : FontWeight.normal,
                              color: isToday ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isSw ? 'Chanjo na Dawa Zinazofuata Kalendani:' : 'Upcoming Calendar Schedules:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...appState.vaccinations.map(
            (v) => ListTile(
              leading: Icon(
                v.isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                color: v.isCompleted ? Colors.green : AppTheme.amberGold,
                size: 28,
              ),
              title: Text(v.diseaseName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Text('${v.vaccineName} • ${DateFormat('dd MMM yyyy').format(v.scheduledDate)}', style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context, AppState appState, bool isSw) {
    final diseaseCtrl = TextEditingController();
    final vaccineCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final instructionsCtrl = TextEditingController();
    String selectedType = 'vaccine';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSw ? 'Weka Chanjo / Dawa Mpya' : 'Add Vaccine / Medicine Reminder', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                isExpanded: true,
                decoration: InputDecoration(labelText: isSw ? 'Aina ya Ratiba' : 'Schedule Type'),
                items: [
                  DropdownMenuItem(value: 'vaccine', child: Text(isSw ? 'Chanjo (Vaccine)' : 'Vaccine', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 'deworming', child: Text(isSw ? 'Dawa ya Tumbo (Deworming)' : 'Deworming', overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (val) {
                  if (val != null) selectedType = val;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: diseaseCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Jina la Ugonjwa / Lengo' : 'Disease / Target'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: vaccineCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Jina la Dawa / Chanjo' : 'Vaccine/Medicine Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ageCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Umri wa Kuku (Target Age)' : 'Target Age (e.g. Siku 21)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: instructionsCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Maelekezo ya Utoaji' : 'Instructions'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isSw ? 'Ghairi' : 'Cancel', style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (diseaseCtrl.text.isEmpty || vaccineCtrl.text.isEmpty) return;
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              try {
                await appState.addVaccinationSchedule(
                  VaccinationItem(
                    id: '',
                    diseaseName: diseaseCtrl.text,
                    vaccineName: vaccineCtrl.text,
                    targetAge: ageCtrl.text.isNotEmpty ? ageCtrl.text : 'Siku 21',
                    scheduledDate: DateTime.now().add(const Duration(days: 7)),
                    instructions: instructionsCtrl.text.isNotEmpty ? instructionsCtrl.text : 'Weka kwenye maji safi ya kunywa.',
                    itemType: selectedType,
                  ),
                );
                messenger.showSnackBar(SnackBar(content: Text(isSw ? 'Kumbukumbu imehifadhiwa.' : 'Reminder saved.')));
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: Text(isSw ? 'Hifadhi Remainder' : 'Save Reminder', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
