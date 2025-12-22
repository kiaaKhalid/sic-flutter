package com.sacmp.health.service;

import com.sacmp.health.dto.HeartRateResponse;
import com.sacmp.health.dto.SleepDataResponse;
import com.sacmp.health.entity.HeartRateData;
import com.sacmp.health.entity.SleepData;
import com.sacmp.health.repository.HeartRateDataRepository;
import com.sacmp.health.repository.SleepDataRepository;
import com.sacmp.patient.entity.Patient;
import com.sacmp.patient.repository.PatientRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class HealthDataServiceTest {

    @Mock
    private PatientRepository patientRepository;

    @Mock
    private HeartRateDataRepository heartRateDataRepository;

    @Mock
    private SleepDataRepository sleepDataRepository;

    @InjectMocks
    private HealthDataService healthDataService;

    private UUID patientId;
    private Patient patient;

    @BeforeEach
    void setUp() {
        patientId = UUID.randomUUID();

        patient = new Patient();
        patient.setId(patientId);
    }

    @Test
    void getHeartRateData_ShouldReturnData_WhenPatientExists() {
        // Given
        LocalDateTime now = LocalDateTime.now();
        List<HeartRateData> heartRateList = Arrays.asList(
                createHeartRateData(75, 50, now.minusHours(1)),
                createHeartRateData(80, 55, now.minusHours(2)),
                createHeartRateData(72, 48, now.minusHours(3))
        );

        when(patientRepository.findById(patientId)).thenReturn(Optional.of(patient));
        when(heartRateDataRepository.findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class)))
                .thenReturn(heartRateList);

        // When
        HeartRateResponse response = healthDataService.getHeartRateData(patientId, "24h");

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getCurrentBpm()).isEqualTo(75);
        assertThat(response.getCurrentVfc()).isEqualTo(50);
        assertThat(response.getMinBpm()).isEqualTo(72);
        assertThat(response.getMaxBpm()).isEqualTo(80);
        assertThat(response.getAverageBpm()).isEqualTo(75.66666666666667);
        assertThat(response.getLast24Hours()).hasSize(3);

        verify(patientRepository).findById(patientId);
        verify(heartRateDataRepository).findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class));
    }

    @Test
    void getHeartRateData_ShouldReturnEmptyResponse_WhenNoData() {
        // Given
        when(patientRepository.findById(patientId)).thenReturn(Optional.of(patient));
        when(heartRateDataRepository.findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class)))
                .thenReturn(Collections.emptyList());

        // When
        HeartRateResponse response = healthDataService.getHeartRateData(patientId, "24h");

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getCurrentBpm()).isNull();
    }

    @Test
    void getHeartRateData_ShouldThrowException_WhenPatientNotFound() {
        // Given
        when(patientRepository.findById(patientId)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> healthDataService.getHeartRateData(patientId, "24h"))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Patient non trouvé");

        verify(patientRepository).findById(patientId);
        verifyNoInteractions(heartRateDataRepository);
    }

    @Test
    void getHeartRateData_ShouldHandleDifferentPeriods() {
        // Given
        when(patientRepository.findById(patientId)).thenReturn(Optional.of(patient));
        when(heartRateDataRepository.findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class)))
                .thenReturn(Collections.emptyList());

        // Test different periods
        healthDataService.getHeartRateData(patientId, "24h");
        healthDataService.getHeartRateData(patientId, "7d");
        healthDataService.getHeartRateData(patientId, "30d");
        healthDataService.getHeartRateData(patientId, null); // Default to 24h

        // Then
        verify(heartRateDataRepository, times(4)).findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class));
    }

    @Test
    void getSleepData_ShouldReturnData_WhenPatientExists() {
        // Given
        LocalDateTime now = LocalDateTime.now();
        List<SleepData> sleepList = Arrays.asList(
                createSleepData(480, 85, now.minusDays(1)),
                createSleepData(420, 75, now.minusDays(2)),
                createSleepData(500, 90, now.minusDays(3))
        );

        when(patientRepository.findById(patientId)).thenReturn(Optional.of(patient));
        when(sleepDataRepository.findByPatientIdAndSleepStartBetweenOrderBySleepStartDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class)))
                .thenReturn(sleepList);

        // When
        SleepDataResponse response = healthDataService.getSleepData(patientId, "7d");

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getTotalMinutes()).isEqualTo(480);
        assertThat(response.getSleepQuality()).isEqualTo(85);
        assertThat(response.getLast7Nights()).hasSize(3);

        verify(patientRepository).findById(patientId);
        verify(sleepDataRepository).findByPatientIdAndSleepStartBetweenOrderBySleepStartDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class));
    }

    @Test
    void getSleepData_ShouldReturnEmptyResponse_WhenNoData() {
        // Given
        when(patientRepository.findById(patientId)).thenReturn(Optional.of(patient));
        when(sleepDataRepository.findByPatientIdAndSleepStartBetweenOrderBySleepStartDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class)))
                .thenReturn(Collections.emptyList());

        // When
        SleepDataResponse response = healthDataService.getSleepData(patientId, "7d");

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getTotalMinutes()).isNull();
    }

    @Test
    void getSleepData_ShouldThrowException_WhenPatientNotFound() {
        // Given
        when(patientRepository.findById(patientId)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> healthDataService.getSleepData(patientId, "7d"))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Patient non trouvé");

        verify(patientRepository).findById(patientId);
        verifyNoInteractions(sleepDataRepository);
    }

    private HeartRateData createHeartRateData(Integer bpm, Integer vfc, LocalDateTime recordedAt) {
        HeartRateData data = new HeartRateData();
        data.setId(UUID.randomUUID());
        data.setPatient(patient);
        data.setBpm(bpm);
        data.setVfc(vfc);
        data.setRecordedAt(recordedAt);
        return data;
    }

    private SleepData createSleepData(Integer totalMinutes, Integer quality, LocalDateTime sleepStart) {
        SleepData data = new SleepData();
        data.setId(UUID.randomUUID());
        data.setPatient(patient);
        data.setTotalMinutes(totalMinutes);
        data.setSleepQuality(quality);
        data.setSleepStart(sleepStart);
        data.setSleepEnd(sleepStart.plusMinutes(totalMinutes));
        data.setLightSleepMinutes(200);
        data.setDeepSleepMinutes(150);
        data.setRemSleepMinutes(100);
        data.setAwakeMinutes(30);
        return data;
    }
}
