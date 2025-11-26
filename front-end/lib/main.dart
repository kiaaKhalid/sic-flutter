import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_auth_ui/app/router/app_router.dart';
import 'package:travel_auth_ui/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    final exception = details.exceptionAsString();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Text(
          'Erreur:\n$exception',
          style: const TextStyle(color: Colors.red, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  };
  // Configuration du port web par défaut
  // Pour forcer un port spécifique au démarrage, utilisez l'option --web-port=XXXX
  // Exemple: flutter run -d chrome --web-port=5000
  runApp(const TravelAuthApp());
}

class TravelAuthApp extends StatelessWidget {
  const TravelAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAC-MP - Administrateur Système',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      builder: (context, child) {
        // Assure une police cohérente dans toute l'application sans masquer les Dialog routes
        return DefaultTextStyle.merge(
          style: GoogleFonts.poppins(),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AdminDashboardScreen(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
