import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, this.light = false, this.compact = false});

  final bool light;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final color = light ? Colors.white : AppTheme.primaryGreen;
    if (compact) {
      const labels = {'sw': 'SW', 'en': 'EN', 'fr': 'FR'};
      return PopupMenuButton<String>(
        initialValue: appState.selectedLanguage,
        tooltip: 'Language',
        color: Colors.white,
        onSelected: appState.setLanguage,
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'sw', child: Text('Kiswahili')),
          PopupMenuItem(value: 'en', child: Text('English')),
          PopupMenuItem(value: 'fr', child: Text('Français')),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language_rounded, color: color, size: 20),
              const SizedBox(width: 4),
              Text(labels[appState.selectedLanguage] ?? 'SW', style: TextStyle(color: color, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      );
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: appState.selectedLanguage,
        icon: Icon(Icons.language_rounded, color: color, size: 20),
        dropdownColor: Colors.white,
        style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
        items: const [
          DropdownMenuItem(value: 'sw', child: Text('Kiswahili', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w800))),
          DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w800))),
          DropdownMenuItem(value: 'fr', child: Text('Français', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w800))),
        ],
        onChanged: (lang) {
          if (lang != null) appState.setLanguage(lang);
        },
      ),
    );
  }
}
