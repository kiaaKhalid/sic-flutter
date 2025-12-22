package com.sacmp.alert.service;

import com.sacmp.alert.dto.AcknowledgeAlertRequest;
import com.sacmp.alert.dto.AlertResponse;
import com.sacmp.alert.dto.ResolveAlertRequest;
import com.sacmp.alert.entity.Alert;
import com.sacmp.alert.repository.AlertRepository;
import com.sacmp.auth.entity.User;
import com.sacmp.common.enums.*;
import com.sacmp.healthcare.entity.HealthcareWorker;
import com.sacmp.healthcare.repository.HealthcareWorkerRepository;
import com.sacmp.patient.entity.Patient;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AlertServiceTest {

    @Mock
    private AlertRepository alertRepository;

    @Mock
    private HealthcareWorkerRepository healthcareWorkerRepository;

    @InjectMocks
    private AlertService alertService;

    private Alert alert;
    private Patient patient;
    private User patientUser;
    private HealthcareWorker healthcareWorker;
    private User workerUser;
    private UUID alertId;
    private UUID workerId;

    @BeforeEach
    void setUp() {
        alertId = UUID.randomUUID();
        workerId = UUID.randomUUID();

        patientUser = new User();
        patientUser.setId(UUID.randomUUID());
        patientUser.setFullName("John Doe");
        patientUser.setEmail("patient@test.com");

        patient = new Patient();
        patient.setId(UUID.randomUUID());
        patient.setUser(patientUser);

        workerUser = new User();
        workerUser.setId(workerId);
        workerUser.setFullName("Dr. Smith");
        workerUser.setEmail("doctor@test.com");

        healthcareWorker = new HealthcareWorker();
        healthcareWorker.setId(UUID.randomUUID());
        healthcareWorker.setUser(workerUser);

        alert = new Alert();
        alert.setId(alertId);
        alert.setPatient(patient);
        alert.setTitle("High Heart Rate");
        alert.setMessage("Heart rate is too high");
        alert.setType(AlertType.HEART_RATE);
        alert.setPriority(AlertPriority.HIGH);
        alert.setStatus(AlertStatus.ACTIVE);
        alert.setCreatedAt(LocalDateTime.now());
    }

    @Test
    void getActiveAlerts_ShouldReturnPagedAlerts() {
        // Given
        Pageable pageable = PageRequest.of(0, 10);
        Page<Alert> alertPage = new PageImpl<>(Collections.singletonList(alert));
        
        when(alertRepository.findByStatusOrderByPriorityDescCreatedAtDesc(AlertStatus.ACTIVE, pageable))
                .thenReturn(alertPage);

        // When
        Page<AlertResponse> result = alertService.getActiveAlerts(pageable);

        // Then
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getTitle()).isEqualTo("High Heart Rate");
        verify(alertRepository).findByStatusOrderByPriorityDescCreatedAtDesc(AlertStatus.ACTIVE, pageable);
    }

    @Test
    void getPatientAlerts_ShouldReturnAlertsList() {
        // Given
        UUID patientId = patient.getId();
        when(alertRepository.findByPatientIdOrderByCreatedAtDesc(patientId))
                .thenReturn(Collections.singletonList(alert));

        // When
        List<AlertResponse> result = alertService.getPatientAlerts(patientId);

        // Then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getTitle()).isEqualTo("High Heart Rate");
        assertThat(result.get(0).getPriority()).isEqualTo("HIGH");
        verify(alertRepository).findByPatientIdOrderByCreatedAtDesc(patientId);
    }

    @Test
    void getAlertById_ShouldReturnAlert_WhenExists() {
        // Given
        when(alertRepository.findById(alertId)).thenReturn(Optional.of(alert));

        // When
        AlertResponse result = alertService.getAlertById(alertId);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getTitle()).isEqualTo("High Heart Rate");
        assertThat(result.getStatus()).isEqualTo("ACTIVE");
        verify(alertRepository).findById(alertId);
    }

    @Test
    void getAlertById_ShouldThrowException_WhenNotFound() {
        // Given
        when(alertRepository.findById(alertId)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> alertService.getAlertById(alertId))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Alerte non trouvée");
        verify(alertRepository).findById(alertId);
    }

    @Test
    void acknowledgeAlert_ShouldUpdateAlert() {
        // Given
        AcknowledgeAlertRequest request = new AcknowledgeAlertRequest();
        request.setNote("Acknowledged by doctor");

        when(alertRepository.findById(alertId)).thenReturn(Optional.of(alert));
        when(healthcareWorkerRepository.findByUserId(workerId)).thenReturn(Optional.of(healthcareWorker));
        when(alertRepository.save(any(Alert.class))).thenAnswer(i -> i.getArguments()[0]);

        // When
        alertService.acknowledgeAlert(alertId, workerId, request);

        // Then
        assertThat(alert.getStatus()).isEqualTo(AlertStatus.ACKNOWLEDGED);
        assertThat(alert.getAcknowledgedBy()).isEqualTo(healthcareWorker);
        assertThat(alert.getAcknowledgedAt()).isNotNull();
        assertThat(alert.getAcknowledgmentNote()).isEqualTo("Acknowledged by doctor");
        verify(alertRepository).save(alert);
    }

    @Test
    void acknowledgeAlert_ShouldThrowException_WhenAlertNotFound() {
        // Given
        AcknowledgeAlertRequest request = new AcknowledgeAlertRequest();
        when(alertRepository.findById(alertId)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> alertService.acknowledgeAlert(alertId, workerId, request))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Alerte non trouvée");
        verify(alertRepository).findById(alertId);
        verify(alertRepository, never()).save(any());
    }

    @Test
    void resolveAlert_ShouldUpdateAlert() {
        // Given
        ResolveAlertRequest request = new ResolveAlertRequest();
        request.setResolutionNote("Issue resolved successfully");

        when(alertRepository.findById(alertId)).thenReturn(Optional.of(alert));
        when(healthcareWorkerRepository.findByUserId(workerId)).thenReturn(Optional.of(healthcareWorker));
        when(alertRepository.save(any(Alert.class))).thenAnswer(i -> i.getArguments()[0]);

        // When
        alertService.resolveAlert(alertId, workerId, request);

        // Then
        assertThat(alert.getStatus()).isEqualTo(AlertStatus.RESOLVED);
        assertThat(alert.getResolvedBy()).isEqualTo(healthcareWorker);
        assertThat(alert.getResolvedAt()).isNotNull();
        assertThat(alert.getResolutionNote()).isEqualTo("Issue resolved successfully");
        verify(alertRepository).save(alert);
    }

    @Test
    void resolveAlert_ShouldThrowException_WhenWorkerNotFound() {
        // Given
        ResolveAlertRequest request = new ResolveAlertRequest();
        when(alertRepository.findById(alertId)).thenReturn(Optional.of(alert));
        when(healthcareWorkerRepository.findByUserId(workerId)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> alertService.resolveAlert(alertId, workerId, request))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Travailleur de santé non trouvé");
        verify(alertRepository, never()).save(any());
    }
}
