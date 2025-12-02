package com.sacmp.common.enums;

/**
 * Type d'alerte
 */
public enum AlertType {
    HEART_RATE,    // Rythme cardiaque anormal
    MOOD,          // Changement d'humeur
    SLEEP,         // Problème de sommeil
    CORRELATION,   // Corrélation multi-paramètres
    MEDICATION,    // Alerte médicamenteuse
    EMERGENCY      // Urgence médicale
}