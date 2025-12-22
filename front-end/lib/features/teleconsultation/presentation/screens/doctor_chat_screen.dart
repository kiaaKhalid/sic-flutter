import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/teleconsultation/presentation/widgets/chat_panel.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

class DoctorChatScreen extends StatelessWidget {
  const DoctorChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF333333),
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dr. Martin',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Cardiologue',
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ChatPanel(
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
