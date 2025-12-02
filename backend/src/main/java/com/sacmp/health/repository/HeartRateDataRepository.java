package com.sacmp.health.repository;

import com.sacmp.health.entity.HeartRateData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface HeartRateDataRepository extends JpaRepository<HeartRateData, UUID> {
    
    List<HeartRateData> findByPatientIdOrderByRecordedAtDesc(UUID patientId);
    
    List<HeartRateData> findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
        UUID patientId, LocalDateTime start, LocalDateTime end
    );
    
    HeartRateData findFirstByPatientIdOrderByRecordedAtDesc(UUID patientId);
    
    @Query("SELECT AVG(h.bpm) FROM HeartRateData h WHERE h.patient.id = :patientId AND h.recordedAt >= :since")
    Double getAverageBpmSince(UUID patientId, LocalDateTime since);
}
