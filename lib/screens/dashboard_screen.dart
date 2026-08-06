import 'package:flutter/material.dart';
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
    final upcomingVaccines = appState.vaccinations.where((v) => !v.isCompleted).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Farmer Greeting & Profile Banner
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.amberGold,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.pets_rounded, color: Colors.black87, size: 34),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jambo, ${profile.farmerName.split(' ').first}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.farmName} • ${profile.location}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Section Header: TAKWIMU KUU ZA SHAMBA
          Row(
            children: const [
              Icon(Icons.analytics_rounded, color: AppTheme.primaryGreen, size: 24),
              SizedBox(width: 8),
              Text(
                'TAKWIMU KUU ZA SHAMBA',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4 Clean Metric Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.35,
            children: [
              // 1. KUKU WOTE
              _buildBigCoreCard(
                icon: Icons.pets_rounded,
                iconColor: const Color(0xFF1B4D3E),
                bgColor: const Color(0xFFE8F5E9),
                title: 'KUKU WOTE',
                value: '${profile.totalChickens}',
                subtitle: 'Kuku Bandani',
              ),

              // 2. MAYAI YA LEO
              _buildBigCoreCard(
                icon: Icons.egg_rounded,
                iconColor: const Color(0xFFB45309),
                bgColor: const Color(0xFFFEF3C7),
                title: 'MAYAI YA LEO',
                value: '${summary.eggsCollected}',
                subtitle: 'Yaliyokusanywa',
              ),

              // 3. CHAKULA KILICHOBAKI
              _buildBigCoreCard(
                icon: Icons.grass_rounded,
                iconColor: const Color(0xFF0284C7),
                bgColor: const Color(0xFFE0F2FE),
                title: 'CHAKULA',
                value: '${summary.feedRemainingKg.toStringAsFixed(0)} Kg',
                subtitle: 'Kilicobaki Bandani',
              ),

              // 4. KUKU WAGONJWA
              _buildBigCoreCard(
                icon: Icons.medical_services_rounded,
                iconColor: const Color(0xFFDC2626),
                bgColor: const Color(0xFFFEE2E2),
                title: 'WAGONJWA',
                value: '${summary.sickChickens}',
                subtitle: summary.sickChickens > 0 ? 'Wanaohitaji Tiba' : 'Wote ni Salama',
                isWarning: summary.sickChickens > 0,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Upcoming Vaccination & Notification Banner
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
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_active_rounded, color: Colors.purple, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RATIBA YA CHANJO INAYOKUJA',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.purple),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          upcomingVaccines.first.diseaseName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                        ),
                        Text(
                          'Tarehe: ${upcomingVaccines.first.scheduledDate.day}/${upcomingVaccines.first.scheduledDate.month}/${upcomingVaccines.first.scheduledDate.year} • ${upcomingVaccines.first.targetAge}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => appState.setActiveDrawerModule('vaccination'),
                    child: const Text('Tazama', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.purple)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // 4. Section Header: VITENDO KUU VYA UFUGAJI
          Row(
            children: const [
              Icon(Icons.touch_app_rounded, color: AppTheme.primaryGreen, size: 24),
              SizedBox(width: 8),
              Text(
                'VITENDO KUU VYA UFUGAJI',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Cards
          Column(
            children: [
              // 1. REKODI MAYAI YA LEO
              _buildActionCard(
                context: context,
                title: 'REKODI MAYAI YA LEO',
                subtitle: 'Weka hesabu ya mayai yote uliyookota leo bandani',
                icon: Icons.add_circle_rounded,
                bgColor: AppTheme.primaryGreen,
                textColor: Colors.white,
                onTap: () => appState.setActiveDrawerModule('production'),
              ),
              const SizedBox(height: 12),

              // 2. PIGA PICHA KUKU MGONJWA
              _buildActionCard(
                context: context,
                title: 'PIGA PICHA KUKU MGONJWA',
                subtitle: 'Piga picha au pakia picha ya ugonjwa upate majibu ya AI',
                icon: Icons.camera_alt_rounded,
                bgColor: const Color(0xFFDC2626),
                textColor: Colors.white,
                onTap: () => appState.setActiveDrawerModule('veterinary'),
              ),
              const SizedBox(height: 12),

              // 3. PANGA CHANJO NA KALENDA
              _buildActionCard(
                context: context,
                title: 'PANGA CHANJO & KALENDA',
                subtitle: 'Weka kumbukumbu za chanjo na upokee Taarifa (Notifications)',
                icon: Icons.event_available_rounded,
                bgColor: const Color(0xFF7C3AED),
                textColor: Colors.white,
                onTap: () => appState.setActiveDrawerModule('vaccination'),
              ),
              const SizedBox(height: 12),

              // 4. SOKO LA KUKU NA MAYAI
              _buildActionCard(
                context: context,
                title: 'SOKO LA KUKU & MAYAI',
                subtitle: 'Uza kuku wako na mayai kwa wateja au nunua pembejeo',
                icon: Icons.storefront_rounded,
                bgColor: AppTheme.amberGold,
                textColor: Colors.black87,
                onTap: () => appState.setActiveDrawerModule('marketplace'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
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
  }) {
    return Container(
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: isWarning ? const Color(0xFFDC2626) : iconColor,
                ),
              ),
              Icon(icon, color: isWarning ? const Color(0xFFDC2626) : iconColor, size: 24),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isWarning ? const Color(0xFFDC2626) : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
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
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: textColor, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: textColor, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
