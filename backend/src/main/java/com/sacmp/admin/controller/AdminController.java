package com.sacmp.admin.controller;

import com.sacmp.auth.entity.User;
import com.sacmp.auth.repository.UserRepository;
import com.sacmp.common.enums.PatientStatus;
import com.sacmp.patient.entity.Patient;
import com.sacmp.patient.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
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
