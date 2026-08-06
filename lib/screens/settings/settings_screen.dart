import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mipangilio ya Programu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                // Dark Mode Switch
                SwitchListTile(
                  title: const Text('Njia ya Usiku (Dark Mode)', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Badilisha muonekano wa skrini uwe mweusi'),
                  secondary: const Icon(Icons.dark_mode_rounded, color: AppTheme.primaryGreen),
                  value: appState.isDarkMode,
                  onChanged: (val) {
                    appState.toggleDarkMode();
                  },
                ),
                const Divider(height: 1),

                // Language Selection
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: AppTheme.amberGold),
                  title: const Text('Lugha ya Programu (Language)', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(appState.selectedLanguage == 'sw' ? 'Kiswahili (Default)' : 'English'),
                  trailing: DropdownButton<String>(
                    value: appState.selectedLanguage,
                    items: const [
                      DropdownMenuItem(value: 'sw', child: Text('Kiswahili')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                    ],
                    onChanged: (val) {
                      if (val != null) appState.setLanguage(val);
                    },
                  ),
                ),
                const Divider(height: 1),

                // Notification preferences
                SwitchListTile(
                  title: const Text('Arifa za Chanjo na Sokoni', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Pata vikumbusho kwenye simu yako'),
                  secondary: const Icon(Icons.notifications_active_rounded, color: Colors.purple),
                  value: true,
                  onChanged: (val) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Kuhusu & Msaada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded, color: Colors.blue),
                  title: const Text('Msaada & Maswali ya Mara kwa Mara'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kituo cha Msaada cha KUKU DIARY kinapatikana: +255 700 000 000')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: Colors.teal),
                  title: const Text('Sera ya Faragha (Privacy Policy)'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: Colors.grey),
                  title: Text('KUKU DIARY Version'),
                  subtitle: Text('v1.0.0 (Build 2026) • Swahili Edition'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
