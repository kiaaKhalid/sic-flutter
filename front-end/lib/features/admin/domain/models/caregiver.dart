import 'package:flutter/material.dart';

/// Modèle Soignant pour l'interface Administrateur
///
/// Représente un professionnel de santé dans le système SAC-MP
class Caregiver {
  final String id;
  final String fullName;
  final String matricule; // Identifiant unique professionnel
  final String email;
  final String clinicalRole; // Médecin, Infirmier, Psychologue, etc.
  final bool isActive;
  final bool has2FA; // Authentification à deux facteurs activée
  final DateTime createdAt;
  final int assignedPatientsCount;

  Caregiver({
    required this.id,
    required this.fullName,
    required this.matricule,
    required this.email,
    required this.clinicalRole,
    this.isActive = true,
    this.has2FA = false,
    required this.createdAt,
    this.assignedPatientsCount = 0,
  });

  String get statusText => isActive ? 'Actif' : 'Désactivé';

  Color get statusColor => isActive ? Colors.green : Colors.red;

  IconData get roleIcon {
    switch (clinicalRole.toLowerCase()) {
      case 'médecin':
      case 'docteur':
        return Icons.medical_services;
      case 'infirmier':
      case 'infirmière':
        return Icons.local_hospital;
      case 'psychologue':
        return Icons.psychology;
      default:
        return Icons.person;
    }
  }

  /// Données de démonstration
  static List<Caregiver> get demoCaregivers => [
        Caregiver(
          id: 'caregiver_1',
          fullName: 'Dr. Martin Durand',
          matricule: 'MED-2023-001',
          email: 'martin.durand@sacmp.fr',
          clinicalRole: 'Médecin',
          isActive: true,
          has2FA: true,
          createdAt: DateTime(2023, 6, 1),
          assignedPatientsCount: 15,
        ),
        Caregiver(
          id: 'caregiver_2',
          fullName: 'Infirmière Claire Dupuis',
          matricule: 'INF-2023-005',
          email: 'claire.dupuis@sacmp.fr',
          clinicalRole: 'Infirmier',
          isActive: true,
          has2FA: true,
          createdAt: DateTime(2023, 8, 15),
          assignedPatientsCount: 22,
        ),
        Caregiver(
          id: 'caregiver_3',
          fullName: 'Dr. Sophie Leroy',
          matricule: 'PSY-2024-003',
          email: 'sophie.leroy@sacmp.fr',
          clinicalRole: 'Psychologue',
          isActive: true,
          has2FA: false,
          createdAt: DateTime(2024, 1, 10),
          assignedPatientsCount: 8,
        ),
        Caregiver(
          id: 'caregiver_4',
          fullName: 'Soignant Antoine Bernard',
          matricule: 'SOI-2024-012',
          email: 'antoine.bernard@sacmp.fr',
          clinicalRole: 'Soignant',
          isActive: false,
          has2FA: false,
          createdAt: DateTime(2024, 3, 5),
          assignedPatientsCount: 0,
        ),
      ];

  Caregiver copyWith({
    String? id,
    String? fullName,
    String? matricule,
    String? email,
    String? clinicalRole,
    bool? isActive,
    bool? has2FA,
    DateTime? createdAt,
    int? assignedPatientsCount,
  }) {
    return Caregiver(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      matricule: matricule ?? this.matricule,
      email: email ?? this.email,
      clinicalRole: clinicalRole ?? this.clinicalRole,
      isActive: isActive ?? this.isActive,
      has2FA: has2FA ?? this.has2FA,
      createdAt: createdAt ?? this.createdAt,
      assignedPatientsCount:
          assignedPatientsCount ?? this.assignedPatientsCount,
    );
  }
}
