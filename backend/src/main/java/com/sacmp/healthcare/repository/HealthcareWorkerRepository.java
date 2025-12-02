package com.sacmp.healthcare.repository;

import com.sacmp.healthcare.entity.HealthcareWorker;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface HealthcareWorkerRepository extends JpaRepository<HealthcareWorker, UUID> {
    
    Optional<HealthcareWorker> findByUserId(UUID userId);
    
    Optional<HealthcareWorker> findByLicenseNumber(String licenseNumber);
    
    boolean existsByLicenseNumber(String licenseNumber);
}
