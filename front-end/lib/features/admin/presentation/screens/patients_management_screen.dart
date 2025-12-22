import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/admin/domain/models/admin_patient.dart';
import '../widgets/patient_form_dialog.dart';

/// Écran de Gestion des Patients (MODULE 1: F-1.1)
///
/// Fonctionnalités:
/// - Liste de tous les patients
/// - Recherche et filtres (actif/archivé, date)
/// - Ajout de nouveaux patients
/// - Modification de patients existants
/// - Archivage/suppression (soft delete)
class PatientsManagementScreen extends StatefulWidget {
  final List<AdminPatient> patients;
  final Function(AdminPatient) onPatientAdded;
  final Function(AdminPatient) onPatientUpdated;
  final Function(String) onPatientDeleted;

  const PatientsManagementScreen({
    super.key,
    required this.patients,
    required this.onPatientAdded,
    required this.onPatientUpdated,
    required this.onPatientDeleted,
  });

  @override
  State<PatientsManagementScreen> createState() =>
      _PatientsManagementScreenState();
}

class _PatientsManagementScreenState extends State<PatientsManagementScreen> {
  String _searchQuery = '';
  String _filterStatus = 'Tous'; // Tous, Actif, Archivé

  List<AdminPatient> get _filteredPatients {
    return widget.patients.where((patient) {
      final matchesSearch =
          patient.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              patient.medicalRecordId
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              patient.email.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _filterStatus == 'Tous' ||
          (_filterStatus == 'Actif' && patient.isActive) ||
          (_filterStatus == 'Archivé' && !patient.isActive);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> _showAddPatientDialog() async {
    final result = await showDialog<AdminPatient>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (dialogContext) => const PatientFormDialog(),
    );

    if (result != null) {
      widget.onPatientAdded(result);
    }
  }

  Future<void> _showEditPatientDialog(AdminPatient patient) async {
    final result = await showDialog<AdminPatient>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (dialogContext) => PatientFormDialog(patient: patient),
    );

    if (result != null) {
      widget.onPatientUpdated(result);
    }
  }

  Future<void> _confirmDeletePatient(AdminPatient patient) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: const Text(
          'Confirmer la suppression',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Voulez-vous vraiment archiver le patient ${patient.fullName} ?\n\nCette action peut être annulée ultérieurement.',
          style: const TextStyle(color: AppTheme.textDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Archiver'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.onPatientDeleted(patient.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Stack(
          children: [
            Column(
              children: [
                // Barre de recherche et filtres
                Container(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText:
                              'Rechercher par nom, dossier médical ou email...',
                          hintStyle: TextStyle(color: AppTheme.textDim),
                          prefixIcon:
                              const Icon(Icons.search, color: AppTheme.textDim),
                          filled: true,
                          fillColor: AppTheme.bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          Text('Statut:',
                              style: TextStyle(color: AppTheme.textDim)),
                          ...['Tous', 'Actif', 'Archivé'].map((status) {
                            final isSelected = _filterStatus == status;
                            return FilterChip(
                              label: Text(status),
                              selected: isSelected,
                              onSelected: (selected) =>
                                  setState(() => _filterStatus = status),
                              backgroundColor: AppTheme.bg,
                              selectedColor: AppTheme.neon.withOpacity(0.3),
                              labelStyle: TextStyle(
                                color:
                                    isSelected ? AppTheme.neon : Colors.white,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                // Liste des patients
                Expanded(
                  child: _filteredPatients.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppTheme.textDim,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun patient trouvé',
                                style: TextStyle(
                                  color: AppTheme.textDim,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                          itemCount: _filteredPatients.length,
                          itemBuilder: (context, index) {
                            return _buildPatientCard(
                                _filteredPatients[index], isMobile);
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                onPressed: _showAddPatientDialog,
                backgroundColor: AppTheme.neon,
                foregroundColor: Colors.black,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter Patient'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPatientCard(AdminPatient patient, bool isMobile) {
    return Card(
      color: AppTheme.card,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () => _showEditPatientDialog(patient),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: isMobile ? 24 : 28,
                backgroundColor: patient.statusColor.withOpacity(0.2),
                child: Text(
                  patient.fullName[0].toUpperCase(),
                  style: TextStyle(
                    color: patient.statusColor,
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info patient
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient.fullName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 15 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: patient.statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: patient.statusColor.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            patient.statusText,
                            style: TextStyle(
                              color: patient.statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.badge,
                          size: 14,
                          color: AppTheme.textDim,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          patient.medicalRecordId,
                          style: TextStyle(
                            color: AppTheme.textDim,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.cake,
                          size: 14,
                          color: AppTheme.textDim,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${patient.age} ans',
                          style: TextStyle(
                            color: AppTheme.textDim,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 14,
                          color: AppTheme.textDim,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            patient.email,
                            style: TextStyle(
                              color: AppTheme.textDim,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (patient.assignedCaregivers.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services,
                            size: 14,
                            color: AppTheme.neon,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${patient.assignedCaregivers.length} soignant(s)',
                            style: const TextStyle(
                              color: AppTheme.neon,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Actions
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditPatientDialog(patient),
                    tooltip: 'Modifier',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: patient.isActive ? Colors.red : Colors.green,
                    ),
                    onPressed: () => _confirmDeletePatient(patient),
                    tooltip: patient.isActive ? 'Archiver' : 'Restaurer',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
