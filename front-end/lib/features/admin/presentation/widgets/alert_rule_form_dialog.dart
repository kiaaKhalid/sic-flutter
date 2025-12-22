import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/admin/domain/models/alert_rule.dart';

/// Dialog de formulaire pour ajouter/modifier une règle d'alerte
class AlertRuleFormDialog extends StatefulWidget {
  final AlertRule? rule;

  const AlertRuleFormDialog({super.key, this.rule});

  @override
  State<AlertRuleFormDialog> createState() => _AlertRuleFormDialogState();
}

class _AlertRuleFormDialogState extends State<AlertRuleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _conditionController;
  late ParameterType _parameterType;
  late AlertPriority _priority;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _nameController = TextEditingController(text: rule?.name ?? '');
    _conditionController =
        TextEditingController(text: rule?.conditionDefinition ?? '');
    _parameterType = rule?.parameterType ?? ParameterType.rythme;
    _priority = rule?.resultPriority ?? AlertPriority.moyenne;
    _isActive = rule?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final rule = AlertRule(
        id: widget.rule?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        parameterType: _parameterType,
        conditionDefinition: _conditionController.text,
        resultPriority: _priority,
        isActive: _isActive,
        createdAt: widget.rule?.createdAt ?? DateTime.now(),
        lastModified: DateTime.now(),
      );
      Navigator.pop(context, rule);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.rule != null;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: AppTheme.card,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL)),
      child: Container(
        width: 550,
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
                    isEdit ? 'Modifier la Règle' : 'Nouvelle Règle d\'Alerte',
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
                      labelText: 'Nom de la règle *',
                      prefixIcon: Icon(Icons.title),
                      hintText: 'Ex: Tachycardie sévère',
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ParameterType>(
                    value: _parameterType,
                    dropdownColor: AppTheme.card,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Type de paramètre *',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: ParameterType.values
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(type.icon, color: type.color, size: 20),
                                  const SizedBox(width: 8),
                                  Text(type.displayName),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _parameterType = v!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _conditionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Définition de la condition *',
                      prefixIcon: Icon(Icons.rule),
                      hintText: 'Ex: BPM > 130 pendant 5 minutes consécutives',
                    ),
                    maxLines: 3,
                    validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AlertPriority>(
                    value: _priority,
                    dropdownColor: AppTheme.card,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Priorité résultante *',
                      prefixIcon: Icon(Icons.priority_high),
                    ),
                    items: AlertPriority.values
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: priority.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(priority.displayName),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _priority = v!),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Règle active',
                        style: TextStyle(color: Colors.white)),
                    subtitle: const Text('La règle génère des alertes',
                        style: TextStyle(color: AppTheme.textDim)),
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
