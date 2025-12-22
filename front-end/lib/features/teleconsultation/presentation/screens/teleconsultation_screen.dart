import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import '../widgets/call_controls.dart';
import '../widgets/chat_panel.dart';
import '../widgets/mini_video_view.dart';

class TeleconsultationScreen extends StatefulWidget {
  static const String routeName = '/teleconsultation';
  final String? patientName;

  const TeleconsultationScreen({super.key, this.patientName});

  @override
  State<TeleconsultationScreen> createState() => _TeleconsultationScreenState();
}

class _TeleconsultationScreenState extends State<TeleconsultationScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isChatOpen = false;

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleVideo() {
    setState(() {
      _isVideoOff = !_isVideoOff;
    });
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  void _endCall() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Main Video Area (Remote User)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1A1A1A),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFF333333),
                      child: Icon(Icons.person, size: 80, color: Colors.white54),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.patientName ?? 'Dr. Martin',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'En ligne',
                      style: TextStyle(
                        color: AppTheme.neon,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Mini Video View (Local User) - PIP
          if (!_isVideoOff)
            const Positioned(
              top: 40,
              right: 20,
              child: MiniVideoView(),
            ),

          // 3. Chat Panel (Collapsible)
          if (_isChatOpen)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 300,
              child: ChatPanel(onClose: _toggleChat),
            ),

          // 4. Call Controls (Bottom Bar)
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: CallControls(
                isMuted: _isMuted,
                isVideoOff: _isVideoOff,
                isChatOpen: _isChatOpen,
                onToggleMute: _toggleMute,
                onToggleVideo: _toggleVideo,
                onToggleChat: _toggleChat,
                onEndCall: _endCall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
