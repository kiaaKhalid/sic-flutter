import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:travel_auth_ui/features/healthcare_worker/presentation/screens/dashboard/healthcare_dashboard_screen.dart';
import 'package:travel_auth_ui/features/patient/presentation/screens/dashboard/patient_dashboard_screen.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Role to Verify',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildButton(context, 'Patient Dashboard', const PatientDashboardScreen(), Colors.blue),
            const SizedBox(height: 16),
            _buildButton(context, 'Healthcare Dashboard', const HealthcareDashboardScreen(), Colors.green),
            const SizedBox(height: 16),
            _buildButton(context, 'Admin Dashboard', const AdminDashboardScreen(), Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Widget screen, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}
