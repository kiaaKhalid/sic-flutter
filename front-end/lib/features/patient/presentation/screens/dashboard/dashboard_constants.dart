import 'package:flutter/material.dart';

class DashboardConstants {
  // Tailles et espacements
  static const double mobileCardHeight = 140.0;
  static const double desktopCardHeight = 160.0;
  static const double cardPadding = 16.0;
  static const double sectionSpacing = 20.0;
  
  // Textes
  static const String healthMetricsTitle = 'Métriques de santé';
  static const String viewDetailsText = 'Voir détails';
  static const String recentAlertsTitle = 'Alertes récentes';
  static const String dashboardTitle = 'Tableau de bord';
  
  // Valeurs par défaut
  static const String defaultPatientName = 'Jean Dupont';
  
  // Paddings
  static EdgeInsets getSectionPadding(bool isMobile) => EdgeInsets.symmetric(
    horizontal: isMobile ? 4.0 : 8.0,
  );
  
  static EdgeInsets getScreenPadding(bool isMobile) => EdgeInsets.symmetric(
    horizontal: isMobile ? 16.0 : 24.0,
    vertical: isMobile ? 8.0 : 16.0,
  );
}
