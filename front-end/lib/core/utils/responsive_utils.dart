import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Tailles d'écran de référence (en dp)
  static const double _mobileMaxWidth = 600;
  static const double _tabletMaxWidth = 1200;
  
  // Vérifie si l'appareil est un téléphone
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileMaxWidth;
  }
  
  // Vérifie si l'appareil est une tablette
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileMaxWidth && width < _tabletMaxWidth;
  }
  
  // Vérifie si l'appareil est un desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletMaxWidth;
  }
  
  // Retourne le type d'appareil
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < _mobileMaxWidth) return DeviceType.mobile;
    if (width < _tabletMaxWidth) return DeviceType.tablet;
    return DeviceType.desktop;
  }
  
  // Calcule une taille réactive en fonction de la largeur de l'écran
  static double responsiveValue({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile * 1.5;
    if (isTablet(context)) return tablet ?? mobile * 1.2;
    return mobile;
  }
  
  // Calcule un padding réactif
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 24);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }
  
  // Calcule une taille de police réactive
  static double responsiveFontSize(BuildContext context, {required double baseSize}) {
    final width = MediaQuery.of(context).size.width;
    if (width > _tabletMaxWidth) return baseSize * 1.3;
    if (width > _mobileMaxWidth) return baseSize * 1.1;
    return baseSize;
  }
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}
