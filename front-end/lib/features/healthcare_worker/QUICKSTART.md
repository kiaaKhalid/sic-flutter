# Quick Start Guide - Healthcare Worker Feature

Guide de démarrage rapide pour les développeurs qui rejoignent le projet.

---

## 🚀 Démarrage Rapide (5 min)

### 1. Comprendre la Structure

```
lib/features/healthcare_worker/
├── 📖 README.md              ← LIRE EN PREMIER
├── 🏗️ ARCHITECTURE.md        ← Design patterns
├── 📝 CHANGELOG.md           ← Historique
├── ⚡ QUICKSTART.md          ← Ce fichier
├── constants.dart            ← Constantes centralisées
├── healthcare_worker.dart    ← Exports centralisés
├── domain/                   ← Modèles métier
└── presentation/             ← UI & widgets
```

### 2. Import Simplifié

```dart
// ✅ Méthode recommandée
import 'package:travel_auth_ui/features/healthcare_worker/healthcare_worker.dart';

// Tous les exports disponibles:
// - Patient, Alert, HealthData
// - HealthcareDashboardScreen
// - AddPatientDialog, CompactDeleteButton
// - Etc.
```

### 3. Lancer l'Interface

```dart
// main.dart
MaterialApp(
  home: HealthcareDashboardScreen(),
  // Ou avec route nommée:
  initialRoute: HealthcareRoutes.dashboard,
)
```

---

## 📋 Tâches Communes

### ✏️ Ajouter un Champ au Formulaire Patient

**Fichier:** `add_patient_dialog.dart`

```dart
// 1. Ajouter controller
final _emailController = TextEditingController();

// 2. Disposer le controller
@override
void dispose() {
  _emailController.dispose();
  super.dispose();
}

// 3. Ajouter le champ dans Column > children
TextFormField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: 'Email',
    prefixIcon: Icon(Icons.email_outlined),
  ),
  validator: (v) {
    if (v != null && v.isNotEmpty) {
      if (!HealthcareValidation.email.hasMatch(v)) {
        return HealthcareMessages.invalidEmail;
      }
    }
    return null;
  },
),

// 4. Passer dans AddPatientResult
AddPatientResult(
  // ... autres champs
  email: _emailController.text.trim().isEmpty 
      ? null 
      : _emailController.text.trim(),
)
```

### 🎨 Personnaliser les Couleurs

**Fichier:** `constants.dart`

```dart
class HealthcareColors {
  // Modifier les valeurs existantes
  static const int accentNeon = 0xFF00FF00; // Vert plus vif
  
  // Ou ajouter de nouvelles couleurs
  static const int warningYellow = 0xFFFFC107;
  static const int infoPurple = 0xFF9C27B0;
}
```

### 🔧 Modifier le Design d'une Carte Patient

**Fichier:** `healthcare_dashboard_screen.dart`  
**Méthode:** `_buildPatientCard(Patient patient)`

```dart
// Exemple: Ajouter un badge "VIP"
if (patient.isVip) {
  Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text('VIP', style: TextStyle(fontSize: 10)),
  ),
}
```

### 🗑️ Personnaliser le Bouton Delete

**Option 1: Changer la couleur**

```dart
// delete_button.dart - Ligne ~125
gradient: LinearGradient(
  colors: [Color(0xFFFF0000), Color(0xFFCC0000)], // Rouge plus foncé
)
```

**Option 2: Changer l'icône**

```dart
Icon(
  Icons.remove_circle_outline, // Au lieu de delete_outline_rounded
  color: Colors.white,
  size: widget.size * 0.5,
)
```

### 📊 Ajouter un Nouveau Type d'Alerte

**Fichier:** `alert.dart`

```dart
// 1. Ajouter dans enum
enum AlertType { health, medication, emergency, appointment } // Nouveau

// 2. Mettre à jour le getter icon
IconData get typeIcon {
  switch (type) {
    // ... cas existants
    case AlertType.appointment:
      return Icons.calendar_today_outlined;
  }
}

// 3. Créer données démo
Alert(
  id: 'alert-4',
  type: AlertType.appointment,
  priority: AlertPriority.medium,
  message: 'Rendez-vous demain à 10h',
  // ...
)
```

---

## 🐛 Debugging Commun

### ❌ "Provider Not Found"

**Symptôme:** Erreur lors navigation  
**Solution:** Vérifier que vous n'utilisez pas `PatientDetailScreen` directement

```dart
// ❌ Éviter
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => PatientDetailScreen(...))
);

// ✅ Utiliser
setState(() {
  _selectedPatient = patient;
  _selectedIndex = 1;
});
```

### ⚠️ "Cannot hit test a render box"

