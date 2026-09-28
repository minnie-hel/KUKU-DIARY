import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: appState.completeOnboarding,
                child: Text(
                  isSw ? 'Ruka' : 'Skip',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF4B5563)),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * 0.42,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/images/onboarding_farmer.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      isSw ? 'USIMAMIZI WA KUKU' : 'POULTRY MANAGEMENT',
                      style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(text: isSw ? 'Boresha Ufugaji wa ' : 'Manage Your '),
                          TextSpan(
                            text: isSw ? 'Kuku Wako' : 'Poultry Better',
                            style: const TextStyle(color: AppTheme.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isSw
                          ? 'Fuatilia kuku wako, rekodi mayai, chakula, chanjo na shughuli za shamba kutoka simu yako.'
                          : 'Track your chickens, production, feeding, vaccination and farm activities from your phone.',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: appState.completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isSw ? 'ANZA KUTUMIA' : 'GET STARTED',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
