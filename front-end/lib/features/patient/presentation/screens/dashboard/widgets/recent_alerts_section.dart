import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/patient/domain/models/alert.dart';
import 'package:travel_auth_ui/features/patient/presentation/widgets/recent_alert_item.dart';

class RecentAlertsSection extends StatelessWidget {
  final List<Alert> alerts;
  final bool isMobile;

  const RecentAlertsSection({
    super.key,
    required this.alerts,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'Alertes récentes',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...alerts.map((alert) => Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: RecentAlertItem(alert: alert),
        )),
      ],
    );
  }
}
