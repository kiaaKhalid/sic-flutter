import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/admin/domain/models/admin_patient.dart';
import 'package:travel_auth_ui/features/admin/domain/models/caregiver.dart';
import 'package:travel_auth_ui/features/admin/domain/models/alert_rule.dart';
import 'package:travel_auth_ui/features/admin/domain/models/security_log.dart';
import '../widgets/admin_kpi_card.dart';
import '../widgets/admin_nav_drawer.dart';
import 'patients_management_screen.dart';
import 'caregivers_management_screen.dart';
import 'alert_rules_screen.dart';
import 'security_logs_screen.dart';

/// Écran principal du dashboard Administrateur Système
///
/// Interface SAC-MP (Système d'Alerte Clinique Multi-Paramètres)
/// Conforme au cahier des charges fonctionnel
///
/// Modules:
/// - MODULE 1: Gestion des Patients (F-1.1)
/// - MODULE 2: Gestion du Personnel Soignant (F-1.2)
/// - MODULE 3: Assignation Soignants ↔ Patients
/// - MODULE 4: Configuration du Moteur d'Alerte (F-4.1)
/// - MODULE 5: Sécurité et Administration (NF-1.x)
/// - MODULE 6: KPIs Système
class AdminDashboardScreen extends StatefulWidget {
  static const String routeName = '/admin-dashboard';

  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // Données (TODO: Remplacer par appels API)
  final List<AdminPatient> _patients = AdminPatient.demoPatients;
  final List<Caregiver> _caregivers = Caregiver.demoCaregivers;
  final List<AlertRule> _alertRules = AlertRule.demoRules;
  final List<SecurityLog> _securityLogs = SecurityLog.demoLogs;

  // Titres des sections
  final List<String> _navTitles = [
    'Tableau de bord',
    'Gestion des Patients',
    'Gestion des Soignants',
    'Règles d\'Alerte',
    'Logs de Sécurité',
  ];

  void _onNavigationTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ==================== Calcul des KPIs ====================

  int get _totalPatients => _patients.length;

  int get _activePatients => _patients.where((p) => p.isActive).length;

  int get _totalCaregivers => _caregivers.length;

  int get _activeCaregivers => _caregivers.where((c) => c.isActive).length;

  Map<AlertPriority, int> get _alertCountsByPriority {
    return {
      AlertPriority.critique: 3,
      AlertPriority.haute: 7,
      AlertPriority.moyenne: 12,
      AlertPriority.basse: 5,
    };
  }

  int get _activeAlertRules => _alertRules.where((r) => r.isActive).length;

  int get _unassignedPatients =>
      _patients.where((p) => p.isActive && p.assignedCaregivers.isEmpty).length;

  double get _twoFactorRate {
    if (_caregivers.isEmpty) return 0;
    final with2FA = _caregivers.where((c) => c.has2FA).length;
    return (with2FA / _caregivers.length) * 100;
  }

