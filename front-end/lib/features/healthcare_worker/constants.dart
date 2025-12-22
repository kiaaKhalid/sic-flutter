/// Constantes pour la feature Healthcare Worker
/// 
/// Centralise toutes les valeurs constantes utilisées dans cette feature
/// pour faciliter la maintenance et la cohérence du design.

library healthcare_constants;

// ==================== Routes ====================

/// Routes nommées pour la navigation
class HealthcareRoutes {
  static const String dashboard = '/healthcare-dashboard';
  static const String patientDetail = '/patient-detail';
  static const String login = '/healthcare-login';
}

// ==================== Design System ====================

/// Couleurs du thème Healthcare
class HealthcareColors {
  // Couleurs principales
  static const int backgroundDark = 0xFF0C0C0C;
  static const int cardDark = 0xFF1E1E1E;
  static const int accentNeon = 0xFFD7F759;
  
  // Gradient de suppression
  static const int deleteStart = 0xFFFF7979;
  static const int deleteEnd = 0xFFFF6B6B;
  static const int deletePressed = 0xFFFF4757;
  
  // Statuts patients
  static const int statusCritical = 0xFFFF5252;
  static const int statusToMonitor = 0xFFFFA726;
  static const int statusStable = 0xFF66BB6A;
  
  // Alertes
  static const int alertHigh = 0xFFFF5252;
  static const int alertMedium = 0xFFFFA726;
  static const int alertLow = 0xFF42A5F5;
}

/// Dimensions et espacements
class HealthcareSpacing {
  // Breakpoints responsive
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;
  
  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 12.0;
  static const double paddingLarge = 16.0;
  
  // Tailles d'icônes
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 28.0;
  
  // Tailles de boutons
  static const double buttonCompact = 32.0;
  static const double buttonNormal = 40.0;
  static const double buttonLarge = 48.0;
}

/// Durées d'animations
class HealthcareAnimations {
  static const int durationFast = 100; // ms
  static const int durationNormal = 150; // ms
  static const int durationSlow = 200; // ms
  static const int durationLoading = 500; // ms
}

// ==================== Validation ====================

/// Expressions régulières pour validation
class HealthcareValidation {
  /// Format ID Dossier Médical: MR-YYYY-NNN
  /// Exemple: MR-2023-001
  static final RegExp medicalRecordId = RegExp(r'^MR-\d{4}-\d{3}$');
  
  /// Format Email standard
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  /// Format Téléphone (flexible pour différents formats)
  static final RegExp phone = RegExp(r'^\+?[\d\s\-\(\)]{8,}$');
}

// ==================== Messages ====================

/// Messages utilisateur
class HealthcareMessages {
  // Succès
  static const String patientAdded = 'Patient ajouté avec succès';
  static const String patientDeleted = 'Patient supprimé avec succès';
  static const String patientUpdated = 'Patient mis à jour avec succès';
  static const String alertAcknowledged = 'Alerte reconnue';
  
  // Erreurs
  static const String requiredField = 'Ce champ est requis';
  static const String invalidMedicalRecordId = 'Format: MR-AAAA-NNN';
  static const String invalidEmail = 'Email invalide';
  static const String invalidPhone = 'Numéro de téléphone invalide';
  static const String selectBirthDate = 'Sélectionnez la date de naissance';
  static const String selectCaregiver = 'Sélectionnez au moins un soignant';
  
  // Confirmations
  static const String confirmDelete = 'Êtes-vous sûr de vouloir supprimer ce patient ?\nCette action est irréversible.';
  static const String confirmDeleteTitle = 'Confirmer la suppression';
  
  // Actions
  static const String cancel = 'Annuler';
  static const String delete = 'Supprimer';
  static const String create = 'Créer';
  static const String save = 'Enregistrer';
  static const String update = 'Mettre à jour';
}

// ==================== Demo Data ====================

/// Liste des soignants pour les démos
class HealthcareDemoData {
  static const List<String> caregivers = [
    'Dr. Martin (Cardio)',
    'Infirmière Dupuis',
    'Dr. Leroy (Sommeil)',
    'Soignant A. Bernard',
  ];
}
