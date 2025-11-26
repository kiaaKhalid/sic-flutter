import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/alert.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/health_data.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/patient.dart';
import 'package:travel_auth_ui/features/healthcare_worker/presentation/providers/healthcare_provider.dart';
import 'package:travel_auth_ui/features/healthcare_worker/presentation/widgets/charts/health_chart.dart';
import 'package:travel_auth_ui/features/healthcare_worker/presentation/widgets/kpi_card.dart';

class PatientDetailScreen extends StatefulWidget {
  final String patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late final HealthcareProvider _provider;
  late Patient _patient;
  HealthData? _healthData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _provider = context.read<HealthcareProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Charger les données du patient
      await _provider.loadPatients();
      
      final patient = _provider.patients.firstWhere(
        (p) => p.id == widget.patientId,
        orElse: () => throw Exception('Patient non trouvé'),
      );
      
      // Charger les données de santé (simulé)
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _patient = patient;
        _healthData = HealthDataDemo.demo(widget.patientId);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des données: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détails du patient'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec les informations du patient
            _buildPatientHeader(),
            const SizedBox(height: 24),

            // KPIs
            _buildKpiSection(),
            const SizedBox(height: 24),

            // Graphiques de santé
            _buildHealthCharts(),
            const SizedBox(height: 24),

            // Dernières alertes
            _buildRecentAlerts(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: _patient.statusColor.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 48,
                color: _patient.statusColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _patient.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dossier: ${_patient.medicalRecordId}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (_patient.roomNumber != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Chambre: ${_patient.roomNumber}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _patient.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _patient.statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _patient.statusText,
                      style: TextStyle(
                        color: _patient.statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiSection() {
    if (_healthData == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Métriques de santé',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            KpiCard(
              title: 'Fréquence cardiaque',
              value: '${_healthData?.heartRate?.bpm ?? '--'}',
              icon: Icons.favorite,
              color: Colors.red,
              unit: 'bpm',
              subtitle: _healthData?.heartRate?.bpm != null
                  ? (_healthData!.heartRate!.bpm > 100
                      ? 'Élevé'
                      : _healthData!.heartRate!.bpm < 60
                          ? 'Bas'
                          : 'Normal')
                  : null,
            ),
            KpiCard(
              title: 'Humeur',
              value: _healthData?.mood?.mood ?? '--',
              icon: Icons.mood,
              color: Colors.blue,
              subtitle: _healthData?.mood?.mood == 'Heureux' ? 'Stable' : 'À surveiller',
            ),
            KpiCard(
              title: 'Sommeil',
              value: _healthData?.sleep?.formattedDuration ?? '--',
              icon: Icons.nightlight_round,
              color: Colors.purple,
              subtitle: _healthData?.sleep?.totalMinutes != null
                  ? (_healthData!.sleep!.totalMinutes < 360
                      ? 'Insuffisant'
                      : 'Suffisant')
                  : null,
            ),
            const KpiCard(
              title: 'Activité',
              value: 'Moyenne',
              icon: Icons.directions_walk,
              color: Colors.green,
              subtitle: 'Normale',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthCharts() {
    if (_healthData == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activité récente',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Graphique de fréquence cardiaque
        if (_healthData?.heartRate != null)
          HealthChart(
            title: 'Fréquence cardiaque (24h)',
            data: _healthData!.heartRate!.last24h
                .map((hr) => ChartData(
                      '${hr.timestamp.hour}h',
                      hr.bpm.toDouble(),
                    ))
                .toList(),
            color: Colors.red,
            yAxisTitle: 'BPM',
            xAxisTitle: 'Heure',
          ),
        const SizedBox(height: 16),
        // Graphique de sommeil
        if (_healthData?.sleep != null)
          HealthChart(
            title: 'Cycles de sommeil (nuit dernière)',
            data: _healthData!.sleep!.cycles
                .map((cycle) => ChartData(
                      '${cycle.startTime.hour}h${cycle.startTime.minute}',
                      cycle.durationMinutes.toDouble(),
                    ))
                .toList(),
            color: Colors.purple,
            yAxisTitle: 'Minutes',
            xAxisTitle: 'Début',
            isBarChart: true,
          ),
      ],
    );
  }

  Widget _buildRecentAlerts() {
    final recentAlerts = _provider.alerts
        .where((alert) => alert.patientId == widget.patientId)
        .take(3)
        .toList();

    if (recentAlerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alertes récentes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...recentAlerts.map((alert) => _buildAlertItem(alert)),
      ],
    );
  }

  Widget _buildAlertItem(Alert alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: alert.isAcknowledged ? Colors.grey[100] : null,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: alert.priorityColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            alert.typeIcon,
            color: alert.priorityColor,
          ),
        ),
        title: Text(
          alert.message,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: alert.isAcknowledged ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Il y a ${_timeAgo(alert.timestamp)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: !alert.isAcknowledged
            ? IconButton(
                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                onPressed: () => _onAcknowledgeAlert(alert.id),
              )
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }

  Future<void> _onAcknowledgeAlert(String alertId) async {
    try {
      await _provider.acknowledgeAlert(alertId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alerte marquée comme lue')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }
}
