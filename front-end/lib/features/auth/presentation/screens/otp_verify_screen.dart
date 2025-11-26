import 'package:flutter/material.dart';
import '../../../../app/router/app_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/glow_button.dart';
import '../../../../widgets/planet_header.dart';
import '../../data/auth_repository.dart';

class OtpVerifyScreen extends StatefulWidget {
  static const routeName = '/otp';
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _codeCtrl = TextEditingController();
  final _repo = AuthRepository();
  bool _loading = false;
  String? _error;

  Future<void> _verify() async {
    setState(() { _loading = true; _error = null; });
    final ok = await _repo.verifyLoginCode(email: widget.email, code: _codeCtrl.text.trim());
    setState(() { _loading = false; });
    if (!ok) {
      setState(() { _error = 'Invalid code. Please check and try again.'; });
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully')),
      );
      // Navigate to dashboard instead of going back
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.patientDashboard,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const PlanetHeader(),
              const SizedBox(height: 8),
              const Text('Enter the 6‑digit code', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('We sent a verification code to ${widget.email}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textDim)),
              const SizedBox(height: 22),
              TextField(
                controller: _codeCtrl,
                maxLength: 6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, letterSpacing: 6, fontSize: 20),
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ],
              const SizedBox(height: 16),
              GlowButton(label: _loading ? 'Verifying...' : 'Verify', icon: Icons.verified_rounded, onPressed: _loading ? null : _verify),
            ],
          ),
        ),
      ),
    );
  }
}
