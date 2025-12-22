import 'package:flutter/material.dart';

/// Énumération des types de paramètres surveillés
enum ParameterType {
  rythme,
  humeur,
  sommeil,
  correlation,
}

/// Énumération des priorités d'alerte
enum AlertPriority {
  critique,
  haute,
  moyenne,
  basse,
}

/// Extension pour obtenir le nom affichable des types de paramètres
extension ParameterTypeExtension on ParameterType {
  String get displayName {
    switch (this) {
      case ParameterType.rythme:
        return 'Rythme cardiaque';
      case ParameterType.humeur:
        return 'Humeur';
      case ParameterType.sommeil:
        return 'Sommeil';
      case ParameterType.correlation:
        return 'Corrélation';
    }
  }

  IconData get icon {
    switch (this) {
      case ParameterType.rythme:
        return Icons.favorite;
      case ParameterType.humeur:
        return Icons.mood;
      case ParameterType.sommeil:
        return Icons.nightlight_round;
      case ParameterType.correlation:
        return Icons.timeline;
    }
  }

  Color get color {
    switch (this) {
      case ParameterType.rythme:
        return Colors.red;
      case ParameterType.humeur:
        return Colors.green;
      case ParameterType.sommeil:
        return Colors.blue;
      case ParameterType.correlation:
        return Colors.purple;
    }
  }
}

/// Extension pour obtenir le nom affichable des priorités
extension AlertPriorityExtension on AlertPriority {
  String get displayName {
    switch (this) {
      case AlertPriority.critique:
        return 'Critique';
      case AlertPriority.haute:
        return 'Haute';
      case AlertPriority.moyenne:
        return 'Moyenne';
      case AlertPriority.basse:
        return 'Basse';
    }
  }

  Color get color {
    switch (this) {
      case AlertPriority.critique:
        return const Color(0xFFFF0000);
      case AlertPriority.haute:
        return const Color(0xFFFF6B00);
      case AlertPriority.moyenne:
        return const Color(0xFFFFC107);
      case AlertPriority.basse:
        return const Color(0xFF2196F3);
    }
  }
}

/// Modèle Règle d'Alerte pour le moteur d'alerte
///
/// Définit les conditions et la priorité d'une alerte automatique
class AlertRule {
  final String id;
  final String name;
  final ParameterType parameterType;
  final String conditionDefinition; // Ex: "BPM > 130 pendant 5 min"
  final AlertPriority resultPriority;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastModified;

  AlertRule({
    required this.id,
    required this.name,
    required this.parameterType,
    required this.conditionDefinition,
    required this.resultPriority,
    this.isActive = true,
    required this.createdAt,
    this.lastModified,
  });

  String get statusText => isActive ? 'Active' : 'Inactive';

  Color get statusColor => isActive ? Colors.green : Colors.grey;

  /// Données de démonstration
  static List<AlertRule> get demoRules => [
        AlertRule(
          id: 'rule_1',
          name: 'Tachycardie sévère',
          parameterType: ParameterType.rythme,
          conditionDefinition: 'BPM > 130 pendant 5 minutes consécutives',
          resultPriority: AlertPriority.critique,
          isActive: true,
          createdAt: DateTime(2025, 1, 1),
          lastModified: DateTime(2025, 3, 15),
        ),
        AlertRule(
          id: 'rule_2',
          name: 'Humeur très basse prolongée',
          parameterType: ParameterType.humeur,
          conditionDefinition: 'Humeur ≤ 2/5 pendant 3 jours consécutifs',
          resultPriority: AlertPriority.haute,
          isActive: true,
          createdAt: DateTime(2025, 1, 1),
        ),
        AlertRule(
          id: 'rule_3',
          name: 'Privation de sommeil',
          parameterType: ParameterType.sommeil,
          conditionDefinition: 'Sommeil < 4h pendant 3 nuits consécutives',
          resultPriority: AlertPriority.haute,
          isActive: true,
          createdAt: DateTime(2025, 1, 5),
        ),
        AlertRule(
          id: 'rule_4',
          name: 'Corrélation négative forte',
          parameterType: ParameterType.correlation,
          conditionDefinition:
              'Coefficient de corrélation < -0.7 (Humeur vs Sommeil)',
          resultPriority: AlertPriority.moyenne,
          isActive: true,
          createdAt: DateTime(2025, 2, 1),
        ),
        AlertRule(
          id: 'rule_5',
          name: 'Bradycardie',
          parameterType: ParameterType.rythme,
          conditionDefinition: 'BPM < 50 pendant 3 mesures consécutives',
          resultPriority: AlertPriority.haute,
          isActive: false,
          createdAt: DateTime(2025, 1, 10),
          lastModified: DateTime(2025, 3, 20),
        ),
      ];

  AlertRule copyWith({
    String? id,
    String? name,
    ParameterType? parameterType,
    String? conditionDefinition,
    AlertPriority? resultPriority,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastModified,
  }) {
    return AlertRule(
      id: id ?? this.id,
      name: name ?? this.name,
      parameterType: parameterType ?? this.parameterType,
      conditionDefinition: conditionDefinition ?? this.conditionDefinition,
      resultPriority: resultPriority ?? this.resultPriority,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}
