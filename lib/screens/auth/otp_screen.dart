import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/tipa_logo.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingiza tarakimu 6 za OTP.')),
      );
      return;
    }
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      await appState.verifyOtp(
        code,
        newPassword: _newPasswordController.text.trim().isEmpty ? null : _newPasswordController.text.trim(),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 24),
          onPressed: () => appState.setRoute('login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TipaLogo(size: 80, showTitle: false),
              const SizedBox(height: 18),
              const Text(
                'Ingiza Namba ya Siri (OTP)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 15, color: Color(0xFF4B5563), height: 1.4),
                  children: [
                    const TextSpan(text: "Kagua ujumbe wa SMS kwenye simu yako. Tumetuma tarakimu 6 kwa\n"),
                    TextSpan(
                      text: appState.pendingIdentifier ?? '+255 ••• ••• 89',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF111827), fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 6 Big PIN Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 58,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2.5),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              if (appState.debugOtp != null) ...[
                Text(
                  'OTP (development): ${appState.debugOtp}',
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.primaryGreen),
                ),
                const SizedBox(height: 12),
              ],
              if (appState.pendingOtpPurpose == 'reset') ...[
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Neno la siri jipya',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Resend Timer Pill in Swahili
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.timer_outlined, size: 18, color: Color(0xFF4B5563)),
                    SizedBox(width: 8),
                    Text(
                      'Tuma tena kodi baada ya 0:58',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Security Callout Card in Swahili
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.4), width: 1.5),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: AppTheme.primaryGreen, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Taarifa za shamba lako ziko salama kabisa. Ukipata changamoto yoyote hakikisha intaneti yako inafanya kazi.",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF047857),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // THIBITISHA NA ENDELEA Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'THIBITISHA NA ENDELEA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
