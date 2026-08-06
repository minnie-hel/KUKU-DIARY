import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddStockModal(BuildContext context) {
    final amountController = TextEditingController();
    String selectedFeed = 'Layer Mash (Chakula cha Kuku wa Mayai)';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ongeza Akiba ya Chakula (Restock)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
            const SizedBox(height: 16),

            const Text('Chagua Aina ya Chakula', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedFeed,
              items: [
                'Layer Mash (Chakula cha Kuku wa Mayai)',
                'Chick Starter (Chakula cha Vifaranga)',
                'Grower Pellets (Chakula cha Kukua)',
              ].map((f) => DropdownMenuItem(value: f, child: Text(f, style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: (val) {
                if (val != null) selectedFeed = val;
              },
            ),
            const SizedBox(height: 14),

            const Text('Idadi ya Kilo Unazoongeza (Kg)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Mfano: 50.0', prefixIcon: Icon(Icons.add_task_rounded)),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (amountController.text.isEmpty) return;
                  double addKg = double.tryParse(amountController.text) ?? 50.0;

                  Provider.of<AppState>(context, listen: false).addFeedStock(selectedFeed, addKg);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Akiba ya $selectedFeed imeongezwa kg $addKg!')),
                  );
                },
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('ONGEZA AKIBA'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddStockModal(context),
        backgroundColor: Colors.orange.shade800,
        icon: const Icon(Icons.add_shopping_cart_rounded),
        label: const Text('Ongeza Chakula', style: TextStyle(fontWeight: FontWeight.bold)),
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
                Tab(icon: Icon(Icons.inventory_2_rounded), text: 'Akiba na Hesabu'),
                Tab(icon: Icon(Icons.eco_rounded), text: 'Lishe Mbadala (Azolla & Hydroponics)'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Inventory
                _buildInventoryTab(context, appState),

                // Tab 2: Sustainable Feeding Content
                _buildSustainableFeedingTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab(BuildContext context, AppState appState) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appState.feedInventory.length,
      itemBuilder: (context, index) {
        final item = appState.feedInventory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    if (item.isLowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(12)),
                        child: const Text('Akiba Imepungua!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Akiba ya Sasa: ${item.currentStockKg} kg', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                    Text('Uwezo wa Stoo: ${item.totalCapacityKg} kg', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (item.currentStockKg / item.totalCapacityKg).clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    color: item.isLowStock ? Colors.red : AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gharama kwa Kilo: TSh ${item.costPerKg.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)),
                    TextButton.icon(
                      onPressed: () => _showAddStockModal(context),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Ongeza Stock'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSustainableFeedingTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mbinu za Lishe Mbadala ya Kuku (Sustainable Feeding)',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
          ),
          const Text(
            'Punguza gharama za chakula kwa 30-50% ukitumia mimea na wadudu lishe.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          _buildGuideCard(
            title: '1. Kilimo cha Azolla (Azolla Farming)',
            desc: 'Azolla ni mmea wa majini wenye protini ya juu mno (25-30%). Unakua kwa haraka sana kwenye mabwawa madogo na unafaa sana kwa kuku wa mayai na kienyeji.',
            benefit: 'Inapunguza gharama za pumba na mash kwa 35%.',
            icon: Icons.water_rounded,
            color: Colors.teal,
          ),
          _buildGuideCard(
            title: '2. Mfumo wa Hydroponics (Majani ya Ngano/Mahindi)',
            desc: 'Kuotesha mbegu za nafaka bila udongo kwa kutumia maji pekee ndani ya siku 7-9. Majani haya yana vitamin A, E na minerals zinazoongeza manjano kwenye yai.',
            benefit: 'Inaongeza kiwango cha utagaji na afya ya kuku.',
            icon: Icons.grass_rounded,
            color: Colors.green,
          ),
          _buildGuideCard(
            title: '3. Funza Lishe & Red Worms (BSFL / Worm Farming)',
            desc: 'Ufugaji wa funza wa nzi mweusi (Black Soldier Fly Larvae) kutokana na makombo ya jikoni. Funza hawa wana protini ya hadi 42% na mafuta bora.',
            benefit: 'Inachukua nafasi ya unga wa dagaa au soya kikamilifu.',
            icon: Icons.bug_report_rounded,
            color: Colors.amber.shade900,
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard({
    required String title,
    required String desc,
    required String benefit,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: color, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(benefit, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
