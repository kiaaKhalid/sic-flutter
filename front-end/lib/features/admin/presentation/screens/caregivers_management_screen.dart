import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/admin/domain/models/caregiver.dart';
import '../widgets/caregiver_form_dialog.dart';

/// Écran de Gestion du Personnel Soignant (MODULE 2: F-1.2)
class CaregiversManagementScreen extends StatefulWidget {
  final List<Caregiver> caregivers;
  final Function(Caregiver) onCaregiverAdded;
  final Function(Caregiver) onCaregiverUpdated;

  const CaregiversManagementScreen({
    super.key,
    required this.caregivers,
    required this.onCaregiverAdded,
    required this.onCaregiverUpdated,
  });

  @override
  State<CaregiversManagementScreen> createState() =>
      _CaregiversManagementScreenState();
}

class _CaregiversManagementScreenState
    extends State<CaregiversManagementScreen> {
  String _searchQuery = '';
  String _filterStatus = 'Tous';

  List<Caregiver> get _filteredCaregivers {
    return widget.caregivers.where((caregiver) {
      final matchesSearch = caregiver.fullName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          caregiver.matricule
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          caregiver.clinicalRole
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesStatus = _filterStatus == 'Tous' ||
          (_filterStatus == 'Actif' && caregiver.isActive) ||
          (_filterStatus == 'Inactif' && !caregiver.isActive);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> _showAddCaregiverDialog() async {
    final result = await showDialog<Caregiver>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (dialogContext) => const CaregiverFormDialog(),
    );

    if (result != null) {
      widget.onCaregiverAdded(result);
    }
  }

  Future<void> _showEditCaregiverDialog(Caregiver caregiver) async {
    final result = await showDialog<Caregiver>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (dialogContext) => CaregiverFormDialog(caregiver: caregiver),
    );

    if (result != null) {
      widget.onCaregiverUpdated(result);
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
                // Barre de recherche
                Container(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText:
                                    'Rechercher par nom, matricule ou rôle...',
                                hintStyle: TextStyle(color: AppTheme.textDim),
                                prefixIcon: const Icon(Icons.search,
                                    color: AppTheme.textDim),
                                filled: true,
                                fillColor: AppTheme.bg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) =>
                                  setState(() => _searchQuery = value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text('Statut:',
                                style: TextStyle(color: AppTheme.textDim)),
                            const SizedBox(width: 12),
                            ...['Tous', 'Actif', 'Inactif'].map((status) {
                              final isSelected = _filterStatus == status;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
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
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Liste
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                    itemCount: _filteredCaregivers.length,
                    itemBuilder: (context, index) {
                      final caregiver = _filteredCaregivers[index];
                      return Card(
                        color: AppTheme.card,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                caregiver.statusColor.withOpacity(0.2),
                            child: Icon(caregiver.roleIcon,
                                color: caregiver.statusColor),
                          ),
                          title: Text(caregiver.fullName,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${caregiver.clinicalRole} • ${caregiver.matricule}',
                                  style: TextStyle(color: AppTheme.textDim)),
                              Text(
                                  '${caregiver.assignedPatientsCount} patients',
                                  style: TextStyle(color: AppTheme.textDim)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (caregiver.has2FA)
                                Icon(Icons.security,
                                    color: AppTheme.neon, size: 18),
                              const SizedBox(width: 8),
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _showEditCaregiverDialog(caregiver),
                              ),
                            ],
                          ),
                          onTap: () => _showEditCaregiverDialog(caregiver),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                onPressed: _showAddCaregiverDialog,
                backgroundColor: AppTheme.neon,
                foregroundColor: Colors.black,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter Soignant'),
              ),
            ),
          ],
        );
      },
    );
  }
}
