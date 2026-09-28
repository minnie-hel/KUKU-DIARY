import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

/// Improved breeds and chick listings from marketplace and hatchery service providers (API).
class BreedsChicksScreen extends StatelessWidget {
  const BreedsChicksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    final chickListings = appState.marketplaceItems.where((item) {
      final cat = item.category.toLowerCase();
      return cat.contains('vifaranga') || cat.contains('chick') || cat.contains('broiler') || cat.contains('layer');
    }).toList();

    final hatcheries = appState.serviceProviders.where((p) {
      final c = p.category.toLowerCase();
      return c.contains('hatch') || c.contains('chick');
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSw ? 'Aina Bora na Vifaranga' : 'Improved Breeds & Chicks',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            isSw
                ? 'Orodha kutoka soko na watoa huduma waliosajiliwa.'
                : 'Listings from the marketplace and registered hatcheries.',
            style: const TextStyle(color: AppTheme.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 20),
          Text(isSw ? 'Vifaranga Sokoni' : 'Chicks on Marketplace', style: _sectionStyle),
          const SizedBox(height: 10),
          if (chickListings.isEmpty)
            _emptyCard(isSw ? 'Hakuna vifaranga vilivyowekwa sokoni bado.' : 'No chick listings on the marketplace yet.')
          else
            ...chickListings.map((item) => _listingCard(item, isSw)),
          const SizedBox(height: 24),
          Text(isSw ? 'Vituo vya Vifaranga' : 'Hatcheries & Suppliers', style: _sectionStyle),
          const SizedBox(height: 10),
          if (hatcheries.isEmpty)
            _emptyCard(isSw ? 'Hakuna vituo vilivyosajiliwa. Endesha seed_catalog kwenye seva.' : 'No hatcheries in catalog yet.')
          else
            ...hatcheries.map((p) => _providerCard(p, isSw)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => appState.setActiveDrawerModule('marketplace'),
            icon: const Icon(Icons.storefront_rounded),
            label: Text(isSw ? 'Nenda Sokoni' : 'Open Marketplace'),
          ),
        ],
      ),
    );
  }

  static const _sectionStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen);

  Widget _emptyCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message, style: const TextStyle(color: AppTheme.textSecondary)),
      ),
    );
  }

  Widget _listingCard(MarketplaceItem item, bool isSw) {
    final price = NumberFormat('#,###').format(item.price.round());
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.amberGold.withValues(alpha: 0.25),
          child: const Icon(Icons.egg_alt_rounded, color: AppTheme.amberGold),
        ),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${item.location} • $price TZS/${item.unit}'),
        isThreeLine: item.description.isNotEmpty,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _providerCard(ServiceProvider p, bool isSw) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.infoBlue.withValues(alpha: 0.15),
          child: const Icon(Icons.pets_rounded, color: AppTheme.infoBlue),
        ),
        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${p.location}\n${p.description}', maxLines: 3, overflow: TextOverflow.ellipsis),
        isThreeLine: true,
      ),
    );
  }
}
