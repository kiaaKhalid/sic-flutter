# DOCUMENTATION DES ENTITÉS ET ENUMS
## Backend Spring Boot - Système de Surveillance Médicale

Date de création : 2 décembre 2025

---

## 📊 RÉSUMÉ GLOBAL

**Total : 13 Enums + 12 Entités**

---

## 🔢 ENUMS (13)

### Module Common

| Enum | Valeurs | Description |
|------|---------|-------------|
| **UserRole** | PATIENT, HEALTHCARE_WORKER, ADMIN | Rôle de l'utilisateur |
| **AccountStatus** | ACTIVE, INACTIVE, SUSPENDED, PENDING | Statut du compte utilisateur |
| **PatientStatus** | CRITICAL, TO_MONITOR, STABLE, DISCHARGED | État de santé du patient |
| **AlertType** | HEART_RATE, MOOD, SLEEP, CORRELATION, MEDICATION, EMERGENCY | Type d'alerte médicale |
| **AlertPriority** | CRITICAL, HIGH, MEDIUM, LOW | Niveau de priorité d'alerte |
| **AlertStatus** | ACTIVE, ACKNOWLEDGED, RESOLVED, IGNORED | Statut de traitement d'alerte |
| **SleepStage** | AWAKE, LIGHT, DEEP, REM | Phase de sommeil |
| **MoodValue** | HAPPY, CALM, ANXIOUS, SAD, TIRED, STRESSED | Valeur d'humeur du patient |
| **ReportType** | DAILY, WEEKLY, MONTHLY, CUSTOM | Type de rapport médical |
| **ReportFormat** | PDF, EXCEL, CSV | Format d'export du rapport |
| **ReportStatus** | PENDING, GENERATING, COMPLETED, FAILED | Statut de génération du rapport |
| **CodeType** | LOGIN, PASSWORD_RESET, EMAIL_VERIFICATION | Type de code de vérification |
| **AuditAction** | LOGIN, LOGOUT, CREATE, READ, UPDATE, DELETE, EXPORT, ACKNOWLEDGE_ALERT, RESOLVE_ALERT | Action auditée |

---

## 📦 ENTITÉS (12)

### 1. Module Auth (4 entités)

#### User
**Table:** `users`  
**Description:** Compte utilisateur (patient, soignant, admin)

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| email | String | Email (unique) |
| passwordHash | String | Hash du mot de passe |
| fullName | String | Nom complet |
| role | UserRole | Rôle de l'utilisateur |
| status | AccountStatus | Statut du compte |
| lastLogin | LocalDateTime | Dernière connexion |
| emailVerified | Boolean | Email vérifié |
| phoneNumber | String | Numéro de téléphone |
| profilePictureUrl | String | URL de la photo de profil |
| createdAt | LocalDateTime | Date de création |
| updatedAt | LocalDateTime | Date de mise à jour |
| deleted | Boolean | Suppression logique |

**Relations:**
- OneToOne avec Patient
- OneToMany avec RefreshToken
- OneToMany avec MedicalNote
- OneToMany avec Report
- OneToMany avec AuditLog

---

#### VerificationCode
**Table:** `verification_codes`  
**Description:** Codes de vérification pour connexion/reset password

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| email | String | Email destinataire |
| code | String(6) | Code à 6 chiffres |
| type | CodeType | Type de code |
| expiresAt | LocalDateTime | Date d'expiration |
| used | Boolean | Code utilisé |
| attempts | Integer | Nombre de tentatives |
| createdAt | LocalDateTime | Date de création |

**Méthodes utiles:**
- `isExpired()` : Vérifie si le code est expiré
- `isValid()` : Vérifie si le code est valide (non utilisé et non expiré)

---

#### RefreshToken
**Table:** `refresh_tokens`  
**Description:** Tokens de rafraîchissement JWT

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| user | User | Utilisateur propriétaire |
| token | String | Token JWT |
| expiresAt | LocalDateTime | Date d'expiration |
| revoked | Boolean | Token révoqué |
| deviceInfo | String | Info sur l'appareil |
| ipAddress | String | Adresse IP |
| createdAt | LocalDateTime | Date de création |

**Relations:**
- ManyToOne avec User

---

### 2. Module Patient (1 entité)

#### Patient
**Table:** `patients`  
**Description:** Dossier patient médical

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| fullName | String | Nom complet |
| medicalRecordId | String | N° dossier médical (unique) |
| birthDate | LocalDate | Date de naissance |
| sex | String(1) | Sexe (M/F) |
| status | PatientStatus | État de santé |
| roomNumber | String | Numéro de chambre |
| phoneNumber | String | Téléphone |
| emergencyContact | String | Contact d'urgence |
| emergencyPhone | String | Tél. d'urgence |
| caregivers | List<String> | Liste des soignants |
| user | User | Compte utilisateur lié |
| profilePictureUrl | String | Photo de profil |
| alertCount | Integer | Nombre d'alertes actives |
| createdAt | LocalDateTime | Date de création |
| updatedAt | LocalDateTime | Date de mise à jour |
| deleted | Boolean | Suppression logique |

