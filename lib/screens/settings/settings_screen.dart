import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _vaccineNotifs = true;
  bool _diseaseAlerts = true;
  bool _marketAlerts = true;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Mipangilio ya Programu' : 'Application Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Language Selector Card
            Text(
              isSw ? 'Lugha ya Programu (Language)' : 'App Language',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.language_rounded, color: AppTheme.primaryGreen, size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Language / Lugha',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: appState.selectedLanguage,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      items: const [
                        DropdownMenuItem(value: 'sw', child: Text('Kiswahili')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'fr', child: Text('Français')),
                      ],
                      onChanged: (lang) {
                        if (lang != null) {
                          appState.setLanguage(lang);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Notification Preferences
            Text(
              isSw ? 'Mipangilio ya Arifa (Notifications)' : 'Notification Preferences',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: AppTheme.primaryGreen,
                    title: Text(isSw ? 'Arifa za Chanjo & Dawa' : 'Vaccination Reminders', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    value: _vaccineNotifs,
                    onChanged: (val) => setState(() => _vaccineNotifs = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    activeColor: AppTheme.primaryGreen,
                    title: Text(isSw ? 'Tahadhari za Magonjwa Eneoni' : 'Regional Disease Alerts', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    value: _diseaseAlerts,
                    onChanged: (val) => setState(() => _diseaseAlerts = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    activeColor: AppTheme.primaryGreen,
                    title: Text(isSw ? 'Mabadiliko ya Bei za Soko' : 'Market Price Updates', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    value: _marketAlerts,
                    onChanged: (val) => setState(() => _marketAlerts = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Dark Mode Toggle
            Card(
              child: SwitchListTile(
                activeColor: AppTheme.primaryGreen,
                secondary: const Icon(Icons.dark_mode_rounded, color: AppTheme.primaryGreen, size: 28),
                title: Text(isSw ? 'Mfumo wa Giza (Dark Mode)' : 'Dark Mode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                value: appState.isDarkMode,
                onChanged: (val) => appState.toggleDarkMode(),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Account Settings & Support Actions
            Text(
              isSw ? 'Akaunti na Msaada' : 'Account & Support',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_rounded, color: AppTheme.primaryGreen),
                    title: Text(isSw ? 'Hariri Profaili ya Mfugaji' : 'Edit Profile', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => appState.setActiveDrawerModule('profile'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_rounded, color: AppTheme.primaryGreen),
                    title: Text(isSw ? 'Badilisha Neno la Siri' : 'Change Password', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showChangePasswordDialog(context, isSw),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_center_rounded, color: AppTheme.infoBlue),
                    title: Text(isSw ? 'Msaada & Huduma kwa Wateja' : 'Help & Support', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showHelpSupportDialog(context, isSw),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => appState.logout(),
                icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 24),
                label: Text(
                  isSw ? 'Ondoka (Logout)' : 'Logout',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, bool isSw) {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSw ? 'Badilisha Neno la Siri' : 'Change Password', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassCtrl,
              obscureText: true,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(labelText: isSw ? 'Neno la Siri la Purani' : 'Old Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(labelText: isSw ? 'Neno la Siri Jipya' : 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isSw ? 'Ghairi' : 'Cancel', style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await Provider.of<AppState>(context, listen: false).changePassword(
                  oldPassCtrl.text,
                  newPassCtrl.text,
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isSw ? 'Neno la siri limebadilishwa kwa usahihi!' : 'Password changed successfully!')),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: Text(isSw ? 'Hifadhi' : 'Save', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context, bool isSw) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSw ? 'Msaada & Huduma kwa Wateja' : 'Help & Support', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Hotline: +255 800 555 777', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Email: msaada@kukudiary.co.tz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Office: Kibaha, Pwani, Tanzania', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isSw ? 'Funga' : 'Close', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
