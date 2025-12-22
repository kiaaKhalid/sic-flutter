import 'package:flutter/material.dart';
import 'package:travel_auth_ui/widgets/planet_header.dart';
import 'package:travel_auth_ui/widgets/auth_text_field.dart';
import 'package:travel_auth_ui/widgets/glow_button.dart';
import 'package:travel_auth_ui/features/auth/presentation/widgets/social_google_button.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/login_screen.dart';
import 'package:travel_auth_ui/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour contrôler le formulaire
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  bool _isLoading = false;
  bool _termsAccepted = false;

  Future<void> _handleRegister() async {
    // Check terms acceptance first
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vous devez accepter les conditions d'utilisation"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // validate() renvoie false si un seul validator renvoie une erreur
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulation API
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compte créé !"), backgroundColor: Colors.green),
        );
        // Redirection SEULEMENT si valide
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Form( // ENVELOPPE FORM
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PlanetHeader(),
                const SizedBox(height: 8),
                Semantics(
                  label: 'Create Your Account',
                  header: true,
                  child: const Text(
                    'Create Your Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                
                AuthTextField(
                  label: 'Full Name*', 
                  controller: nameCtrl,
                  semanticLabel: 'Full Name',
                  validator: Validators.validateFullName,
                ),
                const SizedBox(height: 14),
                
                AuthTextField(
                  label: 'Email address*',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  semanticLabel: 'Email',
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 14),
                
                AuthTextField(
                  label: 'Password*', 
                  controller: passCtrl, 
                  obscure: true,
                  semanticLabel: 'Password',
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 14),
                
                AuthTextField(
                  label: 'Confirm Password*', 
                  controller: confirmCtrl, 
                  obscure: true,
                  semanticLabel: 'Confirm Password',
                  validator: (v) => Validators.validateConfirmPassword(v, passCtrl.text),
                ),
                const SizedBox(height: 16),
                
                // Terms and Conditions Checkbox
                Semantics(
                  label: 'Accept Terms and Conditions',
                  checked: _termsAccepted,
                  child: CheckboxListTile(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    title: const Text(
                      "J'accepte les conditions d'utilisation",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF6C63FF),
                    checkColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 20),
                
                GlowButton(
                  label: _isLoading ? 'Patientez...' : 'Register',
                  icon: _isLoading ? null : Icons.app_registration,
                  semanticLabel: 'Register Button',
                  onPressed: _isLoading ? null : _handleRegister,
                ),
                // ... suite de votre UI (Divider, Social buttons, etc.)
              ],
            ),
          ),
        ),
      ),
    );
  }
}