package com.sacmp.health.repository;

import com.sacmp.health.entity.MoodData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface MoodDataRepository extends JpaRepository<MoodData, UUID> {
    
    List<MoodData> findByPatientIdOrderByRecordedAtDesc(UUID patientId);
    
    List<MoodData> findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
        UUID patientId, LocalDateTime start, LocalDateTime end
    );
    
    MoodData findFirstByPatientIdOrderByRecordedAtDesc(UUID patientId);
}
