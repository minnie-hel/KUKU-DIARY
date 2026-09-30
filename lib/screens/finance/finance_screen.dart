import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  void _showAddTransactionModal(BuildContext context) {
    final amountController = TextEditingController();
    final descController = TextEditingController();

    String type = 'Mapato'; // Mapato au Matumizi
    String category = 'Mauzo ya Mayai';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rekodi Mpya ya Fedha', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Mapato (+)')),
                      selected: type == 'Mapato',
                      selectedColor: Colors.green,
                      labelStyle: TextStyle(color: type == 'Mapato' ? Colors.white : Colors.black87),
                      onSelected: (val) => setModalState(() {
                        type = 'Mapato';
                        category = 'Mauzo ya Mayai';
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Matumizi (-)')),
                      selected: type == 'Matumizi',
                      selectedColor: Colors.red,
                      labelStyle: TextStyle(color: type == 'Matumizi' ? Colors.white : Colors.black87),
                      onSelected: (val) => setModalState(() {
                        type = 'Matumizi';
                        category = 'Vyakula';
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const Text('Kundi (Category)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: category,
                items: (type == 'Mapato'
                        ? ['Mauzo ya Mayai', 'Mauzo ya Kuku', 'Mauzo ya Samadi', 'Mengineyo']
                        : ['Vyakula', 'Dawa & Chanjo', 'Vifaa vya Banda', 'Mishahara', 'Mengineyo'])
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => category = val);
                },
              ),
              const SizedBox(height: 14),

              const Text('Kiasi cha Fedha (TSh)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '190000', prefixIcon: Icon(Icons.attach_money_rounded)),
              ),
              const SizedBox(height: 14),

              const Text('Maelezo Mafupi', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: descController,
                decoration: const InputDecoration(hintText: 'Mf. Mauzo ya trei 14 za mayai'),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (amountController.text.isEmpty) return;
                    final amt = double.tryParse(amountController.text) ?? 0.0;
                    final messenger = ScaffoldMessenger.of(context);
                    final appState = Provider.of<AppState>(context, listen: false);
                    final newRec = FinanceRecord(
                      id: '',
                      type: type,
                      category: category,
                      amount: amt,
                      date: DateTime.now(),
                      description: descController.text.isEmpty ? category : descController.text,
                    );
                    Navigator.pop(context);
                    try {
                      await appState.addFinanceRecord(newRec);
                      messenger.showSnackBar(
                        SnackBar(content: Text('Rekodi ya $type ya TSh ${amt.toStringAsFixed(0)} imehifadhiwa.')),
                      );
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('HIFADHI REKODI YA FEDHA'),
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
    final records = appState.financeRecords;

    double totalIncome = records.where((r) => r.type == 'Mapato').fold(0.0, (sum, r) => sum + r.amount);
    double totalExpenses = records.where((r) => r.type == 'Matumizi').fold(0.0, (sum, r) => sum + r.amount);
    double netProfit = totalIncome - totalExpenses;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionModal(context),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('Rekodi ya Fedha', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Profit Card Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: netProfit >= 0 ? [AppTheme.primaryGreen, Colors.teal] : [Colors.red.shade800, Colors.red.shade600],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Faida Halisi ya Shamba', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    'TSh ${netProfit.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFinanceSubStat('Jumla ya Mapato', 'TSh ${(totalIncome / 1000).toStringAsFixed(0)}k', Colors.greenAccent),
                      _buildFinanceSubStat('Jumla ya Matumizi', 'TSh ${(totalExpenses / 1000).toStringAsFixed(0)}k', Colors.orangeAccent),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Transactions History Header
            const Text(
              'Orodha ya Miamala ya Shamba',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final r = records[index];
                bool isIncome = r.type == 'Mapato';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isIncome ? Colors.green.shade100 : Colors.red.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                        color: isIncome ? Colors.green.shade900 : Colors.red.shade900,
                      ),
                    ),
                    title: Text(r.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(r.description, style: const TextStyle(fontSize: 12)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isIncome ? '+' : '-'} TSh ${r.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isIncome ? Colors.green.shade800 : Colors.red.shade800,
                          ),
                        ),
                        Text(
                          '${r.date.day}/${r.date.month}',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        ),
                      ],
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

  Widget _buildFinanceSubStat(String label, String val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
