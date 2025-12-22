import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/patient/domain/models/health_metric.dart';
import 'package:travel_auth_ui/features/patient/domain/models/alert.dart';
import 'package:travel_auth_ui/features/patient/presentation/widgets/modern_nav_bar.dart';
import 'package:travel_auth_ui/features/patient/presentation/widgets/health_metric_card.dart';
import 'package:travel_auth_ui/features/patient/presentation/screens/health/mood_declaration_screen.dart';
import 'package:travel_auth_ui/features/teleconsultation/presentation/widgets/communication_choice_dialog.dart';
import 'package:travel_auth_ui/app/router/app_router.dart';

// Widgets
import 'widgets/profile_header.dart';
import 'widgets/health_metrics_section.dart';
import 'widgets/health_metrics_section.dart';
import 'widgets/recent_alerts_section.dart';
import 'widgets/patient_settings_section.dart';

// Constantes
import 'dashboard_constants.dart';

class PatientDashboardScreen extends StatefulWidget {
  static const String routeName = AppRouter.patientDashboard;
  
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  int _currentIndex = 0;
  // Utilisation d'un avatar par défaut au lieu d'une image
  final String patientName = "Jean Dupont";
  
  void _onItemTapped(int index) {
    if (index == 2) { // Si on clique sur l'onglet Humeur
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MoodDeclarationScreen(),
        ),
      );
    } else if (index == 3) { // Si on clique sur l'onglet Paramètres
      setState(() {
        _currentIndex = 3; // Mettre à jour l'index pour afficher les paramètres
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
  
  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0: // Accueil
        return _buildDashboardContent();
      case 1: // Santé
        return _buildHealthScreen();
      case 2: // Humeur (géré par _onItemTapped)
        return _buildDashboardContent(); // Retourne l'accueil par défaut
      case 3: // Paramètres
        return _buildSettingsScreen();
      default:
        return _buildDashboardContent();
    }
  }
  
  Widget _buildHealthScreen() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16.0 : 24.0, 
            vertical: 16.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec bouton Voir détails
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tableau de santé',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.sleepHeartRateDetail);
                    },
                    child: Text(
                      'Voir détails',
                      style: TextStyle(
                        color: AppTheme.neon,
                        fontSize: isMobile ? 14 : 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Contenu de la page Santé
              ...healthMetrics.map((metric) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: HealthMetricCard(
                  metric: metric,
                  isSmall: isMobile,
                ),
              )),
            ],
          ),
        );
      },
    );
  }
  
  final List<HealthMetric> healthMetrics = [
    HealthMetric(
      title: 'Rythme cardiaque',
      value: '72',
      unit: 'BPM',
      status: HealthStatus.good,
      icon: Icons.favorite,
      color: Colors.red,
    ),
    HealthMetric(
      title: 'Sommeil',
      value: '7.5',
      unit: 'heures',
      status: HealthStatus.warning,
      icon: Icons.nightlight_round,
      color: Colors.blue,
    ),
    HealthMetric(
      title: 'Humeur',
      value: 'Calme',
      unit: 'Stable',
      status: HealthStatus.good,
      icon: Icons.mood,
      color: Colors.green,
    ),
  ];

  final List<Alert> recentAlerts = [
    Alert(
      id: '1',
      title: 'Rythme cardiaque élevé',
      message: 'Votre rythme cardiaque a dépassé 100 BPM pendant 10 minutes',
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      priority: AlertPriority.high,
    ),
    Alert(
      id: '2',
      title: 'Rappel de médicament',
      message: 'Il est temps de prendre votre traitement',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      priority: AlertPriority.medium,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024; // Définit le seuil pour le mode desktop
    final isTablet = width >= 600 && width < 1024; // Définit le seuil pour le mode tablette
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: (isMobile || isTablet)
          ? AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'Tableau de bord',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            )
          : null,
      drawer: (isMobile || isTablet)
          ? Drawer(
              backgroundColor: AppTheme.bg,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppTheme.neon,
                          child: Icon(Icons.person, size: 40, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          patientName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDrawerItem(0, Icons.home, 'Accueil'),
                  _buildDrawerItem(1, Icons.favorite, 'Santé'),
                  _buildDrawerItem(2, Icons.mood, 'Humeur'),
                  _buildDrawerItem(3, Icons.settings, 'Paramètres'),
                ],
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Barre de navigation en haut uniquement pour le mode desktop
            if (isDesktop)
              ModernNavBar(
                currentIndex: _currentIndex,
                onItemTapped: _onItemTapped,
                patientName: patientName,
              ),
            
            // Contenu principal avec défilement
            Expanded(
              child: _buildCurrentScreen(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CommunicationChoiceDialog(),
          );
        },
        backgroundColor: AppTheme.neon,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.videocam),
        label: const Text('Parler à mon docteur'),
      ),
    );
  }
  

  Widget _buildDashboardContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        
        return SingleChildScrollView(
          padding: DashboardConstants.getScreenPadding(isMobile),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - (isMobile ? 100 : 0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du profil
                if (!isMobile) 
                  ProfileHeader(patientName: patientName, isMobile: isMobile),
                if (isMobile) 
                  ProfileHeader(patientName: patientName, isMobile: isMobile),
                
                const SizedBox(height: 16),
                
                // Section des métriques de santé
                HealthMetricsSection(
                  healthMetrics: healthMetrics,
                  isMobile: isMobile,
                  onViewDetails: () {
                    Navigator.pushNamed(context, AppRouter.sleepHeartRate);
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Section des alertes récentes
                if (recentAlerts.isNotEmpty)
                  RecentAlertsSection(
                    alerts: recentAlerts,
                    isMobile: isMobile,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSettingsScreen() {
    return const PatientSettingsSection();
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: _currentIndex == index ? AppTheme.neon : Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: _currentIndex == index ? AppTheme.neon : Colors.white,
          fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Ferme le drawer
        _onItemTapped(index);
      },
    );
  }
}
