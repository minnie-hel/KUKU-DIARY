import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final _eggsController = TextEditingController();
  final _feedController = TextEditingController();
  final _waterController = TextEditingController();
  final _mortalityController = TextEditingController(text: '0');

  void _showAddLogModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
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
                  const Text('Rekodi Uzalishaji wa Leo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen)),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),

              // Eggs
              const Text('Idadi ya Mayai Yaliyokusanywa', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              const SizedBox(height: 6),
              TextField(
                controller: _eggsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Mfano: 380',
                  prefixIcon: const Icon(Icons.egg_rounded, color: AppTheme.primaryGreen),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
                ),
              ),
              const SizedBox(height: 16),

              // Feed & Water
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Chakula (Kg)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _feedController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: '54.0',
                            prefixIcon: const Icon(Icons.grass_rounded, color: Color(0xFF0284C7)),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Maji (Lita)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _waterController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: '96.0',
                            prefixIcon: const Icon(Icons.water_drop_rounded, color: Colors.blue),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mortality
              const Text('Vifo vya Kuku Leo (Kama Vipo)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              const SizedBox(height: 6),
              TextField(
                controller: _mortalityController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '0',
                  prefixIcon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_eggsController.text.isEmpty) return;

                    final appState = Provider.of<AppState>(context, listen: false);
                    final newLog = ProductionLog(
                      date: DateTime.now(),
                      eggs: int.tryParse(_eggsController.text) ?? 380,
                      feedKg: double.tryParse(_feedController.text) ?? 54.0,
                      waterLiters: double.tryParse(_waterController.text) ?? 96.0,
                      mortality: int.tryParse(_mortalityController.text) ?? 0,
                      birdAvgWeightKg: 1.88,
                      expensesTsz: 0.0,
                    );
                    appState.addProductionLog(newLog);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rekodi ya leo ya utagaji imehifadhiwa kikamilifu!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  icon: const Icon(Icons.save_rounded, size: 24),
                  label: const Text('HIFADHI REKODI YA MAYAI', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final logs = appState.productionLogs;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLogModal(context),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded, size: 26),
        label: const Text('Weka Rekodi ya Mayai', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Cards (Visual High Contrast in Swahili)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFF59E0B), width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.egg_rounded, color: Color(0xFFB45309), size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'UZALISHAJI WA MAYAI LEO',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFB45309)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${appState.todaySummary.eggsCollected} Mayai',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                        ),
                        Text(
                          'Kiwango cha Utagaji: ${appState.todaySummary.productivityPercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4B5563)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daily History List (No Graph as requested)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kumbukumbu za Utagaaji',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.lightGreen, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Siku ${logs.length} Zilizorekodiwa',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.reversed.length,
              itemBuilder: (context, index) {
                final log = logs.reversed.toList()[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.egg_alt_rounded, color: AppTheme.primaryGreen, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${log.eggs} Mayai Yaliyokusanywa',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF111827)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Chakula: ${log.feedKg}kg • Maji: ${log.waterLiters}L • Vifo: ${log.mortality}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFD1D5DB))),
                        child: Text(
                          '${log.date.day}/${log.date.month}',
                          style: const TextStyle(color: Color(0xFF374151), fontSize: 12, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
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
