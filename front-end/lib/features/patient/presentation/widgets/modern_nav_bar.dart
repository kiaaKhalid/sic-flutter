import 'package:flutter/material.dart';
import 'package:travel_auth_ui/core/utils/responsive_utils.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

// Constantes pour la barre de navigation
class NavConstants {
  // Hauteurs minimales et maximales
  static const double minNavBarHeight = 60.0;
  static const double maxNavBarHeight = 100.0;
  
  // Tailles d'icônes
  static const double minIconSize = 20.0;
  static const double maxIconSize = 28.0;
  
  // Tailles de police
  static const double minFontSize = 10.0;
  static const double maxFontSize = 14.0;
  
  // Largeurs d'éléments
  static const double minItemWidth = 60.0;
  static const double maxItemWidth = 160.0;
  
  // Espacements
  static const double itemSpacing = 8.0;
  static const double itemPadding = 8.0;
  static const double indicatorHeight = 3.0;
  
  // Seuils de largeur d'écran
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
}

// Thème de la barre de navigation
class NavTheme {
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color primary = AppTheme.neon;
  static const Color onPrimary = Colors.black;
  static const Color secondary = Color(0xFF646464);
  static const Color onSurface = Colors.white;
  static const double elevation = 8.0;
  static const double borderRadius = 20.0;
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Curve animationCurve = Curves.easeInOutCubic;
  
  // Méthode pour obtenir la hauteur de la barre de navigation en fonction du contexte
  static double getNavBarHeight(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context: context,
      mobile: NavConstants.minNavBarHeight,
      tablet: NavConstants.minNavBarHeight * 1.2,
      desktop: NavConstants.maxNavBarHeight,
    );
  }
  
  // Méthode pour obtenir la taille des icônes en fonction du contexte
  static double getIconSize(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context: context,
      mobile: NavConstants.minIconSize,
      tablet: NavConstants.minIconSize * 1.2,
      desktop: NavConstants.maxIconSize,
    );
  }
  
  // Méthode pour obtenir la taille de la police en fonction du contexte
  static double getFontSize(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context: context,
      mobile: NavConstants.minFontSize,
      tablet: NavConstants.minFontSize * 1.2,
      desktop: NavConstants.maxFontSize,
    );
  }
  
  // Méthode pour obtenir la largeur d'élément en fonction du contexte
  static double getItemWidth(BuildContext context, int itemCount) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < NavConstants.mobileBreakpoint) {
      return screenWidth / itemCount;
    } else if (screenWidth < NavConstants.tabletBreakpoint) {
      return NavConstants.minItemWidth * 1.2;
    } else if (screenWidth < NavConstants.desktopBreakpoint) {
      return NavConstants.minItemWidth * 1.5;
    } else {
      return NavConstants.maxItemWidth;
    }
  }
}

// Dimensions adaptatives
class NavDimensions {
  final double height;
  final double iconSize;
  final double fontSize;
  final double itemSpacing;
  final double itemPadding;
  final double indicatorHeight;
  final double itemWidth;
  final double maxWidth;
  final bool showLabels;

  const NavDimensions({
    required this.height,
    required this.iconSize,
    required this.fontSize,
    required this.itemSpacing,
    required this.itemPadding,
    required this.indicatorHeight,
    required this.itemWidth,
    required this.maxWidth,
    required this.showLabels,
  });

  factory NavDimensions.adaptive(BuildContext context, {bool forceShowLabels = false}) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    
    // Vérifier si on est sur un écran large
    final isWideScreen = width >= NavConstants.tabletBreakpoint;
    
    // Déterminer si on affiche les labels
    final showLabels = forceShowLabels || isWideScreen;
    
    // Obtenir les dimensions réactives
    final navBarHeight = NavTheme.getNavBarHeight(context);
    final iconSize = NavTheme.getIconSize(context);
    final fontSize = NavTheme.getFontSize(context);
    
    // Calculer la largeur d'élément en fonction du nombre d'éléments
    const navItemCount = 4; // Nombre d'éléments dans la barre de navigation
    final itemWidth = NavTheme.getItemWidth(context, navItemCount);
    
    return NavDimensions(
      height: navBarHeight,
      iconSize: iconSize,
      fontSize: fontSize,
      itemSpacing: NavConstants.itemSpacing,
      itemPadding: NavConstants.itemPadding,
      indicatorHeight: NavConstants.indicatorHeight,
      itemWidth: itemWidth,
      maxWidth: NavConstants.desktopBreakpoint,
      showLabels: showLabels,
    );
  }
}

class ModernNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;
  final String patientName;
  final bool forceShowLabels;
  final bool showAvatar;

  const ModernNavBar({
    super.key,
    required this.currentIndex,
    required this.patientName,
    required this.onItemTapped,
    this.forceShowLabels = false,
    this.showAvatar = true,
  });

  @override
  _ModernNavBarState createState() => _ModernNavBarState();
  
  // Méthode statique pour obtenir la hauteur de la barre de navigation
  static double getNavBarHeight(BuildContext context) {
    return NavTheme.getNavBarHeight(context) + MediaQuery.of(context).padding.bottom;
  }
}

