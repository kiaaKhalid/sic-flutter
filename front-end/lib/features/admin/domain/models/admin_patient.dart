import 'package:flutter/material.dart';

/// Modèle Patient pour l'interface Administrateur
///
/// Représente un patient dans le système SAC-MP avec toutes les informations
/// nécessaires pour la gestion administrative
class AdminPatient {
  final String id;
  final String fullName;
  final String medicalRecordId; // Format: MR-YYYY-XXX
  final DateTime dateOfBirth;
  final String gender; // M, F, Autre
  final String email;
  final String phone;
  final String address;
  final bool isActive;
  final DateTime createdAt;
  final List<String>
      monitoredParameters; // RYTHME, SOMMEIL, HUMEUR, CORRELATION
  final List<String> assignedCaregivers; // IDs des soignants assignés

  AdminPatient({
    required this.id,
    required this.fullName,
    required this.medicalRecordId,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.phone,
    required this.address,
    this.isActive = true,
    required this.createdAt,
    this.monitoredParameters = const [],
    this.assignedCaregivers = const [],
  });

  int get age {
    final now = DateTime.now();
    int calculatedAge = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  String get statusText => isActive ? 'Actif' : 'Archivé';

  Color get statusColor => isActive ? Colors.green : Colors.grey;

  /// Données de démonstration
  static List<AdminPatient> get demoPatients => [
        AdminPatient(
          id: '1',
          fullName: 'Marie Dubois',
          medicalRecordId: 'MR-2025-001',
          dateOfBirth: DateTime(1985, 6, 15),
          gender: 'F',
          email: 'marie.dubois@email.com',
          phone: '+33 6 12 34 56 78',
          address: '12 Rue de la Paix, 75001 Paris',
          isActive: true,
          createdAt: DateTime(2025, 1, 15),
          monitoredParameters: ['RYTHME', 'SOMMEIL', 'HUMEUR'],
          assignedCaregivers: ['caregiver_1', 'caregiver_2'],
        ),
        AdminPatient(
          id: '2',
          fullName: 'Jean Martin',
          medicalRecordId: 'MR-2025-002',
          dateOfBirth: DateTime(1978, 3, 22),
          gender: 'M',
          email: 'jean.martin@email.com',
          phone: '+33 6 23 45 67 89',
          address: '45 Avenue des Champs, 75008 Paris',
          isActive: true,
          createdAt: DateTime(2025, 2, 1),
          monitoredParameters: ['RYTHME', 'HUMEUR', 'CORRELATION'],
          assignedCaregivers: ['caregiver_1'],
        ),
        AdminPatient(
          id: '3',
          fullName: 'Sophie Bernard',
          medicalRecordId: 'MR-2025-003',
          dateOfBirth: DateTime(1990, 11, 8),
          gender: 'F',
          email: 'sophie.bernard@email.com',
          phone: '+33 6 34 56 78 90',
          address: '78 Boulevard Saint-Germain, 75006 Paris',
          isActive: false,
          createdAt: DateTime(2024, 12, 10),
          monitoredParameters: ['SOMMEIL', 'HUMEUR'],
          assignedCaregivers: ['caregiver_3'],
        ),
        AdminPatient(
          id: '4',
          fullName: 'Pierre Leroy',
          medicalRecordId: 'MR-2025-004',
          dateOfBirth: DateTime(1982, 7, 30),
          gender: 'M',
          email: 'pierre.leroy@email.com',
          phone: '+33 6 45 67 89 01',
          address: '23 Rue de Rivoli, 75004 Paris',
          isActive: true,
          createdAt: DateTime(2025, 3, 5),
          monitoredParameters: ['RYTHME', 'SOMMEIL', 'HUMEUR', 'CORRELATION'],
          assignedCaregivers: ['caregiver_1', 'caregiver_2', 'caregiver_3'],
        ),
      ];

  AdminPatient copyWith({
    String? id,
    String? fullName,
    String? medicalRecordId,
    DateTime? dateOfBirth,
    String? gender,
    String? email,
    String? phone,
    String? address,
    bool? isActive,
    DateTime? createdAt,
    List<String>? monitoredParameters,
    List<String>? assignedCaregivers,
  }) {
    return AdminPatient(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      medicalRecordId: medicalRecordId ?? this.medicalRecordId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      monitoredParameters: monitoredParameters ?? this.monitoredParameters,
      assignedCaregivers: assignedCaregivers ?? this.assignedCaregivers,
    );
  }
}