  // ==================== Construction des écrans ====================

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardOverview();
      case 1:
        return PatientsManagementScreen(
          patients: _patients,
          onPatientAdded: _handlePatientAdded,
          onPatientUpdated: _handlePatientUpdated,
          onPatientDeleted: _handlePatientDeleted,
        );
      case 2:
        return CaregiversManagementScreen(
          caregivers: _caregivers,
          onCaregiverAdded: _handleCaregiverAdded,
          onCaregiverUpdated: _handleCaregiverUpdated,
        );
      case 3:
        return AlertRulesScreen(
          alertRules: _alertRules,
          onRuleAdded: _handleRuleAdded,
          onRuleUpdated: _handleRuleUpdated,
          onRuleDeleted: _handleRuleDeleted,
        );
      case 4:
        return SecurityLogsScreen(logs: _securityLogs);
      default:
        return _buildDashboardOverview();
    }
  }

  Widget _buildDashboardOverview() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final crossAxisCount = isMobile ? 2 : (width < 900 ? 3 : 4);

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Text(
                'Vue d\'ensemble du système',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Surveillez les KPIs et l\'activité du système SAC-MP',
                style: TextStyle(
                  color: AppTheme.textDim,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
              const SizedBox(height: 24),

              // Grid de KPIs
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isMobile ? 1.3 : 1.5,
                children: [
                  AdminKPICard(
                    title: 'Total Patients',
                    value: '$_totalPatients',
                    subtitle: '$_activePatients actifs',
                    icon: Icons.people,
                    color: Colors.blue,
                    onTap: () => _onNavigationTapped(1),
                  ),
                  AdminKPICard(
                    title: 'Soignants',
                    value: '$_totalCaregivers',
                    subtitle: '$_activeCaregivers actifs',
                    icon: Icons.medical_services,
                    color: Colors.green,
                    onTap: () => _onNavigationTapped(2),
                  ),
                  AdminKPICard(
                    title: 'Règles d\'Alerte',
                    value: '$_activeAlertRules',
                    subtitle: '${_alertRules.length} au total',
                    icon: Icons.rule,
                    color: Colors.orange,
                    onTap: () => _onNavigationTapped(3),
                  ),
                  AdminKPICard(
                    title: 'Patients Non Assignés',
                    value: '$_unassignedPatients',
                    subtitle: 'Nécessite attention',
                    icon: Icons.warning_amber_rounded,
                    color: _unassignedPatients > 0 ? Colors.red : Colors.green,
                    onTap: () => _onNavigationTapped(1),
                  ),
                  AdminKPICard(
                    title: 'Taux 2FA',
                    value: '${_twoFactorRate.toStringAsFixed(0)}%',
                    subtitle:
                        '${_caregivers.where((c) => c.has2FA).length}/${_caregivers.length} soignants',
                    icon: Icons.security,
                    color: _twoFactorRate >= 80 ? Colors.green : Colors.orange,
                    onTap: () => _onNavigationTapped(2),
                  ),
                  AdminKPICard(
                    title: 'Alertes Critiques',
                    value: '${_alertCountsByPriority[AlertPriority.critique]}',
                    subtitle: 'En attente',
                    icon: Icons.emergency,
                    color: Colors.red,
                  ),
                  AdminKPICard(
                    title: 'Alertes Hautes',
                    value: '${_alertCountsByPriority[AlertPriority.haute]}',
                    subtitle: 'À surveiller',
                    icon: Icons.notification_important,
                    color: Colors.orange,
                  ),
                  AdminKPICard(
                    title: 'Actions Récentes',
                    value: '${_securityLogs.length}',
                    subtitle: 'Dernières 24h',
                    icon: Icons.history,
                    color: Colors.purple,
                    onTap: () => _onNavigationTapped(4),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Alertes par priorité (Graphique)
              _buildAlertsDistributionCard(isMobile),

              const SizedBox(height: 24),

              // Activité récente
              _buildRecentActivityCard(isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertsDistributionCard(bool isMobile) {
    return Card(
      color: AppTheme.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribution des Alertes par Priorité',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ..._alertCountsByPriority.entries.map((entry) {
              final total =
                  _alertCountsByPriority.values.reduce((a, b) => a + b);
              final percentage = (entry.value / total * 100).toStringAsFixed(0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: entry.key.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.key.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${entry.value} ($percentage%)',
                          style: TextStyle(
                            color: AppTheme.textDim,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: entry.value / total,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(entry.key.color),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(bool isMobile) {
    final recentLogs = _securityLogs.take(5).toList();

    return Card(
      color: AppTheme.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activité Récente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _onNavigationTapped(4),
                  child: Text(
                    'Voir tout',
                    style: TextStyle(
                      color: AppTheme.neon,
                      fontSize: isMobile ? 13 : 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recentLogs.map((log) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: log.action.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          log.action.icon,
                          color: log.action.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.action.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${log.userName} • ${log.timeAgo}',
                              style: TextStyle(
                                color: AppTheme.textDim,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ==================== Handlers ====================

  void _handlePatientAdded(AdminPatient patient) {
    setState(() {
      _patients.insert(0, patient);
    });
    _showSuccessSnackBar('Patient ${patient.fullName} créé avec succès');
  }

  void _handlePatientUpdated(AdminPatient patient) {
    setState(() {
      final index = _patients.indexWhere((p) => p.id == patient.id);
      if (index != -1) {
        _patients[index] = patient;
      }
    });
    _showSuccessSnackBar('Patient ${patient.fullName} modifié avec succès');
  }

  void _handlePatientDeleted(String patientId) {
    setState(() {
      _patients.removeWhere((p) => p.id == patientId);
    });
    _showSuccessSnackBar('Patient supprimé avec succès');
  }

  void _handleCaregiverAdded(Caregiver caregiver) {
    setState(() {
      _caregivers.insert(0, caregiver);
    });
    _showSuccessSnackBar('Soignant ${caregiver.fullName} créé avec succès');
  }

  void _handleCaregiverUpdated(Caregiver caregiver) {
    setState(() {
      final index = _caregivers.indexWhere((c) => c.id == caregiver.id);
      if (index != -1) {
        _caregivers[index] = caregiver;
      }
    });
    _showSuccessSnackBar('Soignant ${caregiver.fullName} modifié avec succès');
  }

  void _handleRuleAdded(AlertRule rule) {
    setState(() {
      _alertRules.insert(0, rule);
    });
    _showSuccessSnackBar('Règle "${rule.name}" créée avec succès');
  }

  void _handleRuleUpdated(AlertRule rule) {
    setState(() {
      final index = _alertRules.indexWhere((r) => r.id == rule.id);
      if (index != -1) {
        _alertRules[index] = rule;
      }
    });
    _showSuccessSnackBar('Règle "${rule.name}" modifiée avec succès');
  }

  void _handleRuleDeleted(String ruleId) {
    setState(() {
      _alertRules.removeWhere((r) => r.id == ruleId);
    });
    _showSuccessSnackBar('Règle supprimée avec succès');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _navTitles[_selectedIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Ouvrir les notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Ouvrir les paramètres
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: AdminNavDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavigationTapped,
      ),
      body: _buildCurrentScreen(),
    );
  }
}
