import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/login_screen.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/register_screen.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:travel_auth_ui/features/patient/presentation/screens/dashboard/patient_dashboard_screen.dart';
import 'package:travel_auth_ui/features/patient/presentation/screens/health/sleep_heart_rate_screen.dart';
import 'package:travel_auth_ui/features/patient/presentation/screens/health/mood_declaration_screen.dart';
import 'package:travel_auth_ui/features/patient/presentation/screens/health/sleep_heart_rate_detail_screen.dart';
import 'package:travel_auth_ui/features/healthcare_worker/presentation/screens/dashboard/healthcare_dashboard_screen.dart';
import 'package:travel_auth_ui/features/healthcare_worker/presentation/screens/auth/healthcare_login_screen.dart';


class AppRouter {
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String healthcareLogin = '/healthcare-login';
  static const String patientDashboard = '/patient-dashboard';
  static const String sleepHeartRate = '/sleep-heart-rate';
  static const String moodDeclaration = '/mood-declaration';
  static const String sleepHeartRateDetail = '/sleep-heart-rate-detail';
  static const String healthcareDashboard = '/healthcare-dashboard';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case healthcareLogin:
        return MaterialPageRoute(builder: (_) => const HealthcareLoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case patientDashboard:
        return MaterialPageRoute(builder: (_) => const PatientDashboardScreen());
      case sleepHeartRate:
        return MaterialPageRoute(builder: (_) => const SleepHeartRateScreen());
      case moodDeclaration:
        return MaterialPageRoute(builder: (_) => const MoodDeclarationScreen());
      case sleepHeartRateDetail:
        return MaterialPageRoute(builder: (_) => const SleepHeartRateDetailScreen());
      case healthcareDashboard:
        return MaterialPageRoute(builder: (_) => const HealthcareDashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
