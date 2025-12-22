import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/patient.dart';
import 'package:travel_auth_ui/features/teleconsultation/presentation/widgets/chat_panel.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

class PatientChatScreen extends StatelessWidget {
  final Patient patient;

  const PatientChatScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: patient.statusColor.withOpacity(0.2),
              child: Icon(Icons.person, size: 20, color: patient.statusColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Dossier: ${patient.medicalRecordId}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Show patient details
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ChatPanel(
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
