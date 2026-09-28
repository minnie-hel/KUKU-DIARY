import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  final bool nested;

  const NotificationsScreen({super.key, this.nested = false});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Chanjo',
    'Ugonjwa',
    'Hali ya Hewa',
    'Mafunzo',
    'Soko',
    'Vet',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    final filteredNotifs = _selectedFilter == 'All'
        ? appState.notifications
        : appState.notifications.where((n) => n.type.toLowerCase().contains(_selectedFilter.toLowerCase())).toList();

    final content = Column(
        children: [
          // Filter horizontal list
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filters.length,
              itemBuilder: (ctx, idx) {
                final filter = _filters[idx];
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(
                      _getFilterLabel(filter, isSw),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selectedColor: AppTheme.primaryGreen,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (val) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Notifications List
          Expanded(
            child: filteredNotifs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_none_rounded, size: 70, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          isSw ? 'Hakuna arifa mpya kwa sasa' : 'No new notifications',
                          style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotifs.length,
                    itemBuilder: (context, index) {
                      final notif = filteredNotifs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        color: notif.isRead ? Colors.white : Colors.amber.shade50,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          leading: CircleAvatar(
                            backgroundColor: _getNotifColor(notif.type).withValues(alpha: 0.2),
                            child: Icon(_getNotifIcon(notif.type), color: _getNotifColor(notif.type), size: 26),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notif.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: notif.isRead ? FontWeight.bold : FontWeight.w900,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm').format(notif.time),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              notif.message,
                              style: const TextStyle(fontSize: 14, height: 1.3),
                            ),
                          ),
                          onTap: () {
                            appState.markNotificationAsRead(notif.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      );

    if (widget.nested) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: appState.clearNotifications,
              icon: const Icon(Icons.delete_sweep_rounded, size: 20),
              label: Text(isSw ? 'Futa zote' : 'Clear all'),
            ),
          ),
          Expanded(child: content),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Arifa na Tahadhari' : 'Notifications & Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded, size: 26),
            tooltip: isSw ? 'Futa Zote' : 'Clear All',
            onPressed: appState.clearNotifications,
          ),
        ],
      ),
      body: content,
    );
  }

  String _getFilterLabel(String filter, bool isSw) {
    if (!isSw) return filter;
    switch (filter) {
      case 'All':
        return 'Zote';
      case 'Chanjo':
        return 'Chanjo';
      case 'Ugonjwa':
        return 'Tahadhari Ugonjwa';
      case 'Hali ya Hewa':
        return 'Hali ya Hewa';
      case 'Mafunzo':
        return 'Mafunzo';
      case 'Soko':
        return 'Bei za Soko';
      case 'Vet':
        return 'Majibu ya Vet';
      default:
        return filter;
    }
  }

  Color _getNotifColor(String type) {
    switch (type.toLowerCase()) {
      case 'chanjo':
      case 'vaccine':
        return AppTheme.primaryGreen;
      case 'ugonjwa':
      case 'disease':
        return Colors.red;
      case 'hali ya hewa':
      case 'weather':
        return Colors.blue;
      case 'soko':
      case 'market':
        return AppTheme.amberGold;
      default:
        return AppTheme.infoBlue;
    }
  }

  IconData _getNotifIcon(String type) {
    switch (type.toLowerCase()) {
      case 'chanjo':
      case 'vaccine':
        return Icons.vaccines_rounded;
      case 'ugonjwa':
      case 'disease':
        return Icons.warning_amber_rounded;
      case 'hali ya hewa':
      case 'weather':
        return Icons.wb_sunny_rounded;
      case 'soko':
      case 'market':
        return Icons.shopping_bag_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }
}
