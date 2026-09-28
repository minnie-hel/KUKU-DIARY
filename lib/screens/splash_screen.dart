import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/tipa_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isProceeding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _proceedToApp() async {
    if (_isProceeding) return;
    setState(() => _isProceeding = true);
    final appState = Provider.of<AppState>(context, listen: false);
    final route = await appState.resolvePostSplashRoute();
    if (!mounted) return;
    appState.setRoute(route);
  }

  @override
  Widget build(BuildContext context) {
    final isSw = Provider.of<AppState>(context).selectedLanguage == 'sw';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),

                    // Top Logo Card
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0xFFF3F4F6), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: TipaLogo(
                            size: 96,
                            showTitle: true,
                            tagline: isSw ? 'USIMAMIZI BORA WA KUKU NA MAYAI' : 'SMART POULTRY MANAGEMENT',
                          ),
                        ),
                      ),
                    ),

                    // Central Hero Chicken Photo + Button
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Container(
                            height: 230,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: const Color(0xFFF3F4F6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                'assets/images/splash_white_chicken.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 62,
                            child: ElevatedButton(
                              onPressed: _isProceeding ? null : _proceedToApp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.infoBlue,
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shadowColor: AppTheme.infoBlue.withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: _isProceeding
                                  ? const SizedBox(
                                      width: 26,
                                      height: 26,
                                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isSw ? 'INGIA SHAMBANI' : 'ENTER THE FARM',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.arrow_forward_rounded, size: 26),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Footer Label
                    Text(
                      'KUKU DIARY © ${DateTime.now().year} • TIPA',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
