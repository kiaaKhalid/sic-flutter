import 'package:flutter/material.dart';

enum AlertType { heartRate, mood, sleep, correlation }
enum AlertPriority { critical, high, medium, low }

class Alert {
  final String id;
  final AlertType type;
  final AlertPriority priority;
  final String patientId;
  final String patientName;
  final String message;
  final DateTime timestamp;
  final bool isAcknowledged;
  final String? acknowledgedBy;
  final DateTime? acknowledgedAt;
  final String? note;
  final Map<String, dynamic>? metadata;

  const Alert({
    required this.id,
    required this.type,
    required this.priority,
    required this.patientId,
    required this.patientName,
    required this.message,
    required this.timestamp,
    this.isAcknowledged = false,
    this.acknowledgedBy,
    this.acknowledgedAt,
    this.note,
    this.metadata,
  });

  Alert copyWith({
    String? id,
    AlertType? type,
    AlertPriority? priority,
    String? patientId,
    String? patientName,
    String? message,
    DateTime? timestamp,
    bool? isAcknowledged,
    String? acknowledgedBy,
    DateTime? acknowledgedAt,
    String? note,
    Map<String, dynamic>? metadata,
  }) {
    return Alert(
      id: id ?? this.id,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      acknowledgedBy: acknowledgedBy ?? this.acknowledgedBy,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      note: note ?? this.note,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper to get type icon
  IconData get typeIcon {
    switch (type) {
      case AlertType.heartRate:
        return Icons.favorite;
      case AlertType.mood:
        return Icons.mood;
      case AlertType.sleep:
        return Icons.nightlight_round;
      case AlertType.correlation:
        return Icons.insights;
    }
  }

  // Helper to get priority color
  Color get priorityColor {
    switch (priority) {
      case AlertPriority.critical:
        return Colors.red;
      case AlertPriority.high:
        return Colors.orange;
      case AlertPriority.medium:
        return Colors.yellow[700]!;
      case AlertPriority.low:
        return Colors.blue;
    }
  }

  // Helper to get priority text
  String get priorityText {
    switch (priority) {
      case AlertPriority.critical:
        return 'Critique';
      case AlertPriority.high:
        return 'Haute';
      case AlertPriority.medium:
        return 'Moyenne';
      case AlertPriority.low:
        return 'Basse';
    }
  }

  // For demo purposes
  static List<Alert> demoAlerts = [
    Alert(
      id: '1',
      type: AlertType.heartRate,
      priority: AlertPriority.critical,
      patientId: '1',
      patientName: 'Jean Dupont',
      message: 'Rythme cardiaque élevé détecté',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      metadata: {'bpm': 125, 'threshold': 100},
    ),
    Alert(
      id: '2',
      type: AlertType.mood,
      priority: AlertPriority.medium,
      patientId: '2',
      patientName: 'Marie Martin',
      message: 'Humeur détectée: Anxieux',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      metadata: {'mood': 'anxious', 'duration': '2h'},
    ),
    Alert(
      id: '3',
      type: AlertType.sleep,
      priority: AlertPriority.low,
      patientId: '3',
      patientName: 'Pierre Durand',
      message: 'Temps de sommeil insuffisant',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      metadata: {'duration': '4h 30m', 'recommended': '7h'},
    ),
  ];
}
