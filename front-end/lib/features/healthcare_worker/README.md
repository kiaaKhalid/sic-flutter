# Healthcare Worker Feature Module

## 📁 Structure du Module

Cette feature suit l'architecture **Clean Architecture** avec séparation claire des responsabilités.

```
healthcare_worker/
├── domain/                      # Logique métier & modèles
│   └── models/                  # Entités métier
│       ├── patient.dart         # Modèle Patient avec données démo
│       ├── alert.dart           # Modèle Alert (notifications médicales)
│       └── health_data.dart     # Données de santé (rythme cardiaque, etc.)
│
└── presentation/                # Interface utilisateur
    ├── screens/                 # Écrans complets
    │   ├── dashboard/
    │   │   └── healthcare_dashboard_screen.dart  # Dashboard principal (liste patients, détails, alertes)
    │   ├── patient_detail/
    │   │   └── patient_detail_screen.dart        # Détails complets d'un patient (avec Provider)
    │   └── auth/
    │       └── healthcare_login_screen.dart      # Écran de connexion soignant
    │
    ├── widgets/                 # Composants réutilisables
    │   ├── forms/
    │   │   └── add_patient_dialog.dart           # Dialog de création de patient
    │   ├── charts/
    │   │   └── health_chart.dart                 # Graphiques de santé
    │   ├── delete_button.dart                    # Bouton de suppression moderne
    │   ├── kpi_card.dart                         # Carte KPI (indicateurs)
    │   └── patient_list_item.dart                # Item de liste patient
    │
    └── providers/
        └── healthcare_provider.dart              # State management avec Provider

```

---

## 🎯 Écrans Principaux

### 1. **Healthcare Dashboard** (`healthcare_dashboard_screen.dart`)
**Point d'entrée principal de l'interface soignant**

**Fonctionnalités:**
- ✅ Liste des patients avec statut (Critique, À surveiller, Stable)
- ✅ Détails du patient sélectionné (métriques de santé)
- ✅ Liste des alertes médicales avec niveaux de priorité
- ✅ FloatingActionButton pour ajouter un nouveau patient
- ✅ Bouton de suppression sur chaque carte patient
- ✅ Navigation par onglets (Patients / Détails / Alertes)

**Navigation:**
- Accessible depuis: `main.dart` (défini comme `home`)
- Route nommée: `/healthcare-dashboard`

**Widgets utilisés:**
- `AddPatientDialog` - Création de patient
- `CompactDeleteButton` - Suppression de patient
- Cartes patients personnalisées avec design responsive

---

### 2. **Add Patient Dialog** (`add_patient_dialog.dart`)
**Dialog modal pour créer un nouveau patient**

**Champs du formulaire:**
- Nom complet (requis)
- ID Dossier médical (format: MR-YYYY-NNN) (requis)
- Date de naissance (requis) - DatePicker
- Sexe (Homme/Femme/Autre)
- Soignants assignés (requis) - Multi-sélection avec FilterChips

**Validation:**
- ✅ Format ID dossier: `^MR-\d{4}-\d{3}$`
- ✅ Tous les champs obligatoires
- ✅ Au moins un soignant assigné

**Retour:**
```dart
AddPatientResult(
  fullName, birthDate, sex, medicalRecordId,
  email, phone, address, groups, caregivers
)
```

