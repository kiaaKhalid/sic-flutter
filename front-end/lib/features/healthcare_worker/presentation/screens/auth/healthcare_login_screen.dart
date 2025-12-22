import 'package:flutter/material.dart';
import 'package:travel_auth_ui/app/router/app_router.dart';
import 'package:travel_auth_ui/features/healthcare_worker/presentation/screens/dashboard/healthcare_dashboard_screen.dart';

class HealthcareLoginScreen extends StatefulWidget {
  const HealthcareLoginScreen({super.key});

  @override
  State<HealthcareLoginScreen> createState() => _HealthcareLoginScreenState();
}

class _HealthcareLoginScreenState extends State<HealthcareLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simuler un délai de connexion
    // await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Static login check
      if ((email == 'patient@admin.com' || email == 'doc@gmail.com') && password == '123456') {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HealthcareDashboardScreen()),
        );
        return;
      }
      
      // Fallback or error simulation (optional)
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);
      // For now, fail or just show error if not matching static creds
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identifiants invalides')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1), // Deep Blue
              Color(0xFF00ACC1), // Cyan/Teal accents
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Section
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE1F5FE),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF0277BD), width: 2),
                                ),
                                child: const Icon(
                                  Icons.local_hospital_rounded,
                                  size: 48,
                                  color: Color(0xFF0277BD),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Portail Pro',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF01579B),
                                      letterSpacing: 0.5,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Accès sécurisé réservé au personnel soignant',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),

                          // Champ email
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              labelText: 'Identifiant Professionnel',
                              hintText: 'ex: doc@gmail.com',
                              prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF0277BD)),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF0277BD), width: 2),
                              ),
                              floatingLabelStyle: const TextStyle(color: Color(0xFF0277BD)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Champ mot de passe
                          TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0277BD)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF0277BD), width: 2),
                              ),
                              floatingLabelStyle: const TextStyle(color: Color(0xFF0277BD)),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requis';
                              }
                              return null;
                            },
                          ),
                          
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO
                              },
                              child: Text(
                                'Problème de connexion ?',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Bouton de connexion
                          ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0277BD),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFF0277BD).withOpacity(0.4),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'ACCÉDER AU PORTAIL',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                          
                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 16),

                          // Bascule vers l'interface patient
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, AppRouter.login);
                            },
                            icon: const Icon(Icons.arrow_back, size: 16),
                            label: const Text('Retour à l\'application patient'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