**Relations:**
- OneToOne avec User
- OneToMany avec Alert
- OneToMany avec HeartRateData
- OneToMany avec MoodData
- OneToMany avec SleepData
- OneToMany avec MedicalNote
- OneToMany avec Report

**Méthodes utiles:**
- `getAge()` : Calcule l'âge du patient

---

### 3. Module Alert (1 entité)

#### Alert
**Table:** `alerts`  
**Description:** Alertes médicales

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| type | AlertType | Type d'alerte |
| priority | AlertPriority | Priorité |
| status | AlertStatus | Statut |
| patient | Patient | Patient concerné |
| message | String(500) | Message d'alerte |
| timestamp | LocalDateTime | Horodatage |
| acknowledged | Boolean | Alerte reconnue |
| acknowledgedBy | User | Reconnu par |
| acknowledgedAt | LocalDateTime | Date de reconnaissance |
| acknowledgementNote | String(500) | Note de reconnaissance |
| resolved | Boolean | Alerte résolue |
| resolvedBy | User | Résolu par |
| resolvedAt | LocalDateTime | Date de résolution |
| resolutionNote | String(500) | Note de résolution |
| actionTaken | String(500) | Action entreprise |
| metadata | String(JSON) | Métadonnées additionnelles |
| createdAt | LocalDateTime | Date de création |

**Relations:**
- ManyToOne avec Patient
- ManyToOne avec User (acknowledgedBy)
- ManyToOne avec User (resolvedBy)

**Index:**
- patient_id
- status
- priority
- timestamp

---

### 4. Module Health (4 entités)

#### HeartRateData
**Table:** `heart_rate_data`  
**Description:** Données de fréquence cardiaque

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| patient | Patient | Patient |
| timestamp | LocalDateTime | Horodatage de la mesure |
| bpm | Integer | Battements par minute |
| vfc | Integer | Variabilité (ms) |
| minBpm | Integer | BPM minimum |
| maxBpm | Integer | BPM maximum |
| isAnomaly | Boolean | Anomalie détectée |
| createdAt | LocalDateTime | Date de création |

**Relations:**
- ManyToOne avec Patient

---

#### MoodData
**Table:** `mood_data`  
**Description:** Données d'humeur du patient

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| patient | Patient | Patient |
| moodValue | MoodValue | Valeur d'humeur |
| notes | String(500) | Notes additionnelles |
| timestamp | LocalDateTime | Horodatage |
| reportedByPatient | Boolean | Rapporté par le patient |
| reportedBy | User | Rapporté par (soignant) |
| createdAt | LocalDateTime | Date de création |

**Relations:**
- ManyToOne avec Patient
- ManyToOne avec User (reportedBy)

---

#### SleepData
**Table:** `sleep_data`  
**Description:** Session de sommeil complète

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| patient | Patient | Patient |
| startTime | LocalDateTime | Début du sommeil |
| endTime | LocalDateTime | Fin du sommeil |
| totalMinutes | Integer | Durée totale (min) |
| lightSleepMinutes | Integer | Sommeil léger (min) |
| deepSleepMinutes | Integer | Sommeil profond (min) |
| remSleepMinutes | Integer | Sommeil REM (min) |
| awakeMinutes | Integer | Éveillé (min) |
| sleepQuality | Integer | Qualité (0-100) |
| cycles | List<SleepCycle> | Cycles de sommeil |
| createdAt | LocalDateTime | Date de création |

**Relations:**
- ManyToOne avec Patient
- OneToMany avec SleepCycle

**Méthodes utiles:**
- `getFormattedDuration()` : Retourne "Xh Ym"

---

#### SleepCycle
**Table:** `sleep_cycles`  
**Description:** Cycle de sommeil individuel

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| sleepData | SleepData | Session de sommeil parente |
| stage | SleepStage | Phase de sommeil |
| durationMinutes | Integer | Durée (min) |
| startTime | LocalDateTime | Début du cycle |
| endTime | LocalDateTime | Fin du cycle |
| sequenceOrder | Integer | Ordre dans la séquence |

**Relations:**
- ManyToOne avec SleepData

---

### 5. Module Healthcare (1 entité)

