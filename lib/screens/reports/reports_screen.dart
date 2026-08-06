import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedReportType = 'Uzalishaji wa Mayai';
  String _selectedPeriod = 'Mwezi Huu (Siku 30)';

  void _generateAndShowPdfPreview(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final profile = appState.farmProfile;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                        Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 28),
                        SizedBox(width: 8),
                        Text('PDF Report Preview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),

                // Mock Printable Document
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'KUKU DIARY - RIPOTI YA SHAMBA',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen),
                        ),
                      ),
                      const Center(child: Text('Smart Poultry Management System', style: TextStyle(fontSize: 10, color: Colors.grey))),
                      const SizedBox(height: 12),
                      Text('Jina la Shamba: ${profile.farmName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('Mfugaji: ${profile.farmerName} • Mahali: ${profile.location}', style: const TextStyle(fontSize: 11)),
                      Text('Kipindi cha Ripoti: $_selectedPeriod', style: const TextStyle(fontSize: 11)),
                      Text('Aina ya Ripoti: $_selectedReportType', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),

                      const Text('MUHTASARI WA TAKWIMU:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text('• Jumla ya Mayai Yaliyokusanywa: ${appState.todaySummary.eggsCollected * 30} Mayai'),
                      Text('• Kiwango cha Uzalishaji (Productivity): ${appState.todaySummary.productivityPercentage.toStringAsFixed(1)}%'),
                      Text('• Matumizi ya Chakula: 1,560 kg'),
                      Text('• Jumla ya Vifo: ${appState.todaySummary.mortality} Kuku'),
                      Text('• Jumla ya Mapato: TSh ${(appState.todaySummary.todayIncomeTsz * 20).toStringAsFixed(0)}'),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text('KUKU DIARY Official Verified Seal ✓', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ripoti ya PDF imepakuliwa kwenye simu yako!')),
                          );
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('PAKUA PDF'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ripoti imetumwa kwenye printer!')),
                        );
                      },
                      icon: const Icon(Icons.print_rounded),
                      label: const Text('PRINT'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
                    ),
                  ],
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tengeneza Ripoti za Shamba Lako',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
          ),
          const Text(
            'Chagua aina ya ripoti na kipindi kisha ipakue kama faili la PDF au uliprinti.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Select Report Type
          const Text('Aina ya Ripoti (Module)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedReportType,
            items: [
              'Uzalishaji wa Mayai',
              'Vifo na Afya ya Kuku',
              'Matumizi ya Chakula',
              'Ratiba na Chanjo',
              'Fedha na Faida',
              'Uzalishaji kwa Ujumla (Comprehensive)',
            ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedReportType = val);
            },
          ),
          const SizedBox(height: 16),

          // Select Period
          const Text('Kipindi cha Muda (Time Period)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedPeriod,
            items: [
              'Wiki Hii (Siku 7)',
              'Mwezi Huu (Siku 30)',
              'Miezi 3 Zilizopita',
              'Mwaka Huu (2026)',
            ].map((period) => DropdownMenuItem(value: period, child: Text(period))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedPeriod = val);
            },
          ),
          const SizedBox(height: 24),

          // Generate Report Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _generateAndShowPdfPreview(context),
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: const Text('TENGENEZA NA TAZAMA RIPOTI YA PDF', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 28),

          // Quick Preset Report Cards
          const Text('Ripoti Zilizotengenezwa Hivi Karibuni', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildQuickReportTile(context, 'Ripoti ya Uzalishaji Mayai - Julai 2026', 'PDF • 1.2 MB', () => _generateAndShowPdfPreview(context)),
          _buildQuickReportTile(context, 'Ripoti ya Fedha & Matumizi Q2 2026', 'PDF • 850 KB', () => _generateAndShowPdfPreview(context)),
          _buildQuickReportTile(context, 'Ripoti ya Chanjo na Afya ya Kuku', 'PDF • 600 KB', () => _generateAndShowPdfPreview(context)),
        ],
      ),
    );
  }

  Widget _buildQuickReportTile(BuildContext context, String title, String desc, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 11)),
        trailing: IconButton(
          icon: const Icon(Icons.visibility_rounded, color: AppTheme.primaryGreen),
          onPressed: onTap,
        ),
      ),
    );
  }
}
