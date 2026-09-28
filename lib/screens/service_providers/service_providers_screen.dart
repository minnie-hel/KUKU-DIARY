import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';


class ServiceProvidersScreen extends StatefulWidget {
  const ServiceProvidersScreen({super.key});

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Veterinary Doctors',
    'Feed Suppliers',
    'Hatcheries',
    'Transporters',
    'Insurance Providers',
    'Financial Services',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    final filteredProviders = _selectedCategory == 'All'
        ? appState.serviceProviders
        : appState.serviceProviders.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Watoa Huduma za Mifugo' : 'Service Providers Directory'),
      ),
      body: Column(
        children: [
          // Filter Chips horizontal list
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (ctx, idx) {
                final cat = _categories[idx];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(
                      _getCategoryLabel(cat, isSw),
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
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Provider Cards List
          Expanded(
            child: filteredProviders.isEmpty
                ? Center(
                    child: Text(
                      isSw ? 'Hakuna mtoa huduma aliyepatikana' : 'No service providers found',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProviders.length,
                    itemBuilder: (context, index) {
                      final p = filteredProviders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.1),
                                    child: Icon(_getProviderIcon(p.category), color: AppTheme.primaryGreen, size: 30),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(p.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                        Text(_getCategoryLabel(p.category, isSw), style: const TextStyle(fontSize: 14, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  Text(p.rating, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(p.description, style: const TextStyle(fontSize: 14, height: 1.3)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_rounded, size: 16, color: Colors.redAccent),
                                      const SizedBox(width: 4),
                                      Text(p.location, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(isSw ? 'Piga simu kwa: ${p.phone}' : 'Calling: ${p.phone}')),
                                      );
                                    },
                                    icon: const Icon(Icons.phone_rounded, size: 18),
                                    label: Text(isSw ? 'Piga Simu' : 'Call', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryGreen,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  String _getCategoryLabel(String cat, bool isSw) {
    if (!isSw) return cat;
    switch (cat) {
      case 'All':
        return 'Wote';
      case 'Veterinary Doctors':
        return 'Madaktari wa Mifugo';
      case 'Feed Suppliers':
        return 'Wauzaji wa Vyakula';
      case 'Hatcheries':
        return 'Vituo vya Vifaranga';
      case 'Transporters':
        return 'Wasafirishaji';
      case 'Insurance Providers':
        return 'Bima ya Ufugaji';
      case 'Financial Services':
        return 'Huduma za Fedha & Mikopo';
      default:
        return cat;
    }
  }

  IconData _getProviderIcon(String cat) {
    switch (cat) {
      case 'Veterinary Doctors':
        return Icons.medical_services_rounded;
      case 'Feed Suppliers':
        return Icons.rice_bowl_rounded;
      case 'Hatcheries':
        return Icons.egg_rounded;
      case 'Transporters':
        return Icons.local_shipping_rounded;
      case 'Insurance Providers':
        return Icons.security_rounded;
      case 'Financial Services':
        return Icons.account_balance_rounded;
      default:
        return Icons.business_center_rounded;
    }
  }
}
