package com.sacmp.healthcare.service;

import com.sacmp.alert.entity.Alert;
import com.sacmp.alert.repository.AlertRepository;
import com.sacmp.auth.entity.User;
import com.sacmp.auth.repository.UserRepository;
import com.sacmp.common.enums.*;
import com.sacmp.healthcare.dto.AddPatientRequest;
import com.sacmp.healthcare.dto.DashboardResponse;
import com.sacmp.healthcare.dto.PatientDetailResponse;
import com.sacmp.healthcare.repository.HealthcareWorkerRepository;
import com.sacmp.health.entity.HeartRateData;
import com.sacmp.health.entity.MoodData;
import com.sacmp.health.entity.SleepData;
import com.sacmp.health.repository.HeartRateDataRepository;
import com.sacmp.health.repository.MoodDataRepository;
import com.sacmp.health.repository.SleepDataRepository;
import com.sacmp.patient.entity.Patient;
import com.sacmp.patient.repository.PatientRepository;
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
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class HealthcareWorkerServiceTest {

    @Mock
    private PatientRepository patientRepository;

    @Mock
    private AlertRepository alertRepository;

    @Mock
    private HeartRateDataRepository heartRateDataRepository;

    @Mock
    private MoodDataRepository moodDataRepository;

    @Mock
    private SleepDataRepository sleepDataRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private HealthcareWorkerRepository healthcareWorkerRepository;

    @InjectMocks
    private HealthcareWorkerService healthcareWorkerService;

    private Patient patient;
    private User patientUser;
    private UUID patientId;

    @BeforeEach
    void setUp() {
        patientId = UUID.randomUUID();

        patientUser = new User();
        patientUser.setId(UUID.randomUUID());
        patientUser.setEmail("patient@test.com");
        patientUser.setFullName("John Doe");
        patientUser.setRole(UserRole.PATIENT);
        patientUser.setPhoneNumber("1234567890");

        patient = new Patient();
        patient.setId(patientId);
        patient.setUser(patientUser);
        patient.setMedicalRecordId("MR-123456");
        patient.setStatus(PatientStatus.STABLE);
        patient.setRoomNumber("A-101");
        patient.setDeleted(false);
        patient.setUpdatedAt(LocalDateTime.now());
    }

    @Test
    void getDashboard_ShouldReturnDashboardData() {
        // Given
        when(patientRepository.countByDeletedFalse()).thenReturn(100L);
        when(patientRepository.countByStatusAndDeletedFalse(PatientStatus.CRITICAL)).thenReturn(5L);
        when(patientRepository.countByStatusAndDeletedFalse(PatientStatus.TO_MONITOR)).thenReturn(15L);
        when(patientRepository.countByStatusAndDeletedFalse(PatientStatus.STABLE)).thenReturn(80L);
        when(alertRepository.countByStatus(AlertStatus.ACTIVE)).thenReturn(25L);
        when(alertRepository.findByStatusAndPriorityOrderByCreatedAtDesc(
                AlertStatus.ACTIVE, AlertPriority.CRITICAL))
                .thenReturn(Collections.emptyList());
        when(patientRepository.findAll()).thenReturn(Collections.singletonList(patient));
        when(alertRepository.countByPatientIdAndStatus(patientId, AlertStatus.ACTIVE)).thenReturn(2L);
        when(alertRepository.findTop10ByStatusOrderByPriorityDescCreatedAtDesc(AlertStatus.ACTIVE))
                .thenReturn(Collections.emptyList());

        // When
        DashboardResponse response = healthcareWorkerService.getDashboard();

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getStatistics()).isNotNull();
        assertThat(response.getStatistics().getTotalPatients()).isEqualTo(100L);
        assertThat(response.getStatistics().getCriticalPatients()).isEqualTo(5L);
        assertThat(response.getStatistics().getToMonitorPatients()).isEqualTo(15L);
        assertThat(response.getStatistics().getStablePatients()).isEqualTo(80L);
        assertThat(response.getStatistics().getActiveAlerts()).isEqualTo(25L);

        verify(patientRepository).countByDeletedFalse();
        verify(alertRepository).countByStatus(AlertStatus.ACTIVE);
    }

    @Test
    void addPatient_ShouldCreateNewPatient_WhenValidRequest() {
        // Given
        AddPatientRequest request = new AddPatientRequest();
        request.setFullName("Jane Doe");
        request.setEmail("jane.doe@example.com");
        request.setMedicalRecordId("MR-NEW001");
        request.setPhoneNumber("9876543210");
        request.setBirthDate(LocalDate.of(1990, 5, 15));
        request.setSex("F");
        request.setRoomNumber("B-202");
        request.setEmergencyContactName("John Doe");
        request.setEmergencyContactPhone("1234567890");

        when(userRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(patientRepository.existsByMedicalRecordId(request.getMedicalRecordId())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenAnswer(i -> {
            User user = (User) i.getArguments()[0];
            user.setId(UUID.randomUUID());
            return user;
        });
        when(patientRepository.save(any(Patient.class))).thenAnswer(i -> {
            Patient p = (Patient) i.getArguments()[0];
            p.setId(UUID.randomUUID());
            p.setUpdatedAt(LocalDateTime.now());
            return p;
        });
        when(heartRateDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(any())).thenReturn(null);
        when(moodDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(any())).thenReturn(null);
        when(sleepDataRepository.findFirstByPatientIdOrderBySleepStartDesc(any())).thenReturn(null);
        when(alertRepository.countByPatientIdAndStatus(any(), eq(AlertStatus.ACTIVE))).thenReturn(0L);

        // When
        PatientDetailResponse response = healthcareWorkerService.addPatient(request);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getFullName()).isEqualTo("Jane Doe");
        assertThat(response.getEmail()).isEqualTo("jane.doe@example.com");
        assertThat(response.getMedicalRecordId()).isEqualTo("MR-NEW001");

        verify(userRepository).existsByEmail(request.getEmail());
        verify(patientRepository).existsByMedicalRecordId(request.getMedicalRecordId());
        verify(userRepository).save(any(User.class));
        verify(patientRepository).save(any(Patient.class));
    }

    @Test
    void addPatient_ShouldThrowException_WhenEmailExists() {
        // Given
        AddPatientRequest request = new AddPatientRequest();
        request.setEmail("existing@example.com");
        request.setMedicalRecordId("MR-NEW001");

        when(userRepository.existsByEmail(request.getEmail())).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> healthcareWorkerService.addPatient(request))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Cet email est déjà utilisé");

        verify(userRepository).existsByEmail(request.getEmail());
        verify(patientRepository, never()).save(any());
    }

    @Test
    void addPatient_ShouldThrowException_WhenMedicalRecordIdExists() {
        // Given
        AddPatientRequest request = new AddPatientRequest();
        request.setEmail("new@example.com");
        request.setMedicalRecordId("MR-EXISTING");

        when(userRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(patientRepository.existsByMedicalRecordId(request.getMedicalRecordId())).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> healthcareWorkerService.addPatient(request))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Ce numéro de dossier médical existe déjà");

        verify(patientRepository).existsByMedicalRecordId(request.getMedicalRecordId());
        verify(userRepository, never()).save(any());
    }

    @Test
    void getAllPatients_ShouldReturnPagedPatients() {
        // Given
        Pageable pageable = PageRequest.of(0, 10);
        Page<Patient> patientPage = new PageImpl<>(Collections.singletonList(patient));

        when(patientRepository.findByDeletedFalse(pageable)).thenReturn(patientPage);
        when(heartRateDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId)).thenReturn(null);
        when(moodDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId)).thenReturn(null);
        when(sleepDataRepository.findFirstByPatientIdOrderBySleepStartDesc(patientId)).thenReturn(null);
        when(alertRepository.countByPatientIdAndStatus(patientId, AlertStatus.ACTIVE)).thenReturn(0L);

        // When
        Page<PatientDetailResponse> result = healthcareWorkerService.getAllPatients(pageable);

        // Then
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getFullName()).isEqualTo("John Doe");

        verify(patientRepository).findByDeletedFalse(pageable);
    }

    @Test
    void getPatientById_ShouldReturnPatient_WhenExists() {
        // Given
        when(patientRepository.findById(patientId)).thenReturn(Optional.of(patient));
        when(heartRateDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId)).thenReturn(null);
        when(moodDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId)).thenReturn(null);
        when(sleepDataRepository.findFirstByPatientIdOrderBySleepStartDesc(patientId)).thenReturn(null);
        when(alertRepository.countByPatientIdAndStatus(patientId, AlertStatus.ACTIVE)).thenReturn(0L);

        // When
        PatientDetailResponse response = healthcareWorkerService.getPatientById(patientId);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getFullName()).isEqualTo("John Doe");
        assertThat(response.getMedicalRecordId()).isEqualTo("MR-123456");

        verify(patientRepository).findById(patientId);
    }

    @Test
    void getPatientById_ShouldThrowException_WhenNotFound() {
        // Given
        when(patientRepository.findById(patientId)).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> healthcareWorkerService.getPatientById(patientId))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Patient non trouvé");

        verify(patientRepository).findById(patientId);
    }

    @Test
    void deletePatient_ShouldSoftDeletePatient() {
        // Given
        when(patientRepository.findById(patientId)).thenReturn(Optional.of(patient));
        when(patientRepository.save(any(Patient.class))).thenAnswer(i -> i.getArguments()[0]);

        // When
        healthcareWorkerService.deletePatient(patientId);

        // Then
        assertThat(patient.getDeleted()).isTrue();
        verify(patientRepository).findById(patientId);
        verify(patientRepository).save(patient);
    }

    @Test
    void getPatientById_ShouldIncludeHealthData_WhenAvailable() {
        // Given
        HeartRateData heartRateData = new HeartRateData();
        heartRateData.setBpm(75);
        heartRateData.setVfc(50);

        MoodData moodData = new MoodData();
        moodData.setMoodValue(MoodValue.HAPPY);

        SleepData sleepData = new SleepData();
        sleepData.setTotalMinutes(480);
        sleepData.setSleepQuality(85);

        when(patientRepository.findById(patientId)).thenReturn(Optional.of(patient));
        when(heartRateDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId)).thenReturn(heartRateData);
        when(moodDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patientId)).thenReturn(moodData);
        when(sleepDataRepository.findFirstByPatientIdOrderBySleepStartDesc(patientId)).thenReturn(sleepData);
        when(alertRepository.countByPatientIdAndStatus(patientId, AlertStatus.ACTIVE)).thenReturn(3L);

        // When
        PatientDetailResponse response = healthcareWorkerService.getPatientById(patientId);

        // Then
        assertThat(response.getCurrentHealth()).isNotNull();
        assertThat(response.getCurrentHealth().getHeartRate()).isEqualTo(75);
        assertThat(response.getCurrentHealth().getVfc()).isEqualTo(50);
        assertThat(response.getCurrentHealth().getLastMood()).isEqualTo("HAPPY");
        assertThat(response.getCurrentHealth().getLastSleepDuration()).isEqualTo(480);
        assertThat(response.getCurrentHealth().getSleepQuality()).isEqualTo(85);
        assertThat(response.getActiveAlertCount()).isEqualTo(3);
    }
}
