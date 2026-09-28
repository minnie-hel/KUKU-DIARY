import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/tipa_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  Future<void> _handleLogin() async {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() => _isSubmitting = true);
    try {
      await appState.login(_emailController.text.trim(), _passwordController.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              const TipaLogo(size: 96, showTitle: true),
              const SizedBox(height: 20),
              const Text(
                'Karibu Tena Shambani!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ingia kwenye akaunti yako ya Kuku Diary',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 32),

              // Form Inputs (Large Fonts & High Contrast)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barua Pepe au Namba ya Simu
                  const Text(
                    'Barua Pepe au Namba ya Simu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Mf. 0712345678 au barua pepe',
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppTheme.primaryGreen, size: 24),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Neno la Siri (Password)
                  const Text(
                    'Neno la Siri (Password)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppTheme.primaryGreen, size: 24),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: const Color(0xFF6B7280),
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Umesahau Neno la Siri?
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        appState.setRoute('forgot_password');
                      },
                      child: const Text(
                        'Umesahau Neno la Siri?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // INGIA SHAMBANI Primary Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSubmitting ? 'INASUBIRI...' : 'INGIA SHAMBANI',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Register Account Link in Swahili
              Column(
                children: [
                  const Text(
                    'Huna akaunti bado?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      appState.setRoute('register');
                    },
                    child: const Text(
                      'Tengeneza Akaunti Mpya Hapa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryGreen,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
