# 📡 Documentation des APIs - Système SAC-MP

## Vue d'ensemble

Ce dossier contient **3 fichiers d'API** complets pour le système SAC-MP (Surveillance Active et Continue - Médecine Personnalisée).

### ⚠️ Important
Ces fichiers contiennent **UNIQUEMENT** :
- ✅ Signatures de méthodes
- ✅ Endpoints REST
- ✅ Modèles de requêtes et réponses
- ✅ Documentation complète
- ✅ Exemples JSON
- ✅ Codes d'erreur possibles

❌ **Aucune implémentation** - Prêts pour développement backend

---

## 📂 Structure du dossier API

```
lib/api/
├── patient_api.dart              # API Interface Patient (7 endpoints)
├── auth_api.dart                 # API Authentification (12 endpoints)
├── healthcare_worker_api.dart    # API Travailleur de Santé (15 endpoints)
└── API_README.md                 # Ce fichier
```

---

## 1️⃣ patient_api.dart

### Description
Interface API pour les **patients** du système. Permet aux patients de consulter leurs données de santé et déclarer leur humeur.

### Endpoints (7)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/api/patient/{id}` | Récupère les informations du patient |
| `GET` | `/api/patient/{id}/rythme` | Rythme cardiaque (BPM, VFC) sur 24h/7j/30j |
| `GET` | `/api/patient/{id}/sommeil` | Données de sommeil (durée, cycles, qualité) |
| `GET` | `/api/patient/{id}/humeur` | Historique des humeurs + fréquence |
| `POST` | `/api/patient/{id}/humeur` | Déclarer une nouvelle humeur |
| `GET` | `/api/patient/{id}/alertes` | Liste des alertes liées au patient |
| `GET` | `/api/patient/{id}/correlation` | Visualisation corrélée multi-paramètres |

### Enums Clés
```dart
enum ValeurHumeur { anxieux, calme, triste }
enum PeriodeRythme { vingtQuatreHeures, septJours, trentJours }
enum PrioriteAlerte { basse, moyenne, haute, critique }
enum StatutAlerte { active, traitee, ignoree, resolue }
```

### Modèles Principaux
- `PatientInfoResponse` - Informations patient avec humeur, BPM, sommeil récents
- `RythmeCardiaqueResponse` - Mesures BPM avec VFC et timestamps
- `DonneesSommeilResponse` - Durée, cycles (léger/profond/paradoxal), qualité
- `HistoriqueHumeurResponse` - Déclarations d'humeur avec fréquence
- `AlertesPatientResponse` - Liste des alertes avec statut et priorité
- `CorrelationMultiParametresResponse` - Données superposées (BPM + Sommeil + Humeur)

### Exemple d'utilisation
```dart
// Récupérer les informations du patient
final info = await patientApi.getPatientInfo('MR-2023-001');
print('Dernière humeur: ${info.humeurRecente?.valeur}');

// Déclarer une humeur
final declaration = DeclarationHumeurRequest(
  valeurHumeur: ValeurHumeur.calme,
  noteTextuelle: 'Bonne journée',
  timestamp: DateTime.now(),
);
await patientApi.declarerHumeur('MR-2023-001', declaration);
```

### Conformité RGPD
- ✅ Patient ne peut accéder qu'à ses propres données
- ✅ Authentification JWT obligatoire
- ✅ Logs d'accès conservés 3 mois

---

## 2️⃣ auth_api.dart

### Description
Interface API pour l'**authentification** et la gestion des utilisateurs. Supporte email/password et Google Sign-In.

### Endpoints (12)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `POST` | `/api/auth/register` | Inscription (email, password, rôle) |
| `POST` | `/api/auth/login` | Connexion avec email/password |
| `POST` | `/api/auth/send-code` | Envoyer code de connexion (6 chiffres) |
| `POST` | `/api/auth/verify-code` | Vérifier code de connexion |
| `POST` | `/api/auth/forgot-password` | Demander réinitialisation (5 chiffres) |
| `POST` | `/api/auth/reset-password` | Réinitialiser mot de passe |
| `POST` | `/api/auth/google` | Authentification via Google |
| `POST` | `/api/auth/refresh-token` | Rafraîchir le token JWT |
| `POST` | `/api/auth/logout` | Déconnexion |
| `GET` | `/api/auth/verify-token` | Vérifier validité du token |
| `POST` | `/api/auth/change-password` | Changer mot de passe (nécessite ancien) |
| `PATCH` | `/api/auth/profile` | Mettre à jour profil |

