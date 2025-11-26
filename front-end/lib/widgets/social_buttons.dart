import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButtons extends StatelessWidget {
  final VoidCallback? onGoogle;

  const SocialButtons({super.key, this.onGoogle});

  static const _googleSvg = '''
<svg width="18" height="18" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
  <path fill="#FFC107" d="M43.611 20.083H42V20H24v8h11.303C33.826 32.662 29.286 36 24 36c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.159 7.957 3.043l5.657-5.657C33.64 6.053 29.084 4 24 4 12.955 4 4 12.955 4 24s8.955 20 20 20 20-8.955 20-20c0-1.341-.138-2.651-.389-3.917z"/>
  <path fill="#FF3D00" d="M6.306 14.691l6.571 4.817C14.46 16.108 18.867 12 24 12c3.059 0 5.842 1.159 7.957 3.043l5.657-5.657C33.64 6.053 29.084 4 24 4c-7.797 0-14.433 4.427-17.694 10.691z"/>
  <path fill="#4CAF50" d="M24 44c5.217 0 9.9-1.997 13.457-5.243l-6.21-5.24C29.149 35.488 26.701 36 24 36c-5.267 0-9.793-3.317-11.293-7.964l-6.5 5.01C8.414 39.47 15.62 44 24 44z"/>
  <path fill="#1976D2" d="M43.611 20.083H42V20H24v8h11.303c-1.103 3.31-3.52 5.98-6.556 7.517l6.21 5.24C37.925 38.735 40 33.806 40 28c0-1.341-.138-2.651-.389-3.917z"/>
 </svg>
''';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onGoogle,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF101010),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A2A)),
            boxShadow: const [
              BoxShadow(color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.string(_googleSvg),
              const SizedBox(width: 10),
              const Text(
                'Continue with Google',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
