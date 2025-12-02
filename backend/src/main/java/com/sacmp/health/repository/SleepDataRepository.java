package com.sacmp.health.repository;

import com.sacmp.health.entity.SleepData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface SleepDataRepository extends JpaRepository<SleepData, UUID> {
    
    List<SleepData> findByPatientIdOrderBySleepStartDesc(UUID patientId);
    
    List<SleepData> findByPatientIdAndSleepStartBetweenOrderBySleepStartDesc(
        UUID patientId, LocalDateTime start, LocalDateTime end
    );
    
    SleepData findFirstByPatientIdOrderBySleepStartDesc(UUID patientId);
}
