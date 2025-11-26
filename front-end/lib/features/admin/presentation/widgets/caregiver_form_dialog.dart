import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/admin/domain/models/caregiver.dart';

/// Dialog de formulaire pour ajouter/modifier un soignant
class CaregiverFormDialog extends StatefulWidget {
  final Caregiver? caregiver;

  const CaregiverFormDialog({super.key, this.caregiver});

  @override
  State<CaregiverFormDialog> createState() => _CaregiverFormDialogState();
}

class _CaregiverFormDialogState extends State<CaregiverFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _matriculeController;
  late TextEditingController _emailController;
  late String _clinicalRole;
  late bool _has2FA;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final caregiver = widget.caregiver;
    _nameController = TextEditingController(text: caregiver?.fullName ?? '');
    _matriculeController =
        TextEditingController(text: caregiver?.matricule ?? '');
    _emailController = TextEditingController(text: caregiver?.email ?? '');
    _clinicalRole = caregiver?.clinicalRole ?? 'Médecin';
    _has2FA = caregiver?.has2FA ?? false;
    _isActive = caregiver?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _matriculeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final caregiver = Caregiver(
        id: widget.caregiver?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: _nameController.text,
        matricule: _matriculeController.text,
        email: _emailController.text,
        clinicalRole: _clinicalRole,
        has2FA: _has2FA,
        isActive: _isActive,
        createdAt: widget.caregiver?.createdAt ?? DateTime.now(),
        assignedPatientsCount: widget.caregiver?.assignedPatientsCount ?? 0,
      );
      Navigator.pop(context, caregiver);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.caregiver != null;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: AppTheme.card,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL)),
      child: Container(
        width: 500,
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.85,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? 'Modifier le Soignant' : 'Ajouter un Soignant',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nom complet *',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _matriculeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Matricule *',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Email professionnel *',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _clinicalRole,
                    dropdownColor: AppTheme.card,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Rôle clinique',
                      prefixIcon: Icon(Icons.medical_services),
                    ),
                    items: ['Médecin', 'Infirmier', 'Psychologue', 'Soignant']
                        .map((role) =>
                            DropdownMenuItem(value: role, child: Text(role)))
                        .toList(),
                    onChanged: (v) => setState(() => _clinicalRole = v!),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Authentification 2FA',
                        style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Sécurité renforcée',
                        style: TextStyle(color: AppTheme.textDim)),
                    value: _has2FA,
                    onChanged: (v) => setState(() => _has2FA = v),
                    activeThumbColor: AppTheme.neon,
                  ),
                  SwitchListTile(
                    title: const Text('Compte actif',
                        style: TextStyle(color: Colors.white)),
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                    activeThumbColor: AppTheme.neon,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.neon,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(isEdit ? 'Modifier' : 'Créer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
