/// Validation utilities for form fields
/// Provides comprehensive validation for registration and authentication forms

class Validators {
  // Regular expressions for validation
  static final RegExp _nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _lowercaseRegex = RegExp(r'[a-z]');
  static final RegExp _digitRegex = RegExp(r'[0-9]');
  static final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  // Common email domains for basic verification
  static final List<String> _validDomains = [
    'gmail.com',
    'yahoo.com',
    'outlook.com',
    'hotmail.com',
    'icloud.com',
    'protonmail.com',
    'aol.com',
    'mail.com',
    'zoho.com',
    'yandex.com',
  ];

  /// Validates full name
  /// Requirements:
  /// - Not empty
  /// - Between 2 and 50 characters
  /// - Only letters and spaces allowed
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom complet est requis';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }

    if (trimmedValue.length > 50) {
      return 'Le nom ne peut pas dépasser 50 caractères';
    }

    if (!_nameRegex.hasMatch(trimmedValue)) {
      return 'Le nom ne peut contenir que des lettres et des espaces';
    }

    return null;
  }

  /// Validates email address
  /// Requirements:
  /// - Not empty
  /// - Valid email format
  /// - Valid domain (basic check)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    final trimmedValue = value.trim().toLowerCase();

    if (!_emailRegex.hasMatch(trimmedValue)) {
      return 'Format d\'email invalide';
    }

    // Extract domain
    final parts = trimmedValue.split('@');
    if (parts.length != 2) {
      return 'Format d\'email invalide';
    }

    final domain = parts[1];

    // Check if domain has at least one dot
    if (!domain.contains('.')) {
      return 'Domaine email invalide';
    }

    // Check for common valid domains or proper domain format
    final domainParts = domain.split('.');
    if (domainParts.any((part) => part.isEmpty)) {
      return 'Domaine email invalide';
    }

    // Optional: Check against common domains (can be removed for more flexibility)
    final isCommonDomain = _validDomains.contains(domain);
    final hasValidTLD = domainParts.last.length >= 2;

    if (!isCommonDomain && !hasValidTLD) {
      return 'Domaine email non reconnu. Veuillez utiliser un email valide';
    }

    return null;
  }

  /// Validates password
  /// Requirements:
  /// - Not empty
  /// - At least 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  /// - At least one special character
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }

    if (!_uppercaseRegex.hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }

    if (!_lowercaseRegex.hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }

    if (!_digitRegex.hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }

    if (!_specialCharRegex.hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un caractère spécial (!@#\$%^&*(),.?":{}|<>)';
    }

    return null;
  }

  /// Validates password confirmation
  /// Requirements:
  /// - Not empty
  /// - Matches the original password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }

    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  /// Validates terms acceptance
  /// Requirements:
  /// - Must be true (checked)
  static String? validateTermsAcceptance(bool? value) {
    if (value == null || !value) {
      return 'Vous devez accepter les conditions d\'utilisation';
    }

    return null;
  }

  /// Helper method to check password strength
  /// Returns a value from 0 to 4 indicating password strength
  static int getPasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++;
    if (_uppercaseRegex.hasMatch(password)) strength++;
    if (_lowercaseRegex.hasMatch(password)) strength++;
    if (_digitRegex.hasMatch(password)) strength++;
    if (_specialCharRegex.hasMatch(password)) strength++;

    return strength;
  }

  /// Helper method to get password strength label
  static String getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Très faible';
      case 2:
        return 'Faible';
      case 3:
        return 'Moyen';
      case 4:
        return 'Fort';
      case 5:
        return 'Très fort';
      default:
        return 'Inconnu';
    }
  }
}
