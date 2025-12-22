import 'package:flutter/material.dart';
import '../../domain/models/health_metric.dart';

class HealthMetricCard extends StatelessWidget {
  final HealthMetric metric;
  final bool isSmall;

  const HealthMetricCard({
    super.key,
    required this.metric,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSmall ? 140 : 160,
      padding: EdgeInsets.all(isSmall ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2B2B2B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isSmall ? 6 : 8),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(
                    (metric.color.r * 255).round(),
                    (metric.color.g * 255).round(),
                    (metric.color.b * 255).round(),
                    0.2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(metric.icon, 
                  color: metric.color, 
                  size: isSmall ? 18 : 20,
                ),
              ),
              _buildStatusIndicator(metric.status),
            ],
          ),
          SizedBox(height: isSmall ? 12 : 16),
          SizedBox(height: isSmall ? 12 : 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${metric.value} ${metric.unit}',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmall ? 18 : 20,
                fontWeight: isSmall ? FontWeight.w600 : FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: isSmall ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(HealthStatus status) {
    Color color;
    switch (status) {
      case HealthStatus.good:
        color = Colors.green;
        break;
      case HealthStatus.warning:
        color = Colors.orange;
        break;
      case HealthStatus.critical:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          (color.r * 255).round(),
          (color.g * 255).round(),
          (color.b * 255).round(),
          0.2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getStatusText(HealthStatus status) {
    switch (status) {
      case HealthStatus.good:
        return 'Bon';
      case HealthStatus.warning:
        return 'Attention';
      case HealthStatus.critical:
        return 'Critique';
    }
  }
}
