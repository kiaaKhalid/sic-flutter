import 'package:flutter/material.dart';

enum HealthStatus { good, warning, critical }

class HealthMetric {
  final String title;
  final String value;
  final String unit;
  final HealthStatus status;
  final IconData icon;
  final Color color;

  HealthMetric({
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.icon,
    required this.color,
  });
}
