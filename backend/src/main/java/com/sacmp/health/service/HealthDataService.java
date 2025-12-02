package com.sacmp.health.service;

import com.sacmp.health.dto.HeartRateResponse;
import com.sacmp.health.dto.SleepDataResponse;
import com.sacmp.health.entity.HeartRateData;
import com.sacmp.health.entity.SleepData;
import com.sacmp.health.repository.HeartRateDataRepository;
import com.sacmp.health.repository.SleepDataRepository;
import com.sacmp.patient.entity.Patient;
import com.sacmp.patient.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class HealthDataService {

    private final PatientRepository patientRepository;
    private final HeartRateDataRepository heartRateDataRepository;
    private final SleepDataRepository sleepDataRepository;

    @Transactional(readOnly = true)
    public HeartRateResponse getHeartRateData(UUID patientId, String period) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient non trouvé"));

        LocalDateTime since = calculateSince(period);
        List<HeartRateData> dataList = heartRateDataRepository
                .findByPatientIdAndRecordedAtBetweenOrderByRecordedAtDesc(patient.getId(), since, LocalDateTime.now());

        if (dataList.isEmpty()) {
            return HeartRateResponse.builder().build();
        }

        HeartRateData latest = dataList.get(0);
        Integer minBpm = dataList.stream().map(HeartRateData::getBpm).min(Integer::compareTo).orElse(null);
        Integer maxBpm = dataList.stream().map(HeartRateData::getBpm).max(Integer::compareTo).orElse(null);
        Double averageBpm = dataList.stream().mapToInt(HeartRateData::getBpm).average().orElse(0.0);

        List<HeartRateResponse.Measurement> measurements = dataList.stream()
                .map(data -> HeartRateResponse.Measurement.builder()
                        .bpm(data.getBpm())
                        .vfc(data.getVfc())
                        .timestamp(data.getRecordedAt())
                        .build())
                .collect(Collectors.toList());

        return HeartRateResponse.builder()
                .currentBpm(latest.getBpm())
                .currentVfc(latest.getVfc())
                .minBpm(minBpm)
                .maxBpm(maxBpm)
                .averageBpm(averageBpm)
                .last24Hours(measurements)
                .last7Days(measurements)
                .build();
    }

    @Transactional(readOnly = true)
    public SleepDataResponse getSleepData(UUID patientId, String period) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient non trouvé"));

        LocalDateTime since = calculateSince(period);
        List<SleepData> dataList = sleepDataRepository
                .findByPatientIdAndSleepStartBetweenOrderBySleepStartDesc(patient.getId(), since, LocalDateTime.now());

        if (dataList.isEmpty()) {
            return SleepDataResponse.builder().build();
        }

        SleepData latest = dataList.get(0);

        List<SleepDataResponse.SleepNight> last7Nights = dataList.stream()
                .limit(7)
                .map(data -> SleepDataResponse.SleepNight.builder()
                        .date(data.getSleepStart())
                        .totalMinutes(data.getTotalMinutes())
                        .quality(data.getSleepQuality())
                        .bedtime(data.getSleepStart())
                        .wakeTime(data.getSleepEnd())
                        .build())
                .collect(Collectors.toList());

        return SleepDataResponse.builder()
                .totalMinutes(latest.getTotalMinutes())
                .lightSleepMinutes(latest.getLightSleepMinutes())
                .deepSleepMinutes(latest.getDeepSleepMinutes())
                .remSleepMinutes(latest.getRemSleepMinutes())
                .awakeMinutes(latest.getAwakeMinutes())
                .sleepQuality(latest.getSleepQuality())
                .sleepStart(latest.getSleepStart())
                .sleepEnd(latest.getSleepEnd())
                .last7Nights(last7Nights)
                .build();
    }

    private LocalDateTime calculateSince(String period) {
        return switch (period != null ? period.toLowerCase() : "24h") {
            case "24h" -> LocalDateTime.now().minusHours(24);
            case "7d" -> LocalDateTime.now().minusDays(7);
            case "30d" -> LocalDateTime.now().minusDays(30);
            default -> LocalDateTime.now().minusHours(24);
        };
    }
}
