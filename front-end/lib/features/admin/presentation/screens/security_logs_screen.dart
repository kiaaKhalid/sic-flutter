import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/admin/domain/models/security_log.dart';

/// Écran des Logs de Sécurité (MODULE 5: NF-1.4)
class SecurityLogsScreen extends StatefulWidget {
  final List<SecurityLog> logs;

  const SecurityLogsScreen({
    super.key,
    required this.logs,
  });

  @override
  State<SecurityLogsScreen> createState() => _SecurityLogsScreenState();
}

class _SecurityLogsScreenState extends State<SecurityLogsScreen> {
  String _filterAction = 'Toutes';
  String _filterRole = 'Tous';

  List<SecurityLog> get _filteredLogs {
    return widget.logs.where((log) {
      final matchesAction =
          _filterAction == 'Toutes' || log.action.displayName == _filterAction;
      final matchesRole = _filterRole == 'Tous' || log.userRole == _filterRole;
      return matchesAction && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              decoration: BoxDecoration(
                color: AppTheme.card,
                border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
              ),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Rôle:', style: TextStyle(color: AppTheme.textDim)),
                        const SizedBox(width: 8),
                        ...['Tous', 'Administrateur', 'Soignant', 'Patient']
                            .map((role) {
                          final isSelected = _filterRole == role;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(role),
                              selected: isSelected,
                              onSelected: (selected) =>
                                  setState(() => _filterRole = role),
                              backgroundColor: AppTheme.bg,
                              selectedColor: AppTheme.neon.withOpacity(0.3),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                itemCount: _filteredLogs.length,
                itemBuilder: (context, index) {
                  final log = _filteredLogs[index];
                  return Card(
                    color: AppTheme.card,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: log.action.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(log.action.icon,
                            color: log.action.color, size: 20),
                      ),
                      title: Text(log.action.displayName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${log.userName} (${log.userRole})',
                              style: TextStyle(color: AppTheme.textDim)),
                          if (log.targetName != null)
                            Text('Cible: ${log.targetName}',
                                style: TextStyle(
                                    color: AppTheme.textDim, fontSize: 12)),
                          if (log.details != null)
                            Text(log.details!,
                                style: TextStyle(
                                    color: AppTheme.textDim.withOpacity(0.7),
                                    fontSize: 11)),
                          Text(log.timeAgo,
                              style: TextStyle(
                                  color: AppTheme.textDim, fontSize: 11)),
                        ],
                      ),
                      trailing: log.ipAddress != null
                          ? Text(log.ipAddress!,
                              style: TextStyle(
                                  color: AppTheme.textDim, fontSize: 11))
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
