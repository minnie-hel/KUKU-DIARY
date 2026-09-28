import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_state.dart';

import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/setup/farm_setup_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const KukuDiaryApp(),
    ),
  );
}

class KukuDiaryApp extends StatelessWidget {
  const KukuDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      title: 'KUKU DIARY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _buildScreen(appState.currentRoute),
    );
  }

  Widget _buildScreen(String route) {
    switch (route) {
      case 'splash':
        return const SplashScreen();
      case 'onboarding':
        return const OnboardingScreen();
      case 'login':
        return const LoginScreen();
      case 'register':
        return const RegisterScreen();
      case 'forgot_password':
        return const ForgotPasswordScreen();
      case 'otp':
        return const OtpScreen();
      case 'farm_setup':
        return const FarmSetupScreen();
      case 'main_shell':
        return const MainNavigationShell();
      default:
        return const SplashScreen();
    }
  }
}
