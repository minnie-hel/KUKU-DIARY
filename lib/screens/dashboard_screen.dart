import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.farmProfile;
    final summary = appState.todaySummary;
    final isSw = appState.selectedLanguage == 'sw';
    final upcomingVaccines = appState.vaccinations.where((v) => !v.isCompleted).toList();
    final feedDays = appState.feedDaysRemainingEstimate();
    final sales = NumberFormat('#,###').format(summary.todayIncomeTsz.round());
    final firstName = profile.farmerName.trim().isEmpty
        ? (isSw ? 'Mfugaji' : 'Farmer')
        : profile.farmerName.trim().split(' ').first;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Farmer Greeting & Farm Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryGreen, Color(0xFF0F382C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appState.greetingForNow()}, $firstName',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Karibu kwenye KUKU DIARY',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.amberGold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Farm statistics
          _sectionHeader(Icons.analytics_rounded, isSw ? 'TAKWIMU KUU ZA SHAMBA' : 'FARM STATUS TODAY'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.35,
            children: [
              _buildBigCoreCard(
                icon: Icons.pets_rounded,
                iconColor: const Color(0xFF1B4D3E),
                bgColor: const Color(0xFFE8F5E9),
                title: isSw ? 'KUKU WOTE' : 'ALL BIRDS',
                value: '${profile.totalChickens}',
                subtitle: isSw ? 'Kuku Bandani' : 'In the house',
                onTap: () => appState.setActiveDrawerModule('farm_management'),
              ),
              _buildBigCoreCard(
                icon: Icons.egg_rounded,
                iconColor: const Color(0xFFB45309),
                bgColor: const Color(0xFFFEF3C7),
                title: isSw ? 'MAYAI YA LEO' : 'EGGS TODAY',
                value: '${summary.eggsCollected}',
                subtitle: isSw ? 'Yaliyokusanywa' : 'Collected',
                onTap: () => appState.setActiveDrawerModule('production'),
              ),
              _buildBigCoreCard(
                icon: Icons.grass_rounded,
                iconColor: const Color(0xFF0284C7),
                bgColor: const Color(0xFFE0F2FE),
                title: isSw ? 'CHAKULA' : 'FEED',
                value: '${summary.feedRemainingKg.toStringAsFixed(0)} Kg',
                subtitle: feedDays > 0
                    ? (isSw ? 'Siku $feedDays zimebaki' : '$feedDays days remaining')
                    : (isSw ? 'Kilichobaki Bandani' : 'Remaining in store'),
                isWarning: feedDays > 0 && feedDays <= 3,
                onTap: () => appState.setActiveDrawerModule('feed'),
              ),
              _buildBigCoreCard(
                icon: Icons.medical_services_rounded,
                iconColor: const Color(0xFFDC2626),
                bgColor: const Color(0xFFFEE2E2),
                title: isSw ? 'WAGONJWA' : 'SICK BIRDS',
                value: '${summary.sickChickens}',
                subtitle: summary.sickChickens > 0
                    ? (isSw ? 'Wanaohitaji Tiba' : 'Need treatment')
                    : (isSw ? 'Wote ni Salama' : 'All healthy'),
                isWarning: summary.sickChickens > 0,
                onTap: () => appState.setActiveDrawerModule('veterinary'),
              ),
              _buildBigCoreCard(
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFF7C2D12),
                bgColor: const Color(0xFFFFEDD5),
                title: isSw ? 'VIFO' : 'MORTALITY',
                value: '${summary.mortality}',
                subtitle: isSw ? 'Leo' : 'Today',
                isWarning: summary.mortality > 0,
                onTap: () => appState.setActiveDrawerModule('production'),
              ),
              _buildBigCoreCard(
                icon: Icons.payments_rounded,
                iconColor: const Color(0xFF065F46),
                bgColor: const Color(0xFFD1FAE5),
                title: isSw ? 'MAUZO' : 'SALES',
                value: 'TZS $sales',
                subtitle: isSw
                    ? 'Uzalishaji ${summary.productivityPercentage.toStringAsFixed(0)}%'
                    : 'Productivity ${summary.productivityPercentage.toStringAsFixed(0)}%',
                onTap: () => appState.setActiveDrawerModule('finance'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Upcoming Vaccination Banner
          if (upcomingVaccines.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple.shade300, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.purple.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_active_rounded, color: Colors.purple, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSw ? 'RATIBA YA CHANJO INAYOKUJA' : 'UPCOMING VACCINATION',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.purple),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          upcomingVaccines.first.diseaseName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                        ),
                        Text(
                          '${DateFormat('dd/MM/yyyy').format(upcomingVaccines.first.scheduledDate)} • ${upcomingVaccines.first.targetAge}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => appState.setActiveDrawerModule('vaccination'),
                    child: Text(
                      isSw ? 'Tazama' : 'View',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          _sectionHeader(Icons.list_alt_rounded, isSw ? 'REKODI ZILIZOHIFADHIWA' : 'SAVED RECORDS'),
          const SizedBox(height: 10),
          if (appState.productionLogs.isEmpty && appState.financeRecords.isEmpty && appState.vaccinations.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text('Hakuna rekodi bado. Rekodi utakayohifadhi itaonekana hapa.'),
            )
          else ...[
            ...appState.productionLogs.take(4).map((log) => _savedRow(
                  Icons.egg_rounded,
                  isSw ? 'Mayai ${log.eggs}' : '${log.eggs} eggs',
                  DateFormat('dd/MM/yyyy').format(log.date),
                  () => appState.setActiveDrawerModule('production'),
                )),
            ...appState.financeRecords.take(4).map((row) => _savedRow(
                  Icons.account_balance_wallet_rounded,
                  '${row.type} • TSh ${row.amount.toStringAsFixed(0)}',
                  row.category,
                  () => appState.setActiveDrawerModule('finance'),
                )),
            ...appState.vaccinations.take(3).map((item) => _savedRow(
                  Icons.vaccines_rounded,
                  item.diseaseName,
                  DateFormat('dd/MM/yyyy').format(item.scheduledDate),
                  () => appState.setActiveDrawerModule('vaccination'),
                )),
            const SizedBox(height: 16),
          ],

          // 4. Modules
          _sectionHeader(Icons.grid_view_rounded, isSw ? 'HUDUMA ZOTE' : 'ALL MODULES'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: 0.82,
            children: [
              _moduleTile(isSw ? 'Daktari' : 'Veterinary', Icons.health_and_safety_rounded, const Color(0xFFDC2626), () => appState.setActiveDrawerModule('veterinary')),
              _moduleTile(isSw ? 'Uzalishaji' : 'Production', Icons.show_chart_rounded, AppTheme.primaryGreen, () => appState.setActiveDrawerModule('production')),
              _moduleTile(isSw ? 'Mafunzo' : 'Training', Icons.school_rounded, const Color(0xFF7C3AED), () => appState.setActiveDrawerModule('training')),
              _moduleTile(isSw ? 'Soko' : 'Market', Icons.storefront_rounded, const Color(0xFFB45309), () => appState.setActiveDrawerModule('marketplace')),
              _moduleTile(isSw ? 'Chakula' : 'Feed', Icons.rice_bowl_rounded, const Color(0xFF0284C7), () => appState.setActiveDrawerModule('feed')),
              _moduleTile(isSw ? 'Chanjo' : 'Vaccines', Icons.vaccines_rounded, const Color(0xFF0F766E), () => appState.setActiveDrawerModule('vaccination')),
              _moduleTile(isSw ? 'Fedha' : 'Finance', Icons.account_balance_wallet_rounded, const Color(0xFF065F46), () => appState.setActiveDrawerModule('finance')),
              _moduleTile(isSw ? 'Ripoti' : 'Reports', Icons.assessment_rounded, const Color(0xFF334155), () => appState.setActiveDrawerModule('reports')),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryGreen, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: AppTheme.primaryGreen,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBigCoreCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String value,
    required String subtitle,
    bool isWarning = false,
    VoidCallback? onTap,
  }) {
    final accent = isWarning ? const Color(0xFFDC2626) : iconColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isWarning ? const Color(0xFFDC2626) : iconColor.withValues(alpha: 0.3),
            width: isWarning ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: accent),
                  ),
                ),
                Icon(icon, color: accent, size: 24),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isWarning ? const Color(0xFFDC2626) : const Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isWarning ? const Color(0xFFDC2626) : const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _savedRow(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }

  Widget _moduleTile(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1F2937)),
          ),
        ],
      ),
    );
  }
}
