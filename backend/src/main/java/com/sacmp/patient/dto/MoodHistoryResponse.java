package com.sacmp.patient.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MoodHistoryResponse {
    private List<MoodEntry> history;
    private Map<String, Integer> frequency;
    private String dominantMood;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MoodEntry {
        private String id;
        private String mood;
        private String notes;
        private LocalDateTime recordedAt;
    }
}
