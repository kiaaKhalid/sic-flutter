package com.sacmp.auth.dto;

import com.sacmp.common.enums.UserRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * DTO pour la réponse d'authentification
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {

    private String accessToken;
    private String refreshToken;
    @Builder.Default
    private String tokenType = "Bearer";
    private Long expiresIn;
    private UserInfo user;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UserInfo {
        private UUID id;
        private String email;
        private String fullName;
        private UserRole role;
        private String profilePictureUrl;
        private Boolean emailVerified;
    }
}
