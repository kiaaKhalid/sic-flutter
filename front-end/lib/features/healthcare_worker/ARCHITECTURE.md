# Architecture Healthcare Worker Feature

## 📐 Principes Architecturaux

Cette feature suit les principes de **Clean Architecture** adaptés pour Flutter:

### Séparation des Responsabilités

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  (UI, Widgets, Screens, State Management)               │
│  ┌────────────────────────────────────────────────┐    │
│  │  Widgets → Screens → Providers                 │    │
│  │  (Dumb)     (Smart)    (State)                 │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                      Domain Layer                        │
│  (Business Logic, Models, Entities)                     │
│  ┌────────────────────────────────────────────────┐    │
│  │  Models (Patient, Alert, HealthData)           │    │
│  │  Pure Dart - No Flutter Dependencies           │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                       Data Layer                         │
│  (Repositories, API Clients, Local Storage)             │
│  ┌────────────────────────────────────────────────┐    │
│  │  TODO: À implémenter pour connexion backend    │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 Choix de Design

### 1. State Management

**Actuellement:** State local avec `StatefulWidget`

**Pourquoi:**
- ✅ Simple et léger pour prototypage
- ✅ Pas de dépendances externes complexes
- ✅ Idéal pour données démo

**Migration future recommandée:**
- [ ] Provider pour state global (déjà préparé dans `healthcare_provider.dart`)
- [ ] Riverpod pour meilleure testabilité
- [ ] Bloc/Cubit pour apps complexes

### 2. Navigation

**Approche:** Navigation déclarative simplifiée

**Implémentation actuelle:**
```dart
// Navigation interne (tabs)
_selectedIndex = 1; // Changement d'onglet

// Navigation externe (futur)
Navigator.pushNamed(context, HealthcareRoutes.dashboard);
```

**Évolution recommandée:**
- [ ] go_router pour deep linking
- [ ] Navigation 2.0 pour web
- [ ] Guards pour authentification

### 3. Validation

**Pattern:** Validation inline + FormKey

```dart
validator: (v) {
  if (v == null || v.isEmpty) return 'Requis';
  if (!RegExp(r'^MR-\d{4}-\d{3}$').hasMatch(v)) {
    return 'Format: MR-AAAA-NNN';
  }
  return null;
}
```

**Avantages:**
- ✅ Feedback immédiat
- ✅ Messages clairs
- ✅ Facile à maintenir

### 4. Responsive Design

**Strategy:** MediaQuery + Breakpoints

```dart
final isCompact = MediaQuery.of(context).size.width < 600;

// Adaptation conditionnelle
fontSize: isCompact ? 14 : 16,
padding: isCompact ? 8 : 12,
```

**Breakpoints:**
- Mobile: < 600px
- Tablet: 600px - 1200px
- Desktop: > 1200px

---

## 🔄 Flux de Données

### Ajouter un Patient

```
User Action (FAB tap)
    ↓
showDialog(AddPatientDialog)
    ↓
User fills form
    ↓
Validation (FormKey)
    ↓
Return AddPatientResult
    ↓
Dashboard setState
    ↓
_patients.add(newPatient)
    ↓
UI Update (rebuild)
    ↓
SnackBar confirmation
```

### Supprimer un Patient

```
User Action (Delete button tap)
    ↓
showDialog(Confirmation)
    ↓
User confirms
    ↓
_onDeletePatient(patientId)
    ↓
setState(() {
  _patients.removeWhere(...)
})
    ↓
UI Update
    ↓
SnackBar success
```

---

## 🎨 Système de Design

### Hiérarchie des Composants

```
Screen (Smart Widget)
  └── Layout Widgets (Scaffold, TabBar)
      └── Container Widgets (Card, Container)
          └── Content Widgets (Text, Icon)
              └── Interactive Widgets (Button, TextField)
```

### Widgets Réutilisables

**Principe:** Composition > Inheritance

```dart
// ❌ Mauvais: Héritage
class PatientCard extends BaseCard { ... }

// ✅ Bon: Composition
Widget _buildPatientCard(Patient patient) {
  return Card(
    child: CompactDeleteButton(...)
  );
}
```

### Thème & Consistance

**Centralisé dans:** `constants.dart`

```dart
// Utilisation cohérente
Color.fromRGBO(
  HealthcareColors.accentNeon >> 16 & 0xFF,
  HealthcareColors.accentNeon >> 8 & 0xFF,
  HealthcareColors.accentNeon & 0xFF,
  1.0,
)
```

