import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class MarketplaceScreen extends StatefulWidget {
  final bool nested;

  const MarketplaceScreen({super.key, this.nested = false});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'All';
  bool _showSellOnly = true; // true = Sell, false = Buy

  final List<String> _categories = [
    'All',
    'Mayai',
    'Vifaranga',
    'Kuku Wakubwa',
    'Vyakula',
    'Chanjo',
    'Dawa',
    'Vifaa',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    final filteredItems = appState.marketplaceItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSaleType = _showSellOnly ? item.isForSale : !item.isForSale;
      return matchesCategory && matchesSaleType;
    }).toList();

    final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sell vs Buy Toggle Buttons
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showSellOnly = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showSellOnly ? AppTheme.primaryGreen : Colors.grey.shade300,
                      foregroundColor: _showSellOnly ? Colors.white : Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isSw ? 'Uza (Mayai / Kuku)' : 'Sell Products',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showSellOnly = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showSellOnly ? AppTheme.infoBlue : Colors.grey.shade300,
                      foregroundColor: !_showSellOnly ? Colors.white : Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isSw ? 'Nunua (Chakula / Dawa)' : 'Buy Supplies',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Categories Horizontal Filter
          SizedBox(
            height: 48,
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
                      cat,
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
          const SizedBox(height: 8),

          // Marketplace Items Grid
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      isSw ? 'Hakuna bidhaa katika jamii hii sokoni' : 'No items found in this marketplace category',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildMarketplaceCard(context, item, isSw);
                    },
                  ),
          ),
        ],
      );

    if (widget.nested) {
      return Stack(
        children: [
          content,
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () => _showAddProductDialog(context, appState, isSw),
              backgroundColor: AppTheme.amberGold,
              icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.black87, size: 22),
              label: Text(
                isSw ? 'Weka Bidhaa' : 'Post',
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Soko la Kuku & Vifaa' : 'Poultry Marketplace'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(context, appState, isSw),
        backgroundColor: AppTheme.amberGold,
        icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.black87, size: 26),
        label: Text(
          isSw ? 'Weka Bidhaa Sokoni' : 'Post Product',
          style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: content,
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mayai':
        return Icons.egg_rounded;
      case 'Vifaranga':
        return Icons.pets_rounded;
      case 'Kuku Wakubwa':
        return Icons.agriculture_rounded;
      case 'Vyakula':
        return Icons.grass_rounded;
      case 'Chanjo':
        return Icons.vaccines_rounded;
      case 'Dawa':
        return Icons.medication_rounded;
      case 'Vifaa':
        return Icons.build_rounded;
      default:
        return Icons.shopping_bag_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Mayai':
        return const Color(0xFFF59E0B);
      case 'Vifaranga':
        return const Color(0xFF10B981);
      case 'Kuku Wakubwa':
        return const Color(0xFF059669);
      case 'Vyakula':
        return const Color(0xFFD97706);
      case 'Chanjo':
        return const Color(0xFF2563EB);
      case 'Dawa':
        return const Color(0xFFDC2626);
      case 'Vifaa':
        return const Color(0xFF4B5563);
      default:
        return AppTheme.primaryGreen;
    }
  }

  Widget _buildMarketplaceCard(BuildContext context, MarketplaceItem item, bool isSw) {
    final catColor = _getCategoryColor(item.category);
    final catIcon = _getCategoryIcon(item.category);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instant Image & Category Header (Zero Delay)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Container(
                  height: 105,
                  width: double.infinity,
                  color: catColor.withValues(alpha: 0.15),
                  child: Center(
                    child: Icon(catIcon, size: 48, color: catColor),
                  ),
                ),
                Image.network(
                  item.imageUrl,
                  height: 105,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return AnimatedOpacity(
                      opacity: frame == null ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: child,
                    );
                  },
                  errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price.toStringAsFixed(0)} ${item.unit}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        item.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () => _openItemDetailsModal(context, item, isSw),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      isSw ? 'Angalia Oda' : 'View & Order',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openItemDetailsModal(BuildContext context, MarketplaceItem item, bool isSw) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 28),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${item.price.toStringAsFixed(0)} ${item.unit}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.amberGold),
              ),
              const Divider(height: 24),
              Text(
                item.description,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 16),
              Text('${isSw ? 'Muuzaji' : 'Seller'}: ${item.sellerName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${isSw ? 'Mahali' : 'Location'}: ${item.location}', style: const TextStyle(fontSize: 15, color: Colors.grey)),
              Text('${isSw ? 'Simu' : 'Phone'}: ${item.sellerPhone}', style: const TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isSw ? 'Oda yako ya ${item.title} imetumwa kwa muuzaji!' : 'Order for ${item.title} sent to seller!')),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 22),
                      label: Text(isSw ? 'Weka Oda Papo Hapo' : 'Place Order', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, AppState appState, bool isSw) {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'TSh / Trei');
    final descCtrl = TextEditingController();
    String category = 'Mayai';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSw ? 'Weka Bidhaa Mpya Sokoni' : 'Post Product to Marketplace', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: InputDecoration(labelText: isSw ? 'Jamii ya Bidhaa' : 'Product Category'),
                items: ['Mayai', 'Vifaranga', 'Kuku Wakubwa', 'Vyakula', 'Chanjo', 'Dawa', 'Vifaa']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) category = val;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Jina la Bidhaa' : 'Product Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Bei (TSh)' : 'Price (TSh)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: unitCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Kipimo (Mf. TSh/Trei)' : 'Unit'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Maelezo ya Bidhaa' : 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isSw ? 'Ghairi' : 'Cancel', style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                appState.addMarketplaceItem(
                  MarketplaceItem(
                    id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text,
                    category: category,
                    price: double.tryParse(priceCtrl.text) ?? 10000.0,
                    unit: unitCtrl.text,
                    description: descCtrl.text,
                    sellerName: appState.farmProfile.farmerName,
                    sellerPhone: appState.farmProfile.phone,
                    location: appState.farmProfile.location,
                    imageUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=400&q=80',
                    isForSale: true,
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: Text(isSw ? 'Hifadhi Sokoni' : 'Post Item', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
