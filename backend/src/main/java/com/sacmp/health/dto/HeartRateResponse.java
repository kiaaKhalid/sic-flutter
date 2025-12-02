package com.sacmp.health.dto;

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
public class HeartRateResponse {
    private Integer currentBpm;
    private Integer currentVfc;
    private Integer minBpm;
    private Integer maxBpm;
    private Double averageBpm;
    private List<Measurement> last24Hours;
    private List<Measurement> last7Days;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Measurement {
        private Integer bpm;
        private Integer vfc;
        private LocalDateTime timestamp;
    }
}
