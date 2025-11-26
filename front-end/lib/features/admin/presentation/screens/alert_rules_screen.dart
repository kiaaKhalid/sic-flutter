import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/admin/domain/models/alert_rule.dart';
import '../widgets/alert_rule_form_dialog.dart';

/// Écran de Configuration du Moteur d'Alerte (MODULE 4: F-4.1)
class AlertRulesScreen extends StatefulWidget {
  final List<AlertRule> alertRules;
  final Function(AlertRule) onRuleAdded;
  final Function(AlertRule) onRuleUpdated;
  final Function(String) onRuleDeleted;

  const AlertRulesScreen({
    super.key,
    required this.alertRules,
    required this.onRuleAdded,
    required this.onRuleUpdated,
    required this.onRuleDeleted,
  });

  @override
  State<AlertRulesScreen> createState() => _AlertRulesScreenState();
}

class _AlertRulesScreenState extends State<AlertRulesScreen> {
  String _filterParameter = 'Tous';

  List<AlertRule> get _filteredRules {
    if (_filterParameter == 'Tous') return widget.alertRules;
    return widget.alertRules
        .where((rule) => rule.parameterType.displayName == _filterParameter)
        .toList();
  }

  Future<void> _showAddRuleDialog() async {
    final result = await showDialog<AlertRule>(
      context: context,
      builder: (context) => const AlertRuleFormDialog(),
    );
    if (result != null) widget.onRuleAdded(result);
  }

  Future<void> _showEditRuleDialog(AlertRule rule) async {
    final result = await showDialog<AlertRule>(
      context: context,
      builder: (context) => AlertRuleFormDialog(rule: rule),
    );
    if (result != null) widget.onRuleUpdated(result);
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
            Container(
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              decoration: BoxDecoration(
                color: AppTheme.card,
                border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
              ),
              child: Wrap(
                spacing: 8,
                children: [
                  'Tous',
                  ...ParameterType.values.map((e) => e.displayName)
                ].map((param) {
                  final isSelected = _filterParameter == param;
                  return FilterChip(
                    label: Text(param),
                    selected: isSelected,
                    onSelected: (selected) =>
                        setState(() => _filterParameter = param),
                    backgroundColor: AppTheme.bg,
                    selectedColor: AppTheme.neon.withOpacity(0.3),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                itemCount: _filteredRules.length,
                itemBuilder: (context, index) {
                  final rule = _filteredRules[index];
                  return Card(
                    color: AppTheme.card,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            rule.parameterType.color.withOpacity(0.2),
                        child: Icon(rule.parameterType.icon,
                            color: rule.parameterType.color),
                      ),
                      title: Text(rule.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rule.conditionDefinition,
                              style: TextStyle(color: AppTheme.textDim)),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: rule.resultPriority.color
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  rule.resultPriority.displayName,
                                  style: TextStyle(
                                      color: rule.resultPriority.color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: rule.statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  rule.statusText,
                                  style: TextStyle(
                                      color: rule.statusColor, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditRuleDialog(rule),
                      ),
                      onTap: () => _showEditRuleDialog(rule),
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
                onPressed: _showAddRuleDialog,
                backgroundColor: AppTheme.neon,
                foregroundColor: Colors.black,
                icon: const Icon(Icons.add),
                label: const Text('Nouvelle Règle'),
              ),
            ),
          ],
        );
      },
    );
  }
}
