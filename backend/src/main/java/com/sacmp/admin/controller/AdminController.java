package com.sacmp.admin.controller;

import com.sacmp.admin.dto.AdminPatientResponse;
import com.sacmp.admin.dto.AssignPatientRequest;
import com.sacmp.admin.service.AdminService;
import com.sacmp.auth.entity.User;
import com.sacmp.auth.repository.UserRepository;
import com.sacmp.common.enums.PatientStatus;
import com.sacmp.patient.entity.Patient;
import com.sacmp.patient.repository.PatientRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.UUID;

@RestController
@RequestMapping("/v1/admin")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AdminController {

    private final UserRepository userRepository;
    private final PatientRepository patientRepository;
    private final AdminService adminService;

    /**
     * Récupérer tous les patients (paginé)
     * GET /api/v1/admin/patients
     */
    @GetMapping("/patients")
    public ResponseEntity<Page<AdminPatientResponse>> getAllPatients(
            @PageableDefault(size = 20) Pageable pageable) {
        Page<AdminPatientResponse> patients = adminService.getAllPatients(pageable);
        return ResponseEntity.ok(patients);
    }

    /**
     * Récupérer les patients par statut
     * GET /api/v1/admin/patients/status/{status}
     */
    @GetMapping("/patients/status/{status}")
    public ResponseEntity<Page<AdminPatientResponse>> getPatientsByStatus(
            @PathVariable String status,
            @PageableDefault(size = 20) Pageable pageable) {
        Page<AdminPatientResponse> patients = adminService.getPatientsByStatus(status, pageable);
        return ResponseEntity.ok(patients);
    }

    /**
     * Rechercher des patients
     * GET /api/v1/admin/patients/search?q=query
     */
    @GetMapping("/patients/search")
    public ResponseEntity<Page<AdminPatientResponse>> searchPatients(
            @RequestParam("q") String query,
            @PageableDefault(size = 20) Pageable pageable) {
        Page<AdminPatientResponse> patients = adminService.searchPatients(query, pageable);
        return ResponseEntity.ok(patients);
    }

    /**
     * Assigner un patient à un healthcare worker (docteur)
     * POST /api/v1/admin/patients/assign
     */
    @PostMapping("/patients/assign")
    public ResponseEntity<String> assignPatientToDoctor(
            @Valid @RequestBody AssignPatientRequest request) {
        String result = adminService.assignPatientToDoctor(request);
        return ResponseEntity.ok(result);
    }

    /**
     * Désassigner un patient d'un healthcare worker
     * DELETE /api/v1/admin/patients/{patientId}/unassign/{healthcareWorkerId}
     */
    @DeleteMapping("/patients/{patientId}/unassign/{healthcareWorkerId}")
    public ResponseEntity<String> unassignPatientFromDoctor(
            @PathVariable UUID patientId,
            @PathVariable UUID healthcareWorkerId) {
        String result = adminService.unassignPatientFromDoctor(patientId, healthcareWorkerId);
        return ResponseEntity.ok(result);
    }

    /**
     * Créer un patient pour un utilisateur existant
     * POST /api/v1/admin/create-patient/{userId}
     */
    @PostMapping("/create-patient/{userId}")
    public ResponseEntity<String> createPatientForUser(@PathVariable UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

        // Vérifier si un patient existe déjà
        if (patientRepository.findByUserId(userId).isPresent()) {
            return ResponseEntity.badRequest().body("Un patient existe déjà pour cet utilisateur");
        }

        Patient patient = Patient.builder()
                .user(user)
                .medicalRecordId("MR-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase())
                .status(PatientStatus.STABLE)
                .admissionDate(LocalDateTime.now())
                .deleted(false)
                .build();

        patientRepository.save(patient);

        return ResponseEntity.ok("Patient créé avec succès pour " + user.getEmail() + 
                " - ID Patient: " + patient.getId() + 
                " - Dossier médical: " + patient.getMedicalRecordId());
    }
}
