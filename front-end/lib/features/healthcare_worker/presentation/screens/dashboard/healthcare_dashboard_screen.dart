import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/patient.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/alert.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/health_data.dart' show HealthData, HealthDataDemo;
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/teleconsultation/presentation/widgets/patient_selection_dialog.dart';
import '../../widgets/forms/add_patient_dialog.dart';
import '../../widgets/delete_button.dart';

/// Dashboard principal pour les professionnels de santé
/// 
/// Affiche 3 onglets principaux:
/// - Patients: Liste de tous les patients avec possibilité d'ajout/suppression
/// - Détails: Informations détaillées du patient sélectionné (métriques de santé)
/// - Alertes: Notifications médicales avec niveaux de priorité
/// 
/// Features:
/// - CRUD patients (Create via FloatingActionButton, Delete via bouton rouge)
/// - Affichage des statuts patients (Critique, À surveiller, Stable)
/// - Gestion des alertes médicales
/// - Design responsive (mobile/tablet/desktop)
class HealthcareDashboardScreen extends StatefulWidget {
  static const String routeName = '/healthcare-dashboard';

  const HealthcareDashboardScreen({super.key});

  @override
  State<HealthcareDashboardScreen> createState() => _HealthcareDashboardScreenState();
}

class _HealthcareDashboardScreenState extends State<HealthcareDashboardScreen> {
  // État de navigation
  int _selectedIndex = 0; // 0: Patients, 1: Détails, 2: Alertes
  
  // Patient actuellement sélectionné pour affichage détaillé
  Patient? _selectedPatient;
  
  // Liste des patients (TODO: remplacer par appel API)
  final List<Patient> _patients = Patient.demoPatients;
  
  // Liste des alertes médicales (TODO: remplacer par appel API)
  final List<Alert> _alerts = Alert.demoAlerts;
  
  // Liste des soignants disponibles pour assignation
  final List<String> _caregivers = const [
    'Dr. Martin (Cardio)',
    'Infirmière Dupuis',
    'Dr. Leroy (Sommeil)',
    'Soignant A. Bernard',
  ];

  // ==================== Méthodes de Gestion d'État ====================
  
  /// Change l'onglet actif dans la navigation bottom bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Sélectionne un patient et bascule vers l'onglet Détails
  /// 
  /// Appelé quand l'utilisateur clique sur une carte patient
  void _onPatientSelected(Patient patient) {
    setState(() {
      _selectedPatient = patient;
      _selectedIndex = 1; // Basculer vers l'onglet Détails
    });
  }

  /// Marque une alerte comme reconnue/vue
  /// 
  /// TODO: Implémenter l'appel API pour persister l'état
  void _onAcknowledgeAlert(String alertId) {
    // await alertRepository.acknowledgeAlert(alertId);
    // setState pour mettre à jour l'UI
  }

  /// Supprime un patient de la liste
  /// 
  /// Affiche une confirmation avant suppression
  /// TODO: Implémenter l'appel API backend
  void _onDeletePatient(String patientId) {
    setState(() {
      _patients.removeWhere((patient) => patient.id == patientId);
      
      // Si le patient supprimé était sélectionné, désélectionner
      if (_selectedPatient?.id == patientId) {
        _selectedPatient = null;
      }
    });
    
    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Patient supprimé avec succès'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    
    // TODO: Implémenter l'appel API backend pour supprimer le patient
    // await patientRepository.deletePatient(patientId);
  }

  // Méthodes de construction des différents écrans
  Widget _buildPatientList() {
    return ListView.builder(
      itemCount: _patients.length,
      itemBuilder: (context, index) {
        final patient = _patients[index];
        return _buildPatientCard(patient);
      },
    );
  }