#### MedicalNote
**Table:** `medical_notes`  
**Description:** Notes médicales des soignants

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| patient | Patient | Patient concerné |
| author | User | Auteur (soignant) |
| title | String | Titre de la note |
| content | Text | Contenu de la note |
| confidential | Boolean | Note confidentielle |
| tags | List<String> | Tags de catégorisation |
| createdAt | LocalDateTime | Date de création |
| updatedAt | LocalDateTime | Date de mise à jour |
| deleted | Boolean | Suppression logique |

**Relations:**
- ManyToOne avec Patient
- ManyToOne avec User (author)

---

### 6. Module Report (1 entité)

#### Report
**Table:** `reports`  
**Description:** Rapports médicaux générés

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| patient | Patient | Patient concerné |
| generatedBy | User | Généré par |
| reportType | ReportType | Type de rapport |
| format | ReportFormat | Format d'export |
| startDate | LocalDate | Date de début |
| endDate | LocalDate | Date de fin |
| filePath | String | Chemin du fichier |
| downloadUrl | String | URL de téléchargement |
| fileSize | Long | Taille du fichier |
| includeCharts | Boolean | Inclure les graphiques |
| includeRawData | Boolean | Inclure les données brutes |
| status | ReportStatus | Statut de génération |
| expiresAt | LocalDateTime | Date d'expiration |
| errorMessage | String | Message d'erreur |
| createdAt | LocalDateTime | Date de création |

**Relations:**
- ManyToOne avec Patient
- ManyToOne avec User (generatedBy)

---

### 7. Module Audit (1 entité)

#### AuditLog
**Table:** `audit_logs`  
**Description:** Traçabilité des actions utilisateur

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Identifiant unique |
| user | User | Utilisateur |
| action | AuditAction | Action effectuée |
| resourceType | String | Type de ressource |
| resourceId | String | ID de la ressource |
| details | Text(JSON) | Détails de l'action |
| ipAddress | String | Adresse IP |
| userAgent | String(500) | User agent |
| success | Boolean | Action réussie |
| errorMessage | String(500) | Message d'erreur |
| createdAt | LocalDateTime | Date de création |

**Relations:**
- ManyToOne avec User

**Index:**
- user_id + action
- resource_type + resource_id
- created_at

---

## 🗂️ STRUCTURE DES PACKAGES

```
com.sacmp
├── common
│   └── enums
│       ├── UserRole.java
│       ├── AccountStatus.java
│       ├── PatientStatus.java
│       ├── AlertType.java
│       ├── AlertPriority.java
│       ├── AlertStatus.java
│       ├── SleepStage.java
│       ├── MoodValue.java
│       ├── ReportType.java
│       ├── ReportFormat.java
│       ├── ReportStatus.java
│       ├── CodeType.java
│       └── AuditAction.java
│
├── auth
│   └── entity
│       ├── User.java
│       ├── VerificationCode.java
│       └── RefreshToken.java
│
├── patient
│   └── entity
│       └── Patient.java
│
├── alert
│   └── entity
│       └── Alert.java
│
├── health
│   └── entity
│       ├── HeartRateData.java
│       ├── MoodData.java
│       ├── SleepData.java
│       └── SleepCycle.java
│
├── healthcare
│   └── entity
│       └── MedicalNote.java
│
├── report
│   └── entity
│       └── Report.java
│
└── audit
    └── entity
        └── AuditLog.java
```

---

## 📋 PROCHAINES ÉTAPES

### 1. Repositories
Créer les repositories Spring Data JPA pour chaque entité

### 2. Services
Implémenter la logique métier pour chaque module

### 3. Controllers
Créer les endpoints REST API

### 4. DTOs
Créer les objets de transfert de données

### 5. Mappers
Mapper les entités vers les DTOs

### 6. Validation
Ajouter les validations Jakarta

### 7. Tests
Écrire les tests unitaires et d'intégration

### 8. Migration Base de Données
Créer les scripts Flyway ou Liquibase

---

## 🔐 SÉCURITÉ

- Toutes les entités utilisent `@EntityListeners(AuditingEntityListener.class)` pour l'audit automatique
- User implémente `UserDetails` pour l'intégration Spring Security
- Les mots de passe sont stockés en hash (passwordHash)
- Suppression logique avec le flag `deleted`
- Tokens de rafraîchissement pour une sécurité accrue
- Traçabilité complète avec AuditLog

---

## 📊 STATISTIQUES

| Catégorie | Nombre |
|-----------|--------|
| Enums | 13 |
| Entités | 12 |
| Relations OneToOne | 2 |
| Relations OneToMany | 12 |
| Relations ManyToOne | 14 |
| Index créés | 25+ |
| Champs totaux | ~150 |

---

**Note:** Ce document reflète la structure complète des entités basée sur l'analyse du frontend Flutter.
