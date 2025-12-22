import 'package:flutter/material.dart';
import 'package:travel_auth_ui/widgets/planet_header.dart';
import 'package:travel_auth_ui/widgets/auth_text_field.dart';
import 'package:travel_auth_ui/widgets/glow_button.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import 'package:travel_auth_ui/features/auth/presentation/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Ajout de la clé
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // LOGIQUE DE CONNEXION (Admin ou API)
      final email = emailCtrl.text.trim();
      final password = passCtrl.text;

      if (email == 'admin@gmail.com' && password == '123456') {
        // Rediriger vers Dashboard
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Identifiants incorrects")),
        );
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
                const Text('Welcome Back!', textAlign: TextAlign.center, 
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 24),

                AuthTextField(
                  label: 'Email address*',
                  controller: emailCtrl,
                  validator: (v) => (v == null || v.isEmpty) ? "Entrez votre email" : null,
                ),
                const SizedBox(height: 14),
                
                AuthTextField(
                  label: 'Password*',
                  controller: passCtrl,
                  obscure: true,
                  validator: (v) => (v == null || v.isEmpty) ? "Entrez votre mot de passe" : null,
                ),

                const SizedBox(height: 20),
                GlowButton(
                  label: loading ? 'Chargement...' : 'Sign In',
                  onPressed: loading ? null : _handleLogin,
                ),
                
                // LIEN VERS REGISTER
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, RegisterScreen.routeName),
                  child: const Text("Don't have an account? Sign up", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}