package com.sacmp.common.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.LastModifiedBy;

import java.util.UUID;

/**
 * Classe de base pour les entités nécessitant un audit complet
 * Hérite de SoftDeletableEntity et ajoute les informations de créateur/modificateur
 */
@MappedSuperclass
@Getter
@Setter
public abstract class AuditableEntity extends SoftDeletableEntity {

    @CreatedBy
    @Column(name = "created_by", updatable = false)
    private UUID createdBy;

    @LastModifiedBy
    @Column(name = "last_modified_by")
    private UUID lastModifiedBy;
}
