import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

class CallControls extends StatelessWidget {
  final bool isMuted;
  final bool isVideoOff;
  final bool isChatOpen;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleChat;
  final VoidCallback onEndCall;

  const CallControls({
    super.key,
    required this.isMuted,
    required this.isVideoOff,
    required this.isChatOpen,
    required this.onToggleMute,
    required this.onToggleVideo,
    required this.onToggleChat,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B).withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(
            icon: isMuted ? Icons.mic_off : Icons.mic,
            isActive: !isMuted,
            onTap: onToggleMute,
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            backgroundColor: isMuted ? Colors.red : Colors.white.withOpacity(0.2),
          ),
          const SizedBox(width: 16),
          _buildControlButton(
            icon: isVideoOff ? Icons.videocam_off : Icons.videocam,
            isActive: !isVideoOff,
            onTap: onToggleVideo,
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            backgroundColor: isVideoOff ? Colors.red : Colors.white.withOpacity(0.2),
          ),
          const SizedBox(width: 16),
          _buildControlButton(
            icon: isChatOpen ? Icons.chat_bubble : Icons.chat_bubble_outline,
            isActive: isChatOpen,
            onTap: onToggleChat,
            activeColor: Colors.black,
            inactiveColor: Colors.white,
            backgroundColor: isChatOpen ? AppTheme.neon : Colors.white.withOpacity(0.2),
          ),
          const SizedBox(width: 24),
          _buildControlButton(
            icon: Icons.call_end,
            isActive: true,
            onTap: onEndCall,
            activeColor: Colors.white,
            backgroundColor: Colors.red,
            size: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color? activeColor,
    Color? inactiveColor,
    Color? backgroundColor,
    double size = 48,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? activeColor : inactiveColor,
          size: size * 0.5,
        ),
      ),
    );
  }
}
