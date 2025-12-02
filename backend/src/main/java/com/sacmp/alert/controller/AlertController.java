package com.sacmp.alert.controller;

import com.sacmp.alert.dto.AcknowledgeAlertRequest;
import com.sacmp.alert.dto.AlertResponse;
import com.sacmp.alert.dto.ResolveAlertRequest;
import com.sacmp.alert.service.AlertService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Contrôleur pour les alertes
 * Base URL: /api/v1/alerts
 */
@RestController
@RequestMapping("/v1/alerts")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AlertController {

    private final AlertService alertService;

    /**
     * Récupérer les alertes actives (paginé)
     * GET /api/v1/alerts
     */
    @GetMapping
    public ResponseEntity<Page<AlertResponse>> getActiveAlerts(Pageable pageable) {
        Page<AlertResponse> alerts = alertService.getActiveAlerts(pageable);
        return ResponseEntity.ok(alerts);
    }

    /**
     * Récupérer les alertes d'un patient
     * GET /api/v1/alerts/patient/{patientId}
     */
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<AlertResponse>> getPatientAlerts(@PathVariable UUID patientId) {
        List<AlertResponse> alerts = alertService.getPatientAlerts(patientId);
        return ResponseEntity.ok(alerts);
    }

    /**
     * Récupérer les détails d'une alerte
     * GET /api/v1/alerts/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<AlertResponse> getAlertById(@PathVariable UUID id) {
        AlertResponse alert = alertService.getAlertById(id);
        return ResponseEntity.ok(alert);
    }

    /**
     * Accuser réception d'une alerte
     * POST /api/v1/alerts/{id}/acknowledge
     */
    @PostMapping("/{id}/acknowledge")
    public ResponseEntity<String> acknowledgeAlert(
            @PathVariable UUID id,
            @Valid @RequestBody AcknowledgeAlertRequest request) {
        // TODO: Récupérer l'ID du travailleur de santé depuis le token JWT
        UUID healthcareWorkerId = UUID.randomUUID(); // Temporaire
        alertService.acknowledgeAlert(id, healthcareWorkerId, request);
        return ResponseEntity.ok("Alerte accusée réception");
    }

    /**
     * Résoudre une alerte
     * POST /api/v1/alerts/{id}/resolve
     */
    @PostMapping("/{id}/resolve")
    public ResponseEntity<String> resolveAlert(
            @PathVariable UUID id,
            @Valid @RequestBody ResolveAlertRequest request) {
        // TODO: Récupérer l'ID du travailleur de santé depuis le token JWT
        UUID healthcareWorkerId = UUID.randomUUID(); // Temporaire
        alertService.resolveAlert(id, healthcareWorkerId, request);
        return ResponseEntity.ok("Alerte résolue");
    }
}
