package com.sacmp.healthcare.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PatientDetailResponse {
    private String id;
    private String fullName;
    private String email;
    private String medicalRecordId;
    private LocalDate birthDate;
    private String sex;
    private String status;
    private String roomNumber;
    private LocalDateTime admissionDate;
    private String phoneNumber;
    private String emergencyContactName;
    private String emergencyContactPhone;
    private String medicalNotes;
    private String allergies;
    private String currentMedications;
    private HealthData currentHealth;
    private Integer activeAlertCount;
    private LocalDateTime lastUpdate;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class HealthData {
        private Integer heartRate;
        private Integer vfc;
        private String lastMood;
        private Integer lastSleepDuration;
        private Integer sleepQuality;
    }
}
