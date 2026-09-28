import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/tipa_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  Future<void> _handleRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maneno ya siri hayafanani.')),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty || _passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jaza jina, namba ya simu na neno la siri (angalau herufi 6).')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await Provider.of<AppState>(context, listen: false).register(
        farmerName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
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
              const TipaLogo(size: 88, showTitle: true),
              const SizedBox(height: 14),
              const Text(
                'Jiunge na Kuku Diary',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Anza kusimamia kuku na mayai yako kwa urahisi leo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 28),

              // Fields in Swahili with Big Typography
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jina Kamili
                  _buildFieldLabel('Jina Lako Kamili'),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: _buildInputDecoration('Mf. Juma Hamisi', Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 16),

                  // Namba ya Simu
                  _buildFieldLabel('Namba ya Simu'),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: _buildInputDecoration('0712 345 678', Icons.phone_outlined),
                  ),
                  const SizedBox(height: 16),

                  // Barua Pepe (Email)
                  _buildFieldLabel('Barua Pepe (Kama Unayo)'),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: _buildInputDecoration('juma@mfano.com', Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),

                  // Neno la Siri
                  _buildFieldLabel('Neno la Siri (Password)'),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: _buildInputDecoration(
                      'Weka neno la siri thabiti',
                      Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: const Color(0xFF6B7280),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rudia Neno la Siri
                  _buildFieldLabel('Rudia Neno la Siri'),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: _buildInputDecoration(
                      'Rudia neno la siri',
                      Icons.shield_outlined,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: const Color(0xFF6B7280),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Terms Disclaimer
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.check_circle_outline_rounded, size: 20, color: AppTheme.primaryGreen),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Kwa kubonyeza Jiandikishe, unakubali masharti ya usalama na uhifadhi wa taarifa za kuku wako.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4B5563),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),

              // TENGENEZA AKAUNTI Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSubmitting ? 'INASUBIRI...' : 'TENGENEZA AKAUNTI',
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData prefixIcon, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(prefixIcon, color: AppTheme.primaryGreen, size: 22),
      suffixIcon: suffixIcon,
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
    );
  }
}
