import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _timeRange = 'Wiki Hii (7 Days)';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    // Summary calculations
    int totalEggs = appState.productionLogs.fold(0, (sum, log) => sum + log.eggs);
    int totalMortality = appState.productionLogs.fold(0, (sum, log) => sum + log.mortality);
    double totalFeedKg = appState.productionLogs.fold(0.0, (sum, log) => sum + log.feedKg);
    double totalIncome = appState.financeRecords.where((f) => f.type == 'Mapato').fold(0.0, (sum, f) => sum + f.amount);
    double totalExpenses = appState.financeRecords.where((f) => f.type == 'Matumizi').fold(0.0, (sum, f) => sum + f.amount);
    double netProfit = totalIncome - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Ripoti za Shamba & Utendaji' : 'Farm Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, size: 26),
            tooltip: isSw ? 'Pakua PDF' : 'Download PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSw
                        ? 'Ripoti ya PDF ya ${appState.farmProfile.farmName} imepakuliwa kwenye simu!'
                        : 'PDF Report downloaded to your device!',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time filter bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isSw ? 'Muda wa Ripoti:' : 'Report Timeframe:',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _timeRange,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  items: ['Wiki Hii (7 Days)', 'Mwezi Huu (30 Days)', 'Mwaka Huu (Yearly)']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _timeRange = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Report Cards Grid (Egg Production, Mortality, Feed, Income, Expense, Profit)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.35,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildReportCard(
                  title: isSw ? 'Mayai Yaliyokusanywa' : 'Egg Production',
                  value: '$totalEggs ${isSw ? 'Mayai' : 'Eggs'}',
                  icon: Icons.egg_rounded,
                  color: AppTheme.amberGold,
                ),
                _buildReportCard(
                  title: isSw ? 'Vifo vya Kuku' : 'Mortality Count',
                  value: '$totalMortality ${isSw ? 'Kuku' : 'Birds'}',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
                _buildReportCard(
                  title: isSw ? 'Chakula Kilicholiwa' : 'Feed Consumed',
                  value: '${totalFeedKg.toStringAsFixed(1)} kg',
                  icon: Icons.rice_bowl_rounded,
                  color: Colors.green,
                ),
                _buildReportCard(
                  title: isSw ? 'Jumla ya Mapato' : 'Total Income',
                  value: 'TSh ${NumberFormat('#,###').format(totalIncome)}',
                  icon: Icons.trending_up_rounded,
                  color: AppTheme.primaryGreen,
                ),
                _buildReportCard(
                  title: isSw ? 'Jumla ya Matumizi' : 'Total Expenses',
                  value: 'TSh ${NumberFormat('#,###').format(totalExpenses)}',
                  icon: Icons.trending_down_rounded,
                  color: Colors.orange.shade800,
                ),
                _buildReportCard(
                  title: isSw ? 'Faida Halisi (Profit)' : 'Net Profit',
                  value: 'TSh ${NumberFormat('#,###').format(netProfit)}',
                  icon: Icons.account_balance_wallet_rounded,
                  color: netProfit >= 0 ? Colors.blue.shade800 : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Download PDF Banner
            Card(
              color: AppTheme.lightGreen,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.primaryGreen, size: 40),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSw ? 'Tengeneza Ripoti Rasmi ya PDF' : 'Generate Official PDF Report',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isSw ? 'Pakua ripoti kamili ya uzalishaji, chakula na fedha kwa ajili ya benki au wataalamu.' : 'Download complete report for bank loans or vet reference.',
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
