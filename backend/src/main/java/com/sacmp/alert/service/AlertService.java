package com.sacmp.alert.service;

import com.sacmp.alert.dto.AcknowledgeAlertRequest;
import com.sacmp.alert.dto.AlertResponse;
import com.sacmp.alert.dto.ResolveAlertRequest;
import com.sacmp.alert.entity.Alert;
import com.sacmp.alert.repository.AlertRepository;
import com.sacmp.common.enums.AlertStatus;
import com.sacmp.healthcare.entity.HealthcareWorker;
import com.sacmp.healthcare.repository.HealthcareWorkerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AlertService {

    private final AlertRepository alertRepository;
    private final HealthcareWorkerRepository healthcareWorkerRepository;

    @Transactional(readOnly = true)
    public Page<AlertResponse> getActiveAlerts(Pageable pageable) {
        Page<Alert> alerts = alertRepository.findByStatusOrderByPriorityDescCreatedAtDesc(AlertStatus.ACTIVE, pageable);
        return alerts.map(this::buildAlertResponse);
    }

    @Transactional(readOnly = true)
    public List<AlertResponse> getPatientAlerts(UUID patientId) {
        List<Alert> alerts = alertRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
        return alerts.stream()
                .map(this::buildAlertResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public AlertResponse getAlertById(UUID alertId) {
        Alert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new RuntimeException("Alerte non trouvée"));
        return buildAlertResponse(alert);
    }

    @Transactional
    public void acknowledgeAlert(UUID alertId, UUID healthcareWorkerId, AcknowledgeAlertRequest request) {
        Alert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new RuntimeException("Alerte non trouvée"));

        HealthcareWorker healthcareWorker = healthcareWorkerRepository.findByUserId(healthcareWorkerId)
                .orElseThrow(() -> new RuntimeException("Travailleur de santé non trouvé"));

        alert.setStatus(AlertStatus.ACKNOWLEDGED);
        alert.setAcknowledgedBy(healthcareWorker);
        alert.setAcknowledgedAt(LocalDateTime.now());
        alert.setAcknowledgmentNote(request.getNote());

        alertRepository.save(alert);
        log.info("Alerte {} accusée réception par {}", alertId, healthcareWorker.getUser().getFullName());
    }

    @Transactional
    public void resolveAlert(UUID alertId, UUID healthcareWorkerId, ResolveAlertRequest request) {
        Alert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new RuntimeException("Alerte non trouvée"));

        HealthcareWorker healthcareWorker = healthcareWorkerRepository.findByUserId(healthcareWorkerId)
                .orElseThrow(() -> new RuntimeException("Travailleur de santé non trouvé"));

        alert.setStatus(AlertStatus.RESOLVED);
        alert.setResolvedBy(healthcareWorker);
        alert.setResolvedAt(LocalDateTime.now());
        alert.setResolutionNote(request.getResolutionNote());

        alertRepository.save(alert);
        log.info("Alerte {} résolue par {}", alertId, healthcareWorker.getUser().getFullName());
    }

    private AlertResponse buildAlertResponse(Alert alert) {
        AlertResponse.AcknowledgmentInfo acknowledgment = null;
        if (alert.getAcknowledgedBy() != null) {
            acknowledgment = AlertResponse.AcknowledgmentInfo.builder()
                    .acknowledgedBy(alert.getAcknowledgedBy().getUser().getFullName())
                    .acknowledgedAt(alert.getAcknowledgedAt())
                    .note(alert.getAcknowledgmentNote())
                    .build();
        }

        AlertResponse.ResolutionInfo resolution = null;
        if (alert.getResolvedBy() != null) {
            resolution = AlertResponse.ResolutionInfo.builder()
                    .resolvedBy(alert.getResolvedBy().getUser().getFullName())
                    .resolvedAt(alert.getResolvedAt())
                    .note(alert.getResolutionNote())
                    .build();
        }

        return AlertResponse.builder()
                .id(alert.getId().toString())
                .type(alert.getType().name())
                .priority(alert.getPriority().name())
                .status(alert.getStatus().name())
                .title(alert.getTitle())
                .message(alert.getMessage())
                .patientId(alert.getPatient().getId().toString())
                .patientName(alert.getPatient().getUser().getFullName())
                .metadata(alert.getMetadata())
                .createdAt(alert.getCreatedAt())
                .acknowledgment(acknowledgment)
                .resolution(resolution)
                .build();
    }
}
