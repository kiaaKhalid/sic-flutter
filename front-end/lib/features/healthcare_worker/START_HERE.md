# 🚀 BIENVENUE - Healthcare Worker Feature

## 📚 Par Où Commencer?

Vous venez de rejoindre le projet? Suivez ce guide étape par étape!

---

## 🎯 Lecture Recommandée (dans cet ordre)

### 1️⃣ **README.md** (10 min) 
📖 Vue d'ensemble complète de la feature
- Structure du module
- Écrans principaux
- Modèles de données
- Thème & design

### 2️⃣ **QUICKSTART.md** (5 min)
⚡ Guide de démarrage rapide
- Import simplifiés
- Tâches communes
- Snippets utiles
- Debugging

### 3️⃣ **ARCHITECTURE.md** (15 min)
🏗️ Comprendre les choix techniques
- Principes architecturaux
- Patterns utilisés
- Flux de données
- Préparation backend

### 4️⃣ **STRUCTURE.md** (5 min)
📂 Carte complète des fichiers
- Arbre visuel
- Relations entre fichiers
- Points d'entrée

### 5️⃣ **CODE_QUALITY.md** (optionnel)
📊 État de la qualité du code
- Issues connues
- Plan d'action
- Score qualité

### 6️⃣ **CHANGELOG.md** (optionnel)
📝 Historique des changements
- Versions
- Features ajoutées
- Bugs corrigés

---

## 🎨 Fichiers Principaux à Connaître

### 🔧 Configuration

| Fichier | Description | Quand l'utiliser |
|---------|-------------|------------------|
| `constants.dart` | Couleurs, routes, validation, messages | Ajouter constantes, changer thème |
| `healthcare_worker.dart` | Exports centralisés | Importer la feature ailleurs |

### 📱 Screens (UI Complètes)

| Fichier | Description | Fonctionnalités |
|---------|-------------|-----------------|
| `healthcare_dashboard_screen.dart` | **Dashboard principal** | Liste patients, Détails, Alertes, CRUD |
| `add_patient_dialog.dart` | Dialog création patient | Formulaire avec validation |
| `patient_detail_screen.dart` | Détails complets patient | Métriques santé (nécessite Provider) |

### 🧩 Widgets (Réutilisables)

| Fichier | Description | Utilisation |
|---------|-------------|-------------|
| `delete_button.dart` | Bouton suppression moderne | `CompactDeleteButton(onDelete: ...)` |
| `kpi_card.dart` | Carte indicateur | Afficher métriques |
| `health_chart.dart` | Graphiques santé | Visualisation données |

### 📊 Modèles

| Fichier | Description | Contient |
|---------|-------------|----------|
| `patient.dart` | Modèle Patient | Données patient + démo |
| `alert.dart` | Modèle Alert | Alertes médicales + démo |
| `health_data.dart` | Données santé | Métriques + démo |

---

## 🛠️ Setup Local (5 min)

### 1. Cloner & Installer

```bash
# Cloner le repo
git clone <repo-url>
cd front-end

# Installer dépendances
flutter pub get

# Vérifier setup
flutter doctor
```

### 2. Lancer l'App

```bash
# Chrome (recommandé pour dev)
flutter run -d chrome

# Android Emulator
flutter run -d <emulator-id>

# iOS Simulator (Mac uniquement)
flutter run -d ios
```

### 3. Vérifier que ça Marche

✅ Le dashboard s'affiche  
✅ La liste de 4 patients est visible  
✅ Le bouton ➕ ouvre le dialog  
✅ Les boutons 🗑️ rouges sont cliquables  

---

## 💡 Premiers Pas Pratiques

### Exercice 1: Changer une Couleur (2 min)

**Objectif:** Se familiariser avec `constants.dart`

```dart
// constants.dart - Ligne ~15
static const int accentNeon = 0xFFD7F759; // Vert actuel

// Changer pour bleu
static const int accentNeon = 0xFF00BFFF; 
```

**Hot Reload** (touche `r`) → Voir le changement instantané!

### Exercice 2: Ajouter un Champ (10 min)

**Objectif:** Modifier le formulaire patient

**Fichier:** `add_patient_dialog.dart`

```dart
// 1. Ajouter controller (ligne ~44)
final _phoneController = TextEditingController();

// 2. Disposer (ligne ~57)
_phoneController.dispose();

// 3. Ajouter champ (après le champ Email, ligne ~150)
TextFormField(
  controller: _phoneController,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    labelText: 'Téléphone',
    prefixIcon: Icon(Icons.phone_outlined),
  ),
),

// 4. Retourner dans result (ligne ~90)
phone: _phoneController.text.trim(),
```

