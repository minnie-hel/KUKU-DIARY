import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class GpsRegistrationScreen extends StatefulWidget {
  const GpsRegistrationScreen({super.key});

  @override
  State<GpsRegistrationScreen> createState() => _GpsRegistrationScreenState();
}

class _GpsRegistrationScreenState extends State<GpsRegistrationScreen> {
  bool _isCapturingGps = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.farmProfile;
    final isSw = appState.selectedLanguage == 'sw';

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Usajili wa Shamba & GPS' : 'GPS Farm Registration & QR'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.gps_fixed_rounded, color: AppTheme.amberGold, size: 40),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.farmName,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${isSw ? 'Eneo' : 'Location'}: ${profile.location}',
                                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      '${isSw ? 'Latitudo (Latitude)' : 'Latitude'}: ${profile.latitude}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${isSw ? 'Longitudo (Longitude)' : 'Longitude'}: ${profile.longitude}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isCapturingGps
                            ? null
                            : () async {
                                setState(() {
                                  _isCapturingGps = true;
                                });
                                try {
                                  LocationPermission permission = await Geolocator.checkPermission();
                                  if (permission == LocationPermission.denied) {
                                    permission = await Geolocator.requestPermission();
                                  }
                                  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                                    throw Exception(isSw ? 'Ruhusa ya GPS imekataliwa.' : 'GPS permission denied.');
                                  }
                                  final position = await Geolocator.getCurrentPosition();
                                  await appState.updateFarmGps(
                                    position.latitude,
                                    position.longitude,
                                    location: profile.location,
                                  );
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isSw
                                            ? 'Eneo la GPS limehifadhiwa kwenye database.'
                                            : 'GPS location saved to the database.',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isCapturingGps = false;
                                    });
                                  }
                                }
                              },
                        icon: _isCapturingGps
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.my_location_rounded),
                        label: Text(
                          _isCapturingGps ? (isSw ? 'Inachukua GPS...' : 'Capturing GPS...') : (isSw ? 'CHUKUA GPS YA SHAMBA' : 'CAPTURE FARM GPS'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // QR Code Traceability Container
            Text(
              isSw ? 'Msimbo wa QR wa Shamba (Traceability)' : 'Farm QR Code (Traceability)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isSw
                  ? 'Kila tray ya mayai au kuku inayotoka shambani kwako inatambulika kwa Msimbo huu wa QR ili wanunuzi na wateja wahakikishe usalama na asili ya chakula.'
                  : 'Every egg tray or chicken from your farm carries this unique QR code for buyers to verify origin and safety.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 16),

            // Simulated QR Visual Widget
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryGreen, width: 3),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_2_rounded, size: 180, color: AppTheme.primaryGreen),
                    const SizedBox(height: 8),
                    Text(
                      profile.qrCodeData,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isSw ? 'Msimbo wa QR umechapishwa / Kuhifadhiwa!' : 'QR Code printed / saved!')),
                        );
                      },
                      icon: const Icon(Icons.print_rounded, size: 20),
                      label: Text(isSw ? 'Chapisha Msimbo wa QR' : 'Print QR Code', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.amberGold, foregroundColor: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