---

## 🧪 Testabilité

### Structure Actuelle

```
lib/
└── features/
    └── healthcare_worker/
        ├── domain/           ← Facilement testable (Pure Dart)
        ├── presentation/     ← Tests widgets nécessaires
        └── constants.dart    ← Tests unitaires simples
```

### Recommandations Tests

**À implémenter:**

```dart
// 1. Tests Unitaires (Domain)
test/domain/models/
  ├── patient_test.dart
  ├── alert_test.dart
  └── health_data_test.dart

// 2. Tests Widgets
test/presentation/widgets/
  ├── delete_button_test.dart
  ├── add_patient_dialog_test.dart
  └── patient_card_test.dart

// 3. Tests d'Intégration
test/integration/
  ├── add_patient_flow_test.dart
  ├── delete_patient_flow_test.dart
  └── navigation_test.dart
```

**Exemple de test:**

```dart
testWidgets('Delete button shows confirmation dialog', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: CompactDeleteButton(
        onDelete: () {},
        showConfirmation: true,
      ),
    ),
  );
  
  await tester.tap(find.byType(CompactDeleteButton));
  await tester.pumpAndSettle();
  
  expect(find.text('Confirmer la suppression'), findsOneWidget);
});
```

---

## 🔌 Préparation Backend

### Structure API Attendue

```dart
// Repository Interface (à créer)
abstract class PatientRepository {
  Future<List<Patient>> getPatients();
  Future<Patient> getPatientById(String id);
  Future<Patient> createPatient(CreatePatientDto dto);
  Future<void> deletePatient(String id);
  Future<Patient> updatePatient(String id, UpdatePatientDto dto);
}

// Implementation
class PatientRepositoryImpl implements PatientRepository {
  final ApiClient _client;
  
  @override
  Future<List<Patient>> getPatients() async {
    final response = await _client.get('/api/patients');
    return (response.data as List)
        .map((json) => Patient.fromJson(json))
        .toList();
  }
  // ...
}
```

### Endpoints API Recommandés

```
GET    /api/patients              → List<Patient>
GET    /api/patients/:id          → Patient
POST   /api/patients              → Patient
PUT    /api/patients/:id          → Patient
DELETE /api/patients/:id          → void

GET    /api/alerts                → List<Alert>
PUT    /api/alerts/:id/acknowledge → Alert

GET    /api/health-data/:patientId → HealthData
```

---

## 📦 Dépendances

### Actuelles

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1          # State management (préparé)
  google_fonts: ^6.1.0      # Typography
  fl_chart: ^0.66.2         # Graphiques santé
```

### Recommandées pour Production

```yaml
dependencies:
  # HTTP & API
  dio: ^5.4.0               # Client HTTP
  retrofit: ^4.0.0          # REST API generator
  
  # State Management
  riverpod: ^2.4.0          # Alternative Provider
  
  # Storage
  hive: ^2.2.3              # Local DB
  shared_preferences: ^2.2.0 # Settings
  
  # Utils
  intl: ^0.18.0             # Dates/formats
  freezed: ^2.4.0           # Immutability
  json_serializable: ^6.7.0 # JSON parsing
```

---

## 🚀 Prochaines Étapes

### Phase 1: Stabilisation (Court terme)
- [x] Structure de base fonctionnelle
- [x] CRUD patients (UI only)
- [x] Documentation complète
- [ ] Tests unitaires modèles
- [ ] Tests widgets principaux

### Phase 2: Backend Integration (Moyen terme)
- [ ] Créer repositories
- [ ] Implémenter API client
- [ ] Ajouter error handling
- [ ] Loading states
- [ ] Cache local (Hive)

### Phase 3: Features Avancées (Long terme)
- [ ] Filtres & recherche
- [ ] Tri personnalisé
- [ ] Export PDF
- [ ] Notifications push
- [ ] Mode offline
- [ ] Multi-langue (i18n)

---

## 📚 Références

**Patterns utilisés:**
- Clean Architecture (Uncle Bob)
- Repository Pattern
- Composition over Inheritance
- Single Responsibility Principle

**Documentation Flutter:**
- [State Management Options](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Responsive Design](https://docs.flutter.dev/ui/layout/responsive/adaptive-responsive)

**Communauté:**
- [Flutter Community](https://flutter.dev/community)
- [Pub.dev](https://pub.dev)
- [GitHub Discussions](https://github.com/flutter/flutter/discussions)
