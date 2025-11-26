# 📂 Structure Complète - Healthcare Worker Feature

```
healthcare_worker/
│
├── 📖 Documentation
│   ├── README.md              # Guide complet de la feature
│   ├── ARCHITECTURE.md        # Choix architecturaux et patterns
│   ├── CHANGELOG.md           # Historique des versions
│   └── QUICKSTART.md          # Guide démarrage rapide
│
├── 🔧 Configuration
│   ├── constants.dart         # Constantes centralisées (couleurs, routes, validation)
│   └── healthcare_worker.dart # Exports centralisés pour imports simplifiés
│
├── 🏗️ Domain Layer (Business Logic)
│   └── models/
│       ├── patient.dart       # Modèle Patient + données démo
│       ├── alert.dart         # Modèle Alert avec types et priorités
│       └── health_data.dart   # Données de santé (metrics)
│
├── 💾 Data Layer (TODO - Backend Integration)
│   └── repositories/          # À implémenter
│       ├── patient_repository.dart
│       ├── alert_repository.dart
│       └── health_repository.dart
│
└── 🎨 Presentation Layer (UI)
    │
    ├── 📱 Screens
    │   ├── dashboard/
    │   │   └── healthcare_dashboard_screen.dart
    │   │       ├── 3 onglets (Patients, Détails, Alertes)
    │   │       ├── CRUD patients
    │   │       ├── Navigation bottom bar
    │   │       └── FloatingActionButton (Ajout)
    │   │
    │   ├── patient_detail/
    │   │   └── patient_detail_screen.dart
    │   │       ├── Vue détaillée patient
    │   │       ├── Métriques de santé
    │   │       └── Nécessite Provider (non utilisé actuellement)
    │   │
    │   └── auth/
    │       └── healthcare_login_screen.dart
    │           └── Authentification soignants
    │
    ├── 🧩 Widgets (Composants Réutilisables)
    │   ├── forms/
    │   │   └── add_patient_dialog.dart
    │   │       ├── Dialog modal création patient
    │   │       ├── Validation formulaire temps réel
    │   │       ├── DatePicker, Dropdown, FilterChips
    │   │       └── Loading state
    │   │
    │   ├── charts/
    │   │   └── health_chart.dart
    │   │       └── Graphiques métriques de santé
    │   │
    │   ├── delete_button.dart
    │   │   ├── ModernDeleteButton (version complète)
    │   │   │   ├── Animations hover/press
    │   │   │   ├── Gradient rouge
    │   │   │   └── Shadow dynamique
    │   │   └── CompactDeleteButton (version inline)
    │   │       └── Pour intégration dans cartes
    │   │
    │   ├── kpi_card.dart
    │   │   └── Cartes KPI (indicateurs)
    │   │
    │   └── patient_list_item.dart
    │       └── Item liste patient
    │
    └── 🔄 Providers (State Management)
        └── healthcare_provider.dart
            ├── Préparé pour Provider pattern
            └── Non utilisé actuellement (state local)
```

---

## 📊 Statistiques

- **Total Fichiers Dart:** 15
- **Lignes de Code:** ~2,500
- **Fichiers Documentation:** 4
- **Widgets Réutilisables:** 6
- **Modèles de Données:** 3
- **Screens:** 3

---

## 🎯 Points d'Entrée Principaux

### Pour Utilisateurs
```dart
// Afficher le dashboard
HealthcareDashboardScreen()
```

### Pour Développeurs
```dart
// Import centralisé
import 'package:travel_auth_ui/features/healthcare_worker/healthcare_worker.dart';

// Accès direct aux modèles
Patient patient = Patient(...);
Alert alert = Alert(...);

// Widgets réutilisables
CompactDeleteButton(onDelete: () {})
AddPatientDialog(availableCaregivers: [...])
```

---

## 🔗 Relations Entre Fichiers

```
main.dart
    ↓
HealthcareDashboardScreen
    ├─→ Patient (model)
    ├─→ Alert (model)
    ├─→ HealthData (model)
    ├─→ AddPatientDialog
    │   └─→ AddPatientResult
    └─→ CompactDeleteButton

constants.dart
    ↑ (utilisé par)
    ├─→ healthcare_dashboard_screen.dart
    ├─→ add_patient_dialog.dart
    └─→ delete_button.dart

healthcare_worker.dart (exports)
    ├─→ domain/models/*
    ├─→ presentation/screens/*
    ├─→ presentation/widgets/*
    └─→ presentation/providers/*
```

