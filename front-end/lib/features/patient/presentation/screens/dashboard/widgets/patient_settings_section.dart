import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';
import '../../settings/edit_profile_screen.dart';
import '../../settings/change_password_screen.dart';

class PatientSettingsSection extends StatefulWidget {
  const PatientSettingsSection({super.key});

  @override
  State<PatientSettingsSection> createState() => _PatientSettingsSectionState();
}

class _PatientSettingsSectionState extends State<PatientSettingsSection> {
  bool _medicationReminders = true;
  bool _healthAlerts = true;
  bool _ecoMode = false;
  bool _biometricAuth = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paramètres',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Mon Compte'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Modifier mon profil',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Changer mot de passe',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
              );
            },
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            title: 'Rappels de médicaments',
            value: _medicationReminders,
            onChanged: (val) => setState(() => _medicationReminders = val),
          ),
          _buildSwitchTile(
            title: 'Alertes santé critiques',
            value: _healthAlerts,
            onChanged: (val) => setState(() => _healthAlerts = val),
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Sécurité & Apparence'),
          _buildSwitchTile(
            title: 'Authentification biométrique',
            subtitle: 'FaceID / TouchID',
            value: _biometricAuth,
            onChanged: (val) => setState(() => _biometricAuth = val),
          ),
          _buildSwitchTile(
            title: 'Mode économie d\'énergie',
            value: _ecoMode,
            onChanged: (val) => setState(() => _ecoMode = val),
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('A propos'),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Conditions d\'utilisation',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Politique de confidentialité',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'Version de l\'application',
            trailing: Text(
              '1.0.2', 
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            onTap: null,
          ),
          
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement logout logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Déconnexion...')),
                );
                Navigator.of(context).pushReplacementNamed('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C1E1E),
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: const Text(
                'Se déconnecter',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppTheme.neon.withOpacity(0.8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.white30, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        activeColor: AppTheme.neon,
        activeTrackColor: AppTheme.neon.withOpacity(0.3),
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.white.withOpacity(0.1),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        subtitle: subtitle != null 
          ? Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)) 
          : null,
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
