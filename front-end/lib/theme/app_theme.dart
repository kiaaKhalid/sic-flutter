import 'package:flutter/material.dart';
import 'package:travel_auth_ui/core/utils/responsive_utils.dart';

class AppTheme {
  // Couleurs
  static const Color bg = Color(0xFF0C0C0C);
  static const Color neon = Color(0xFFD7F759);
  static const Color card = Color(0xFF141414);
  static const Color textDim = Color(0xFF9BA3A7);
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Tailles de police de base
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeXXXLarge = 32.0;

  // Espacements
  static const double spacingXXS = 4.0;
  static const double spacingXS = 8.0;
  static const double spacingS = 12.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Rayons de bordure
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;
  static const double borderRadiusXL = 16.0;
  static const double borderRadiusXXL = 24.0;

  // Hauteurs et largeurs
  static const double buttonHeight = 48.0;
  static const double inputFieldHeight = 52.0;
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // Durées d'animation
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Thème sombre par défaut
  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: bg,
      primaryColor: neon,
      colorScheme: const ColorScheme.dark(
        primary: neon,
        secondary: neon,
        surface: card,
        onSurface: Colors.white,
        error: error,
        onError: Colors.white,
      ),
      // Thème du texte
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSizeXXXLarge,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: fontSizeXXLarge,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: fontSizeXLarge,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSizeLarge,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSizeMedium,
          color: textDim,
        ),
        bodySmall: TextStyle(
          fontSize: fontSizeSmall,
          color: textDim,
        ),
      ),
      // Thème des champs de saisie
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F0F0F),
        hintStyle: const TextStyle(color: textDim),
        labelStyle: const TextStyle(color: textDim),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: Color(0xFF1F1F1F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: neon, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: error, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS,
        ),
      ),
      // Thème des boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neon,
          foregroundColor: Colors.black,
          minimumSize: const Size(0, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusL),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(vertical: spacingS, horizontal: spacingM),
        ),
      ),
      // Thème des cartes
      cardTheme: ThemeData.dark().cardTheme.copyWith(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      // Thème des dialogs pour assurer leur visibilité
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
        ),
        elevation: 24,
      ),
      // Thème des popups et menus
      popupMenuTheme: PopupMenuThemeData(
        color: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
        ),
      ),
    );
  }

  // Méthodes utilitaires pour les styles réactifs
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    return ResponsiveUtils.responsiveValue(
      context: context,
      mobile: baseSize,
      tablet: baseSize * 1.1,
      desktop: baseSize * 1.3,
    );
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    return ResponsiveUtils.responsivePadding(context);
  }

  static double getResponsiveIconSize(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context: context,
      mobile: iconSizeM,
      tablet: iconSizeL,
      desktop: iconSizeXL,
    );
  }
}