---

## 📦 Dépendances Externes

```yaml
Directes:
- flutter/material.dart     # Framework UI
- google_fonts              # Typography
- fl_chart                  # Graphiques
- provider                  # State (préparé)

Transitives:
- cupertino_icons          # Icons iOS
- intl (potentiel)         # Dates/formats
```

---

## 🚀 Flux d'Exécution

### 1. Lancement Application
```
main.dart
  → MaterialApp
    → HealthcareDashboardScreen (home)
      → Scaffold + BottomNavigationBar
        → Tab 0: _buildPatientList()
```

### 2. Ajout Patient
```
FAB tap
  → showDialog(AddPatientDialog)
    → User remplit formulaire
      → Validation
        → return AddPatientResult
          → _patients.add()
            → setState()
              → UI rebuild
                → SnackBar success
```

### 3. Suppression Patient
```
CompactDeleteButton tap
  → showDialog(Confirmation)
    → User confirme
      → _onDeletePatient()
        → _patients.removeWhere()
          → setState()
            → UI rebuild
              → SnackBar success
```

### 4. Sélection Patient
```
Patient card tap
  → _onPatientSelected()
    → _selectedPatient = patient
    → _selectedIndex = 1
      → setState()
        → UI rebuild (onglet Détails)
```

---

## 🎨 Hiérarchie Visuelle

```
Screen Level
└── HealthcareDashboardScreen
    ├── AppBar
    │   └── Title + Actions
    ├── Body (IndexedStack)
    │   ├── Tab 0: Patient List
    │   │   └── ListView
    │   │       └── Card (patient)
    │   │           ├── Avatar
    │   │           ├── Info (name, ID)
    │   │           ├── Status badge
    │   │           └── CompactDeleteButton
    │   ├── Tab 1: Patient Detail
    │   │   └── SingleChildScrollView
    │   │       ├── Header card
    │   │       ├── Metrics grid
    │   │       └── Charts
    │   └── Tab 2: Alerts
    │       └── ListView
    │           └── Alert card
    ├── FloatingActionButton
    │   └── AddPatientDialog
    └── BottomNavigationBar
```

---

## 📱 Responsive Breakpoints

```
Mobile (< 600px)
├── Stack layout
├── Compact spacing
├── Smaller fonts
└── Single column

Tablet (600px - 1200px)
├── Grid layout possible
├── Medium spacing
├── Regular fonts
└── Two columns

Desktop (> 1200px)
├── Grid layout
├── Large spacing
├── Large fonts
└── Three columns
```

---

## 🔐 Sécurité & Validation

```
Formulaire Patient
├── Nom: Required
├── ID Dossier: Required + Format MR-YYYY-NNN
├── Date Naissance: Required
└── Soignants: Required (min 1)

Règles Métier
├── Un patient = 1 ID unique
├── ID dossier non modifiable après création
├── Suppression irréversible (confirmation requise)
└── Alertes non modifiables (read-only)
```

---

## 🧪 Tests (À Implémenter)

```
tests/
├── unit/
│   ├── models/
│   │   ├── patient_test.dart
│   │   ├── alert_test.dart
│   │   └── health_data_test.dart
│   └── validation/
│       └── healthcare_validation_test.dart
│
├── widget/
│   ├── delete_button_test.dart
│   ├── add_patient_dialog_test.dart
│   └── patient_card_test.dart
│
└── integration/
    ├── add_patient_flow_test.dart
    ├── delete_patient_flow_test.dart
    └── navigation_test.dart
```

---

## 📈 Métriques de Qualité

### ✅ Actuellement
- Code formaté et consistant
- Documentation complète
- Architecture claire
- Composants réutilisables
- Responsive design

### ⚠️ À Améliorer
- Tests (coverage 0%)
- Error handling
- Loading states
- Backend integration
- Offline support

---

## 🔄 Workflow Développeur

```
1. Lire README.md
    ↓
2. Consulter QUICKSTART.md
    ↓
3. Importer healthcare_worker.dart
    ↓
4. Utiliser constants.dart pour valeurs
    ↓
5. Développer feature
    ↓
6. Tester (hot reload)
    ↓
7. Documenter changements (CHANGELOG.md)
    ↓
8. Commit & Push
```

---

**Structure maintenue par:** B.Medori  
**Dernière révision:** 11 Novembre 2025  
**Status:** ✅ Production Ready (Frontend)
