import 'package:flutter/material.dart';

enum AlertPriority { low, medium, high }

class Alert {
  final String id;
  final String title;
  final String message;
  final DateTime dateTime;
  final AlertPriority priority;
  final bool read;

  Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.dateTime,
    this.priority = AlertPriority.medium,
    this.read = false,
  });

  String get formattedDate => '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

  Alert copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? dateTime,
    AlertPriority? priority,
    bool? read,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      read: read ?? this.read,
    );
  }
}

extension AlertPriorityExtension on AlertPriority {
  Color get color {
    switch (this) {
      case AlertPriority.low:
        return Colors.blue;
      case AlertPriority.medium:
        return Colors.orange;
      case AlertPriority.high:
        return Colors.red;
    }
  }
  
  String get label {
    switch (this) {
      case AlertPriority.low:
        return 'Basse';
      case AlertPriority.medium:
        return 'Moyenne';
      case AlertPriority.high:
        return 'Haute';
    }
  }
}