class _ModernNavBarState extends State<ModernNavBar> {
  // Liste des éléments de navigation
  List<NavItem> _getNavItems() {
    return const [
      NavItem(icon: Icons.dashboard_rounded, label: 'Accueil'),
      NavItem(icon: Icons.monitor_heart_outlined, label: 'Santé'),
      NavItem(icon: Icons.mood_outlined, label: 'Humeur'),
      NavItem(icon: Icons.settings_outlined, label: 'Paramètres'),
    ];
  }

  // La méthode _onItemTapped a été supprimée car elle n'est pas utilisée
  // La gestion du clic est directement gérée dans le widget _NavItem
  
  // Gestion des icônes actives/inactives
  IconData _getActiveIcon(IconData icon) {
    // Utilisation de la propriété codePoint pour comparer les icônes
    if (icon.codePoint == Icons.dashboard_outlined.codePoint) {
      return Icons.dashboard_rounded;
    } else if (icon.codePoint == Icons.monitor_heart_outlined.codePoint) {
      return Icons.monitor_heart_rounded;
    } else if (icon.codePoint == Icons.mood_outlined.codePoint) {
      return Icons.mood_rounded;
    } else if (icon.codePoint == Icons.settings_outlined.codePoint) {
      return Icons.settings_rounded;
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = ResponsiveUtils.isDesktop(context);
    
    // Obtenir les dimensions adaptatives
    final dimensions = NavDimensions.adaptive(
      context,
      forceShowLabels: widget.forceShowLabels,
    );
    
    // Créer le contenu de la barre de navigation
    final content = _buildNavContent(context, dimensions, isLargeScreen);
    
    // Si c'est un grand écran, afficher l'avatar
    if (isLargeScreen) {
      return Container(
        width: double.infinity,
        color: NavTheme.background,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dimensions.maxWidth,
            ),
            child: content,
          ),
        ),
      );
    }
    
    // Pour les appareils mobiles/tablettes, ajouter un padding en bas pour éviter les débordements
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: content,
    );
  }
    
  Widget _buildNavContent(
    BuildContext context, 
    NavDimensions dimensions,
    bool isLargeScreen,
  ) {
    final showLabels = dimensions.showLabels;
    final navItems = _getNavItems();
    
    return Container(
      decoration: BoxDecoration(
        color: NavTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51), // 20% opacity
            blurRadius: NavTheme.elevation,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      // Hauteur fixe pour éviter les variations de hauteur
      height: dimensions.height + MediaQuery.of(context).padding.bottom,
      child: SafeArea(
        top: false,
        bottom: !isLargeScreen,
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barre supérieure avec logo et avatar (uniquement sur desktop/tablette)
            if (!isLargeScreen)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: dimensions.itemPadding * 1.5,
                  vertical: dimensions.itemSpacing * 2,
                ),
                child: Row(
                  children: [
                    const Text(
                      'HealthApp',
                      style: TextStyle(
                        color: NavTheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    _UserAvatar(
                      patientName: widget.patientName,
                      size: dimensions.iconSize * 1.5,
                    ),
                  ],
                ),
              ),
            
            // Barre de navigation principale
            Container(
              height: dimensions.height,
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? dimensions.itemPadding : dimensions.itemSpacing,
                vertical: dimensions.itemSpacing * 0.5,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: NavTheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(NavTheme.borderRadius),
                    topRight: const Radius.circular(NavTheme.borderRadius),
                    bottomLeft: isLargeScreen 
                        ? const Radius.circular(NavTheme.borderRadius) 
                        : Radius.zero,
                    bottomRight: isLargeScreen 
                        ? const Radius.circular(NavTheme.borderRadius) 
                        : Radius.zero,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Logo sur grand écran
                    if (isLargeScreen) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: dimensions.itemPadding),
                        child: const Text(
                          'HealthApp',
                          style: TextStyle(
                            color: NavTheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                    
                    // Éléments de navigation
                    Expanded(
                      flex: isLargeScreen ? 0 : 1,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: isLargeScreen 
                                    ? navItems.length * dimensions.itemWidth 
                                    : constraints.maxWidth,
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(navItems.length, (index) {
                                    final item = navItems[index];
                                    final isSelected = widget.currentIndex == index;
                                    
                                    return SizedBox(
                                      width: dimensions.itemWidth,
                                      child: _NavItem(
                                        icon: isSelected 
                                            ? _getActiveIcon(item.icon) 
                                            : item.icon,
                                        label: showLabels ? item.label : '',
                                        isSelected: isSelected,
                                        onTap: () => widget.onItemTapped(index),
                                        dimensions: dimensions,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Espacement et avatar
                    if (!isLargeScreen) ...[
                      // Séparateur
                      Container(
                        width: 1,
                        height: dimensions.height * 0.4,
                        margin: EdgeInsets.symmetric(horizontal: dimensions.itemSpacing * 0.5),
                        color: NavTheme.secondary.withAlpha(77), // 30% opacity
                      ),
                      
                      // Avatar utilisateur
                      if (widget.showAvatar)
                        _UserAvatar(
                          patientName: widget.patientName,
                          isMobile: true,
                          size: dimensions.iconSize * 1.5,
                        ),
                      
                      SizedBox(width: dimensions.itemSpacing * 0.5),
                    ] else if (widget.showAvatar) ...[
                      const Spacer(),
                      _UserAvatar(
                        patientName: widget.patientName,
                        isMobile: false,
                        size: dimensions.iconSize * 1.5,
                      ),
                      SizedBox(width: dimensions.itemSpacing),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modèle pour les éléments de navigation
class NavItem {
  final IconData icon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
  });
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final NavDimensions dimensions;
  
  // Animation de l'icône
  static final Tween<double> _opacityTween = Tween<double>(
    begin: 0.7,
    end: 1.0,
  );

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.dimensions,
  });

  @override
  Widget build(BuildContext context) {
    final hasLabel = label.isNotEmpty;
    final isLargeScreen = ResponsiveUtils.isDesktop(context);
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {},
      onExit: (_) {},
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: NavTheme.animationDuration,
          curve: NavTheme.animationCurve,
          margin: EdgeInsets.symmetric(
            horizontal: isLargeScreen 
                ? dimensions.itemSpacing * 0.3 
                : dimensions.itemSpacing * 0.5,
            vertical: isLargeScreen 
                ? dimensions.itemSpacing * 0.3 
                : dimensions.itemSpacing * 0.5,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen 
                ? dimensions.itemPadding * 0.5 
                : hasLabel 
                    ? dimensions.itemPadding * 0.8 
                    : dimensions.itemPadding * 0.6,
            vertical: isLargeScreen 
                ? dimensions.itemPadding * 0.4 
                : dimensions.itemPadding * 0.6,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? NavTheme.primary.withOpacity(0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(NavTheme.borderRadius * 0.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône avec animation
              TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: isSelected ? 1.0 : 0.0,
                  end: isSelected ? 1.0 : 0.0,
                ),
                duration: NavTheme.animationDuration,
                curve: NavTheme.animationCurve,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: _opacityTween.transform(value),
                    child: Transform.scale(
                      scale: 1.0 + (0.1 * value),
                      child: child,
                    ),
                  );
                },
                child: AnimatedSwitcher(
                  duration: NavTheme.animationDuration ~/ 2,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    icon,
                    key: ValueKey('$icon-$isSelected'),
                    color: isSelected 
                        ? NavTheme.primary 
                        : NavTheme.onSurface.withOpacity(0.7),
                    size: dimensions.iconSize,
                  ),
                ),
              ),
              
              // Texte du label
              if (hasLabel) ...[
                SizedBox(height: dimensions.itemSpacing * 0.3),
                AnimatedDefaultTextStyle(
                  duration: NavTheme.animationDuration ~/ 2,
                  style: TextStyle(
                    color: isSelected 
                        ? NavTheme.primary 
                        : NavTheme.onSurface.withOpacity(0.8),
                    fontSize: dimensions.fontSize,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.3,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              
              // Indicateur de sélection
              AnimatedContainer(
                duration: NavTheme.animationDuration,
                curve: NavTheme.animationCurve,
                margin: EdgeInsets.only(
                  top: hasLabel 
                      ? dimensions.itemSpacing * 0.3 
                      : dimensions.itemSpacing * 0.5,
                ),
                height: isSelected ? dimensions.indicatorHeight : 0,
                width: dimensions.iconSize * (isLargeScreen ? 0.8 : 0.6),
                decoration: BoxDecoration(
                  color: NavTheme.primary,
                  borderRadius: BorderRadius.circular(dimensions.indicatorHeight),
                  boxShadow: [
                    BoxShadow(
                      color: NavTheme.secondary.withAlpha(128), // 50% opacity
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String patientName;
  final bool isMobile;
  final double size;

  const _UserAvatar({
    required this.patientName,
    this.isMobile = false,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Action lors du clic sur l'avatar
      },
      child: AnimatedContainer(
        duration: NavTheme.animationDuration,
        curve: NavTheme.animationCurve,
        padding: EdgeInsets.all(size * 0.1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              NavTheme.primary,
              NavTheme.primary.withBlue(200),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: NavTheme.primary.withAlpha(102), // 40% opacity
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(size * 0.1),
          decoration: BoxDecoration(
            color: NavTheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: NavTheme.secondary.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: CircleAvatar(
            radius: size * 0.35,
            backgroundColor: Colors.transparent,
            child: Text(
              patientName.isNotEmpty ? patientName[0].toUpperCase() : 'U',
              style: TextStyle(
                color: NavTheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.5,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
