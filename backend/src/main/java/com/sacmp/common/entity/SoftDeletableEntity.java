package com.sacmp.common.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * Classe de base pour les entités avec suppression logique
 * Hérite de BaseEntity et ajoute le flag de suppression
 */
@MappedSuperclass
@Getter
@Setter
public abstract class SoftDeletableEntity extends BaseEntity {

    @Column(name = "is_deleted", nullable = false)
    private Boolean deleted = false;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    /**
     * Marque l'entité comme supprimée (soft delete)
     */
    public void softDelete() {
        this.deleted = true;
        this.deletedAt = LocalDateTime.now();
    }

    /**
     * Restaure l'entité supprimée
     */
    public void restore() {
        this.deleted = false;
        this.deletedAt = null;
    }

    /**
     * Vérifie si l'entité est active (non supprimée)
     */
    public boolean isActive() {
        return !deleted;
    }
}
