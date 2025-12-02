package com.sacmp.healthcare.service;

import com.sacmp.alert.entity.Alert;
import com.sacmp.alert.repository.AlertRepository;
import com.sacmp.auth.entity.User;
import com.sacmp.auth.repository.UserRepository;
import com.sacmp.common.enums.AccountStatus;
import com.sacmp.common.enums.AlertStatus;
import com.sacmp.common.enums.PatientStatus;
import com.sacmp.common.enums.UserRole;
import com.sacmp.healthcare.dto.AddPatientRequest;
import com.sacmp.healthcare.dto.DashboardResponse;
import com.sacmp.healthcare.dto.PatientDetailResponse;
import com.sacmp.healthcare.entity.HealthcareWorker;
import com.sacmp.healthcare.repository.HealthcareWorkerRepository;
import com.sacmp.health.entity.HeartRateData;
import com.sacmp.health.entity.MoodData;
import com.sacmp.health.entity.SleepData;
import com.sacmp.health.repository.HeartRateDataRepository;
import com.sacmp.health.repository.MoodDataRepository;
import com.sacmp.health.repository.SleepDataRepository;
import com.sacmp.patient.entity.Patient;
import com.sacmp.patient.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class HealthcareWorkerService {

    private final PatientRepository patientRepository;
    private final AlertRepository alertRepository;
    private final HeartRateDataRepository heartRateDataRepository;
    private final MoodDataRepository moodDataRepository;
    private final SleepDataRepository sleepDataRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public DashboardResponse getDashboard() {
        // Statistiques
        long totalPatients = patientRepository.countByDeletedFalse();
        long criticalPatients = patientRepository.countByStatusAndDeletedFalse(PatientStatus.CRITICAL);
        long toMonitorPatients = patientRepository.countByStatusAndDeletedFalse(PatientStatus.TO_MONITOR);
        long stablePatients = patientRepository.countByStatusAndDeletedFalse(PatientStatus.STABLE);
        long activeAlerts = alertRepository.countByStatus(AlertStatus.ACTIVE);
        
        List<Alert> criticalAlertsList = alertRepository.findByStatusAndPriorityOrderByCreatedAtDesc(
            AlertStatus.ACTIVE, com.sacmp.common.enums.AlertPriority.CRITICAL
        );
        long criticalAlerts = criticalAlertsList.size();

        DashboardResponse.Statistics statistics = DashboardResponse.Statistics.builder()
                .totalPatients(totalPatients)
                .criticalPatients(criticalPatients)
                .toMonitorPatients(toMonitorPatients)
                .stablePatients(stablePatients)
                .activeAlerts(activeAlerts)
                .criticalAlerts(criticalAlerts)
                .todayAdmissions(0L) // TODO: Implémenter
                .build();

        // Patients récents
        List<Patient> recentPatientsList = patientRepository.findAll().stream()
                .filter(p -> !p.getDeleted())
                .sorted((p1, p2) -> p2.getUpdatedAt().compareTo(p1.getUpdatedAt()))
                .limit(10)
                .collect(Collectors.toList());

        List<DashboardResponse.RecentPatient> recentPatients = recentPatientsList.stream()
                .map(patient -> {
                    long alertCount = alertRepository.countByPatientIdAndStatus(patient.getId(), AlertStatus.ACTIVE);
                    return DashboardResponse.RecentPatient.builder()
                            .id(patient.getId().toString())
                            .name(patient.getUser().getFullName())
                            .medicalRecordId(patient.getMedicalRecordId())
                            .status(patient.getStatus().name())
                            .roomNumber(patient.getRoomNumber())
                            .lastUpdate(patient.getUpdatedAt())
                            .alertCount((int) alertCount)
                            .build();
                })
                .collect(Collectors.toList());

        // Alertes actives
        List<Alert> activeAlertsList = alertRepository.findTop10ByStatusOrderByPriorityDescCreatedAtDesc(AlertStatus.ACTIVE);
        List<DashboardResponse.ActiveAlert> activeAlertsDtos = activeAlertsList.stream()
                .map(alert -> DashboardResponse.ActiveAlert.builder()
                        .id(alert.getId().toString())
                        .type(alert.getType().name())
                        .priority(alert.getPriority().name())
                        .patientName(alert.getPatient().getUser().getFullName())
                        .patientId(alert.getPatient().getId().toString())
                        .message(alert.getMessage())
                        .createdAt(alert.getCreatedAt())
                        .build())
                .collect(Collectors.toList());

        return DashboardResponse.builder()
                .statistics(statistics)
                .recentPatients(recentPatients)
                .activeAlerts(activeAlertsDtos)
                .build();
    }

    @Transactional
    public PatientDetailResponse addPatient(AddPatientRequest request) {
        // Vérifier si l'email existe déjà
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Cet email est déjà utilisé");
        }

        // Vérifier si le numéro de dossier médical existe déjà
        if (patientRepository.existsByMedicalRecordId(request.getMedicalRecordId())) {
            throw new RuntimeException("Ce numéro de dossier médical existe déjà");
        }

        // Créer l'utilisateur
        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .passwordHash(passwordEncoder.encode("TempPassword123!")) // Mot de passe temporaire
                .role(UserRole.PATIENT)
                .phoneNumber(request.getPhoneNumber())
                .status(AccountStatus.ACTIVE)
                .emailVerified(false)
                .build();
        user = userRepository.save(user);

        // Créer le patient
        Patient patient = Patient.builder()
                .user(user)
                .medicalRecordId(request.getMedicalRecordId())
                .birthDate(request.getBirthDate())
                .sex(request.getSex())
                .status(PatientStatus.STABLE)
                .roomNumber(request.getRoomNumber())
                .admissionDate(LocalDateTime.now())
                .emergencyContactName(request.getEmergencyContactName())
                .emergencyContactPhone(request.getEmergencyContactPhone())
                .medicalNotes(request.getMedicalNotes())
                .allergies(request.getAllergies())
                .currentMedications(request.getCurrentMedications())
                .build();

        patient = patientRepository.save(patient);
        log.info("Nouveau patient ajouté: {}", patient.getMedicalRecordId());

        return buildPatientDetailResponse(patient);
    }

    @Transactional(readOnly = true)
    public Page<PatientDetailResponse> getAllPatients(Pageable pageable) {
        Page<Patient> patients = patientRepository.findByDeletedFalse(pageable);
        return patients.map(this::buildPatientDetailResponse);
    }

    @Transactional(readOnly = true)
    public PatientDetailResponse getPatientById(UUID patientId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient non trouvé"));
        return buildPatientDetailResponse(patient);
    }

    @Transactional
    public void deletePatient(UUID patientId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient non trouvé"));
        patient.setDeleted(true);
        patientRepository.save(patient);
        log.info("Patient supprimé (soft delete): {}", patient.getMedicalRecordId());
    }

    private PatientDetailResponse buildPatientDetailResponse(Patient patient) {
        HeartRateData lastHeartRate = heartRateDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patient.getId());
        MoodData lastMood = moodDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patient.getId());
        SleepData lastSleep = sleepDataRepository.findFirstByPatientIdOrderBySleepStartDesc(patient.getId());
        long activeAlertCount = alertRepository.countByPatientIdAndStatus(patient.getId(), AlertStatus.ACTIVE);

        PatientDetailResponse.HealthData healthData = PatientDetailResponse.HealthData.builder()
                .heartRate(lastHeartRate != null ? lastHeartRate.getBpm() : null)
                .vfc(lastHeartRate != null ? lastHeartRate.getVfc() : null)
                .lastMood(lastMood != null ? lastMood.getMoodValue().name() : null)
                .lastSleepDuration(lastSleep != null ? lastSleep.getTotalMinutes() : null)
                .sleepQuality(lastSleep != null ? lastSleep.getSleepQuality() : null)
                .build();

        return PatientDetailResponse.builder()
                .id(patient.getId().toString())
                .fullName(patient.getUser().getFullName())
                .email(patient.getUser().getEmail())
                .medicalRecordId(patient.getMedicalRecordId())
                .birthDate(patient.getBirthDate())
                .sex(patient.getSex())
                .status(patient.getStatus().name())
                .roomNumber(patient.getRoomNumber())
                .admissionDate(patient.getAdmissionDate())
                .phoneNumber(patient.getUser().getPhoneNumber())
                .emergencyContactName(patient.getEmergencyContactName())
                .emergencyContactPhone(patient.getEmergencyContactPhone())
                .medicalNotes(patient.getMedicalNotes())
                .allergies(patient.getAllergies())
                .currentMedications(patient.getCurrentMedications())
                .currentHealth(healthData)
                .activeAlertCount((int) activeAlertCount)
                .lastUpdate(patient.getUpdatedAt())
                .build();
    }
}
