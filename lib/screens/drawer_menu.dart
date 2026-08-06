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

    final List<Map<String, dynamic>> menuItems = [
      {'key': 'dashboard', 'title': 'Dashibodi Kuu', 'icon': Icons.dashboard_rounded},
      {'key': 'veterinary', 'title': 'Huduma za Mifugo & AI', 'icon': Icons.health_and_safety_rounded},
      {'key': 'training', 'title': 'Mafunzo & Elimu', 'icon': Icons.school_rounded},
      {'key': 'marketplace', 'title': 'Soko la Kuku & Vifaa', 'icon': Icons.storefront_rounded},
      {'key': 'production', 'title': 'Ufuatiliaji wa Uzalishaji', 'icon': Icons.show_chart_rounded},
      {'key': 'feed', 'title': 'Usimamizi wa Chakula', 'icon': Icons.rice_bowl_rounded},
      {'key': 'vaccination', 'title': 'Ratiba ya Chanjo', 'icon': Icons.vaccines_rounded},
      {'key': 'finance', 'title': 'Fedha & Mapato', 'icon': Icons.account_balance_wallet_rounded},
      {'key': 'reports', 'title': 'Ripoti za Shamba (PDF)', 'icon': Icons.assessment_rounded},
      {'key': 'calendar', 'title': 'Kalenda ya Shamba', 'icon': Icons.calendar_month_rounded},
      {'key': 'ai_assistant', 'title': 'Msaidizi wa KukuAI', 'icon': Icons.psychology_rounded},
      {'key': 'notifications', 'title': 'Arifa za Shamba', 'icon': Icons.notifications_rounded},
      {'key': 'profile', 'title': 'Profaili Yangu', 'icon': Icons.person_rounded},
      {'key': 'settings', 'title': 'Mipangilio', 'icon': Icons.settings_rounded},
    ];

    return Drawer(
      child: Column(
        children: [
          // User Profile Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryGreen,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppTheme.amberGold,
              child: Text(
                profile.farmerName[0],
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            accountName: Text(
              profile.farmerName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(profile.farmName, style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.w600)),
                Text('${profile.totalChickens} ${profile.chickenType}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),

          // Menu List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = appState.activeDrawerModule == item['key'];

                return ListTile(
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
                    Navigator.pop(context); // close drawer
                    appState.setActiveDrawerModule(item['key'] as String);
                  },
                );
              },
            ),
          ),

          const Divider(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Ondoka (Logout)',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              appState.setRoute('login');
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
