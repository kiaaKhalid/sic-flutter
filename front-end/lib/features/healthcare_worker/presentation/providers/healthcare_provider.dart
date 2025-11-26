import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/patient.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/alert.dart';

class HealthcareProvider with ChangeNotifier {
  List<Patient> _patients = [];
  List<Alert> _alerts = [];
  Patient? _selectedPatient;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Patient> get patients => _patients;
  List<Alert> get alerts => _alerts;
  Patient? get selectedPatient => _selectedPatient;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Charger les patients
  Future<void> loadPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simuler un chargement asynchrone
      await Future.delayed(const Duration(seconds: 1));
      
      // Utiliser les données de démonstration
      _patients = Patient.demoPatients;
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des patients: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger les alertes
  Future<void> loadAlerts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simuler un chargement asynchrone
      await Future.delayed(const Duration(seconds: 1));
      
      // Utiliser les données de démonstration
      _alerts = Alert.demoAlerts;
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des alertes: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sélectionner un patient
  void selectPatient(Patient patient) {
    _selectedPatient = patient;
    notifyListeners();
  }

  // Marquer une alerte comme lue
  Future<void> acknowledgeAlert(String alertId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simuler une mise à jour asynchrone
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _alerts.indexWhere((alert) => alert.id == alertId);
      if (index != -1) {
        _alerts[index] = _alerts[index].copyWith(isAcknowledged: true);
        _error = null;
      }
    } catch (e) {
      _error = 'Erreur lors de la mise à jour de l\'alerte: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajouter une note à une alerte
  Future<void> addNoteToAlert(String alertId, String note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simuler une mise à jour asynchrone
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _alerts.indexWhere((alert) => alert.id == alertId);
      if (index != -1) {
        _alerts[index] = _alerts[index].copyWith(note: note);
        _error = null;
      }
    } catch (e) {
      _error = 'Erreur lors de l\'ajout de la note: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filtrer les patients par statut
  List<Patient> getPatientsByStatus(PatientStatus status) {
    return _patients.where((patient) => patient.status == status).toList();
  }

  // Filtrer les alertes par priorité
  List<Alert> getAlertsByPriority(AlertPriority priority) {
    return _alerts.where((alert) => alert.priority == priority).toList();
  }

  // Réinitialiser l'état
  void reset() {
    _selectedPatient = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
