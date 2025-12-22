import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/patient/domain/models/health_metric.dart';
import 'package:travel_auth_ui/features/patient/presentation/widgets/health_metric_card.dart';

class HealthMetricsSection extends StatelessWidget {
  final List<HealthMetric> healthMetrics;
  final bool isMobile;
  final VoidCallback? onViewDetails;

  const HealthMetricsSection({
    super.key,
    required this.healthMetrics,
    required this.isMobile,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Métriques de santé',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewDetails,
                child: Text(
                  'Voir détails',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: isMobile ? 160 : 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: healthMetrics.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: isMobile ? 12.0 : 16.0,
                  left: index == 0 ? 4.0 : 0,
                ),
                child: HealthMetricCard(
                  metric: healthMetrics[index],
                  isSmall: isMobile,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
