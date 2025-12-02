package com.sacmp.healthcare.dto;

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
public class DashboardResponse {
    private Statistics statistics;
    private List<RecentPatient> recentPatients;
    private List<ActiveAlert> activeAlerts;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Statistics {
        private Long totalPatients;
        private Long criticalPatients;
        private Long toMonitorPatients;
        private Long stablePatients;
        private Long activeAlerts;
        private Long criticalAlerts;
        private Long todayAdmissions;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RecentPatient {
        private String id;
        private String name;
        private String medicalRecordId;
        private String status;
        private String roomNumber;
        private LocalDateTime lastUpdate;
        private Integer alertCount;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ActiveAlert {
        private String id;
        private String type;
        private String priority;
        private String patientName;
        private String patientId;
        private String message;
        private LocalDateTime createdAt;
    }
}
