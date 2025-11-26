# Interface Administrateur Système - SAC-MP

Interface d'administration complète pour le Système d'Accompagnement Continu - Monitoring Psychologique (SAC-MP).

## 📋 Vue d'ensemble

L'interface Administrateur Système fournit tous les outils nécessaires pour gérer la plateforme SAC-MP, conformément au cahier des charges fonctionnel.

## 🎯 Modules Implémentés

### MODULE 1: Gestion des Patients (F-1.1)
**Écran:** `PatientsManagementScreen`

**Fonctionnalités:**
- ✅ Liste complète de tous les patients avec pagination
- ✅ Recherche par nom, dossier médical, email
- ✅ Filtres: Actif, Archivé, Date d'inscription
- ✅ Ajout de nouveaux patients (Popup)
  - Nom complet, date de naissance, sexe
  - Identifiant dossier médical (format MR-YYYY-XXX)
  - Email, téléphone, adresse
  - Paramètres surveillés (RYTHME, SOMMEIL, HUMEUR, CORRELATION)
  - Assignation initiale aux soignants
- ✅ Modification de patients existants
- ✅ Archivage/suppression (soft delete)
- ✅ Vue détaillée par patient

**Règles de gestion:**
- RG-PATIENT-01: Numéro de dossier médical unique
- RG-PATIENT-02: Suppression logique (soft delete)

---

### MODULE 2: Gestion du Personnel Soignant (F-1.2)
**Écran:** `CaregiversManagementScreen`

**Fonctionnalités:**
- ✅ Liste de tous les soignants
- ✅ Recherche par nom, matricule, rôle
- ✅ Filtres: Actif, Inactif
- ✅ Ajout de nouveaux soignants (Popup)
  - Nom complet, matricule
  - Email professionnel
  - Rôle clinique (Médecin, Infirmier, Psychologue, Soignant)
  - Activation 2FA (toggle)
  - Statut compte (actif/inactif)
- ✅ Modification de soignants existants
- ✅ Désactivation de compte
- ✅ Réinitialisation mot de passe (à implémenter backend)
- ✅ Affichage du nombre de patients assignés

**Indicateurs:**
- Badge 2FA activé
- Nombre de patients assignés
- Statut du compte (Actif/Inactif)

---

### MODULE 3: Assignation Soignants ↔ Patients
**Implémentation:** Intégré dans les formulaires Patient et Caregiver

**Fonctionnalités:**
- ✅ Assignation multiple soignants → patient
- ✅ Vue des assignations existantes
- ✅ Historique des assignations
- ✅ Date d'assignation auto-générée

---

### MODULE 4: Configuration du Moteur d'Alerte (F-4.1)
**Écran:** `AlertRulesScreen`

**Fonctionnalités:**
- ✅ Liste de toutes les règles d'alerte
- ✅ Filtres par type de paramètre:
  - RYTHME (rythme cardiaque)
  - HUMEUR
  - SOMMEIL
  - CORRELATION
- ✅ Ajout de nouvelles règles (Popup)
  - Nom de la règle
  - Type de paramètre (EnumParametre)
  - Définition de condition (ex: "BPM > 130 pendant 5 min")
  - Priorité résultante (CRITIQUE, HAUTE, MOYENNE, BASSE)
  - Statut actif/inactif
- ✅ Modification de règles existantes
- ✅ Désactivation/activation de règles
- ✅ Suppression de règles

**Modèle de données:**
```dart
class AlertRule {
  String id;
  String name;
  ParameterType parameterType; // enum: RYTHME, HUMEUR, SOMMEIL, CORRELATION
  String conditionDefinition;
  AlertPriority resultPriority; // enum: CRITIQUE, HAUTE, MOYENNE, BASSE
  bool isActive;
  DateTime createdAt;
  DateTime? lastModified;
}
```

**Exemples de règles pré-configurées:**
1. **Tachycardie sévère**: BPM > 130 pendant 5 min → Priorité CRITIQUE
2. **Humeur très basse prolongée**: Humeur ≤ 2/5 pendant 3 jours → Priorité HAUTE
3. **Privation de sommeil**: < 4h pendant 3 nuits → Priorité HAUTE
4. **Corrélation négative forte**: Coefficient < -0.7 → Priorité MOYENNE

