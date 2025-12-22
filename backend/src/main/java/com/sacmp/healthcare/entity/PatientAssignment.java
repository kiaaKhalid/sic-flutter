package com.sacmp.healthcare.entity;

import com.sacmp.patient.entity.Patient;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entité représentant l'assignation d'un patient à un healthcare worker (docteur)
 */
@Entity
@Table(name = "patient_assignments", indexes = {
    @Index(name = "idx_healthcare_worker_id", columnList = "healthcare_worker_id"),
    @Index(name = "idx_patient_id", columnList = "patient_id"),
    @Index(name = "idx_active", columnList = "is_active")
}, uniqueConstraints = {
    @UniqueConstraint(columnNames = {"healthcare_worker_id", "patient_id"})
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class PatientAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "healthcare_worker_id", nullable = false)
    private HealthcareWorker healthcareWorker;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "assigned_date", nullable = false)
    private LocalDateTime assignedDate;

    @Column(name = "unassigned_date")
    private LocalDateTime unassignedDate;

    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean active = true;

    @Column(name = "is_primary", nullable = false)
    @Builder.Default
    private Boolean primary = false;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
