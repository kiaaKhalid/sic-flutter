package com.sacmp.health.controller;

import com.sacmp.health.dto.HeartRateResponse;
import com.sacmp.health.dto.SleepDataResponse;
import com.sacmp.health.service.HealthDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * Contrôleur pour les données de santé
 * Base URL: /api/v1/health
 */
@RestController
@RequestMapping("/v1/health")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class HealthDataController {

    private final HealthDataService healthDataService;

    /**
     * Récupérer les données de rythme cardiaque
     * GET /api/v1/health/heart-rate/{patientId}
     */
    @GetMapping("/heart-rate/{patientId}")
    public ResponseEntity<HeartRateResponse> getHeartRateData(
            @PathVariable UUID patientId,
            @RequestParam(defaultValue = "24h") String period) {
        HeartRateResponse response = healthDataService.getHeartRateData(patientId, period);
        return ResponseEntity.ok(response);
    }

    /**
     * Récupérer les données de sommeil
     * GET /api/v1/health/sleep/{patientId}
     */
    @GetMapping("/sleep/{patientId}")
    public ResponseEntity<SleepDataResponse> getSleepData(
            @PathVariable UUID patientId,
            @RequestParam(defaultValue = "7d") String period) {
        SleepDataResponse response = healthDataService.getSleepData(patientId, period);
        return ResponseEntity.ok(response);
    }

    /**
     * Récupérer les corrélations multi-paramètres
     * GET /api/v1/health/correlation/{patientId}
     */
    @GetMapping("/correlation/{patientId}")
    public ResponseEntity<?> getCorrelationData(@PathVariable UUID patientId) {
        // TODO: Implémenter les corrélations
        return ResponseEntity.ok("Données de corrélation");
    }
}