**Style:**
- Dark theme (#1E1E1E)
- Bordure verte néon (#D7F759)
- Bouton créer avec loading state

---

### 3. **Delete Button** (`delete_button.dart`)
**Composant de suppression moderne avec animations**

**Variantes:**
1. **ModernDeleteButton** - Version complète (40x40px)
   - Animations hover (scale 1.1)
   - Gradient rouge élégant
   - Shadow dynamique

2. **CompactDeleteButton** - Version compacte (inline)
   - Pour intégration dans cartes
   - Même style, taille réduite

**Props:**
```dart
ModernDeleteButton(
  onDelete: () => _handleDelete(),
  size: 40.0,              // Optionnel
  showConfirmation: true,  // Optionnel
)
```

**Dialog de confirmation:**
- Titre avec icône warning
- Message d'irréversibilité
- Boutons Annuler / Supprimer

---

## 📊 Modèles de Données

### **Patient** (`patient.dart`)
```dart
Patient(
  id: String,
  name: String,
  medicalRecordId: String,    // Format: MR-YYYY-NNN
  status: PatientStatus,       // critical / toMonitor / stable
  lastUpdate: DateTime,
  alertCount: int,
  roomNumber: String?,
)
```

**Données démo:** 4 patients inclus (Jean Dupont, Marie Martin, Pierre Durand, medori)

---

### **Alert** (`alert.dart`)
```dart
Alert(
  id: String,
  patientId: String,
  patientName: String,
  message: String,
  type: AlertType,             // health / medication / emergency
  priority: AlertPriority,     // high / medium / low
  timestamp: DateTime,
  isAcknowledged: bool,
)
```

**Types d'alertes:**
- Santé (health)
- Médicament (medication)
- Urgence (emergency)

---

### **HealthData** (`health_data.dart`)
```dart
HealthData(
  patientId: String,
  heartRate: int,              // BPM
  bloodPressure: String,       // Format: "120/80"
  temperature: double,         // °C
  oxygenLevel: int,            // %
  lastMeasurement: DateTime,
)
```

**Démo:** Générateur `HealthDataDemo.demo(patientId)` pour tests

---

## 🎨 Thème & Design System

### Couleurs Principales
```dart
- Background:     #0C0C0C (noir profond)
- Card:           #1E1E1E (gris foncé)
- Accent:         #D7F759 (vert néon)
- Delete:         #FF6B6B → #FF5252 (gradient rouge)
- Critical:       Rouge
- To Monitor:     Orange
- Stable:         Vert
```

### Breakpoints Responsive
```dart
- Mobile:    < 600px
- Tablet:    600px - 1200px
- Desktop:   > 1200px
```

### Composants Réutilisables
- **Border radius:** 12px - 20px
- **Shadows:** Soft (opacity 0.1-0.4)
- **Animations:** 150-200ms duration
- **Icons:** Material Icons (outline style)

---

## 🔄 État et Navigation

### État Local (Dashboard)
```dart
_selectedIndex      // Onglet actif (0: Patients, 1: Détails, 2: Alertes)
_selectedPatient    // Patient sélectionné pour détails
_patients           // Liste des patients
_alerts             // Liste des alertes
_caregivers         // Liste des soignants disponibles
```

### Interactions Principales
1. **Ajouter patient:** FAB → Dialog → Validation → Ajout à liste
2. **Supprimer patient:** Bouton delete → Confirmation → Suppression + SnackBar
3. **Voir détails:** Click sur carte → Change onglet vers Détails
4. **Reconnaître alerte:** Bouton check → Marquer comme vue

---

## 🚀 Points d'Entrée pour Développeurs

### Ajouter un Nouveau Champ au Formulaire Patient
**Fichier:** `add_patient_dialog.dart`
1. Ajouter le controller dans `_AddPatientDialogState`
2. Ajouter le TextFormField dans `Column > children`
3. Mettre à jour `AddPatientResult` avec le nouveau champ
4. Ajouter validation si nécessaire

### Personnaliser les Cartes Patients
**Fichier:** `healthcare_dashboard_screen.dart`
**Méthode:** `_buildPatientCard(Patient patient)`
- Modifier le layout dans `Row > children`
- Ajuster le responsive avec `isCompact`

### Ajouter un Nouveau Type d'Alerte
**Fichier:** `alert.dart`
1. Ajouter enum dans `AlertType`
2. Mettre à jour `typeIcon` getter
3. Créer données démo si nécessaire

### Modifier le Style des Boutons Delete
**Fichier:** `delete_button.dart`
- Gradient: `LinearGradient > colors`
- Taille: `widget.size`
- Animation: `_scaleAnimation` Tween

---

## 📝 TODO / Améliorations Futures

### Backend Integration
- [ ] Connecter API REST pour CRUD patients
- [ ] Implémenter authentification JWT
- [ ] WebSocket pour alertes en temps réel
- [ ] Upload photos de profil patients

### Features
- [ ] Filtres de recherche patients (nom, statut, date)
- [ ] Tri de la liste (A-Z, date, statut)
- [ ] Export PDF des détails patient
- [ ] Notifications push pour alertes critiques
- [ ] Historique des modifications patient

### UI/UX
- [ ] Dark/Light mode toggle
- [ ] Animations de transition entre onglets
- [ ] Skeleton loaders pendant chargement
- [ ] Pagination de la liste patients
- [ ] Swipe-to-delete sur mobile

### Tests
- [ ] Unit tests pour modèles
- [ ] Widget tests pour composants
- [ ] Integration tests pour flows complets
- [ ] Tests de validation formulaire

---

## 🐛 Problèmes Connus & Solutions

### ❌ Provider Not Found Error
**Symptôme:** Erreur lors du clic sur patient  
**Cause:** `PatientDetailScreen` utilise `context.read<HealthcareProvider>()` non configuré  
**Solution:** Navigation modifiée vers l'onglet Détails du dashboard au lieu de naviguer vers un nouvel écran

### ⚠️ Dialog Layout Errors
**Symptôme:** "Cannot hit test a render box with no size"  
**Cause:** Utilisation de `Expanded` dans `Dialog` widget  
**Solution:** Utiliser `AlertDialog` avec `mainAxisSize: MainAxisSize.min`

---

## 📞 Contact & Maintenance

**Dernière mise à jour:** 11 Novembre 2025  
**Version:** 1.0.0  
**Mainteneur:** B.Medori

Pour toute question sur cette feature, référez-vous à ce README ou consultez les commentaires inline dans le code.
