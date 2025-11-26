import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/admin/domain/models/admin_patient.dart';

/// Dialog de formulaire pour ajouter/modifier un patient
class PatientFormDialog extends StatefulWidget {
  final AdminPatient? patient;

  const PatientFormDialog({super.key, this.patient});

  @override
  State<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends State<PatientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _medicalIdController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late DateTime _dateOfBirth;
  late String _gender;
  late List<String> _monitoredParams;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final patient = widget.patient;
    _nameController = TextEditingController(text: patient?.fullName ?? '');
    _medicalIdController =
        TextEditingController(text: patient?.medicalRecordId ?? '');
    _emailController = TextEditingController(text: patient?.email ?? '');
    _phoneController = TextEditingController(text: patient?.phone ?? '');
    _addressController = TextEditingController(text: patient?.address ?? '');
    _dateOfBirth = patient?.dateOfBirth ??
        DateTime.now().subtract(const Duration(days: 365 * 30));
    _gender = patient?.gender ?? 'M';
    _monitoredParams = patient?.monitoredParameters ?? [];
    _isActive = patient?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _medicalIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final patient = AdminPatient(
        id: widget.patient?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: _nameController.text,
        medicalRecordId: _medicalIdController.text,
        dateOfBirth: _dateOfBirth,
        gender: _gender,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        isActive: _isActive,
        createdAt: widget.patient?.createdAt ?? DateTime.now(),
        monitoredParameters: _monitoredParams,
        assignedCaregivers: widget.patient?.assignedCaregivers ?? [],
      );
      Navigator.pop(context, patient);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.patient != null;
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEdit ? 'Modifier le Patient' : 'Ajouter un Patient',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Nom complet *',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requis' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _medicalIdController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Dossier médical (MR-YYYY-XXX) *',
                            prefixIcon: Icon(Icons.badge),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requis' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Email *',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requis' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Téléphone *',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requis' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Adresse complète *',
                            prefixIcon: Icon(Icons.home),
                          ),
                          maxLines: 2,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requis' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          dropdownColor: AppTheme.card,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Sexe',
                            prefixIcon: Icon(Icons.wc),
                          ),
                          items: ['M', 'F', 'Autre']
                              .map((g) =>
                                  DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (v) => setState(() => _gender = v!),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _dateOfBirth,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (date != null)
                              setState(() => _dateOfBirth = date);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Date de naissance',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              '${_dateOfBirth.day}/${_dateOfBirth.month}/${_dateOfBirth.year}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Paramètres surveillés:',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            'RYTHME',
                            'SOMMEIL',
                            'HUMEUR',
                            'CORRELATION'
                          ].map((param) {
                            final isSelected = _monitoredParams.contains(param);
                            return FilterChip(
                              label: Text(param),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _monitoredParams.add(param);
                                  } else {
                                    _monitoredParams.remove(param);
                                  }
                                });
                              },
                              backgroundColor: AppTheme.bg,
                              selectedColor:
                                  AppTheme.neon.withValues(alpha: 0.3),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Compte actif',
                              style: TextStyle(color: Colors.white)),
                          value: _isActive,
                          onChanged: (v) => setState(() => _isActive = v),
                          activeThumbColor: AppTheme.neon,
                        ),
                      ],
                    ),
                  ),
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
    );
  }
}
