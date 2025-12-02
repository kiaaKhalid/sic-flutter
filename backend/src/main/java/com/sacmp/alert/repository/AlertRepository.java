package com.sacmp.alert.repository;

import com.sacmp.alert.entity.Alert;
import com.sacmp.common.enums.AlertStatus;
import com.sacmp.common.enums.AlertPriority;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface AlertRepository extends JpaRepository<Alert, UUID> {
    
    List<Alert> findByPatientIdOrderByCreatedAtDesc(UUID patientId);
    
    List<Alert> findByPatientIdAndStatusOrderByCreatedAtDesc(UUID patientId, AlertStatus status);
    
    Page<Alert> findByStatusOrderByPriorityDescCreatedAtDesc(AlertStatus status, Pageable pageable);
    
    List<Alert> findByStatusAndPriorityOrderByCreatedAtDesc(AlertStatus status, AlertPriority priority);
    
    long countByStatus(AlertStatus status);
    
    long countByPatientIdAndStatus(UUID patientId, AlertStatus status);
    
    List<Alert> findTop10ByStatusOrderByPriorityDescCreatedAtDesc(AlertStatus status);
}