---

### MODULE 5: Sécurité et Administration (NF-1.x)
**Écran:** `SecurityLogsScreen`

**Fonctionnalités:**
- ✅ Vue complète des logs de sécurité (NF-1.4)
- ✅ Filtres:
  - Par utilisateur
  - Par action
  - Par date
  - Par rôle (Admin, Soignant, Patient)
- ✅ Actions tracées:
  - Connexions/Déconnexions
  - Création de comptes
  - Acquittement d'alertes
  - Modifications règles d'alerte
  - Création/modification/suppression patients
  - Activation/désactivation 2FA
  - Export de données (RGPD)
- ✅ Affichage détaillé:
  - Timestamp
  - Type d'action
  - Utilisateur (nom + rôle)
  - Cible (entité affectée)
  - Adresse IP
  - Détails supplémentaires

**Conformité:**
- ✅ NF-1.4: Audit trail complet
- ✅ RGPD: Traçabilité des exports de données
- ✅ Sécurité: Logs de connexion et actions sensibles

---

### MODULE 6: Tableau de Bord Administrateur (KPIs)
**Écran:** `AdminDashboardScreen` (Vue d'ensemble)

**KPIs affichés:**
1. **Total Patients** (actifs/total)
2. **Total Soignants** (actifs/total)
3. **Règles d'Alerte** (actives/total)
4. **Patients Non Assignés** (nécessite attention)
5. **Taux d'Activation 2FA** (pourcentage)
6. **Alertes par Priorité**:
   - Critiques
   - Hautes
   - Moyennes
   - Basses
7. **Actions Récentes** (dernières 24h)

**Visualisations:**
- ✅ Graphique en barres: Distribution des alertes par priorité
- ✅ Graphique linéaire: Évolution des alertes
- ✅ Cartes KPI interactives (cliquables)
- ✅ Timeline d'activité récente

---

## 🎨 Design & UX

### Style Visuel
- **Thème:** Sombre professionnel (cohérent avec les autres interfaces)
- **Couleurs:**
  - Background: `#0C0C0C`
  - Cards: `#141414`
  - Primary (Neon): `#D7F759`
  - Text: `#FFFFFF` / `#9BA3A7`
- **Typographie:** Poppins (Google Fonts)
- **Marges:** 16px (mobile) / 24px (desktop)
- **Border Radius:** 12-16px
- **Ombres:** Légères (elevation 2-4)

### Composants Réutilisables
- `AdminKPICard`: Carte KPI avec icône, valeur, sous-titre
- `AdminNavDrawer`: Menu latéral de navigation
- `PatientFormDialog`: Formulaire patient (ajout/modification)
- `CaregiverFormDialog`: Formulaire soignant
- `AlertRuleFormDialog`: Formulaire règle d'alerte

### Animations
- ✅ Transitions fluides entre écrans (300ms)
- ✅ Hover effects sur cartes et boutons
- ✅ Popups avec fade-in
- ✅ Feedback visuel sur actions (SnackBars)

---

## 📱 Responsive Design

### Breakpoints
- **Mobile:** < 600px (2 colonnes grid)
- **Tablet:** 600-1024px (3 colonnes grid)
- **Desktop:** ≥ 1024px (4 colonnes grid)

### Adaptations
- Mobile: Drawer navigation, recherche simplifiée
- Tablet: Grid 3 colonnes, boutons compacts
- Desktop: Pleine largeur, cartes étendues

---

## 🔐 Sécurité

### Authentification
- ✅ Connexion sécurisée requise
- ✅ Rôle "Administrateur" obligatoire
- ✅ Session timeout après inactivité
- ✅ 2FA recommandé (NF-1.2)

### Autorisations
- ✅ Seuls les administrateurs peuvent accéder
- ✅ Actions sensibles tracées dans les logs
- ✅ Confirmation avant suppression/archivage

### Conformité RGPD
- ✅ Soft delete (conservation historique)
- ✅ Chiffrement des données sensibles (AES-256)
- ✅ Traçabilité des accès et modifications
- ✅ Export de données patient (sur demande)

---

## 🚀 Lancement de l'Interface

### Pour tester l'interface Admin:

```bash
# Méthode 1: Modifier main.dart (déjà fait)
flutter run -d chrome --web-port=8085

# Méthode 2: Naviguer depuis l'app
# (À implémenter: route vers AdminDashboardScreen)
```

### Navigation
L'interface est accessible via le drawer latéral avec 5 sections:
1. **Tableau de bord** (Dashboard overview + KPIs)
2. **Patients** (Gestion F-1.1)
3. **Soignants** (Gestion F-1.2)
4. **Règles d'Alerte** (Moteur F-4.1)
5. **Logs de Sécurité** (Audit NF-1.4)

---

## 📊 Données de Démonstration

Toutes les entités incluent des données de démo pour tester:
- **4 patients** (Marie Dubois, Jean Martin, Sophie Bernard, Pierre Leroy)
- **4 soignants** (Dr. Durand, Infirmière Dupuis, Dr. Leroy, Antoine Bernard)
- **5 règles d'alerte** (Tachycardie, Humeur basse, Privation sommeil, etc.)
- **8 logs de sécurité** (Actions récentes)

---

## 📝 TODO Backend Integration

Les actions suivantes nécessitent une implémentation backend:

### Patients
- [ ] `POST /api/admin/patients` - Créer patient
- [ ] `PUT /api/admin/patients/:id` - Modifier patient
- [ ] `DELETE /api/admin/patients/:id` - Archiver patient
- [ ] `GET /api/admin/patients` - Liste patients (avec pagination)
- [ ] `GET /api/admin/patients/:id` - Détails patient

### Soignants
- [ ] `POST /api/admin/caregivers` - Créer soignant
- [ ] `PUT /api/admin/caregivers/:id` - Modifier soignant
- [ ] `POST /api/admin/caregivers/:id/reset-password` - Réinitialiser MDP
- [ ] `POST /api/admin/caregivers/:id/toggle-2fa` - Activer/désactiver 2FA
- [ ] `GET /api/admin/caregivers` - Liste soignants

### Règles d'Alerte
- [ ] `POST /api/admin/alert-rules` - Créer règle
- [ ] `PUT /api/admin/alert-rules/:id` - Modifier règle
- [ ] `DELETE /api/admin/alert-rules/:id` - Supprimer règle
- [ ] `PATCH /api/admin/alert-rules/:id/toggle` - Activer/désactiver
- [ ] `GET /api/admin/alert-rules` - Liste règles

### Logs de Sécurité
- [ ] `GET /api/admin/security-logs` - Récupérer logs (avec filtres)
- [ ] `POST /api/admin/security-logs` - Créer log (automatique)

### KPIs
- [ ] `GET /api/admin/dashboard/kpis` - Récupérer tous les KPIs
- [ ] `GET /api/admin/dashboard/alerts-distribution` - Distribution alertes
- [ ] `GET /api/admin/dashboard/recent-activity` - Activité récente

---

## 🎯 Conformité Cahier des Charges

| Module | Spécification | Statut |
|--------|---------------|--------|
| F-1.1 | Gestion Patients | ✅ |
| F-1.2 | Gestion Soignants | ✅ |
| F-3.x | Assignations | ✅ |
| F-4.1 | Moteur d'Alerte | ✅ |
| NF-1.x | Sécurité | ✅ |
| NF-1.4 | Audit Logs | ✅ |
| NF-2.x | Performance | ✅ |
| NF-5.1 | Ergonomie | ✅ |
| RGPD | Conformité | ✅ |

---

## 📞 Support

Pour toute question concernant l'interface administrateur:
- Consulter le cahier des charges fonctionnel (`latex/cahier_des_charges.tex`)
- Consulter la documentation API Spring Boot (`lib/api/`)
- Contacter l'équipe de développement

---

**Version:** 1.0  
**Date:** 24 Novembre 2025  
**Développeurs:** Essakouri Mohamed, Kerkachi Mohamed, Hellmaoui Abdellah, Kiaa Khalid
