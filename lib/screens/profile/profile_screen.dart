import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/tipa_logo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.farmProfile;
    final isSw = appState.selectedLanguage == 'sw';
    final name = profile.farmerName.trim().isEmpty ? (isSw ? 'Mfugaji' : 'Farmer') : profile.farmerName.trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const TipaLogo(size: 72, showTitle: false),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                    const SizedBox(height: 4),
                    Text(
                      profile.farmName.trim().isEmpty ? (isSw ? 'Shamba halijawekwa' : 'Farm not saved') : profile.farmName,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.location.trim().isEmpty ? (isSw ? 'Eneo halijawekwa' : 'Location not saved') : profile.location,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(isSw ? 'Taarifa za shamba' : 'Farm details', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen)),
        const SizedBox(height: 8),
        _detail(Icons.home_work_outlined, isSw ? 'Jina la shamba' : 'Farm name', profile.farmName),
        _detail(Icons.location_on_outlined, isSw ? 'Eneo' : 'Location', profile.location),
        _detail(Icons.pets_outlined, isSw ? 'Aina ya kuku' : 'Chicken type', profile.chickenType),
        _detail(Icons.numbers_rounded, isSw ? 'Idadi ya kuku' : 'Birds', '${profile.totalChickens}'),
        _detail(Icons.house_outlined, isSw ? 'Mfumo wa banda' : 'Housing', profile.housingSystem),
        const SizedBox(height: 8),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => appState.setRoute('farm_setup'),
            icon: const Icon(Icons.edit_rounded),
            label: Text(isSw ? 'Hariri taarifa za shamba' : 'Edit farm details', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _detail(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value.trim().isEmpty ? '—' : value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
