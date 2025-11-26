import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/patient/domain/models/alert.dart';

class RecentAlertItem extends StatelessWidget {
  final Alert alert;
  final bool isSmall;

  const RecentAlertItem({
    super.key,
    required this.alert,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2B2B2B)),
      ),
      child: Row(
        children: [
          // Indicateur de priorité
          Container(
            width: 4,
            height: isSmall ? 32 : 40,
            decoration: BoxDecoration(
              color: alert.priority.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: isSmall ? 8 : 12),
          // Contenu de l'alerte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmall ? 14 : 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!alert.read)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  alert.formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: isSmall ? 10 : 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