**Symptôme:** Dialog ne s'affiche pas  
**Solution:** Vérifier que vous utilisez `AlertDialog` et pas `Dialog`

```dart
// ❌ Éviter
Dialog(
  child: Expanded(child: ...) // Expanded cause le problème
)

// ✅ Utiliser
AlertDialog(
  content: SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min, // Important!
      children: [...]
    )
  )
)
```

### 🔍 "Validation Failed"

**Symptôme:** Formulaire ne se soumet pas  
**Solution:** Vérifier les validators et FormKey

```dart
// S'assurer que:
final _formKey = GlobalKey<FormState>(); // ✅ Déclaré

Form(
  key: _formKey, // ✅ Assigné
  child: ...
)

if (_formKey.currentState!.validate()) { // ✅ Appelé
  // Soumettre
}
```

---

## 🎯 Snippets Utiles

### Créer un Nouveau Screen

```dart
import 'package:flutter/material.dart';
import 'package:travel_auth_ui/features/healthcare_worker/healthcare_worker.dart';

class MyNewScreen extends StatefulWidget {
  static const String routeName = '/my-screen';
  
  const MyNewScreen({super.key});

  @override
  State<MyNewScreen> createState() => _MyNewScreenState();
}

class _MyNewScreenState extends State<MyNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: const Center(child: Text('Hello')),
    );
  }
}
```

### Afficher un SnackBar de Succès

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 12),
        Text(HealthcareMessages.patientAdded),
      ],
    ),
    backgroundColor: Color(HealthcareColors.statusStable),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(HealthcareSpacing.radiusMedium),
    ),
    duration: Duration(seconds: 3),
  ),
);
```

### Vérifier si Mobile/Desktop

```dart
bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < HealthcareSpacing.mobileBreakpoint;
}

bool isTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width >= HealthcareSpacing.mobileBreakpoint && 
         width < HealthcareSpacing.tabletBreakpoint;
}

bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width >= HealthcareSpacing.tabletBreakpoint;
}
```

---

## 📚 Resources

### Fichiers Importants à Connaître

| Fichier | Quand l'utiliser |
|---------|------------------|
| `README.md` | Vue d'ensemble complète |
| `ARCHITECTURE.md` | Comprendre les choix de design |
| `constants.dart` | Ajouter/modifier des constantes |
| `healthcare_worker.dart` | Import centralisé |
| `add_patient_dialog.dart` | Modifier formulaire patient |
| `delete_button.dart` | Personnaliser bouton suppression |
| `healthcare_dashboard_screen.dart` | Modifier l'UI principale |

### Commandes Utiles

```bash
# Lancer l'app
flutter run -d chrome

# Hot reload
r

# Hot restart
R

# Analyser le code
flutter analyze

# Formatter le code
flutter format lib/

# Vérifier les dépendances
flutter pub outdated
```

### Conventions de Code

```dart
// ✅ Bon
class PatientCard extends StatelessWidget { ... }    // PascalCase classes
const String apiUrl = '...';                         // camelCase variables
void _privateMethod() { ... }                        // Underscore privé
static const int value = 10;                         // const si possible

// ❌ Éviter
class patient_card extends StatelessWidget { ... }   // Pas snake_case
String ApiUrl = '...';                               // Pas PascalCase vars
void PublicMethod() { ... }                          // Pas PascalCase méthodes
```

---

## ✅ Checklist Avant Commit

- [ ] Code formaté (`flutter format .`)
- [ ] Aucune erreur d'analyse (`flutter analyze`)
- [ ] Imports organisés et inutilisés supprimés
- [ ] Commentaires ajoutés pour logique complexe
- [ ] Constantes utilisées au lieu de valeurs hardcodées
- [ ] Tests ajoutés si nouvelle feature importante
- [ ] README/CHANGELOG mis à jour si changement majeur
- [ ] Hot reload testé et fonctionnel

---

## 🆘 Besoin d'Aide?

1. **Consulter la documentation:**
   - README.md pour la structure
   - ARCHITECTURE.md pour les patterns
   - Code inline comments

2. **Chercher dans le code:**
   ```bash
   # Trouver tous les usages d'une classe
   grep -r "AddPatientDialog" lib/
   
   # Trouver une constante
   grep -r "accentNeon" lib/
   ```

3. **Debugging:**
   - Ajouter `print()` statements
   - Utiliser Flutter DevTools
   - Vérifier la console pour erreurs

4. **Ressources externes:**
   - [Flutter Documentation](https://docs.flutter.dev)
   - [Dart Documentation](https://dart.dev/guides)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

**Happy Coding! 🚀**

*Dernière mise à jour: 11 Novembre 2025*
