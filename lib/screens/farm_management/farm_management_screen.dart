import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class FarmManagementScreen extends StatefulWidget {
  final bool nested;

  const FarmManagementScreen({super.key, this.nested = false});

  @override
  State<FarmManagementScreen> createState() => _FarmManagementScreenState();
}

class _FarmManagementScreenState extends State<FarmManagementScreen> with SingleTickerProviderStateMixin {
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

    final tabs = TabBar(
      controller: _tabController,
      indicatorColor: AppTheme.amberGold,
      indicatorWeight: 4,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 14),
      labelColor: widget.nested ? AppTheme.primaryGreen : Colors.white,
      unselectedLabelColor: widget.nested ? Colors.grey : Colors.white70,
      tabs: [
        Tab(text: isSw ? 'Taarifa Shamba' : 'Farm Info'),
        Tab(text: isSw ? 'Kundi / Batch' : 'Batches'),
        Tab(text: isSw ? 'Kila Siku' : 'Daily Record'),
      ],
    );

    final body = TabBarView(
      controller: _tabController,
      children: [
        _buildFarmInfoTab(context, appState, isSw),
        _buildPoultryBatchesTab(context, appState, isSw),
        _buildDailyRecordsTab(context, appState, isSw),
      ],
    );

    if (widget.nested) {
      return Column(
        children: [
          Material(color: Colors.white, child: tabs),
          Expanded(child: body),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Usimamizi wa Shamba' : 'Farm Management'),
        bottom: tabs,
      ),
      body: body,
    );
  }

  Widget _buildFarmInfoTab(BuildContext context, AppState appState, bool isSw) {
    final profile = appState.farmProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppTheme.lightGreen,
                        radius: 28,
                        child: Icon(Icons.agriculture_rounded, color: AppTheme.primaryGreen, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.farmName,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  profile.location,
                                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  _buildDetailRow(Icons.straighten_rounded, isSw ? 'Ukubwa wa Shamba' : 'Farm Size', profile.farmSize),
                  _buildDetailRow(Icons.category_rounded, isSw ? 'Aina ya Ufugaji' : 'Farm Type', profile.chickenType),
                  _buildDetailRow(Icons.house_rounded, isSw ? 'Mfumo wa Banda' : 'Housing System', profile.housingSystem),
                  _buildDetailRow(Icons.gps_fixed_rounded, isSw ? 'GPS Coordinates' : 'GPS Location', '${profile.latitude.toStringAsFixed(4)}, ${profile.longitude.toStringAsFixed(4)}'),
                  _buildDetailRow(Icons.verified_rounded, isSw ? 'Hali ya Shamba' : 'Status', profile.status, isBadge: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => appState.setActiveDrawerModule('gps_registration'),
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 24),
              label: Text(
                isSw ? 'Fungua Usajili wa GPS & Msimbo wa QR' : 'GPS & QR Code Registration',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 24),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
          const Spacer(),
          if (isBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
              child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
            )
          else
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
        ],
      ),
    );
  }

  Widget _buildPoultryBatchesTab(BuildContext context, AppState appState, bool isSw) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBatchDialog(context, appState, isSw),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        label: Text(
          isSw ? 'Ongeza Batch ya Kuku' : 'Add Chicken Batch',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appState.poultryBatches.length,
        itemBuilder: (context, index) {
          final batch = appState.poultryBatches[index];
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
                      Text(
                        batch.breed,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.amberGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          '${batch.quantity} ${isSw ? 'Kuku' : 'Chickens'}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${isSw ? 'Umri' : 'Age'}: ${batch.age}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  Text('${isSw ? 'Muuzaji' : 'Supplier'}: ${batch.supplier}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  Text('${isSw ? 'Tarehe ya Ununuzi' : 'Date Purchased'}: ${DateFormat('dd MMM yyyy').format(batch.datePurchased)}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  if (batch.notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(batch.notes, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddBatchDialog(BuildContext context, AppState appState, bool isSw) {
    final breedCtrl = TextEditingController();
    final quantityCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final supplierCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSw ? 'Weka Taarifa za Batch Mpya' : 'Add New Poultry Batch', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: breedCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Aina ya Kuku (Breed)' : 'Breed'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Idadi ya Kuku (Quantity)' : 'Quantity'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ageCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Umri (e.g. Wiki 4 / Siku 1)' : 'Age'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: supplierCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Muuzaji / Hatchery' : 'Supplier'),
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
            onPressed: () {
              if (breedCtrl.text.isNotEmpty && quantityCtrl.text.isNotEmpty) {
                appState.addPoultryBatch(
                  PoultryBatch(
                    id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                    breed: breedCtrl.text,
                    quantity: int.tryParse(quantityCtrl.text) ?? 100,
                    age: ageCtrl.text.isNotEmpty ? ageCtrl.text : 'Siku 1',
                    datePurchased: DateTime.now(),
                    supplier: supplierCtrl.text.isNotEmpty ? supplierCtrl.text : 'Local Hatchery',
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: Text(isSw ? 'Hifadhi Batch' : 'Save Batch', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRecordsTab(BuildContext context, AppState appState, bool isSw) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDailyRecordDialog(context, appState, isSw),
        backgroundColor: AppTheme.amberGold,
        icon: const Icon(Icons.edit_note_rounded, color: Colors.black87, size: 26),
        label: Text(
          isSw ? 'Weka Taarifa za Leo' : 'Log Today Records',
          style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appState.productionLogs.length,
        itemBuilder: (context, index) {
          final log = appState.productionLogs[appState.productionLogs.length - 1 - index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, dd MMM yyyy').format(log.date),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${log.eggs} ${isSw ? 'Mayai' : 'Eggs'}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${log.feedKg} kg ${isSw ? 'Chakula' : 'Feed'}', style: const TextStyle(fontSize: 14)),
                    Text('${log.waterLiters} L ${isSw ? 'Maji' : 'Water'}', style: const TextStyle(fontSize: 14)),
                    Text('${log.mortality} ${isSw ? 'Vifo' : 'Mortality'}', style: TextStyle(fontSize: 14, color: log.mortality > 0 ? Colors.red : Colors.grey)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddDailyRecordDialog(BuildContext context, AppState appState, bool isSw) {
    final eggsCtrl = TextEditingController(text: '380');
    final feedCtrl = TextEditingController(text: '52');
    final waterCtrl = TextEditingController(text: '95');
    final mortalityCtrl = TextEditingController(text: '0');
    final weightCtrl = TextEditingController(text: '1.85');
    final expenseCtrl = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSw ? 'Weka Taarifa za Uzalishaji' : 'Add Daily Production Record', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: eggsCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Mayai Yaliyokusanywa' : 'Eggs Collected'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: feedCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Chakula (Kg)' : 'Feed Given (Kg)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: waterCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Maji (Lita)' : 'Water Given (Liters)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mortalityCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Vifo vya Kuku (Mortality)' : 'Mortality Count'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: weightCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Wastani wa Uzito wa Kuku (Kg)' : 'Bird Avg Weight (Kg)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: expenseCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Matumizi ya Leo (TSh)' : 'Daily Expenses (TSh)'),
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
            onPressed: () {
              appState.addProductionLog(
                ProductionLog(
                  date: DateTime.now(),
                  eggs: int.tryParse(eggsCtrl.text) ?? 0,
                  feedKg: double.tryParse(feedCtrl.text) ?? 0.0,
                  waterLiters: double.tryParse(waterCtrl.text) ?? 0.0,
                  mortality: int.tryParse(mortalityCtrl.text) ?? 0,
                  birdAvgWeightKg: double.tryParse(weightCtrl.text) ?? 1.8,
                  expensesTsz: double.tryParse(expenseCtrl.text) ?? 0.0,
                ),
              );
              Navigator.pop(ctx);
            },
            child: Text(isSw ? 'Hifadhi Taarifa' : 'Save Record', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
