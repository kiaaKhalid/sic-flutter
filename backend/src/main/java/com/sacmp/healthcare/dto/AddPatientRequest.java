package com.sacmp.healthcare.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AddPatientRequest {
    
    @NotBlank(message = "Le nom complet est requis")
    private String fullName;
    
    @NotBlank(message = "L'email est requis")
    @Email(message = "Format d'email invalide")
    private String email;
    
    @NotBlank(message = "Le numéro de dossier médical est requis")
    private String medicalRecordId;
    
    private LocalDate birthDate;
    private String sex;
    private String roomNumber;
    private String phoneNumber;
    private String emergencyContactName;
    private String emergencyContactPhone;
    private String medicalNotes;
    private String allergies;
    private String currentMedications;
}
