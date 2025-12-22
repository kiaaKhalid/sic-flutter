package com.sacmp.admin.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * DTO pour assigner un patient à un healthcare worker
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AssignPatientRequest {

    @NotNull(message = "L'ID du patient est requis")
    private UUID patientId;

    @NotNull(message = "L'ID du healthcare worker est requis")
    private UUID healthcareWorkerId;

    private Boolean primary;
    
    private String notes;
}