### Enums Clés
```dart
enum UserRole { patient, healthcareWorker, admin }
enum AuthMethod { email, google, facebook, apple }
enum AccountStatus { active, inactive, suspended, pending }
```

### Modèles Principaux
- `RegisterRequest` / `RegisterResponse` - Inscription avec consentement RGPD
- `LoginRequest` / `LoginResponse` - Connexion avec tokens JWT
- `SendLoginCodeRequest` / `VerifyLoginCodeRequest` - Authentification passwordless
- `GoogleAuthRequest` / `GoogleAuthResponse` - OAuth Google
- `UserInfo` - Informations complètes utilisateur
- `RefreshTokenRequest` / `RefreshTokenResponse` - Renouvellement token

### Exemple d'utilisation
```dart
// Inscription
final register = RegisterRequest(
  fullName: 'Jean Dupont',
  email: 'jean@example.com',
  password: 'SecurePass123!',
  confirmPassword: 'SecurePass123!',
  role: UserRole.patient,
  gdprConsent: true,
);
final response = await authApi.register(register);

// Connexion passwordless (code par email)
await authApi.sendLoginCode(SendLoginCodeRequest(email: 'jean@example.com'));
// Utilisateur reçoit le code par email: 123456
final loginResponse = await authApi.verifyLoginCode(
  VerifyLoginCodeRequest(email: 'jean@example.com', code: '123456'),
);
// Stocker les tokens
saveTokens(loginResponse.accessToken, loginResponse.refreshToken);
```

### Sécurité
- ✅ JWT avec expiration (1h pour access, 30j pour refresh)
- ✅ Rate limiting: 5 tentatives / 15 minutes
- ✅ Mots de passe hachés avec bcrypt
- ✅ Codes de vérification à usage unique
- ✅ Validation stricte des mots de passe (8 chars min, complexité)