**Tester:** FAB → Remplir → Créer → Vérifier console

### Exercice 3: Personnaliser un Widget (5 min)

**Objectif:** Modifier le design d'une carte patient

**Fichier:** `healthcare_dashboard_screen.dart`  
**Méthode:** `_buildPatientCard` (ligne ~95)

```dart
// Exemple: Ajouter un badge "Nouveau"
if (patient.isNew) { // Supposant qu'on ajoute cette propriété
  Container(
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text('NOUVEAU', style: TextStyle(fontSize: 10)),
  )
}
```

---

## 🎓 Concepts Clés à Comprendre

### 🏛️ Clean Architecture

```
UI (Presentation)
    ↓ utilise
Models (Domain)
    ↓ obtient données
Repository (Data) ← TODO: À implémenter
```

**Principe:** Séparer responsabilités pour faciliter maintenance et tests

### 🔄 State Management

**Actuellement:** State local avec `StatefulWidget`

```dart
setState(() {
  _patients.add(newPatient); // Modifie state
}); // → Rebuild automatique
```

**Futur:** Provider/Riverpod pour state global

### 📐 Responsive Design

```dart
final isCompact = MediaQuery.of(context).size.width < 600;

// Adapter conditionnellement
fontSize: isCompact ? 14 : 16,
padding: isCompact ? 8.0 : 12.0,
```

**Breakpoints:**
- Mobile: < 600px
- Tablet: 600-1200px
- Desktop: > 1200px

---

## 🚨 Pièges Courants (et Solutions)

### ❌ Provider Not Found

**Symptôme:** Erreur rouge au clic patient

**Cause:** `PatientDetailScreen` utilise Provider non configuré

**Solution:** Utiliser navigation interne (onglet Détails) au lieu de `Navigator.push`

```dart
// ✅ Bon
setState(() {
  _selectedPatient = patient;
  _selectedIndex = 1;
});
```

### ⚠️ Dialog Layout Error

**Symptôme:** "Cannot hit test a render box"

**Cause:** `Expanded` dans `Dialog`

**Solution:** Utiliser `AlertDialog` + `mainAxisSize.min`

```dart
// ✅ Bon
AlertDialog(
  content: Column(
    mainAxisSize: MainAxisSize.min, // Important!
    children: [...]
  )
)
```

### 🔄 Hot Reload Ne Marche Pas

**Solutions:**
1. Essayer **Hot Restart** (touche `R`)
2. Vérifier qu'il n'y a pas d'erreurs de compilation
3. Relancer l'app complètement

---

## 🎯 Checklist Avant Premier Commit

- [ ] J'ai lu README.md
- [ ] J'ai testé l'app localement
- [ ] Mon code compile sans erreurs (`flutter analyze`)
- [ ] Mon code est formaté (`flutter format .`)
- [ ] J'ai ajouté des commentaires pour logique complexe
- [ ] J'ai utilisé `constants.dart` au lieu de valeurs hardcodées
- [ ] J'ai testé sur mobile ET desktop (si applicable)

---

## 🆘 Besoin d'Aide?

### 🔍 Où Chercher?

1. **Documentation locale:**
   - `README.md` → Overview
   - `QUICKSTART.md` → Tâches courantes
   - `ARCHITECTURE.md` → Patterns
   - Code comments → Détails inline

2. **Commandes utiles:**
   ```bash
   # Chercher dans le code
   grep -r "CompactDeleteButton" lib/
   
   # Analyser qualité
   flutter analyze lib/features/healthcare_worker
   
   # Lister dépendances
   flutter pub deps
   ```

3. **Ressources externes:**
   - [Flutter Docs](https://docs.flutter.dev)
   - [Dart API](https://api.dart.dev)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

### 💬 Qui Contacter?

**Mainteneur:** B.Medori  
**Questions:** Créer une issue dans le repo  
**Bugs:** CHANGELOG.md pour bugs connus

---

## 🎉 Vous Êtes Prêt!

Maintenant que vous avez lu ce guide:

1. ✅ Vous comprenez la structure
2. ✅ Vous savez où trouver chaque fichier
3. ✅ Vous pouvez faire des modifications simples
4. ✅ Vous connaissez les pièges à éviter

**Prochaine étape:** Commencez par un exercice simple ci-dessus! 🚀

---

**Bon coding et bienvenue dans l'équipe! 💪**

*Dernière mise à jour: 11 Novembre 2025*
