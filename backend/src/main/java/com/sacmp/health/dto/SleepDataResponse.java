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
public class SleepDataResponse {
    private Integer totalMinutes;
    private Integer lightSleepMinutes;
    private Integer deepSleepMinutes;
    private Integer remSleepMinutes;
    private Integer awakeMinutes;
    private Integer sleepQuality;
    private LocalDateTime sleepStart;
    private LocalDateTime sleepEnd;
    private List<SleepNight> last7Nights;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SleepNight {
        private LocalDateTime date;
        private Integer totalMinutes;
        private Integer quality;
        private LocalDateTime bedtime;
        private LocalDateTime wakeTime;
    }
}