  Widget _buildPatientCard(Patient patient) {
    // Responsive sizing based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _onPatientSelected(patient),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: isCompact ? 24 : 28,
                backgroundColor: patient.statusColor.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  color: patient.statusColor,
                  size: isCompact ? 24 : 28,
                ),
              ),
              const SizedBox(width: 12),
              
              // Patient Info (Expanded to take remaining space)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isCompact ? 14 : 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dossier: ${patient.medicalRecordId}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isCompact ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status & Alerts
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: patient.statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: patient.statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      patient.statusText,
                      style: TextStyle(
                        color: patient.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isCompact ? 11 : 12,
                      ),
                    ),
                  ),
                  if (patient.alertCount > 0) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF5252)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${patient.alertCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(width: 12),
              
              // Modern Delete Button
              CompactDeleteButton(
                onDelete: () => _onDeletePatient(patient.id),
                showConfirmation: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientDetail() {
    if (_selectedPatient == null) {
      return const Center(child: Text('Sélectionnez un patient'));
    }

    final patient = _selectedPatient!;
    final healthData = HealthDataDemo.demo(patient.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du patient
          _buildPatientHeader(patient),
          const SizedBox(height: 24),
          
          // Métriques de santé
          _buildHealthMetrics(healthData),
          const SizedBox(height: 24),
          
          // Graphiques
          _buildHealthCharts(healthData),
        ],
      ),
    );
  }

  Widget _buildPatientHeader(Patient patient) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: patient.statusColor.withOpacity(0.2),
              child: Icon(Icons.person, size: 40, color: patient.statusColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Dossier: ${patient.medicalRecordId}'),
                  if (patient.roomNumber != null)
                    Text('Chambre: ${patient.roomNumber}'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: patient.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: patient.statusColor),
              ),
              child: Text(
                patient.statusText,
                style: TextStyle(
                  color: patient.statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetrics(HealthData healthData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Métriques de santé',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricItem(Icons.favorite, Colors.red, 'Fréquence Cardiaque', '72 BPM'),
                  const SizedBox(width: 16),
                  _buildMetricItem(Icons.water_drop, Colors.blue, 'SpO2', '98 %'),
                  const SizedBox(width: 16),
                  _buildMetricItem(Icons.speed, Colors.orange, 'Pression Artérielle', '120/80'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, Color color, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildHealthCharts(HealthData healthData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activité récente',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildActivityItem('Mesure prise', 'Il y a 10 min', Icons.monitor_heart, Colors.blue),
                const Divider(),
                _buildActivityItem('Alerte détectée', 'Il y a 1h', Icons.warning, Colors.orange),
                const Divider(),
                _buildActivityItem('Consultation terminée', 'Hier', Icons.check_circle, Colors.green),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlerts() {
    return ListView.builder(
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: alert.priorityColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(alert.typeIcon, color: alert.priorityColor),
        ),
        title: Text(
          alert.message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${alert.patientName}'),
            Text(
              'Il y a ${_timeAgo(alert.timestamp)}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: alert.priorityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                alert.priorityText,
                style: TextStyle(
                  color: alert.priorityColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!alert.isAcknowledged) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: Colors.green,
                onPressed: () => _onAcknowledgeAlert(alert.id),
              ),
            ],
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord clinique'),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call, color: AppTheme.neon),
            tooltip: 'Rejoindre la consultation',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PatientSelectionDialog(patients: _patients),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Naviguer vers l'écran des notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Déconnexion
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildPatientList(),
          _selectedPatient != null
              ? _buildPatientDetail()
              : const Center(child: Text('Sélectionnez un patient')),
          _buildAlerts(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Détails',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alertes',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFD7F759),
              foregroundColor: Colors.black,
              onPressed: () async {
                print('FloatingActionButton pressed!'); // Debug
                try {
                  final result = await showDialog<AddPatientResult>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext dialogContext) {
                      return AddPatientDialog(availableCaregivers: _caregivers);
                    },
                  );
                  
                  print('Dialog result: $result'); // Debug
                  
                  if (result == null) {
                    print('Dialog was cancelled');
                    return;
                  }
                  
                  final newPatient = Patient(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: result.fullName,
                    medicalRecordId: result.medicalRecordId,
                    status: PatientStatus.stable,
                    lastUpdate: DateTime.now(),
                  );
                  
                  setState(() {
                    _patients.insert(0, newPatient);
                  });
                  
                  if (!mounted) return;
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Patient ${result.fullName} créé avec succès'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  print('Error opening dialog: $e');
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }
}
