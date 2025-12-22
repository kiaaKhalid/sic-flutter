package com.sacmp.auth.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sacmp.auth.dto.*;
import com.sacmp.auth.service.AuthService;
import com.sacmp.common.enums.UserRole;
import com.sacmp.security.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AuthController.class)
@AutoConfigureMockMvc(addFilters = false)
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private AuthService authService;

    @MockBean
    private JwtService jwtService;

    @Test
    void register_ShouldReturnAuthResponse() throws Exception {
        // Given
        RegisterRequest request = new RegisterRequest();
        request.setEmail("newuser@test.com");
        request.setPassword("Password123!");
        request.setConfirmPassword("Password123!");
        request.setFullName("New User");
        request.setRole(UserRole.PATIENT);

        AuthResponse.UserInfo userInfo = AuthResponse.UserInfo.builder()
                .id(UUID.randomUUID())
                .email("newuser@test.com")
                .fullName("New User")
                .role(UserRole.PATIENT)
                .build();

        AuthResponse response = AuthResponse.builder()
                .accessToken("jwt.token.here")
                .refreshToken("refresh.token.here")
                .tokenType("Bearer")
                .user(userInfo)
                .build();

        when(authService.register(any(RegisterRequest.class))).thenReturn(response);

        // When & Then
        mockMvc.perform(post("/v1/auth/register")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.accessToken").value("jwt.token.here"))
                .andExpect(jsonPath("$.user.email").value("newuser@test.com"));

        verify(authService).register(any(RegisterRequest.class));
    }

    @Test
    void login_ShouldReturnAuthResponse() throws Exception {
        // Given
        LoginRequest request = new LoginRequest();
        request.setEmail("user@test.com");
        request.setPassword("password123");

        AuthResponse.UserInfo userInfo = AuthResponse.UserInfo.builder()
                .id(UUID.randomUUID())
                .email("user@test.com")
                .fullName("Test User")
                .role(UserRole.PATIENT)
                .build();

        AuthResponse response = AuthResponse.builder()
                .accessToken("jwt.token.here")
                .refreshToken("refresh.token.here")
                .tokenType("Bearer")
                .user(userInfo)
                .build();

        when(authService.login(any(LoginRequest.class))).thenReturn(response);

        // When & Then
        mockMvc.perform(post("/v1/auth/login")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").value("jwt.token.here"))
                .andExpect(jsonPath("$.user.email").value("user@test.com"));

        verify(authService).login(any(LoginRequest.class));
    }

    @Test
    void sendLoginCode_ShouldReturnSuccessMessage() throws Exception {
        // Given
        SendCodeRequest request = new SendCodeRequest();
        request.setEmail("user@test.com");

        // When & Then
        mockMvc.perform(post("/v1/auth/send-code")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(content().string("Code envoyé à user@test.com"));
    }

    @Test
    void verifyCode_ShouldReturnAuthResponse() throws Exception {
        // Given
        VerifyCodeRequest request = new VerifyCodeRequest();
        request.setEmail("user@test.com");
        request.setCode("123456");

        // When & Then
        mockMvc.perform(post("/v1/auth/verify-code")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());
    }

    @Test
    void googleAuth_ShouldReturnAuthResponse() throws Exception {
        // Given
        GoogleAuthRequest request = new GoogleAuthRequest();
        request.setIdToken("google.id.token");

        // When & Then
        mockMvc.perform(post("/v1/auth/google")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());
    }

    @Test
    void refreshToken_ShouldReturnAuthResponse() throws Exception {
        // When & Then
        mockMvc.perform(post("/v1/auth/refresh-token")
                        .with(csrf())
                        .header("Authorization", "Bearer refresh.token.here"))
                .andExpect(status().isOk());
    }

    @Test
    void logout_ShouldReturnSuccessMessage() throws Exception {
        // When & Then
        mockMvc.perform(post("/v1/auth/logout")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(content().string("Déconnexion réussie"));
    }
}
