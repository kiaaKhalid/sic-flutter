import 'package:flutter/material.dart';

/// Bouton de suppression moderne avec animations et gradient
/// 
/// Caractéristiques:
/// - Gradient rouge élégant (#FF7979 → #FF6B6B)
/// - Animation scale au hover (1.0 → 1.1)
/// - Animation de press (scale 0.9)
/// - Shadow douce qui s'intensifie au hover
/// - Dialog de confirmation optionnel
/// 
/// Utilisation:
/// ```dart
/// ModernDeleteButton(
///   onDelete: () => _handleDelete(patientId),
///   size: 40.0,              // Optionnel, défaut: 40.0
///   showConfirmation: true,  // Optionnel, défaut: true
/// )
/// ```
class ModernDeleteButton extends StatefulWidget {
  /// Callback appelé après confirmation de suppression
  final VoidCallback onDelete;
  
  /// Taille du bouton (largeur et hauteur)
  final double size;
  
  /// Si true, affiche un dialog de confirmation avant suppression
  final bool showConfirmation;
  
  const ModernDeleteButton({
    super.key,
    required this.onDelete,
    this.size = 40.0,
    this.showConfirmation = true,
  });

  @override
  State<ModernDeleteButton> createState() => _ModernDeleteButtonState();
}

class _ModernDeleteButtonState extends State<ModernDeleteButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.showConfirmation) {
      _showDeleteConfirmation();
    } else {
      widget.onDelete();
    }
  }

  Future<void> _showDeleteConfirmation() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6B6B), size: 28),
            SizedBox(width: 12),
            Text(
              'Confirmer la suppression',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer ce patient ?\nCette action est irréversible.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
        _controller.forward();
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
        _controller.reverse();
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isPressed
                    ? [const Color(0xFFFF4757), const Color(0xFFE84118)]
                    : _isHovered
                        ? [const Color(0xFFFF6B6B), const Color(0xFFFF5252)]
                        : [const Color(0xFFFF7979), const Color(0xFFFF6B6B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: AnimatedScale(
              scale: _isPressed ? 0.9 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: widget.size * 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Version compacte du bouton de suppression
/// 
/// Idéal pour intégration dans des cartes ou listes
/// Même style que ModernDeleteButton mais sans animations avancées
/// 
/// Utilisation:
/// ```dart
/// CompactDeleteButton(
///   onDelete: () => _onDeletePatient(patient.id),
///   showConfirmation: true,  // Optionnel, défaut: true
/// )
/// ```
class CompactDeleteButton extends StatelessWidget {
  /// Callback appelé après confirmation de suppression
  final VoidCallback onDelete;
  
  /// Si true, affiche un dialog de confirmation avant suppression
  final bool showConfirmation;
  
  const CompactDeleteButton({
    super.key,
    required this.onDelete,
    this.showConfirmation = true,
  });

  Future<void> _handleDelete(BuildContext context) async {
    if (showConfirmation) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6B6B), size: 28),
              SizedBox(width: 12),
              Text(
                'Confirmer la suppression',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer ce patient ?\nCette action est irréversible.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer'),
            ),
          ],
        ),
      );

      if (shouldDelete == true && context.mounted) {
        onDelete();
      }
    } else {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleDelete(context),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF7979), Color(0xFFFF6B6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
