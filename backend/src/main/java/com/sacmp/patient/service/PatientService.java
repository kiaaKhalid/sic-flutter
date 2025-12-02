package com.sacmp.patient.service;

import com.sacmp.alert.entity.Alert;
import com.sacmp.alert.repository.AlertRepository;
import com.sacmp.auth.entity.User;
import com.sacmp.auth.repository.UserRepository;
import com.sacmp.common.enums.AlertStatus;
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
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PatientService {

    private final PatientRepository patientRepository;
    private final UserRepository userRepository;
    private final MoodDataRepository moodDataRepository;
    private final HeartRateDataRepository heartRateDataRepository;
    private final SleepDataRepository sleepDataRepository;
    private final AlertRepository alertRepository;

    @Transactional(readOnly = true)
    public PatientDashboardResponse getDashboard(UUID userId) {
        Patient patient = patientRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Patient non trouvé"));

        // Informations patient
        PatientDashboardResponse.PatientInfo patientInfo = PatientDashboardResponse.PatientInfo.builder()
                .id(patient.getId().toString())
                .fullName(patient.getUser().getFullName())
                .email(patient.getUser().getEmail())
                .medicalRecordId(patient.getMedicalRecordId())
                .status(patient.getStatus().name())
                .roomNumber(patient.getRoomNumber())
                .profilePictureUrl(patient.getUser().getProfilePictureUrl())
                .build();

        // Métriques de santé
        HeartRateData lastHeartRate = heartRateDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patient.getId());
        SleepData lastSleep = sleepDataRepository.findFirstByPatientIdOrderBySleepStartDesc(patient.getId());
        long alertCount = alertRepository.countByPatientIdAndStatus(patient.getId(), AlertStatus.ACTIVE);

        PatientDashboardResponse.HealthMetrics healthMetrics = PatientDashboardResponse.HealthMetrics.builder()
                .heartRate(lastHeartRate != null ? PatientDashboardResponse.HeartRateMetric.builder()
                        .currentBpm(lastHeartRate.getBpm())
                        .vfc(lastHeartRate.getVfc())
                        .status(determineHeartRateStatus(lastHeartRate.getBpm()))
                        .lastUpdate(lastHeartRate.getRecordedAt())
                        .build() : null)
                .sleep(lastSleep != null ? PatientDashboardResponse.SleepMetric.builder()
                        .totalMinutes(lastSleep.getTotalMinutes())
                        .sleepQuality(lastSleep.getSleepQuality())
                        .status(determineSleepStatus(lastSleep.getTotalMinutes()))
                        .lastNight(lastSleep.getSleepStart())
                        .build() : null)
                .alertCount((int) alertCount)
                .build();

        // Alertes récentes
        List<Alert> alerts = alertRepository.findByPatientIdOrderByCreatedAtDesc(patient.getId());
        List<PatientDashboardResponse.RecentAlert> recentAlerts = alerts.stream()
                .limit(5)
                .map(alert -> PatientDashboardResponse.RecentAlert.builder()
                        .id(alert.getId().toString())
                        .title(alert.getTitle())
                        .message(alert.getMessage())
                        .priority(alert.getPriority().name())
                        .createdAt(alert.getCreatedAt())
                        .read(alert.getStatus() != AlertStatus.ACTIVE)
                        .build())
                .collect(Collectors.toList());

        // Dernière humeur
        MoodData lastMood = moodDataRepository.findFirstByPatientIdOrderByRecordedAtDesc(patient.getId());
        PatientDashboardResponse.LastMood lastMoodInfo = lastMood != null ?
                PatientDashboardResponse.LastMood.builder()
                        .mood(lastMood.getMoodValue().name())
                        .notes(lastMood.getNotes())
                        .recordedAt(lastMood.getRecordedAt())
                        .build() : null;

        return PatientDashboardResponse.builder()
                .patient(patientInfo)
                .healthMetrics(healthMetrics)
                .recentAlerts(recentAlerts)
                .lastMood(lastMoodInfo)
                .build();
    }

    @Transactional
    public void declareMood(UUID userId, MoodDeclarationRequest request) {
        Patient patient = patientRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Patient non trouvé"));

        LocalDateTime now = LocalDateTime.now();
        MoodData moodData = MoodData.builder()
                .patient(patient)
                .moodValue(request.getMoodValue())
                .notes(request.getNotes())
                .recordedAt(request.getRecordedAt() != null ? request.getRecordedAt() : now)
                .timestamp(now)
                .build();

        moodDataRepository.save(moodData);
        log.info("Humeur déclarée pour le patient {}: {}", patient.getMedicalRecordId(), request.getMoodValue());
    }

    @Transactional(readOnly = true)
    public MoodHistoryResponse getMoodHistory(UUID userId, Integer days) {
        Patient patient = patientRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Patient non trouvé"));

        LocalDateTime since = LocalDateTime.now().minusDays(days != null ? days : 30);
        List<MoodData> moodDataList = moodDataRepository.findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(
                patient.getId(), since, LocalDateTime.now()
        );

        List<MoodHistoryResponse.MoodEntry> history = moodDataList.stream()
                .map(mood -> MoodHistoryResponse.MoodEntry.builder()
                        .id(mood.getId().toString())
                        .mood(mood.getMoodValue().name())
                        .notes(mood.getNotes())
                        .recordedAt(mood.getRecordedAt())
                        .build())
                .collect(Collectors.toList());

        Map<String, Integer> frequency = moodDataList.stream()
                .collect(Collectors.groupingBy(
                        mood -> mood.getMoodValue().name(),
                        Collectors.summingInt(e -> 1)
                ));

        String dominantMood = frequency.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("UNKNOWN");

        return MoodHistoryResponse.builder()
                .history(history)
                .frequency(frequency)
                .dominantMood(dominantMood)
                .build();
    }

    /**
     * Récupère l'ID utilisateur à partir de son email
     */
    public UUID getUserIdByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
        return user.getId();
    }

    private String determineHeartRateStatus(Integer bpm) {
        if (bpm == null) return "UNKNOWN";
        if (bpm < 60) return "LOW";
        if (bpm > 100) return "HIGH";
        return "NORMAL";
    }

    private String determineSleepStatus(Integer minutes) {
        if (minutes == null) return "UNKNOWN";
        if (minutes < 360) return "INSUFFICIENT";
        if (minutes > 540) return "EXCESSIVE";
        return "GOOD";
    }
}
