import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddListingModal(BuildContext context) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final unitController = TextEditingController(text: 'TSh / Kuku');
    final descController = TextEditingController();

    String category = 'Kuku';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Weka Bidhaa Mpya Sokoni', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
              const SizedBox(height: 16),

              // Title
              const Text('Jina la Bidhaa (Mf. Kuku wa Mayai / Trei za Mayai)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Mfano: Kuku wa Kienyeji 20 Wanataga'),
              ),
              const SizedBox(height: 14),

              // Category
              const Text('Aina ya Bidhaa', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(),
                items: ['Kuku', 'Mayai', 'Vyakula']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat == 'Kuku' ? '🐔 Kuku' : cat == 'Mayai' ? '🥚 Mayai' : '🌾 Chakula cha Kuku')))
                    .toList(),
                onChanged: (val) {
                  if (val != null) category = val;
                },
              ),
              const SizedBox(height: 14),

              // Price & Unit
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bei (TSh)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '18000'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kipimo', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: unitController,
                          decoration: const InputDecoration(hintText: 'TSh / Kuku'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Description
              const Text('Maelezo ya Ziada', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Eleza afya ya kuku au ubora wa mayai...'),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (titleController.text.isEmpty || priceController.text.isEmpty) {
                      return;
                    }
                    final appState = Provider.of<AppState>(context, listen: false);
                    final newItem = MarketplaceItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      category: category,
                      price: double.tryParse(priceController.text) ?? 15000.0,
                      unit: unitController.text.trim(),
                      description: descController.text.trim(),
                      sellerName: appState.farmProfile.farmerName,
                      sellerPhone: appState.farmProfile.phone,
                      location: appState.farmProfile.location,
                      imageUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=400&q=80',
                      isForSale: true,
                    );
                    appState.addMarketplaceItem(newItem);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bidhaa yako ya kuku imewekwa sokoni!')),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('WEKA BIDHAA SOKONI'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddListingModal(context),
        backgroundColor: AppTheme.amberGold,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add_shopping_cart_rounded),
        label: const Text('Uza Kuku / Mayai Yako', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryGreen,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryGreen,
              tabs: const [
                Tab(icon: Icon(Icons.pets_rounded), text: '🐔 Kuku'),
                Tab(icon: Icon(Icons.egg_rounded), text: '🥚 Mayai'),
                Tab(icon: Icon(Icons.rice_bowl_rounded), text: '🌾 Chakula'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Kuku
                _buildMarketCategoryList(context, appState, 'Kuku'),

                // Tab 2: Mayai
                _buildMarketCategoryList(context, appState, 'Mayai'),

                // Tab 3: Vyakula
                _buildMarketCategoryList(context, appState, 'Vyakula'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketCategoryList(BuildContext context, AppState appState, String categoryFilter) {
    final filtered = appState.marketplaceItems.where((item) => item.category == categoryFilter || categoryFilter == 'Zote').toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categoryFilter == 'Kuku'
                  ? Icons.pets_rounded
                  : categoryFilter == 'Mayai'
                      ? Icons.egg_rounded
                      : Icons.rice_bowl_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text('Hakuna $categoryFilter sokoni kwa sasa.', style: const TextStyle(color: Colors.grey, fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(
                        item.category == 'Kuku'
                            ? '🐓 Kuku'
                            : item.category == 'Mayai'
                                ? '🥚 Mayai'
                                : '🌾 Chakula',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: AppTheme.amberGold.withValues(alpha: 0.25),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(item.location, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TSh ${item.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.primaryGreen),
                            ),
                            Text(item.unit, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Muuzaji: ${item.sellerName}'),
                                content: Text('Namba ya Simu: ${item.sellerPhone}\nMahali: ${item.location}'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Funga')),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.phone),
                                    label: const Text('Piga Simu Sasa'),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('PIGA SIMU NUNUA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
