import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class VeterinaryScreen extends StatefulWidget {
  const VeterinaryScreen({super.key});

  @override
  State<VeterinaryScreen> createState() => _VeterinaryScreenState();
}

class _VeterinaryScreenState extends State<VeterinaryScreen> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Huduma za Daktari wa Mifugo' : 'Veterinary Services'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.amberGold,
          indicatorWeight: 4,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: isSw ? 'Madaktari' : 'Vet Doctors'),
            Tab(text: isSw ? 'Miadi Yangu' : 'Bookings'),
            Tab(text: isSw ? 'KukuAI Chat' : 'AI Chat'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVetDoctorsTab(context, appState, isSw),
          _buildConsultationBookingsTab(context, appState, isSw),
          _buildAiChatTab(context, appState, isSw),
        ],
      ),
    );
  }

  Widget _buildVetDoctorsTab(BuildContext context, AppState appState, bool isSw) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appState.vets.length,
      itemBuilder: (context, index) {
        final vet = appState.vets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.1),
                      child: const Icon(Icons.person_outline_rounded, color: AppTheme.primaryGreen, size: 36),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vet.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(vet.specialty, style: const TextStyle(fontSize: 14, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppTheme.amberGold, size: 18),
                              Text(' ${vet.rating} (${vet.reviewCount} ${isSw ? 'maoni' : 'reviews'})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Icon(Icons.location_on_rounded, size: 16, color: Colors.grey.shade600),
                              Text(' ${vet.location}', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  isSw ? 'Chagua Aina ya Huduma:' : 'Select Consultation Type:',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildConsultationActionChip(
                      icon: Icons.chat_rounded,
                      label: isSw ? 'Chat na Daktari' : 'Chat',
                      color: AppTheme.primaryGreen,
                      onTap: () => _showBookingDialog(context, appState, vet, 'Chat', isSw),
                    ),
                    _buildConsultationActionChip(
                      icon: Icons.phone_rounded,
                      label: isSw ? 'Simu ya Sauti' : 'Voice Call',
                      color: AppTheme.infoBlue,
                      onTap: () => _showBookingDialog(context, appState, vet, 'Voice Call', isSw),
                    ),
                    _buildConsultationActionChip(
                      icon: Icons.videocam_rounded,
                      label: isSw ? 'Video Consultation' : 'Video',
                      color: Colors.purple,
                      onTap: () => _showBookingDialog(context, appState, vet, 'Video Consultation', isSw),
                    ),
                    _buildConsultationActionChip(
                      icon: Icons.house_siding_rounded,
                      label: isSw ? 'Tembelea Shamba' : 'Farm Visit',
                      color: Colors.deepOrange,
                      onTap: () => _showBookingDialog(context, appState, vet, 'Farm Visit', isSw),
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

  Widget _buildConsultationActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  void _showBookingDialog(BuildContext context, AppState appState, VetProfile vet, String consultationType, bool isSw) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${isSw ? 'Omba' : 'Request'} $consultationType', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${isSw ? 'Daktari' : 'Doctor'}: ${vet.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: isSw ? 'Maelezo ya Tatizo au Picha' : 'Symptom Details or Notes',
                hintText: isSw ? 'Eleza hali ya kuku wako...' : 'Describe bird health condition...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isSw ? 'Ghairi' : 'Cancel', style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              appState.bookVetConsultation(
                vetId: vet.id,
                vetName: vet.name,
                consultationType: consultationType,
                symptomsOrNotes: notesController.text.isNotEmpty ? notesController.text : 'Routine checkup request',
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isSw ? 'Ombi la miadi limetumwa kwa ${vet.name}!' : 'Booking request sent to ${vet.name}!')),
              );
            },
            child: Text(isSw ? 'Tuma Miadi' : 'Submit Request', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationBookingsTab(BuildContext context, AppState appState, bool isSw) {
    if (appState.vetConsultations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_note_rounded, size: 70, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                isSw ? 'Huna miadi yoyote ya daktari bado' : 'No vet consultations requested yet',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appState.vetConsultations.length,
      itemBuilder: (context, index) {
        final c = appState.vetConsultations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(c.vetName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(12)),
                  child: Text(c.status, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${isSw ? 'Aina' : 'Type'}: ${c.consultationType}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  Text('${isSw ? 'Maelezo' : 'Notes'}: ${c.symptomsOrNotes}', style: const TextStyle(fontSize: 14)),
                  Text('${isSw ? 'Muda' : 'Time'}: ${DateFormat('dd MMM yyyy, HH:mm').format(c.requestedTime)}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAiChatTab(BuildContext context, AppState appState, bool isSw) {
    final textController = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appState.chatMessages.length,
            itemBuilder: (context, index) {
              final msg = appState.chatMessages[index];
              final isUser = msg.sender == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: isUser ? Colors.white : Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      if (msg.isVetRecommendation) ...[
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            _tabController.animateTo(0); // Switch to Vet Doctors tab
                          },
                          icon: const Icon(Icons.medical_services_rounded, size: 18),
                          label: Text(
                            isSw ? 'Wasiliana na Daktari' : 'Contact Doctor',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.amberGold, foregroundColor: Colors.black87),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: isSw ? 'Uliza KukuAI swali kuhusu afya...' : 'Ask KukuAI about chicken health...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppTheme.primaryGreen,
                radius: 26,
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      appState.sendChatMessage(textController.text);
                      textController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
