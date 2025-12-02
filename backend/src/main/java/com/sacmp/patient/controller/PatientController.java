package com.sacmp.patient.controller;

import com.sacmp.patient.dto.MoodDeclarationRequest;
import com.sacmp.patient.dto.MoodHistoryResponse;
import com.sacmp.patient.dto.PatientDashboardResponse;
import com.sacmp.patient.service.PatientService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * Contrôleur pour les patients
 * Base URL: /api/v1/patients
 */
@RestController
@RequestMapping("/v1/patients")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PatientController {

    private final PatientService patientService;

    /**
     * Récupérer le dashboard du patient
     * GET /api/v1/patients/dashboard
     */
    @GetMapping("/dashboard")
    public ResponseEntity<PatientDashboardResponse> getDashboard() {
        UUID userId = getCurrentUserId();
        PatientDashboardResponse response = patientService.getDashboard(userId);
        return ResponseEntity.ok(response);
    }

    /**
     * Déclarer une humeur
     * POST /api/v1/patients/mood
     */
    @PostMapping("/mood")
    public ResponseEntity<String> declareMood(@Valid @RequestBody MoodDeclarationRequest request) {
        UUID userId = getCurrentUserId();
        patientService.declareMood(userId, request);
        return ResponseEntity.ok("Humeur déclarée avec succès");
    }

    /**
     * Récupérer l'historique des humeurs
     * GET /api/v1/patients/mood/history
     */
    @GetMapping("/mood/history")
    public ResponseEntity<MoodHistoryResponse> getMoodHistory(@RequestParam(required = false) Integer days) {
        UUID userId = getCurrentUserId();
        MoodHistoryResponse response = patientService.getMoodHistory(userId, days);
        return ResponseEntity.ok(response);
    }

    /**
     * Récupérer les alertes du patient
     * GET /api/v1/patients/alerts
     */
    @GetMapping("/alerts")
    public ResponseEntity<?> getAlerts() {
        // TODO: Implémenter la récupération des alertes
        return ResponseEntity.ok("Liste des alertes");
    }

    private UUID getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof org.springframework.security.core.userdetails.UserDetails) {
            String email = ((org.springframework.security.core.userdetails.UserDetails) authentication.getPrincipal()).getUsername();
            // L'email est le username dans notre système
            // Le service va récupérer l'utilisateur par email et retourner son ID
            return patientService.getUserIdByEmail(email);
        }
        throw new RuntimeException("Utilisateur non authentifié");
    }
}
