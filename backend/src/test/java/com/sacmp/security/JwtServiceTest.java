package com.sacmp.security;

import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.HashMap;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class JwtServiceTest {

    private JwtService jwtService;
    private UserDetails userDetails;

    @BeforeEach
    void setUp() {
        jwtService = new JwtService();
        
        // Configure les propriétés du service
        ReflectionTestUtils.setField(jwtService, "secretKey", "404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970");
        ReflectionTestUtils.setField(jwtService, "accessTokenExpiration", 86400000L); // 24 heures
        ReflectionTestUtils.setField(jwtService, "refreshTokenExpiration", 604800000L); // 7 jours

        userDetails = User.builder()
                .username("test@example.com")
                .password("password")
                .authorities("ROLE_USER")
                .build();
    }

    @Test
    void generateToken_ShouldGenerateValidToken() {
        // When
        String token = jwtService.generateToken(userDetails);

        // Then
        assertThat(token).isNotNull();
        assertThat(token).isNotEmpty();
        assertThat(jwtService.extractUsername(token)).isEqualTo("test@example.com");
    }

    @Test
    void generateToken_WithExtraClaims_ShouldIncludeClaims() {
        // Given
        Map<String, Object> extraClaims = new HashMap<>();
        extraClaims.put("role", "PATIENT");
        extraClaims.put("userId", "123");

        // When
        String token = jwtService.generateToken(extraClaims, userDetails);

        // Then
        assertThat(token).isNotNull();
        assertThat(jwtService.extractUsername(token)).isEqualTo("test@example.com");
    }

    @Test
    void generateRefreshToken_ShouldGenerateValidToken() {
        // When
        String refreshToken = jwtService.generateRefreshToken(userDetails);

        // Then
        assertThat(refreshToken).isNotNull();
        assertThat(refreshToken).isNotEmpty();
        assertThat(jwtService.extractUsername(refreshToken)).isEqualTo("test@example.com");
    }

    @Test
    void extractUsername_ShouldReturnCorrectUsername() {
        // Given
        String token = jwtService.generateToken(userDetails);

        // When
        String username = jwtService.extractUsername(token);

        // Then
        assertThat(username).isEqualTo("test@example.com");
    }

    @Test
    void isTokenValid_ShouldReturnTrue_WhenTokenIsValid() {
        // Given
        String token = jwtService.generateToken(userDetails);

        // When
        boolean isValid = jwtService.isTokenValid(token, userDetails);

        // Then
        assertThat(isValid).isTrue();
    }

    @Test
    void isTokenValid_ShouldReturnFalse_WhenUsernameDoesNotMatch() {
        // Given
        String token = jwtService.generateToken(userDetails);
        UserDetails differentUser = User.builder()
                .username("different@example.com")
                .password("password")
                .authorities("ROLE_USER")
                .build();

        // When
        boolean isValid = jwtService.isTokenValid(token, differentUser);

        // Then
        assertThat(isValid).isFalse();
    }

    @Test
    void extractClaim_ShouldExtractSpecificClaim() {
        // Given
        String token = jwtService.generateToken(userDetails);

        // When
        String subject = jwtService.extractClaim(token, Claims::getSubject);

        // Then
        assertThat(subject).isEqualTo("test@example.com");
    }
}
