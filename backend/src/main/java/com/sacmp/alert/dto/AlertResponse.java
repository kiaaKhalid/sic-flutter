package com.sacmp.alert.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AlertResponse {
    private String id;
    private String type;
    private String priority;
    private String status;
    private String title;
    private String message;
    private String patientId;
    private String patientName;
    private String metadata;
    private LocalDateTime createdAt;
    private AcknowledgmentInfo acknowledgment;
    private ResolutionInfo resolution;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AcknowledgmentInfo {
        private String acknowledgedBy;
        private LocalDateTime acknowledgedAt;
        private String note;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ResolutionInfo {
        private String resolvedBy;
        private LocalDateTime resolvedAt;
        private String note;
    }
}
