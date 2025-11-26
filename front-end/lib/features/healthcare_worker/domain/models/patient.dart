import 'package:flutter/material.dart';

enum PatientStatus { critical, toMonitor, stable }

class Patient {
  final String id;
  final String name;
  final String medicalRecordId;
  final PatientStatus status;
  final DateTime lastUpdate;
  final int alertCount;
  final String? profileImage;
  final String? roomNumber;

  const Patient({
    required this.id,
    required this.name,
    required this.medicalRecordId,
    required this.status,
    required this.lastUpdate,
    this.alertCount = 0,
    this.profileImage,
    this.roomNumber,
  });

  // Helper to get status color
  Color get statusColor {
    switch (status) {
      case PatientStatus.critical:
        return Colors.red;
      case PatientStatus.toMonitor:
        return Colors.orange;
      case PatientStatus.stable:
        return Colors.green;
    }
  }

  // Helper to get status text
  String get statusText {
    switch (status) {
      case PatientStatus.critical:
        return 'Critique';
      case PatientStatus.toMonitor:
        return 'À surveiller';
      case PatientStatus.stable:
        return 'Stable';
    }
  }

  // For demo purposes
  static List<Patient> demoPatients = [
    Patient(
      id: '1',
      name: 'Jean Dupont',
      medicalRecordId: 'MR-2023-001',
      status: PatientStatus.critical,
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 5)),
      alertCount: 3,
      roomNumber: 'A101',
    ),
    Patient(
      id: '2',
      name: 'Marie Martin',
      medicalRecordId: 'MR-2023-045',
      status: PatientStatus.toMonitor,
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 15)),
      alertCount: 1,
      roomNumber: 'B205',
    ),
    Patient(
      id: '3',
      name: 'Pierre Durand',
      medicalRecordId: 'MR-2023-112',
      status: PatientStatus.stable,
      lastUpdate: DateTime.now().subtract(const Duration(hours: 1)),
      roomNumber: 'C302',
    ),
  ];
}
