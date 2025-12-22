# Architecture de l'Interface Administrateur SAC-MP

## 📁 Structure des Fichiers

```
lib/features/admin/
├── admin.dart                          # Export principal du module
├── ADMIN_README.md                     # Documentation complète
│
├── domain/
│   └── models/
│       ├── admin_patient.dart          # Modèle Patient (avec données démo)
│       ├── caregiver.dart              # Modèle Soignant (avec données démo)
│       ├── alert_rule.dart             # Modèle Règle d'Alerte + Enums
│       └── security_log.dart           # Modèle Log de Sécurité + Enums
│
└── presentation/
    ├── screens/
    │   ├── admin_dashboard_screen.dart           # [ÉCRAN PRINCIPAL] Dashboard + Navigation
    │   ├── patients_management_screen.dart       # [MODULE 1] Gestion Patients (F-1.1)
    │   ├── caregivers_management_screen.dart     # [MODULE 2] Gestion Soignants (F-1.2)
    │   ├── alert_rules_screen.dart               # [MODULE 4] Config Moteur Alerte (F-4.1)
    │   └── security_logs_screen.dart             # [MODULE 5] Logs Sécurité (NF-1.4)
    │
    └── widgets/
        ├── admin_kpi_card.dart                   # Carte KPI (Dashboard)
        ├── admin_nav_drawer.dart                 # Menu latéral navigation
        ├── patient_form_dialog.dart              # Popup ajout/modif patient
        ├── caregiver_form_dialog.dart            # Popup ajout/modif soignant
        └── alert_rule_form_dialog.dart           # Popup ajout/modif règle
```

---

## 🔄 Flux de Navigation

```
AdminDashboardScreen (Écran Principal)
│
├── Drawer Navigation (AdminNavDrawer)
│   ├── [0] Dashboard Overview       → _buildDashboardOverview()
│   ├── [1] Gestion Patients         → PatientsManagementScreen
│   ├── [2] Gestion Soignants        → CaregiversManagementScreen
│   ├── [3] Règles d'Alerte          → AlertRulesScreen
│   └── [4] Logs de Sécurité         → SecurityLogsScreen
│
└── Actions Rapides
    ├── Notifications
    ├── Paramètres
    ├── Sauvegarde
    ├── Rapports
    └── Déconnexion
```

---

## 🎯 Composants Clés par Écran

### 1️⃣ AdminDashboardScreen (Écran Principal)

**Responsabilités:**
- Navigation globale (IndexedStack)
- Gestion de l'état (_selectedIndex)
- Calcul des KPIs en temps réel
- Affichage du Dashboard Overview

**KPIs Calculés:**
- `_totalPatients` / `_activePatients`
- `_totalCaregivers` / `_activeCaregivers`
- `_alertCountsByPriority` (Map<AlertPriority, int>)
- `_activeAlertRules`
- `_unassignedPatients`
- `_twoFactorRate` (pourcentage)

**Widgets Dashboard:**
- Grid de 8 `AdminKPICard` (responsive 2/3/4 colonnes)
- `_buildAlertsDistributionCard()` (graphique barres priorités)
- `_buildRecentActivityCard()` (5 dernières actions)

---

### 2️⃣ PatientsManagementScreen (MODULE 1)

**État Local:**
- `_searchQuery` (recherche texte)
- `_filterStatus` ('Tous', 'Actif', 'Archivé')

**Widgets:**
- Barre de recherche + bouton "Ajouter Patient"
- FilterChips pour filtres de statut
- ListView.builder de `_buildPatientCard()`
- Popup: `PatientFormDialog` (ajout/modification)

**Callbacks:**
- `onPatientAdded(AdminPatient)`
- `onPatientUpdated(AdminPatient)`
- `onPatientDeleted(String id)`

---

### 3️⃣ CaregiversManagementScreen (MODULE 2)

**État Local:**
- `_searchQuery`
- `_filterStatus` ('Tous', 'Actif', 'Inactif')

**Affichage:**
- Badge 2FA (si activé)
- Nombre de patients assignés
- Rôle clinique avec icône

**Callbacks:**
- `onCaregiverAdded(Caregiver)`
- `onCaregiverUpdated(Caregiver)`

---

### 4️⃣ AlertRulesScreen (MODULE 4)

**État Local:**
- `_filterParameter` ('Tous', 'Rythme cardiaque', 'Humeur', 'Sommeil', 'Corrélation')

**Affichage:**
- Type de paramètre avec icône et couleur
- Condition de déclenchement
- Badge de priorité (couleur dynamique)
- Statut actif/inactif

