import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.farmProfile;
    final isSw = appState.selectedLanguage == 'sw';
    final farmerName = profile.farmerName.trim().isEmpty ? (isSw ? 'Mfugaji' : 'Farmer') : profile.farmerName.trim();

    final List<Map<String, dynamic>> menuItems = [
      {'key': 'dashboard', 'title': isSw ? 'Dashibodi Kuu' : 'Dashboard', 'icon': Icons.dashboard_rounded},
      {'key': 'veterinary', 'title': isSw ? 'Huduma za Mifugo & AI' : 'Veterinary Services', 'icon': Icons.health_and_safety_rounded},
      {'key': 'disease_detection', 'title': isSw ? 'Scanner ya Magonjwa (AI)' : 'AI Disease Screening', 'icon': Icons.biotech_rounded},
      {'key': 'training', 'title': isSw ? 'Mafunzo & Elimu' : 'Training', 'icon': Icons.school_rounded},
      {'key': 'farm_management', 'title': isSw ? 'Rekodi za Shamba' : 'Farm Records', 'icon': Icons.assignment_rounded},
      {'key': 'production', 'title': isSw ? 'Ufuatiliaji wa Uzalishaji' : 'Production', 'icon': Icons.show_chart_rounded},
      {'key': 'feed', 'title': isSw ? 'Usimamizi wa Chakula' : 'Feed Management', 'icon': Icons.rice_bowl_rounded},
      {'key': 'vaccination', 'title': isSw ? 'Ratiba ya Chanjo' : 'Vaccination', 'icon': Icons.vaccines_rounded},
      {'key': 'marketplace', 'title': isSw ? 'Soko la Kuku & Vifaa' : 'Marketplace', 'icon': Icons.storefront_rounded},
      {'key': 'finance', 'title': isSw ? 'Fedha & Mapato' : 'Finance', 'icon': Icons.account_balance_wallet_rounded},
      {'key': 'reports', 'title': isSw ? 'Ripoti za Shamba (PDF)' : 'Reports (PDF)', 'icon': Icons.assessment_rounded},
      {'key': 'calendar', 'title': isSw ? 'Kalenda ya Shamba' : 'Calendar', 'icon': Icons.calendar_month_rounded},
      {'key': 'ai_assistant', 'title': isSw ? 'Msaidizi wa KukuAI' : 'AI Assistant', 'icon': Icons.psychology_rounded},
      {'key': 'service_providers', 'title': isSw ? 'Watoa Huduma' : 'Service Providers', 'icon': Icons.handshake_rounded},
      {'key': 'breeds_chicks', 'title': isSw ? 'Aina Bora & Vifaranga' : 'Breeds & Chicks', 'icon': Icons.egg_alt_rounded},
      {'key': 'community', 'title': isSw ? 'Jumuiya ya Wafugaji' : 'Community', 'icon': Icons.forum_rounded},
      {'key': 'gps_registration', 'title': isSw ? 'Usajili wa GPS & QR' : 'GPS & QR Registration', 'icon': Icons.qr_code_2_rounded},
      {'key': 'notifications', 'title': isSw ? 'Arifa za Shamba' : 'Notifications', 'icon': Icons.notifications_rounded},
      {'key': 'profile', 'title': isSw ? 'Profaili Yangu' : 'My Profile', 'icon': Icons.person_rounded},
      {'key': 'settings', 'title': isSw ? 'Mipangilio & Msaada' : 'Settings & Help', 'icon': Icons.settings_rounded},
    ];

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppTheme.primaryGreen,
            padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 18, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.amberGold,
                  child: Text(
                    farmerName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmerName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17, height: 1.2),
                      ),
                      if (profile.farmName.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          profile.farmName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppTheme.amberGold, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                      if (profile.location.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          profile.location,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        '${profile.totalChickens} ${profile.chickenType.isNotEmpty ? profile.chickenType : (isSw ? 'kuku' : 'birds')}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = appState.activeDrawerModule == item['key'];

                return ListTile(
                  dense: true,
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade700,
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.primaryGreen : null,
                    ),
                  ),
                  tileColor: isSelected ? AppTheme.primaryGreen.withValues(alpha: 0.1) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onTap: () {
                    Navigator.pop(context);
                    appState.setActiveDrawerModule(item['key'] as String);
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: Text(
              isSw ? 'Ondoka (Logout)' : 'Logout',
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              appState.logout();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
