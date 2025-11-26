import 'package:flutter/material.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

class MoodDeclarationScreen extends StatefulWidget {
  static const String routeName = '/mood-declaration';
  
  final VoidCallback? onBack;
  
  const MoodDeclarationScreen({
    super.key,
    this.onBack,
  });

  @override
  State<MoodDeclarationScreen> createState() => _MoodDeclarationScreenState();
}

class _MoodDeclarationScreenState extends State<MoodDeclarationScreen> {
  String? _selectedMood;
  final TextEditingController _noteController = TextEditingController();
  bool _isSubmitting = false;
  
  // Liste des émotions avec leurs icônes et libellés
  final List<Map<String, String>> _emotions = [
    {'emoji': '😊', 'label': 'Heureux', 'value': 'happy'},
    {'emoji': '😌', 'label': 'Calme', 'value': 'calm'},
    {'emoji': '😟', 'label': 'Anxieux', 'value': 'anxious'},
    {'emoji': '😢', 'label': 'Triste', 'value': 'sad'},
    {'emoji': '😡', 'label': 'En colère', 'value': 'angry'},
    {'emoji': '😴', 'label': 'Fatigué', 'value': 'tired'},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Déclarer mon humeur',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre et sous-titre
              const Text(
                'Comment vous sentez-vous aujourd\'hui ?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sélectionnez une émotion qui correspond à votre état d\'esprit',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Grille d'émotions
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _emotions.length,
                itemBuilder: (context, index) {
                  final emotion = _emotions[index];
                  final isSelected = _selectedMood == emotion['value'];
                  
                  return _buildEmotionItem(
                    emoji: emotion['emoji']!,
                    label: emotion['label']!,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedMood = emotion['value']!;
                      });
                    },
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Zone de note
              const Text(
                'Note (optionnelle)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 4,
                maxLength: 200,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Décrivez ce que vous ressentez...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  counterStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Bouton d'enregistrement
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neon,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Enregistrer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmotionItem({
    required String emoji,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.neon.withOpacity(0.1) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.neon : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.neon : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleSubmit() {
    if (_selectedMood == null) {
      _showError('Veuillez sélectionner une émotion');
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    // Simuler un délai de traitement
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      setState(() {
        _isSubmitting = false;
      });
      
      // Afficher la confirmation
      _showSuccess('Humeur enregistrée avec succès!');
      
      // Revenir en arrière après un court délai
      Future.delayed(const Duration(seconds: 1), () {
        if (widget.onBack != null) {
          widget.onBack!();
        } else if (mounted) {
          Navigator.of(context).pop();
        }
      });
    });
  }
  
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  
  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
