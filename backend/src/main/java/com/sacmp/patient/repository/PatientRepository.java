package com.sacmp.patient.repository;

import com.sacmp.patient.entity.Patient;
import com.sacmp.common.enums.PatientStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;
import java.util.List;

@Repository
public interface PatientRepository extends JpaRepository<Patient, UUID> {
    
    Optional<Patient> findByMedicalRecordId(String medicalRecordId);
    
    Optional<Patient> findByUserId(UUID userId);
    
    boolean existsByMedicalRecordId(String medicalRecordId);
    
    Page<Patient> findByDeletedFalse(Pageable pageable);
    
    List<Patient> findByStatusAndDeletedFalse(PatientStatus status);
    
    Page<Patient> findByStatusAndDeletedFalse(PatientStatus status, Pageable pageable);
    
    long countByStatusAndDeletedFalse(PatientStatus status);
    
    long countByDeletedFalse();

    /**
     * Rechercher des patients par nom ou email
     */
    @Query("SELECT p FROM Patient p WHERE p.deleted = false AND " +
           "(LOWER(p.user.fullName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(p.user.email) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(p.medicalRecordId) LIKE LOWER(CONCAT('%', :query, '%')))")
    Page<Patient> searchByNameOrEmail(@Param("query") String query, Pageable pageable);
}
