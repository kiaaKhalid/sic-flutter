package com.sacmp.patient.service;

import com.sacmp.alert.entity.Alert;
import com.sacmp.alert.repository.AlertRepository;
import com.sacmp.auth.entity.User;
import com.sacmp.auth.repository.UserRepository;
import com.sacmp.common.enums.*;
import com.sacmp.health.entity.HeartRateData;
import com.sacmp.health.entity.MoodData;
import com.sacmp.health.entity.SleepData;
import com.sacmp.health.repository.HeartRateDataRepository;
import com.sacmp.health.repository.MoodDataRepository;
import com.sacmp.health.repository.SleepDataRepository;
import com.sacmp.patient.dto.MoodDeclarationRequest;
import com.sacmp.patient.dto.MoodHistoryResponse;
import com.sacmp.patient.dto.PatientDashboardResponse;
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
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PatientServiceTest {

    @Mock
    private PatientRepository patientRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private MoodDataRepository moodDataRepository;

    @Mock
    private HeartRateDataRepository heartRateDataRepository;

    @Mock
    private SleepDataRepository sleepDataRepository;

    @Mock
    private AlertRepository alertRepository;

    @InjectMocks
    private PatientService patientService;

    private UUID userId;
    private UUID patientId;
    private User user;
    private Patient patient;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        patientId = UUID.randomUUID();

        user = new User();
        user.setId(userId);
        user.setEmail("patient@test.com");
        user.setFullName("John Doe");
        user.setRole(UserRole.PATIENT);
        user.setStatus(AccountStatus.ACTIVE);

        patient = new Patient();
        patient.setId(patientId);
        patient.setUser(user);
        patient.setMedicalRecordId("MR-123456");
        patient.setStatus(PatientStatus.STABLE);
        patient.setRoomNumber("A-101");
    }

    @Test
    void getDashboard_ShouldReturnDashboardResponse_WhenPatientExists() {
        // Given
        HeartRateData heartRateData = new HeartRateData();
        heartRateData.setBpm(75);
        heartRateData.setVfc(50);
        heartRateData.setRecordedAt(LocalDateTime.now());

        SleepData sleepData = new SleepData();
        sleepData.setTotalMinutes(480);
        sleepData.setSleepQuality(85);
        sleepData.setSleepStart(LocalDateTime.now().minusHours(8));

        MoodData moodData = new MoodData();
        moodData.setMoodValue(MoodValue.CALM);
        moodData.setNotes("Feeling good");
        moodData.setRecordedAt(LocalDateTime.now());

        Alert alert = new Alert();
        alert.setId(UUID.randomUUID());
        alert.setTitle("Test Alert");
        alert.setMessage("Test message");
        alert.setPriority(AlertPriority.MEDIUM);
        alert.setStatus(AlertStatus.ACTIVE);
        alert.setCreatedAt(LocalDateTime.now());

        when(patientRepository.findByUserId(userId)).thenReturn(Optional.of(patient));
        when(heartRateDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId))
                .thenReturn(heartRateData);
        when(sleepDataRepository.findFirstByPatientIdOrderBySleepStartDesc(patientId))
                .thenReturn(sleepData);
        when(moodDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId))
                .thenReturn(moodData);
        when(alertRepository.countByPatientIdAndStatus(patientId, AlertStatus.ACTIVE))
                .thenReturn(1L);
        when(alertRepository.findByPatientIdOrderByCreatedAtDesc(patientId))
                .thenReturn(Collections.singletonList(alert));

        // When
        PatientDashboardResponse response = patientService.getDashboard(userId);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getPatient().getFullName()).isEqualTo("John Doe");
        assertThat(response.getPatient().getMedicalRecordId()).isEqualTo("MR-123456");
        assertThat(response.getHealthMetrics().getHeartRate().getCurrentBpm()).isEqualTo(75);
        assertThat(response.getHealthMetrics().getSleep().getTotalMinutes()).isEqualTo(480);
        assertThat(response.getLastMood().getMood()).isEqualTo("CALM");
        assertThat(response.getRecentAlerts()).hasSize(1);

        verify(patientRepository).findByUserId(userId);
        verify(heartRateDataRepository).findFirstByPatientIdOrderByRecordedAtDesc(patientId);
    }

    @Test
    void getDashboard_ShouldThrowException_WhenPatientNotFound() {
        // Given
        when(patientRepository.findByUserId(userId)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> patientService.getDashboard(userId))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Patient non trouvé");

        verify(patientRepository).findByUserId(userId);
    }

    @Test
    void declareMood_ShouldSaveMoodData_WhenRequestIsValid() {
        // Given
        MoodDeclarationRequest request = new MoodDeclarationRequest();
        request.setMoodValue(MoodValue.HAPPY);
        request.setNotes("Feeling great today!");
        request.setRecordedAt(LocalDateTime.now());

        when(patientRepository.findByUserId(userId)).thenReturn(Optional.of(patient));
        when(moodDataRepository.save(any(MoodData.class))).thenAnswer(i -> i.getArguments()[0]);

        // When
        patientService.declareMood(userId, request);

        // Then
        verify(patientRepository).findByUserId(userId);
        verify(moodDataRepository).save(argThat(moodData -> {
            assertThat(moodData.getPatient()).isEqualTo(patient);
            assertThat(moodData.getMoodValue()).isEqualTo(MoodValue.HAPPY);
            assertThat(moodData.getNotes()).isEqualTo("Feeling great today!");
            assertThat(moodData.getTimestamp()).isNotNull();
            return true;
        }));
    }

    @Test
    void declareMood_ShouldUseCurrentTime_WhenRecordedAtIsNull() {
        // Given
        MoodDeclarationRequest request = new MoodDeclarationRequest();
        request.setMoodValue(MoodValue.SAD);
        request.setNotes("Not feeling well");
        request.setRecordedAt(null);

        when(patientRepository.findByUserId(userId)).thenReturn(Optional.of(patient));
        when(moodDataRepository.save(any(MoodData.class))).thenAnswer(i -> i.getArguments()[0]);

        // When
        patientService.declareMood(userId, request);

        // Then
        verify(moodDataRepository).save(argThat(moodData -> {
            assertThat(moodData.getRecordedAt()).isNotNull();
            assertThat(moodData.getTimestamp()).isNotNull();
            return true;
        }));
    }

    @Test
    void getMoodHistory_ShouldReturnHistory_WhenDataExists() {
        // Given
        LocalDateTime now = LocalDateTime.now();
        List<MoodData> moodDataList = Arrays.asList(
                createMoodData(MoodValue.HAPPY, "Good day", now.minusDays(1)),
                createMoodData(MoodValue.CALM, "Relaxed", now.minusDays(2)),
                createMoodData(MoodValue.HAPPY, "Great mood", now.minusDays(3))
        );

        when(patientRepository.findByUserId(userId)).thenReturn(Optional.of(patient));
        when(moodDataRepository.findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
                eq(patientId), any(LocalDateTime.class), any(LocalDateTime.class)))
                .thenReturn(moodDataList);

        // When
        MoodHistoryResponse response = patientService.getMoodHistory(userId, 30);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getHistory()).hasSize(3);
        assertThat(response.getDominantMood()).isEqualTo("HAPPY");
        assertThat(response.getFrequency().get("HAPPY")).isEqualTo(2);
        assertThat(response.getFrequency().get("CALM")).isEqualTo(1);

        verify(patientRepository).findByUserId(userId);
    }

    @Test
    void getUserIdByEmail_ShouldReturnUserId_WhenUserExists() {
        // Given
        String email = "test@example.com";
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));

        // When
        UUID result = patientService.getUserIdByEmail(email);

        // Then
        assertThat(result).isEqualTo(userId);
        verify(userRepository).findByEmail(email);
    }

    @Test
    void getUserIdByEmail_ShouldThrowException_WhenUserNotFound() {
        // Given
        String email = "notfound@example.com";
        when(userRepository.findByEmail(email)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> patientService.getUserIdByEmail(email))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Utilisateur non trouvé");

        verify(userRepository).findByEmail(email);
    }

    @Test
    void getDashboard_ShouldHandleNullHealthData() {
        // Given
        when(patientRepository.findByUserId(userId)).thenReturn(Optional.of(patient));
        when(heartRateDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId))
                .thenReturn(null);
        when(sleepDataRepository.findFirstByPatientIdOrderBySleepStartDesc(patientId))
                .thenReturn(null);
        when(moodDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId))
                .thenReturn(null);
        when(alertRepository.countByPatientIdAndStatus(patientId, AlertStatus.ACTIVE))
                .thenReturn(0L);
        when(alertRepository.findByPatientIdOrderByCreatedAtDesc(patientId))
                .thenReturn(Collections.emptyList());

        // When
        PatientDashboardResponse response = patientService.getDashboard(userId);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getHealthMetrics().getHeartRate()).isNull();
        assertThat(response.getHealthMetrics().getSleep()).isNull();
        assertThat(response.getLastMood()).isNull();
        assertThat(response.getHealthMetrics().getAlertCount()).isZero();
    }

    private MoodData createMoodData(MoodValue moodValue, String notes, LocalDateTime recordedAt) {
        MoodData moodData = new MoodData();
        moodData.setId(UUID.randomUUID());
        moodData.setPatient(patient);
        moodData.setMoodValue(moodValue);
        moodData.setNotes(notes);
        moodData.setRecordedAt(recordedAt);
        moodData.setTimestamp(recordedAt);
        return moodData;
    }
}
