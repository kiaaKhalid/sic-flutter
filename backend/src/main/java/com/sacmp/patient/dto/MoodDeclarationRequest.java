package com.sacmp.patient.dto;

import com.sacmp.common.enums.MoodValue;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MoodDeclarationRequest {
    
    @NotNull(message = "La valeur d'humeur est requise")
    private MoodValue moodValue;
    
    private String notes;
    
    private LocalDateTime recordedAt;
}
