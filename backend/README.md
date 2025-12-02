# 🏥 SAC-MP Backend

**Surveillance Active et Continue - Médecine Personnalisée**

Backend Spring Boot pour l'application Flutter de suivi médical.

## 📋 Prérequis

- Java 21+
- Maven 3.8+
- MySQL 8.0+ (pour la production)

## 🚀 Démarrage rapide

### 1. Configuration

```bash
# Copier le fichier d'environnement
cp .env.example .env

# Éditer les variables selon votre environnement
nano .env
```

### 2. Lancement en mode développement

```bash
# Le mode dev utilise H2 (base de données en mémoire)
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

### 3. Accès aux services

| Service | URL |
|---------|-----|
| API | http://localhost:8080/api |
| Swagger UI | http://localhost:8080/api/swagger-ui.html |
| H2 Console (dev) | http://localhost:8080/api/h2-console |
| Health Check | http://localhost:8080/api/actuator/health |

## 📁 Structure du projet

```
src/main/java/com/sacmp/
├── SacMpApplication.java          # Point d'entrée
├── config/                        # Configuration
│   ├── SecurityConfig.java        # Spring Security
│   ├── JwtConfig.java            # Configuration JWT
│   ├── CorsConfig.java           # Configuration CORS
│   └── OpenApiConfig.java        # Swagger/OpenAPI
├── common/                        # Classes communes
│   ├── dto/                      # DTOs partagés
│   ├── entity/                   # Entités de base
│   ├── enums/                    # Énumérations
│   └── exception/                # Gestion des erreurs
├── auth/                          # Module Authentification
│   ├── controller/
│   ├── service/
│   ├── repository/
│   ├── dto/
│   └── entity/
├── patient/                       # Module Patient
│   ├── controller/
│   ├── service/
│   ├── repository/
│   ├── dto/
│   └── entity/
└── healthcare/                    # Module Healthcare Worker
    ├── controller/
    ├── service/
    ├── repository/
    ├── dto/
    └── entity/
```

## 🔐 Authentification

L'API utilise JWT (JSON Web Tokens) pour l'authentification.

### Endpoints publics
- `POST /api/v1/auth/register` - Inscription
- `POST /api/v1/auth/login` - Connexion
- `POST /api/v1/auth/google` - Connexion Google
- `POST /api/v1/auth/forgot-password` - Mot de passe oublié
- `POST /api/v1/auth/refresh-token` - Rafraîchir le token

### Headers requis
```
Authorization: Bearer <access_token>
Content-Type: application/json
```

## 🗄️ Base de données

### Développement (H2)
- Console: http://localhost:8080/api/h2-console
- JDBC URL: `jdbc:h2:mem:sacmp_dev`
- User: `sa`
- Password: (vide)

### Production (MySQL)
```sql
CREATE DATABASE sacmp_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

## 📖 Documentation API

La documentation Swagger est disponible en mode dev:
- **Swagger UI**: http://localhost:8080/api/swagger-ui.html
- **OpenAPI JSON**: http://localhost:8080/api/v3/api-docs

## 🧪 Tests

```bash
# Lancer tous les tests
./mvnw test

# Lancer avec couverture
./mvnw test jacoco:report
```

## 📦 Build

```bash
# Build sans tests
./mvnw clean package -DskipTests

# Build complet
./mvnw clean package
```

## 🐳 Docker (optionnel)

```bash
# Build l'image
docker build -t sacmp-backend .

# Lancer le conteneur
docker run -p 8080:8080 --env-file .env sacmp-backend
```

## 📝 Logs

Les logs sont stockés dans `logs/sacmp-backend.log`

## 🔧 Profils disponibles

| Profil | Description |
|--------|-------------|
| `dev` | Développement avec H2, Swagger activé |
| `test` | Tests avec H2 |
| `prod` | Production avec MySQL, Swagger désactivé |

## 📚 API Endpoints

### Auth API (12 endpoints)
- Inscription, connexion, Google Auth
- Codes de vérification par email
- Reset password
- Refresh token

### Patient API (7 endpoints)
- Profil patient
- Rythme cardiaque
- Données de sommeil
- Humeur (lecture + déclaration)
- Alertes
- Corrélations

### Healthcare Worker API (15 endpoints)
- Dashboard
- Gestion patients (CRUD)
- Gestion alertes
- Notes médicales
- Génération de rapports

---

**Version**: 1.0.0  
**Java**: 21  
**Spring Boot**: 3.5.0
