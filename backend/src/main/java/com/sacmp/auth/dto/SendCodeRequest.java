package com.sacmp.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SendCodeRequest {
    @NotBlank(message = "L'email est requis")
    @Email(message = "Format d'email invalide")
    private String email;
}
