import 'package:flutter/material.dart';
import 'package:travel_auth_ui/widgets/planet_header.dart';
import 'package:travel_auth_ui/widgets/auth_text_field.dart';
import 'package:travel_auth_ui/widgets/glow_button.dart';
import 'package:travel_auth_ui/features/auth/presentation/widgets/social_google_button.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

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
                    'Create Your Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your account to explore exciting travel\ndestinations and adventures.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textDim, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  AuthTextField(label: 'Full Name*', controller: nameCtrl),
                  const SizedBox(height: 14),
                  AuthTextField(
                    label: 'Email address*',
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(label: 'Password*', controller: passCtrl, obscure: true),
                  const SizedBox(height: 14),
                  AuthTextField(label: 'Confirm Password*', controller: confirmCtrl, obscure: true),
                  const SizedBox(height: 12),
                  GlowButton(label: 'Register', icon: Icons.app_registration, onPressed: () {}),

                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFF202020))),
                      SizedBox(width: 12),
                      Text('Or continue with', style: TextStyle(color: AppTheme.textDim)),
                      SizedBox(width: 12),
                      Expanded(child: Divider(color: Color(0xFF202020))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const SocialGoogleButton(),
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
