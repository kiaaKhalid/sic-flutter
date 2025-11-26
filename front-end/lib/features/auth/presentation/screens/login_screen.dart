import 'package:flutter/material.dart';
import 'package:travel_auth_ui/widgets/planet_header.dart';
import 'package:travel_auth_ui/widgets/auth_text_field.dart';
import 'package:travel_auth_ui/widgets/glow_button.dart';
import 'package:travel_auth_ui/features/auth/presentation/widgets/social_google_button.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/register_screen.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:travel_auth_ui/features/auth/data/auth_repository.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/otp_verify_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool remember = false;
  bool loading = false;
  final _repo = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
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
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to access smart, personalized travel\nplans made for you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textDim, height: 1.4),
                    ),
                    const SizedBox(height: 24),

                    AuthTextField(
                      label: 'Email address*',
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      label: 'Password*',
                      controller: passCtrl,
                      obscure: true,
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => remember = !remember),
                          child: Row(children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFF2B2B2B)),
                                color: remember ? AppTheme.neon : Colors.transparent,
                              ),
                              child: remember
                                  ? const Icon(Icons.check, size: 14, color: Colors.black)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            const Text('Remember me', style: TextStyle(color: Colors.white)),
                          ]),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),

                    const SizedBox(height: 6),
                    GlowButton(
                      label: loading ? 'Sending...' : 'Sign In',
                      icon: Icons.login,
                      onPressed: loading
                          ? null
                          : () async {
                              final email = emailCtrl.text.trim();
                              
                              // Handle empty email case synchronously
                              if (email.isEmpty) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter your email')),
                                  );
                                }
                                return;
                              }
                              
                              setState(() => loading = true);
                              
                              // Handle the async operation
                              try {
                                // Get navigator before async operations
                                final navigator = Navigator.of(context);
                                
                                // Perform the async operation
                                await _repo.sendLoginCode(email: email);
                                
                                // Check if widget is still mounted
                                if (!mounted) return;
                                setState(() => loading = false);
                                
                                // Navigate to OTP screen
                                if (!mounted) return;
                                await navigator.push(
                                  MaterialPageRoute(
                                    builder: (_) => OtpVerifyScreen(email: email),
                                  ),
                                );
                              } catch (e) {
                                // Handle errors
                                if (!mounted) return;
                                setState(() => loading = false);
                                
                                // Show error message using a global key
                                if (!mounted) return;
                                final errorMessage = e.toString();
                                if (mounted) {
                                  // Use the existing ScaffoldMessenger to show the error
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $errorMessage')),
                                    );
                                  });
                                }
                              }
                            },
                    ),

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
                          const Text("Don't have an account? ", style: TextStyle(color: AppTheme.textDim)),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
                            child: const Text('Sign up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
