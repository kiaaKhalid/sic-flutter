import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/patient.dart';

class PatientListItem extends StatelessWidget {
  final Patient patient;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const PatientListItem({
    super.key,
    required this.patient,
    this.isSelected = false,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      color: isSelected ? Colors.blue[50] : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[200]!,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Avatar avec indicateur de statut
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: patient.statusColor.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 28,
                      color: patient.statusColor,
                    ),
                  ),
                  if (patient.alertCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          patient.alertCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Détails du patient
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: patient.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: patient.statusColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            patient.statusText,
                            style: TextStyle(
                              color: patient.statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (patient.roomNumber != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            'Ch. ${patient.roomNumber}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Indicateur de sélection
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 20,
                )
              else
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
