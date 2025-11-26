import 'package:flutter/material.dart';

/// Énumération des types d'actions de sécurité
enum SecurityAction {
  login,
  logout,
  accountCreated,
  accountDeleted,
  passwordChanged,
  alertAcknowledged,
  alertRuleCreated,
  alertRuleModified,
  alertRuleDeleted,
  patientCreated,
  patientModified,
  patientDeleted,
  caregiverCreated,
  caregiverModified,
  twoFactorEnabled,
  twoFactorDisabled,
  dataExported,
}

/// Extension pour obtenir les informations d'affichage des actions
extension SecurityActionExtension on SecurityAction {
  String get displayName {
    switch (this) {
      case SecurityAction.login:
        return 'Connexion';
      case SecurityAction.logout:
        return 'Déconnexion';
      case SecurityAction.accountCreated:
        return 'Compte créé';
      case SecurityAction.accountDeleted:
        return 'Compte supprimé';
      case SecurityAction.passwordChanged:
        return 'Mot de passe modifié';
      case SecurityAction.alertAcknowledged:
        return 'Alerte acquittée';
      case SecurityAction.alertRuleCreated:
        return 'Règle d\'alerte créée';
      case SecurityAction.alertRuleModified:
        return 'Règle d\'alerte modifiée';
      case SecurityAction.alertRuleDeleted:
        return 'Règle d\'alerte supprimée';
      case SecurityAction.patientCreated:
        return 'Patient créé';
      case SecurityAction.patientModified:
        return 'Patient modifié';
      case SecurityAction.patientDeleted:
        return 'Patient supprimé';
      case SecurityAction.caregiverCreated:
        return 'Soignant créé';
      case SecurityAction.caregiverModified:
        return 'Soignant modifié';
      case SecurityAction.twoFactorEnabled:
        return '2FA activé';
      case SecurityAction.twoFactorDisabled:
        return '2FA désactivé';
      case SecurityAction.dataExported:
        return 'Données exportées';
    }
  }

  IconData get icon {
    switch (this) {
      case SecurityAction.login:
        return Icons.login;
      case SecurityAction.logout:
        return Icons.logout;
      case SecurityAction.accountCreated:
        return Icons.person_add;
      case SecurityAction.accountDeleted:
        return Icons.person_remove;
      case SecurityAction.passwordChanged:
        return Icons.lock_reset;
      case SecurityAction.alertAcknowledged:
        return Icons.check_circle;
      case SecurityAction.alertRuleCreated:
      case SecurityAction.alertRuleModified:
      case SecurityAction.alertRuleDeleted:
        return Icons.rule;
      case SecurityAction.patientCreated:
      case SecurityAction.patientModified:
      case SecurityAction.patientDeleted:
        return Icons.local_hospital;
      case SecurityAction.caregiverCreated:
      case SecurityAction.caregiverModified:
        return Icons.medical_services;
      case SecurityAction.twoFactorEnabled:
      case SecurityAction.twoFactorDisabled:
        return Icons.security;
      case SecurityAction.dataExported:
        return Icons.download;
    }
  }

  Color get color {
    switch (this) {
      case SecurityAction.login:
      case SecurityAction.accountCreated:
      case SecurityAction.alertRuleCreated:
      case SecurityAction.patientCreated:
      case SecurityAction.caregiverCreated:
      case SecurityAction.twoFactorEnabled:
        return Colors.green;
      case SecurityAction.logout:
        return Colors.blue;
      case SecurityAction.accountDeleted:
      case SecurityAction.patientDeleted:
      case SecurityAction.alertRuleDeleted:
      case SecurityAction.twoFactorDisabled:
        return Colors.red;
      case SecurityAction.passwordChanged:
      case SecurityAction.alertAcknowledged:
      case SecurityAction.alertRuleModified:
      case SecurityAction.patientModified:
      case SecurityAction.caregiverModified:
      case SecurityAction.dataExported:
        return Colors.orange;
    }
  }
}

/// Modèle Log de Sécurité
///
/// Trace toutes les actions importantes du système pour audit et sécurité
class SecurityLog {
  final String id;
  final DateTime timestamp;
  final SecurityAction action;
  final String userId;
  final String userName;
  final String userRole; // Admin, Soignant, Patient
  final String? targetId; // ID de l'entité affectée (patient, règle, etc.)
  final String? targetName; // Nom de l'entité affectée
  final String? ipAddress;
  final String? details; // Détails supplémentaires

  SecurityLog({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.targetId,
    this.targetName,
    this.ipAddress,
    this.details,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }

  /// Données de démonstration
  static List<SecurityLog> get demoLogs => [
        SecurityLog(
          id: 'log_1',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          action: SecurityAction.login,
          userId: 'admin_1',
          userName: 'Admin Principal',
          userRole: 'Administrateur',
          ipAddress: '192.168.1.100',
        ),
        SecurityLog(
          id: 'log_2',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          action: SecurityAction.patientCreated,
          userId: 'admin_1',
          userName: 'Admin Principal',
          userRole: 'Administrateur',
          targetId: 'patient_5',
          targetName: 'Pierre Leroy',
          ipAddress: '192.168.1.100',
          details: 'Patient créé avec 4 paramètres surveillés',
        ),
        SecurityLog(
          id: 'log_3',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          action: SecurityAction.alertRuleModified,
          userId: 'admin_1',
          userName: 'Admin Principal',
          userRole: 'Administrateur',
          targetId: 'rule_1',
          targetName: 'Tachycardie sévère',
          ipAddress: '192.168.1.100',
          details: 'Seuil modifié: BPM > 130',
        ),
        SecurityLog(
          id: 'log_4',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          action: SecurityAction.alertAcknowledged,
          userId: 'caregiver_1',
          userName: 'Dr. Martin Durand',
          userRole: 'Soignant',
          targetId: 'alert_123',
          targetName: 'Alerte rythme cardiaque',
          ipAddress: '192.168.1.50',
        ),
        SecurityLog(
          id: 'log_5',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          action: SecurityAction.caregiverCreated,
          userId: 'admin_1',
          userName: 'Admin Principal',
          userRole: 'Administrateur',
          targetId: 'caregiver_5',
          targetName: 'Dr. Thomas Petit',
          ipAddress: '192.168.1.100',
          details: 'Soignant créé avec 2FA activé',
        ),
        SecurityLog(
          id: 'log_6',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
          action: SecurityAction.twoFactorEnabled,
          userId: 'caregiver_3',
          userName: 'Dr. Sophie Leroy',
          userRole: 'Soignant',
          ipAddress: '192.168.1.75',
          details: 'Authentification à deux facteurs activée',
        ),
        SecurityLog(
          id: 'log_7',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          action: SecurityAction.passwordChanged,
          userId: 'patient_10',
          userName: 'Marie Dubois',
          userRole: 'Patient',
          ipAddress: '81.52.143.20',
        ),
        SecurityLog(
          id: 'log_8',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          action: SecurityAction.dataExported,
          userId: 'patient_15',
          userName: 'Jean Martin',
          userRole: 'Patient',
          ipAddress: '90.63.201.45',
          details: 'Export RGPD: toutes les données personnelles',
        ),
      ];
}
