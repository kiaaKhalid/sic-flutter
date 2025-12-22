package com.sacmp.healthcare.repository;

import com.sacmp.healthcare.entity.PatientAssignment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface PatientAssignmentRepository extends JpaRepository<PatientAssignment, UUID> {

    /**
     * Trouver toutes les assignations actives d'un healthcare worker
     */
    @Query("SELECT pa FROM PatientAssignment pa WHERE pa.healthcareWorker.id = :healthcareWorkerId AND pa.active = true")
    List<PatientAssignment> findActiveByHealthcareWorkerId(@Param("healthcareWorkerId") UUID healthcareWorkerId);

    /**
     * Trouver toutes les assignations actives d'un healthcare worker (paginé)
     */
    @Query("SELECT pa FROM PatientAssignment pa WHERE pa.healthcareWorker.id = :healthcareWorkerId AND pa.active = true")
    Page<PatientAssignment> findActiveByHealthcareWorkerId(@Param("healthcareWorkerId") UUID healthcareWorkerId, Pageable pageable);

    /**
     * Trouver une assignation spécifique
     */
    Optional<PatientAssignment> findByHealthcareWorkerIdAndPatientId(UUID healthcareWorkerId, UUID patientId);

    /**
     * Vérifier si une assignation active existe
     */
    boolean existsByHealthcareWorkerIdAndPatientIdAndActiveTrue(UUID healthcareWorkerId, UUID patientId);

    /**
     * Compter les patients actifs d'un healthcare worker
     */
    @Query("SELECT COUNT(pa) FROM PatientAssignment pa WHERE pa.healthcareWorker.id = :healthcareWorkerId AND pa.active = true")
    long countActivePatientsByHealthcareWorkerId(@Param("healthcareWorkerId") UUID healthcareWorkerId);

    /**
     * Trouver les healthcare workers assignés à un patient
     */
    @Query("SELECT pa FROM PatientAssignment pa WHERE pa.patient.id = :patientId AND pa.active = true")
    List<PatientAssignment> findActiveByPatientId(@Param("patientId") UUID patientId);
}
