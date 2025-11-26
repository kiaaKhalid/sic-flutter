import 'package:flutter/material.dart';

/// Énumération pour le sexe du patient
enum Sex { male, female, other }

/// Résultat retourné par le dialog AddPatient après validation
/// 
/// Contient toutes les informations collectées du formulaire
class AddPatientResult {
  final String fullName;
  final DateTime birthDate;
  final Sex sex;
  final String medicalRecordId; // Format: MR-YYYY-NNN
  final String? email;
  final String? phone;
  final String? address;
  final Set<String> groups;
  final Set<String> caregivers;

  AddPatientResult({
    required this.fullName,
    required this.birthDate,
    required this.sex,
    required this.medicalRecordId,
    this.email,
    this.phone,
    this.address,
    required this.groups,
    required this.caregivers,
  });
}

/// Dialog modal pour créer un nouveau patient
/// 
/// Formulaire avec validation incluant:
/// - Nom complet (requis)
/// - ID Dossier médical avec format MR-YYYY-NNN (requis)
/// - Date de naissance avec DatePicker (requis)
/// - Sexe via dropdown (requis)
/// - Soignants assignés via FilterChips (minimum 1 requis)
/// 
/// Utilisation:
/// ```dart
/// final result = await showDialog<AddPatientResult>(
///   context: context,
///   builder: (context) => AddPatientDialog(
///     availableCaregivers: ['Dr. Martin', 'Infirmière Dupuis'],
///   ),
/// );
/// if (result != null) {
///   // Traiter le nouveau patient
/// }
/// ```
class AddPatientDialog extends StatefulWidget {
  /// Liste des soignants disponibles pour assignation
  final List<String> availableCaregivers;
  
  const AddPatientDialog({super.key, required this.availableCaregivers});

  @override
  State<AddPatientDialog> createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mrController = TextEditingController();

  DateTime? _birthDate;
  Sex _sex = Sex.other;
  bool _loading = false;

  final Set<String> _selectedCaregivers = {};

  @override
  void dispose() {
    _nameController.dispose();
    _mrController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 30),
      firstDate: DateTime(now.year - 120),
      lastDate: DateTime(now.year - 1),
      helpText: 'Date de naissance',
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selectionnez la date de naissance')),
      );
      return;
    }
    if (_selectedCaregivers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selectionnez au moins un soignant')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    Navigator.of(context).pop(
      AddPatientResult(
        fullName: _nameController.text.trim(),
        birthDate: _birthDate!,
        sex: _sex,
        medicalRecordId: _mrController.text.trim(),
        email: null,
        phone: null,
        address: null,
        groups: {},
        caregivers: _selectedCaregivers,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD7F759), width: 2),
      ),
      title: const Text(
        'Creer un patient',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nom complet *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mrController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'ID Dossier (MR-AAAA-NNN) *',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requis';
                  if (!RegExp(r'^MR-\d{4}-\d{3}$').hasMatch(v)) {
                    return 'Format: MR-AAAA-NNN';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance *',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  child: Text(
                    _birthDate == null
                        ? 'Cliquez pour selectionner'
                        : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Sex>(
                initialValue: _sex,
                dropdownColor: const Color(0xFF2A2A2A),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Sexe',
                  prefixIcon: Icon(Icons.wc_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: Sex.male, child: Text('Homme')),
                  DropdownMenuItem(value: Sex.female, child: Text('Femme')),
                  DropdownMenuItem(value: Sex.other, child: Text('Autre')),
                ],
                onChanged: (v) => setState(() => _sex = v ?? Sex.other),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Soignant(s) assigne(s) *',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.availableCaregivers.map((c) {
                  final isSelected = _selectedCaregivers.contains(c);
                  return FilterChip(
                    label: Text(c),
                    selected: isSelected,
                    selectedColor: const Color(0xFFD7F759).withOpacity(0.3),
                    checkmarkColor: const Color(0xFFD7F759),
                    backgroundColor: const Color(0xFF2A2A2A),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCaregivers.add(c);
                        } else {
                          _selectedCaregivers.remove(c);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD7F759),
            foregroundColor: Colors.black,
          ),
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Text('Creer'),
        ),
      ],
    );
  }
}
