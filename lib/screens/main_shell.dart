import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

import 'drawer_menu.dart';
import 'dashboard_screen.dart';
import 'veterinary/veterinary_screen.dart';
import 'training/training_screen.dart';
import 'marketplace/marketplace_screen.dart';
import 'production/production_screen.dart';
import 'feed/feed_screen.dart';
import 'vaccination/vaccination_screen.dart';
import 'finance/finance_screen.dart';
import 'reports/reports_screen.dart';
import 'calendar/calendar_screen.dart';
import 'ai_assistant/ai_assistant_screen.dart';
import 'notifications/notifications_screen.dart';
import 'profile/profile_screen.dart';
import 'settings/settings_screen.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeModule = appState.activeDrawerModule;

    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.pets_rounded, color: AppTheme.amberGold, size: 26),
            const SizedBox(width: 8),
            Text(
              _getModuleTitle(activeModule),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_rounded, size: 26),
                if (appState.unreadNotificationCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text(
                        '${appState.unreadNotificationCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => appState.setActiveDrawerModule('notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person_rounded, size: 26),
            onPressed: () => appState.setActiveDrawerModule('profile'),
          ),
        ],
      ),
      body: _buildActiveModuleScreen(activeModule),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _getBottomNavIndex(activeModule),
          onTap: (index) {
            switch (index) {
              case 0:
                appState.setActiveDrawerModule('dashboard');
                break;
              case 1:
                appState.setActiveDrawerModule('veterinary'); // Afya / Disease Scanner
                break;
              case 2:
                appState.setActiveDrawerModule('marketplace'); // Soko la Kuku, Mayai & Chakula
                break;
              case 3:
                appState.setActiveDrawerModule('vaccination'); // Chanjo
                break;
              case 4:
                appState.setActiveDrawerModule('production'); // Uzalishaji & Grafu
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, size: 26),
              label: 'Nyumbani',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded),
              activeIcon: Icon(Icons.camera_alt_rounded, size: 26),
              label: 'Piga Picha Afya',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_rounded),
              activeIcon: Icon(Icons.storefront_rounded, size: 26),
              label: 'Soko la Kuku',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.vaccines_rounded),
              activeIcon: Icon(Icons.vaccines_rounded, size: 26),
              label: 'Chanjo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_rounded),
              activeIcon: Icon(Icons.insert_chart_rounded, size: 26),
              label: 'Grafu Mayai',
            ),
          ],
        ),
      ),
    );
  }

  int _getBottomNavIndex(String module) {
    switch (module) {
      case 'dashboard':
        return 0;
      case 'veterinary':
        return 1;
      case 'marketplace':
        return 2;
      case 'vaccination':
        return 3;
      case 'production':
        return 4;
      default:
        return 0;
    }
  }

  String _getModuleTitle(String module) {
    switch (module) {
      case 'dashboard':
        return 'KUKU DIARY - Nyumbani';
      case 'veterinary':
        return '📸 Afya & Scanner ya Kuku';
      case 'training':
        return '📚 Mafunzo ya Ufugaji';
      case 'marketplace':
        return '🐔 Soko la Kuku & Mayai';
      case 'production':
        return '📊 Uzalishaji & Grafu za Mayai';
      case 'feed':
        return '🌾 Chakula cha Kuku';
      case 'vaccination':
        return '💉 Chanjo & Vikumbusho';
      case 'finance':
        return '💰 Fedha & Mauzo';
      case 'reports':
        return '📄 Ripoti za Kuku';
      case 'calendar':
        return '📅 Kalenda ya Kuku';
      case 'ai_assistant':
        return '🤖 KukuAI Assistant';
      case 'notifications':
        return '🔔 Arifa';
      case 'profile':
        return '👤 Profaili ya Mfugaji';
      case 'settings':
        return '⚙️ Mipangilio';
      default:
        return 'KUKU DIARY';
    }
  }

  Widget _buildActiveModuleScreen(String module) {
    switch (module) {
      case 'dashboard':
        return const DashboardScreen();
      case 'veterinary':
        return const VeterinaryScreen();
      case 'training':
        return const TrainingScreen();
      case 'marketplace':
        return const MarketplaceScreen();
      case 'production':
        return const ProductionScreen();
      case 'feed':
        return const FeedScreen();
      case 'vaccination':
        return const VaccinationScreen();
      case 'finance':
        return const FinanceScreen();
      case 'reports':
        return const ReportsScreen();
      case 'calendar':
        return const CalendarScreen();
      case 'ai_assistant':
        return const AiAssistantScreen();
      case 'notifications':
        return const NotificationsScreen();
      case 'profile':
        return const ProfileScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }
}
