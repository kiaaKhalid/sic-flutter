package com.sacmp.common.enums;

/**
 * Actions d'audit
 */
public enum AuditAction {
    LOGIN,               // Connexion
    LOGOUT,              // Déconnexion
    CREATE,              // Création
    READ,                // Lecture
    UPDATE,              // Mise à jour
    DELETE,              // Suppression
    EXPORT,              // Export de données
    ACKNOWLEDGE_ALERT,   // Reconnaissance d'alerte
    RESOLVE_ALERT        // Résolution d'alerte
}