**Callbacks:**
- `onRuleAdded(AlertRule)`
- `onRuleUpdated(AlertRule)`
- `onRuleDeleted(String id)`

---

### 5️⃣ SecurityLogsScreen (MODULE 5)

**État Local:**
- `_filterAction` ('Toutes', ou action spécifique)
- `_filterRole` ('Tous', 'Administrateur', 'Soignant', 'Patient')

**Affichage:**
- Icône action (couleur dynamique)
- Nom utilisateur + rôle
- Cible (si applicable)
- IP address
- Timestamp relatif ("Il y a 2h")

---

## 🎨 Design System

### Couleurs

```dart
// Thème principal (AppTheme)
bg:       #0C0C0C  // Background noir
card:     #141414  // Cartes sombres
neon:     #D7F759  // Primary (vert fluo)
textDim:  #9BA3A7  // Texte secondaire
error:    #FF5252
success:  #4CAF50
warning:  #FFC107
info:     #2196F3

// Couleurs spécifiques Alertes
critique: #FF0000  (rouge)
haute:    #FF6B00  (orange)
moyenne:  #FFC107  (jaune)
basse:    #2196F3  (bleu)

// Couleurs Paramètres
rythme:     red
humeur:     green
sommeil:    blue
correlation: purple
```

### Typographie

```dart
// Tailles (AppTheme)
fontSizeSmall:    12.0
fontSizeMedium:   14.0
fontSizeLarge:    16.0
fontSizeXLarge:   20.0
fontSizeXXLarge:  24.0
fontSizeXXXLarge: 32.0

// Police: Poppins (Google Fonts)
```

### Espacements

```dart
spacingXXS:  4.0
spacingXS:   8.0
spacingS:    12.0
spacingM:    16.0
spacingL:    24.0
spacingXL:   32.0
spacingXXL:  48.0
```

### Border Radius

```dart
borderRadiusS:   4.0
borderRadiusM:   8.0
borderRadiusL:   12.0   // Standard pour cartes
borderRadiusXL:  16.0
borderRadiusXXL: 24.0
```

---

## 🔧 Widgets Réutilisables

### AdminKPICard

**Props:**
- `title`: String (ex: "Total Patients")
- `value`: String (ex: "24")
- `subtitle`: String (ex: "20 actifs")
- `icon`: IconData
- `color`: Color
- `onTap`: VoidCallback? (optionnel)

**Usage:**
```dart
AdminKPICard(
  title: 'Total Patients',
  value: '24',
  subtitle: '20 actifs',
  icon: Icons.people,
  color: Colors.blue,
  onTap: () => _onNavigationTapped(1),
)
```

---

### AdminNavDrawer

**Props:**
- `selectedIndex`: int (index actuel)
- `onItemTapped`: Function(int) (callback navigation)

**Sections:**
1. En-tête (logo SAC-MP + badge Admin)
2. Menu items (5 entrées)
3. Actions rapides (Sauvegarde, Rapports)
4. Footer (Déconnexion)

---

### PatientFormDialog

**Props:**
- `patient`: AdminPatient? (null = ajout, non-null = modification)

**Champs:**
- Nom complet *
- Dossier médical (MR-YYYY-XXX) *
- Email * / Téléphone *
- Adresse complète *
- Sexe (dropdown: M/F/Autre)
- Date de naissance (date picker)
- Paramètres surveillés (FilterChips multi-sélection)
- Switch "Compte actif"

**Validation:**
- Tous les champs marqués * sont requis
- Format dossier médical vérifié
- Email validé (format)

---

### CaregiverFormDialog

**Props:**
- `caregiver`: Caregiver? (null = ajout, non-null = modification)

**Champs:**
- Nom complet *
- Matricule *
- Email professionnel *
- Rôle clinique (dropdown)
- Switch "Authentification 2FA"
- Switch "Compte actif"

---

### AlertRuleFormDialog

**Props:**
- `rule`: AlertRule? (null = ajout, non-null = modification)

**Champs:**
- Nom de la règle *
- Type de paramètre (dropdown avec icônes)
- Définition de condition * (multiline)
- Priorité résultante (dropdown avec couleurs)
- Switch "Règle active"

---

## 📊 Données de Démonstration

### Patients (4)

```dart
AdminPatient.demoPatients = [
  Marie Dubois   (MR-2025-001, F, 39 ans, Actif)    → 3 paramètres, 2 soignants
  Jean Martin    (MR-2025-002, M, 47 ans, Actif)    → 3 paramètres, 1 soignant
  Sophie Bernard (MR-2025-003, F, 35 ans, Archivé)  → 2 paramètres, 1 soignant
  Pierre Leroy   (MR-2025-004, M, 43 ans, Actif)    → 4 paramètres, 3 soignants
]
```