### Validation des mots de passe
- Minimum 8 caractères
- Au moins 1 majuscule
- Au moins 1 minuscule
- Au moins 1 chiffre
- Au moins 1 caractère spécial (!@#$%^&*)

---

## 3️⃣ healthcare_worker_api.dart

### Description
Interface API pour les **travailleurs de santé** (médecins, infirmiers). Gestion des patients, alertes, notes médicales et rapports.

### Endpoints (15)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/api/healthcare-worker/dashboard` | Tableau de bord avec statistiques |
| `GET` | `/api/healthcare-worker/patients` | Liste paginée des patients |
| `GET` | `/api/healthcare-worker/patients/{id}` | Détails complets d'un patient |
| `POST` | `/api/healthcare-worker/patients` | Ajouter un nouveau patient |
| `PATCH` | `/api/healthcare-worker/patients/{id}` | Mettre à jour un patient |
| `DELETE` | `/api/healthcare-worker/patients/{id}` | Supprimer (soft delete) un patient |
| `GET` | `/api/healthcare-worker/alerts` | Liste paginée des alertes |
| `GET` | `/api/healthcare-worker/alerts/{id}` | Détails d'une alerte |
| `POST` | `/api/healthcare-worker/alerts/{id}/acknowledge` | Accuser réception d'une alerte |
| `POST` | `/api/healthcare-worker/alerts/{id}/resolve` | Résoudre une alerte |
| `POST` | `/api/healthcare-worker/reports/generate` | Générer rapport PDF/Excel |
| `POST` | `/api/healthcare-worker/patients/{id}/notes` | Ajouter note médicale |
| `GET` | `/api/healthcare-worker/patients/{id}/notes` | Liste des notes d'un patient |
| `PATCH` | `/api/healthcare-worker/notes/{id}` | Mettre à jour une note |
| `DELETE` | `/api/healthcare-worker/notes/{id}` | Supprimer une note |

### Enums Clés
```dart
enum PatientStatus { critical, toMonitor, stable, discharged }
enum AlertType { heartRate, mood, sleep, correlation, medication, emergency }
enum AlertPriority { critical, high, medium, low }
enum AlertStatus { active, acknowledged, resolved, ignored }
enum ReportType { daily, weekly, monthly, custom }
```

### Modèles Principaux
- `DashboardResponse` - Statistiques, patients récents, alertes, tâches
- `PatientSummary` / `PatientDetailResponse` - Informations patient
- `AddPatientRequest` / `UpdatePatientRequest` - Gestion patients
- `AlertSummary` / `AlertDetailResponse` - Informations alertes
- `AcknowledgeAlertRequest` / `ResolveAlertRequest` - Traitement alertes
- `GenerateReportRequest` / `ReportResponse` - Génération rapports
- `MedicalNoteSummary` / `AddMedicalNoteRequest` - Notes médicales

### Exemple d'utilisation
```dart
// Récupérer le dashboard
final dashboard = await api.getDashboard();
print('Patients critiques: ${dashboard.statistics.criticalPatients}');
print('Alertes actives: ${dashboard.statistics.activeAlerts}');

// Ajouter un patient
final patient = AddPatientRequest(
  fullName: 'Jean Dupont',
  medicalRecordId: 'MR-2023-001',
  birthDate: DateTime(1965, 3, 15),
  sex: 'M',
  caregivers: ['Dr. Martin'],
  roomNumber: 'A101',
);
await api.addPatient(patient);

// Traiter une alerte
await api.acknowledgeAlert('alert_123', AcknowledgeAlertRequest(
  acknowledgedBy: 'hw_123',
  note: 'Patient pris en charge',
));

// Résoudre une alerte
await api.resolveAlert('alert_123', ResolveAlertRequest(
  resolvedBy: 'hw_123',
  resolutionNote: 'Rythme cardiaque normalisé',
  actionTaken: 'Médication administrée',
));

// Générer un rapport
final report = await api.generateReport(GenerateReportRequest(
  patientId: 'patient_123',
  reportType: ReportType.weekly,
  includeCharts: true,
));
downloadFile(report.downloadUrl);
```

### Permissions
- ✅ Travailleur de santé voit uniquement ses patients assignés
- ✅ Admin voit tous les patients
- ✅ Audit trail de tous les accès aux données
- ✅ Soft delete pour conservation légale (7 ans)

---

## 📊 Comparaison des APIs

| Critère | Patient API | Auth API | Healthcare Worker API |
|---------|-------------|----------|------------------------|
| **Endpoints** | 7 | 12 | 15 |
| **Public** | Patients | Tous | Travailleurs de santé |
| **Authentification** | JWT obligatoire | Mixte (login public) | JWT obligatoire |
| **CRUD** | Lecture seule (sauf humeur) | Complet | Complet |
| **Pagination** | Non | Non | Oui |
| **Rate Limiting** | Modéré | Strict | Modéré |
| **Audit Trail** | Oui | Oui | Oui (renforcé) |

---

## 🔒 Sécurité commune

### Authentification JWT
Toutes les routes protégées nécessitent un token JWT dans le header:
```
Authorization: Bearer <accessToken>
```

### Tokens
- **Access Token**: Valide 1 heure
- **Refresh Token**: Valide 30 jours
- **Algorithme**: HMAC SHA-256

### Rate Limiting

| API | Limite |
|-----|--------|
| Patient API | 100 requêtes / minute |
| Auth API (login) | 5 tentatives / 15 minutes |
| Auth API (send code) | 1 code / minute, 3 / heure |
| Healthcare Worker API | 1000 requêtes / heure |
| Génération rapport | 10 / heure |

### HTTPS
- ✅ TLS 1.3 obligatoire
- ✅ Certificat valide requis
- ✅ HTTP redirigé vers HTTPS

---

## 📋 Codes d'erreur HTTP

### Codes standards

| Code | Nom | Description |
|------|-----|-------------|
| `200` | OK | Requête réussie |
| `201` | Created | Ressource créée avec succès |
| `400` | Bad Request | Données invalides ou manquantes |
| `401` | Unauthorized | Token invalide ou expiré |
| `403` | Forbidden | Accès refusé (permissions insuffisantes) |
| `404` | Not Found | Ressource introuvable |
| `409` | Conflict | Conflit (ex: email déjà utilisé) |
| `429` | Too Many Requests | Rate limit dépassé |
| `500` | Internal Server Error | Erreur serveur |
| `503` | Service Unavailable | Service temporairement indisponible |

### Format d'erreur standard

```json
{
  "statusCode": 404,
  "errorCode": "PATIENT_NOT_FOUND",
  "message": "Patient non trouvé",
  "details": "Aucun patient avec l'ID patient_999",
  "timestamp": "2025-11-11T14:30:00.000Z",
  "path": "/api/patient/patient_999"
}
```

---

## 🧪 Tests recommandés

### Tests unitaires
- ✅ Validation des modèles (toJson, fromJson)
- ✅ Validation des requêtes (champs requis)
- ✅ Parsing des erreurs

### Tests d'intégration
- ✅ Flow d'inscription complet
- ✅ Flow de connexion avec refresh token
- ✅ CRUD patients avec alertes
- ✅ Génération de rapports

### Tests de charge
- ✅ Rate limiting effectif
- ✅ Temps de réponse < 200ms (95e percentile)
- ✅ Concurrence 1000 utilisateurs simultanés

---

## 📝 Documentation RGPD

### Conformité

#### Patient API
- ✅ Patient accède uniquement à ses propres données
- ✅ Consentement implicite via authentification
- ✅ Droit d'accès garanti (GET endpoints)
- ✅ Anonymisation dans les logs

#### Auth API
- ✅ Consentement RGPD explicite à l'inscription
- ✅ Droit à l'oubli (DELETE account - non documenté ici)
- ✅ Export de données sur demande
- ✅ Notification en cas de violation

#### Healthcare Worker API
- ✅ Audit trail de tous les accès patients
- ✅ Soft delete pour conservation légale (7 ans)
- ✅ Accès limité aux patients assignés
- ✅ Chiffrement des notes sensibles

---

## 🚀 Implémentation recommandée

### Stack backend suggéré
- **Framework**: Node.js (Express), Python (FastAPI), ou Dart (Shelf)
- **Base de données**: PostgreSQL (données relationnelles) + Redis (cache)
- **Authentification**: JWT avec bibliothèque standard
- **File d'attente**: RabbitMQ ou Redis (pour génération rapports)
- **Storage**: S3 (rapports PDF)

### Étapes d'implémentation

1. **Phase 1 - Auth API** (Priorité haute)
   - Implémenter inscription/connexion
   - Configurer JWT
   - Mettre en place rate limiting
   - Tests unitaires et d'intégration

2. **Phase 2 - Patient API** (Priorité haute)
   - Implémenter endpoints lecture
   - Connecter à la base de données
   - Implémenter POST humeur
   - Tests d'intégration

3. **Phase 3 - Healthcare Worker API** (Priorité moyenne)
   - Implémenter CRUD patients
   - Implémenter gestion alertes
   - Implémenter notes médicales
   - Tests complets

4. **Phase 4 - Rapports** (Priorité basse)
   - Génération PDF asynchrone
   - Templates de rapports
   - Stockage et expiration

---

## 📚 Ressources supplémentaires

### Documentation liée
- `ARCHITECTURE.md` - Architecture du projet
- `QUICKSTART.md` - Guide de démarrage rapide
- `CODE_QUALITY.md` - Standards de qualité

### Outils utiles
- **Postman Collection**: Créer une collection avec tous les endpoints
- **Swagger/OpenAPI**: Générer documentation interactive
- **Insomnia**: Alternative à Postman

### Exemples de clients HTTP

#### Dio (Flutter)
```dart
final dio = Dio();
dio.options.headers['Authorization'] = 'Bearer $accessToken';

final response = await dio.get('/api/patient/MR-2023-001');
final patient = PatientInfoResponse.fromJson(response.data);
```

#### http (Dart)
```dart
final response = await http.get(
  Uri.parse('$baseUrl/api/patient/MR-2023-001'),
  headers: {'Authorization': 'Bearer $accessToken'},
);
final patient = PatientInfoResponse.fromJson(jsonDecode(response.body));
```

---

## ✅ Checklist avant production

### Sécurité
- [ ] HTTPS activé avec certificat valide
- [ ] Rate limiting configuré
- [ ] JWT avec expiration courte
- [ ] Mots de passe hachés avec bcrypt (coût 12)
- [ ] Audit trail activé
- [ ] CORS configuré correctement

### Performance
- [ ] Cache Redis pour endpoints fréquents
- [ ] Index base de données optimisés
- [ ] Pagination sur toutes les listes
- [ ] Compression gzip activée
- [ ] CDN pour assets statiques

### Monitoring
- [ ] Logs centralisés (ELK, Datadog)
- [ ] Alertes automatiques (disponibilité, erreurs)
- [ ] Métriques temps réel
- [ ] Dashboard admin fonctionnel

### Documentation
- [ ] Swagger/OpenAPI généré
- [ ] README à jour
- [ ] Exemples de code testés
- [ ] Changelog maintenu

---

## 📞 Contact et support

Pour toute question concernant ces APIs:
1. Consulter la documentation inline (commentaires Dart)
2. Vérifier les exemples JSON fournis
3. Tester avec Postman/Insomia
4. Consulter l'équipe backend pour implémentation

---

**Version**: 1.0.0  
**Date**: 11 Novembre 2025  
**Auteur**: Système SAC-MP  
**Conformité**: RGPD, ISO 27001, HIPAA (si applicable)
