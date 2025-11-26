import 'package:flutter/material.dart';
import 'package:travel_auth_ui/widgets/planet_header.dart';
import 'package:travel_auth_ui/widgets/auth_text_field.dart';
import 'package:travel_auth_ui/widgets/glow_button.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, c) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight - 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const PlanetHeader(),
                  const SizedBox(height: 8),
                  const Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter your email and we'll send a 5-digit\nverification code instantly.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textDim, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  AuthTextField(label: 'Email address*', controller: emailCtrl, keyboardType: TextInputType.emailAddress),

                  const SizedBox(height: 16),
                  GlowButton(label: 'Send Code', icon: Icons.send_rounded, onPressed: () {}),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(top: 22, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(color: AppTheme.textDim)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, LoginScreen.routeName),
                          child: const Text('Sign in', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
