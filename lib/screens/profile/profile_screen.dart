import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.farmProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile Header Avatar
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: AppTheme.amberGold,
                      child: Text(
                        profile.initial,
                        style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: AppTheme.primaryGreen, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(profile.farmerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(profile.email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Farm Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Taarifa za Shamba Lako', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryGreen)),
                  const Divider(),
                  _buildProfileRow('Jina la Shamba', profile.farmName),
                  _buildProfileRow('Eneo / Mahali', profile.location),
                  _buildProfileRow('Aina ya Kuku', profile.chickenType),
                  _buildProfileRow('Idadi ya Kuku', '${profile.totalChickens} Kuku'),
                  _buildProfileRow('Mfumo wa Banda', profile.housingSystem),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Account Actions
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_rounded, color: AppTheme.primaryGreen),
                  title: const Text('Hariri Taarifa za Shamba'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => appState.setRoute('farm_setup'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_rounded, color: AppTheme.amberGold),
                  title: const Text('Badilisha Neno la Siri'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fomu ya kubadili neno la siri imefunguka.')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
