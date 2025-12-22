import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/healthcare_worker/domain/models/patient.dart';
import 'package:travel_auth_ui/features/teleconsultation/presentation/screens/patient_chat_screen.dart';
import 'package:travel_auth_ui/features/teleconsultation/presentation/screens/teleconsultation_screen.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

class PatientSelectionDialog extends StatelessWidget {
  final List<Patient> patients;

  const PatientSelectionDialog({super.key, required this.patients});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Démarrer une consultation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.separated(
              itemCount: patients.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
              itemBuilder: (context, index) {
                final patient = patients[index];
                return _buildPatientItem(context, patient);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientItem(BuildContext context, Patient patient) {
    return ExpansionTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: patient.statusColor.withOpacity(0.2),
        child: Icon(Icons.person, color: patient.statusColor, size: 24),
      ),
      title: Text(
        patient.name,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Dossier: ${patient.medicalRecordId}',
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: patient.statusColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          patient.statusText,
          style: TextStyle(
            color: patient.statusColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                label: 'Message',
                icon: Icons.chat_bubble_outline,
                color: AppTheme.neon,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PatientChatScreen(patient: patient),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                context,
                label: 'Appel Vidéo',
                icon: Icons.videocam,
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeleconsultationScreen(patientName: patient.name),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}
