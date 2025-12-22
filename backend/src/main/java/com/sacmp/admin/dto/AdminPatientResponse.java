package com.sacmp.admin.dto;

import com.sacmp.common.enums.PatientStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * DTO pour la réponse de la liste des patients (Admin)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminPatientResponse {

    private UUID id;
    private UUID userId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String medicalRecordId;
    private LocalDate birthDate;
    private String sex;
    private PatientStatus status;
    private String roomNumber;
    private LocalDateTime admissionDate;
    private LocalDateTime dischargeDate;
    private String emergencyContactName;
    private String emergencyContactPhone;
    private Integer alertCount;
    private Integer assignedDoctorsCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
