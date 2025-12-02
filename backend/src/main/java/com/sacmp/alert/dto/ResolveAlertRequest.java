package com.sacmp.alert.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResolveAlertRequest {
    
    @NotBlank(message = "La note de résolution est requise")
    private String resolutionNote;
    
    private String actionTaken;
}
