import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneOrEmailController = TextEditingController();
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.selectedLanguage == 'sw' ? 'Sahau Neno la Siri' : 'Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => appState.setRoute('login'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_reset_rounded, size: 70, color: AppTheme.amberGold),
            const SizedBox(height: 16),
            Text(
              appState.selectedLanguage == 'sw'
                  ? 'Rejesha Neno la Siri'
                  : 'Reset Password',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              appState.selectedLanguage == 'sw'
                  ? 'Weka namba yako ya simu au barua pepe uliyosajili ili kupokea msimbo wa uthibitisho.'
                  : 'Enter your registered phone number or email to receive a verification code.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            if (!_isSubmitted) ...[
              TextField(
                controller: _phoneOrEmailController,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: appState.selectedLanguage == 'sw' ? 'Namba ya Simu / Barua Pepe' : 'Phone / Email',
                  prefixIcon: const Icon(Icons.contact_phone_rounded, color: AppTheme.primaryGreen),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_phoneOrEmailController.text.isEmpty) return;
                    try {
                      final otp = await appState.requestPasswordReset(_phoneOrEmailController.text.trim());
                      if (!mounted) return;
                      setState(() => _isSubmitted = true);
                      if (otp != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP: $otp')));
                      }
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: Text(
                    appState.selectedLanguage == 'sw' ? 'TUMA MSIMBO' : 'SEND CODE',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        appState.selectedLanguage == 'sw'
                            ? 'Msimbo wa uthibitisho umetumwa kwa: ${_phoneOrEmailController.text}'
                            : 'Verification code sent to: ${_phoneOrEmailController.text}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    appState.setRoute('otp');
                  },
                  child: Text(
                    appState.selectedLanguage == 'sw' ? 'WEKA MSIMBO WA OTP' : 'ENTER OTP CODE',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