### Soignants (4)

```dart
Caregiver.demoCaregivers = [
  Dr. Martin Durand      (MED-2023-001, Médecin, 2FA: ✓, 15 patients)
  Infirmière Dupuis      (INF-2023-005, Infirmier, 2FA: ✓, 22 patients)
  Dr. Sophie Leroy       (PSY-2024-003, Psychologue, 2FA: ✗, 8 patients)
  Antoine Bernard        (SOI-2024-012, Soignant, Inactif, 0 patients)
]
```

### Règles d'Alerte (5)

```dart
AlertRule.demoRules = [
  Tachycardie sévère           (RYTHME, "BPM > 130...", CRITIQUE, Active)
  Humeur très basse prolongée  (HUMEUR, "≤ 2/5 pendant 3j", HAUTE, Active)
  Privation de sommeil         (SOMMEIL, "< 4h pendant 3 nuits", HAUTE, Active)
  Corrélation négative forte   (CORRELATION, "< -0.7", MOYENNE, Active)
  Bradycardie                  (RYTHME, "BPM < 50", HAUTE, Inactive)
]
```

### Logs de Sécurité (8)

```dart
SecurityLog.demoLogs = [
  Login               (Admin Principal, il y a 5min)
  Patient créé        (Admin Principal, Pierre Leroy, il y a 1h)
  Règle modifiée      (Admin Principal, Tachycardie, il y a 2h)
  Alerte acquittée    (Dr. Durand, il y a 3h)
  Soignant créé       (Admin Principal, Dr. Petit, il y a 1j)
  2FA activé          (Dr. Leroy, il y a 1j)
  Mot de passe changé (Marie Dubois, il y a 2j)
  Export données      (Jean Martin, il y a 3j)
]
```

---

## 🚀 Points d'Entrée

### main.dart

```dart
import 'package:travel_auth_ui/features/admin/presentation/screens/admin_dashboard_screen.dart';

// ...

home: const AdminDashboardScreen(),
```

### Utilisation du module

```dart
// Import
import 'package:travel_auth_ui/features/admin/admin.dart';

// Navigation
Navigator.pushNamed(context, AdminDashboardScreen.routeName);
```

---

## 🔐 Sécurité & Bonnes Pratiques

### Validation des Formulaires

Tous les dialogs utilisent `Form` + `GlobalKey<FormState>`:

```dart
final _formKey = GlobalKey<FormState>();

// Dans le bouton Créer/Modifier:
void _save() {
  if (_formKey.currentState!.validate()) {
    // Créer l'entité
    // Navigator.pop avec résultat
  }
}
```

### Confirmation de Suppression

Toujours demander confirmation avant suppression:

```dart
Future<void> _confirmDeletePatient(AdminPatient patient) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(...),
  );
  
  if (confirmed == true) {
    widget.onPatientDeleted(patient.id);
  }
}
```

### Feedback Utilisateur

Toujours afficher un SnackBar après une action:

```dart
void _showSuccessSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppTheme.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
```

---

## 📈 Performance

### Optimisations Implémentées

1. **ListView.builder** (au lieu de ListView) pour listes longues
2. **LayoutBuilder** pour responsive adaptatif
3. **const** constructors partout où possible
4. **SingleChildScrollView** pour éviter overflow
5. **FilterChips** pour filtres (moins coûteux que Dropdowns)

### À Implémenter (Backend)

1. **Pagination** pour listes patients/soignants (si > 100 entrées)
2. **Lazy loading** pour logs de sécurité
3. **Debounce** sur recherche (éviter appels API à chaque frappe)
4. **Cache** pour KPIs (refresh toutes les 30s)

---

## 🧪 Tests Recommandés

### Tests Unitaires

```dart
// domain/models/
test('AdminPatient age calculation', () { ... });
test('AlertRule priority color', () { ... });
test('SecurityLog timeAgo formatting', () { ... });
```

### Tests Widgets

```dart
// presentation/widgets/
testWidgets('AdminKPICard displays correctly', (tester) async { ... });
testWidgets('PatientFormDialog validates fields', (tester) async { ... });
```

### Tests d'Intégration

```dart
// presentation/screens/
testWidgets('Admin can add a new patient', (tester) async { ... });
testWidgets('Search filters patients correctly', (tester) async { ... });
```

---

**Dernière mise à jour:** 24 Novembre 2025
