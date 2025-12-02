# 🏗️ GUIDE DE STRUCTURE PROFESSIONNELLE DES ENTITÉS
## Backend Spring Boot - Bonnes Pratiques

Date : 2 décembre 2025

---

## 📋 TABLE DES MATIÈRES

1. [Hiérarchie des Classes de Base](#hiérarchie-des-classes-de-base)
2. [Règles de Nommage](#règles-de-nommage)
3. [Organisation des Packages](#organisation-des-packages)
4. [Structure d'une Entité](#structure-dune-entité)
5. [Annotations Recommandées](#annotations-recommandées)
6. [Relations entre Entités](#relations-entre-entités)
7. [Indexation et Performance](#indexation-et-performance)
8. [Checklist de Validation](#checklist-de-validation)

---

## 1️⃣ HIÉRARCHIE DES CLASSES DE BASE

```
BaseEntity (abstract)
    ↓
    ├── id: UUID
    ├── createdAt: LocalDateTime
    └── updatedAt: LocalDateTime
    
    ↓ (extends)
    
SoftDeletableEntity (abstract)
    ↓
    ├── deleted: Boolean
    ├── deletedAt: LocalDateTime
    ├── softDelete()
    ├── restore()
    └── isActive()
    
    ↓ (extends)
    
AuditableEntity (abstract)
    ↓
    ├── createdBy: UUID
    └── lastModifiedBy: UUID
```

### Quand utiliser quelle classe de base ?

| Classe de Base | Utilisation | Exemples |
|----------------|-------------|----------|
| **BaseEntity** | Entités simples sans suppression logique | HeartRateData, SleepCycle, VerificationCode |
| **SoftDeletableEntity** | Entités avec suppression logique | Patient, User, MedicalNote, Alert |
| **AuditableEntity** | Entités critiques nécessitant traçabilité complète | MedicalNote, Report, Alert |

---

## 2️⃣ RÈGLES DE NOMMAGE

### Classes
- ✅ **PascalCase** : `Patient`, `HeartRateData`, `MedicalNote`
- ✅ Nom au **singulier** : `User` (pas `Users`)
- ✅ Suffixe **Data** pour données de mesure : `HeartRateData`, `SleepData`

### Tables
- ✅ **snake_case** : `heart_rate_data`, `medical_notes`
- ✅ Nom au **pluriel** : `users`, `patients`, `alerts`

### Colonnes
- ✅ **snake_case** : `created_at`, `medical_record_id`
- ✅ Préfixe **is_** pour booléens : `is_deleted`, `is_active`
- ✅ Suffixe **_id** pour clés étrangères : `patient_id`, `user_id`
- ✅ Suffixe **_at** pour timestamps : `created_at`, `acknowledged_at`

### Index
- ✅ Préfixe **idx_** : `idx_patient_timestamp`
- ✅ Format : `idx_table_column` ou `idx_table_column1_column2`

---

## 3️⃣ ORGANISATION DES PACKAGES

### Structure par Domaine (DDD - Recommandé)

```
com.sacmp.{module}/
    ├── entity/          # Entités JPA
    ├── repository/      # Repositories Spring Data
    ├── service/         # Services métier
    │   ├── impl/       # Implémentations
    │   └── mapper/     # Mappers DTO <-> Entity
    ├── dto/            # Data Transfer Objects
    │   ├── request/    # DTOs de requête
    │   └── response/   # DTOs de réponse
    ├── controller/     # REST Controllers
    └── exception/      # Exceptions spécifiques au module
```

### Exemple concret - Module Patient

```
com.sacmp.patient/
    ├── entity/
    │   └── Patient.java
    ├── repository/
    │   └── PatientRepository.java
    ├── service/
    │   ├── PatientService.java
    │   ├── impl/
    │   │   └── PatientServiceImpl.java
    │   └── mapper/
    │       └── PatientMapper.java
    ├── dto/
    │   ├── request/
    │   │   ├── CreatePatientRequest.java
    │   │   └── UpdatePatientRequest.java
    │   └── response/
    │       ├── PatientResponse.java
    │       └── PatientListResponse.java
    └── controller/
        └── PatientController.java
```

---

## 4️⃣ STRUCTURE D'UNE ENTITÉ

### Ordre des éléments dans une classe d'entité

```java
@Entity
@Table(name = "...", indexes = {...})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExampleEntity extends SoftDeletableEntity {

    // 1. CONSTANTES
    private static final String DEFAULT_STATUS = "ACTIVE";
    
    // 2. CHAMPS SIMPLES (colonnes de base)
    @Column(name = "name", nullable = false)
    private String name;
    
    // 3. ENUMS
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private Status status;
    
    // 4. RELATIONS @ManyToOne / @OneToOne
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Parent parent;
    
    // 5. RELATIONS @OneToMany / @ManyToMany
    @OneToMany(mappedBy = "example", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Child> children = new ArrayList<>();
    
    // 6. EMBEDDED / @ElementCollection
    @ElementCollection
    @CollectionTable(name = "example_tags")
    @Builder.Default
    private List<String> tags = new ArrayList<>();
    
    // 7. MÉTHODES MÉTIER
    public void activate() {
        this.status = Status.ACTIVE;
    }
    
    // 8. MÉTHODES UTILITAIRES
    public String getDisplayName() {
        return name + " (" + status + ")";
    }
}
```

---

## 5️⃣ ANNOTATIONS RECOMMANDÉES

### Annotations de Classe

```java
// Configuration JPA
@Entity                              // ✅ Obligatoire
@Table(name = "users",              // ✅ Nom de table explicite
       indexes = {                   // ✅ Index pour performance
           @Index(name = "idx_email", columnList = "email")
       },
       uniqueConstraints = {         // ⚠️ Contraintes d'unicité au niveau DB
           @UniqueConstraint(columnNames = {"email"})
       })

// Lombok
@Getter                              // ✅ Génère les getters
@Setter                              // ✅ Génère les setters
@NoArgsConstructor                   // ✅ Constructeur sans paramètres (JPA)
@AllArgsConstructor                  // ✅ Constructeur avec tous les paramètres
@Builder                             // ✅ Pattern Builder
@ToString(exclude = {"password"})    // ⚠️ Exclure champs sensibles
@EqualsAndHashCode(of = "id")       // ⚠️ Basé uniquement sur l'ID

// Audit
@EntityListeners(AuditingEntityListener.class)  // ✅ Si extends BaseEntity
```

### Annotations de Champs

```java
// Clé primaire
@Id
@GeneratedValue(strategy = GenerationType.UUID)  // ✅ Pour UUID
@Column(name = "id", updatable = false, nullable = false)

// Champs standards
@Column(name = "email",              // ✅ Nom explicite
        unique = true,               // ✅ Unicité au niveau DB
        nullable = false,            // ✅ Non null au niveau DB
        length = 255)                // ✅ Longueur maximale

// Enums
@Enumerated(EnumType.STRING)         // ✅ TOUJOURS STRING (pas ORDINAL)
@Column(name = "status", nullable = false)

// Dates
@CreatedDate                         // ✅ Auto-rempli à la création
@Column(name = "created_at", nullable = false, updatable = false)

@LastModifiedDate                    // ✅ Auto-mis à jour
@Column(name = "updated_at")

// Texte long
@Column(name = "content", columnDefinition = "TEXT")  // ✅ Pour >255 caractères

// Booléens
@Column(name = "is_active")
@Builder.Default                     // ✅ Valeur par défaut avec Builder
private Boolean active = true;
```

### Annotations de Relations

```java
// ManyToOne (côté possédant la FK)
@ManyToOne(fetch = FetchType.LAZY)   // ✅ TOUJOURS LAZY
@JoinColumn(name = "patient_id",     // ✅ Nom de colonne FK
            nullable = false)        // ✅ Obligatoire ou non

// OneToMany (côté inverse)
@OneToMany(mappedBy = "patient",     // ✅ Nom du champ dans l'entité cible
           cascade = CascadeType.ALL, // ⚠️ Selon besoin
           orphanRemoval = true,     // ⚠️ Supprime les enfants orphelins
           fetch = FetchType.LAZY)   // ✅ TOUJOURS LAZY
@Builder.Default                     // ✅ Initialiser la collection
private List<Alert> alerts = new ArrayList<>();

// OneToOne
@OneToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "user_id", unique = true)

// ManyToMany
@ManyToMany(fetch = FetchType.LAZY)
@JoinTable(
    name = "user_roles",             // ✅ Table de jointure
    joinColumns = @JoinColumn(name = "user_id"),
    inverseJoinColumns = @JoinColumn(name = "role_id")
)
```

---

## 6️⃣ RELATIONS ENTRE ENTITÉS

### Règles d'Or

| Règle | Description |
|-------|-------------|
| **Toujours LAZY** | `fetch = FetchType.LAZY` par défaut (performance) |
| **Bidirectionnelle avec précaution** | Relations bidirectionnelles → risque de boucles infinies |
| **Cascade avec prudence** | `CascadeType.ALL` uniquement si logique métier le justifie |
| **OrphanRemoval** | Activer pour relations de composition forte (parent-enfant) |
| **@JsonIgnore** | Sur le côté inverse pour éviter boucles JSON |

### Types de Relations

#### 1. OneToMany / ManyToOne (Le plus courant)

```java
// Côté Parent (One)
@Entity
public class Patient extends SoftDeletableEntity {
    @OneToMany(mappedBy = "patient", 
               cascade = CascadeType.ALL, 
               orphanRemoval = true)
    @Builder.Default
    private List<Alert> alerts = new ArrayList<>();
}

// Côté Enfant (Many)
@Entity
public class Alert extends BaseEntity {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;
}
```

#### 2. OneToOne

```java
// Côté possédant la FK
@Entity
public class Patient extends SoftDeletableEntity {
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", unique = true)
    private User user;
}

// Côté inverse
@Entity
public class User extends SoftDeletableEntity {
    @OneToOne(mappedBy = "user")
    private Patient patient;
}
```

#### 3. ManyToMany (Rarement utilisé en production)

```java
@Entity
public class User extends SoftDeletableEntity {
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "user_permissions",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "permission_id")
    )
    @Builder.Default
    private Set<Permission> permissions = new HashSet<>();
}
```

---

## 7️⃣ INDEXATION ET PERFORMANCE

### Colonnes à Indexer SYSTÉMATIQUEMENT

- ✅ **Clés étrangères** : `patient_id`, `user_id`
- ✅ **Colonnes de recherche fréquente** : `email`, `status`, `timestamp`
- ✅ **Colonnes de tri** : `created_at`, `priority`
- ✅ **Colonnes filtrées dans WHERE** : `is_deleted`, `status`

### Types d'Index

```java
@Table(name = "alerts", indexes = {
    // Index simple
    @Index(name = "idx_status", columnList = "status"),
    
    // Index composite (ordre important!)
    @Index(name = "idx_patient_timestamp", 
           columnList = "patient_id,timestamp"),
    
    // Index unique
    @Index(name = "idx_email_unique", 
           columnList = "email", 
           unique = true)
})
```

### Règles d'Optimisation

| Situation | Recommandation |
|-----------|----------------|
| Requêtes fréquentes sur `WHERE status = ?` | ✅ Index sur `status` |
| Tri par `ORDER BY created_at DESC` | ✅ Index sur `created_at` |
| Filtre `WHERE patient_id = ? AND date BETWEEN ? AND ?` | ✅ Index composite `(patient_id, date)` |
| Relations LAZY | ✅ Utiliser JOIN FETCH dans les requêtes JPQL |
| N+1 Problem | ✅ `@EntityGraph` ou JOIN FETCH |

---

## 8️⃣ CHECKLIST DE VALIDATION

### ✅ Avant de Commit

- [ ] La classe hérite de `BaseEntity`, `SoftDeletableEntity` ou `AuditableEntity`
- [ ] `@Table(name = "...")` est défini avec nom pluriel en snake_case
- [ ] Les index sont créés sur FK et colonnes de recherche
- [ ] Toutes les relations sont `LAZY` par défaut
- [ ] `@Builder.Default` sur collections et booléens
- [ ] Enums utilisent `EnumType.STRING` (jamais ORDINAL)
- [ ] Colonnes ont des noms explicites en snake_case
- [ ] Pas de boucle infinie JSON (utiliser `@JsonIgnore`)
- [ ] Documentation JavaDoc sur la classe et méthodes complexes
- [ ] Tests unitaires pour méthodes métier

### ⚠️ Signaux d'Alerte

- ❌ `FetchType.EAGER` → Problème de performance
- ❌ `CascadeType.ALL` partout → Risque de suppressions en cascade
- ❌ Relations bidirectionnelles sans `@JsonIgnore` → Boucle JSON
- ❌ Pas d'index sur FK → Performances médiocres
- ❌ `EnumType.ORDINAL` → Problème de maintenance
- ❌ Champs `public` → Violation encapsulation

---

## 🎯 EXEMPLE COMPLET D'ENTITÉ PROFESSIONNELLE

Voir le fichier `Patient.java` refactorisé comme exemple de référence.

---

## 📚 RESSOURCES

- [Spring Data JPA Best Practices](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [Hibernate Performance Tuning](https://vladmihalcea.com/tutorials/hibernate/)
- [Domain-Driven Design](https://martinfowler.com/tags/domain%20driven%20design.html)

---

**Version:** 1.0  
**Auteur:** Architecture Team  
**Dernière mise à jour:** 2 décembre 2025
