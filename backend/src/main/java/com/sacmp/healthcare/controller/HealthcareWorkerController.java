package com.sacmp.healthcare.controller;

import com.sacmp.healthcare.dto.AddPatientRequest;
import com.sacmp.healthcare.dto.DashboardResponse;
import com.sacmp.healthcare.dto.PatientDetailResponse;
import com.sacmp.healthcare.service.HealthcareWorkerService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * Contrôleur pour les travailleurs de santé
 * Base URL: /api/v1/healthcare-workers
 */
@RestController
@RequestMapping("/v1/healthcare-workers")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class HealthcareWorkerController {

    private final HealthcareWorkerService healthcareWorkerService;

    /**
     * Récupérer le dashboard
     * GET /api/v1/healthcare-workers/dashboard
     */
    @GetMapping("/dashboard")
    public ResponseEntity<DashboardResponse> getDashboard() {
        DashboardResponse response = healthcareWorkerService.getDashboard();
        return ResponseEntity.ok(response);
    }

    /**
     * Récupérer la liste des patients (paginée)
     * GET /api/v1/healthcare-workers/patients
     */
    @GetMapping("/patients")
    public ResponseEntity<Page<PatientDetailResponse>> getAllPatients(Pageable pageable) {
        Page<PatientDetailResponse> patients = healthcareWorkerService.getAllPatients(pageable);
        return ResponseEntity.ok(patients);
    }

    /**
     * Récupérer les détails d'un patient
     * GET /api/v1/healthcare-workers/patients/{id}
     */
    @GetMapping("/patients/{id}")
    public ResponseEntity<PatientDetailResponse> getPatientById(@PathVariable UUID id) {
        PatientDetailResponse patient = healthcareWorkerService.getPatientById(id);
        return ResponseEntity.ok(patient);
    }

    /**
     * Ajouter un nouveau patient
     * POST /api/v1/healthcare-workers/patients
     */
    @PostMapping("/patients")
    public ResponseEntity<PatientDetailResponse> addPatient(@Valid @RequestBody AddPatientRequest request) {
        PatientDetailResponse patient = healthcareWorkerService.addPatient(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(patient);
    }

    /**
     * Supprimer un patient (soft delete)
     * DELETE /api/v1/healthcare-workers/patients/{id}
     */
    @DeleteMapping("/patients/{id}")
    public ResponseEntity<String> deletePatient(@PathVariable UUID id) {
        healthcareWorkerService.deletePatient(id);
        return ResponseEntity.ok("Patient supprimé avec succès");
    }

    /**
     * Récupérer les alertes
     * GET /api/v1/healthcare-workers/alerts
     */
    @GetMapping("/alerts")
    public ResponseEntity<?> getAlerts(Pageable pageable) {
        // TODO: Implémenter via AlertService
        return ResponseEntity.ok("Liste des alertes");
    }
}
