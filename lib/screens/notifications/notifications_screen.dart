import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final notifications = appState.notifications;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Arifa na Tahadhari (${notifications.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    appState.clearNotifications();
                  },
                  child: const Text('Futa Zote', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Hakuna arifa mpya kwa sasa.', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final n = notifications[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: n.isRead ? null : AppTheme.primaryGreen.withValues(alpha: 0.05),
                        child: ListTile(
                          leading: Icon(
                            n.type == 'Chanjo'
                                ? Icons.vaccines_rounded
                                : n.type == 'Chakula'
                                    ? Icons.rice_bowl_rounded
                                    : Icons.shopping_bag_rounded,
                            color: n.type == 'Chanjo' ? Colors.purple : AppTheme.primaryGreen,
                          ),
                          title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold)),
                          subtitle: Text(n.message),
                          trailing: IconButton(
                            icon: Icon(n.isRead ? Icons.check_circle_outlined : Icons.circle, size: 16, color: AppTheme.primaryGreen),
                            onPressed: () {
                              appState.markNotificationAsRead(n.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
