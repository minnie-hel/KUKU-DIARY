import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/tipa_logo.dart';

import 'drawer_menu.dart';
import 'dashboard_screen.dart';
import 'records/records_screen.dart';
import 'farm_management/farm_management_screen.dart';
import 'disease_detection/disease_detection_screen.dart';
import 'veterinary/veterinary_screen.dart';
import 'vaccination/vaccination_screen.dart';
import 'training/training_screen.dart';
import 'marketplace/marketplace_screen.dart';
import 'service_providers/service_providers_screen.dart';
import 'notifications/notifications_screen.dart';
import 'community/community_screen.dart';
import 'reports/reports_screen.dart';
import 'finance/finance_screen.dart';
import 'feed/feed_screen.dart';
import 'production/production_screen.dart';
import 'calendar/calendar_screen.dart';
import 'ai_assistant/ai_assistant_screen.dart';
import 'gps_registration/gps_registration_screen.dart';
import 'breeds/breeds_chicks_screen.dart';
import 'settings/settings_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeModule = appState.activeDrawerModule;
    final isSw = appState.selectedLanguage == 'sw';

    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: Row(
          children: [
            const TipaLogo(size: 34, showTitle: false),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _getModuleTitle(activeModule, isSw),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
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
          onTap: appState.setBottomNavIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_rounded, size: 26),
              label: isSw ? 'Nyumbani' : 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.camera_alt_rounded),
              activeIcon: const Icon(Icons.camera_alt_rounded, size: 26),
              label: isSw ? 'Afya ya Kuku' : 'Health',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront_rounded),
              activeIcon: const Icon(Icons.storefront_rounded, size: 26),
              label: isSw ? 'Soko' : 'Market',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.vaccines_rounded),
              activeIcon: const Icon(Icons.vaccines_rounded, size: 26),
              label: isSw ? 'Chanjo' : 'Vaccines',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.insert_chart_rounded),
              activeIcon: const Icon(Icons.insert_chart_rounded, size: 26),
              label: isSw ? 'Uzalishaji' : 'Production',
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
      case 'disease_detection':
        return 1;
      case 'marketplace':
        return 2;
      case 'vaccination':
        return 3;
      case 'production':
      case 'production_module':
        return 4;
      default:
        return 0;
    }
  }

  String _getModuleTitle(String module, bool isSw) {
    switch (module) {
      case 'dashboard':
        return isSw ? 'KUKU DIARY - Nyumbani' : 'KUKU DIARY - Home';
      case 'records':
      case 'farm_management':
        return isSw ? 'Rekodi za Shamba' : 'Farm Records';
      case 'disease_detection':
        return isSw ? 'Scanner ya Afya ya Kuku' : 'AI Disease Screening';
      case 'veterinary':
        return isSw ? 'Afya & Huduma za Daktari' : 'Health & Veterinary';
      case 'vaccination':
        return isSw ? 'Chanjo & Vikumbusho' : 'Vaccination & Reminders';
      case 'training':
        return isSw ? 'Mafunzo ya Ufugaji' : 'Poultry Training';
      case 'marketplace':
        return isSw ? 'Soko la Kuku & Mayai' : 'Marketplace';
      case 'service_providers':
        return isSw ? 'Watoa Huduma' : 'Service Providers';
      case 'breeds_chicks':
        return isSw ? 'Aina Bora & Vifaranga' : 'Breeds & Chicks';
      case 'notifications':
        return isSw ? 'Arifa' : 'Notifications';
      case 'community':
        return isSw ? 'Jumuiya ya Wafugaji' : 'Farmer Community';
      case 'reports':
        return isSw ? 'Ripoti za Kuku' : 'Farm Reports';
      case 'finance':
        return isSw ? 'Fedha & Mauzo' : 'Finance & Sales';
      case 'gps_registration':
        return isSw ? 'GPS na QR' : 'GPS & QR';
      case 'settings':
        return isSw ? 'Mipangilio' : 'Settings';
      case 'profile':
        return isSw ? 'Profaili ya Mfugaji' : 'Farmer Profile';
      case 'calendar':
      case 'calendar_module':
        return isSw ? 'Kalenda ya Kuku' : 'Farm Calendar';
      case 'ai_assistant':
        return 'KukuAI Assistant';
      case 'production':
      case 'production_module':
        return isSw ? 'Uzalishaji & Grafu za Mayai' : 'Production & Charts';
      case 'feed':
      case 'feed_module':
        return isSw ? 'Chakula cha Kuku' : 'Feed Management';
      default:
        return 'KUKU DIARY';
    }
  }

  Widget _buildActiveModuleScreen(String module) {
    switch (module) {
      case 'dashboard':
        return const DashboardScreen();
      case 'records':
        return const RecordsScreen();
      case 'farm_management':
        return const FarmManagementScreen(nested: true);
      case 'disease_detection':
        return const DiseaseDetectionScreen();
      case 'veterinary':
        return const VeterinaryScreen();
      case 'vaccination':
        return const VaccinationScreen();
      case 'calendar':
      case 'calendar_module':
        return const CalendarScreen();
      case 'training':
        return const TrainingScreen();
      case 'marketplace':
        return const MarketplaceScreen(nested: true);
      case 'service_providers':
        return const ServiceProvidersScreen();
      case 'breeds_chicks':
        return const BreedsChicksScreen();
      case 'notifications':
        return const NotificationsScreen(nested: true);
      case 'community':
        return const CommunityScreen();
      case 'reports':
        return const ReportsScreen();
      case 'finance':
        return const FinanceScreen();
      case 'production':
      case 'production_module':
        return const ProductionScreen();
      case 'feed':
      case 'feed_module':
        return const FeedScreen();
      case 'ai_assistant':
        return const AiAssistantScreen();
      case 'gps_registration':
        return const GpsRegistrationScreen();
      case 'settings':
        return const SettingsScreen();
      case 'profile':
        return const ProfileScreen();
      default:
        return const DashboardScreen();
    }
  }
}
