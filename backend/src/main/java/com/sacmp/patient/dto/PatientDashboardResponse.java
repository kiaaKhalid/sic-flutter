package com.sacmp.patient.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PatientDashboardResponse {
    private PatientInfo patient;
    private HealthMetrics healthMetrics;
    private List<RecentAlert> recentAlerts;
    private LastMood lastMood;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PatientInfo {
        private String id;
        private String fullName;
        private String email;
        private String medicalRecordId;
        private String status;
        private String roomNumber;
        private String profilePictureUrl;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class HealthMetrics {
        private HeartRateMetric heartRate;
        private SleepMetric sleep;
        private Integer alertCount;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class HeartRateMetric {
        private Integer currentBpm;
        private Integer vfc;
        private String status;
        private LocalDateTime lastUpdate;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SleepMetric {
        private Integer totalMinutes;
        private Integer sleepQuality;
        private String status;
        private LocalDateTime lastNight;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RecentAlert {
        private String id;
        private String title;
        private String message;
        private String priority;
        private LocalDateTime createdAt;
        private Boolean read;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LastMood {
        private String mood;
        private String notes;
        private LocalDateTime recordedAt;
    }
}
