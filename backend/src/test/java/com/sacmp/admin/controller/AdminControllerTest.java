package com.sacmp.admin.controller;

import com.sacmp.auth.entity.User;
import com.sacmp.auth.repository.UserRepository;
import com.sacmp.patient.entity.Patient;
import com.sacmp.patient.repository.PatientRepository;
import com.sacmp.security.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Optional;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AdminController.class)
class AdminControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private PatientRepository patientRepository;

    @MockBean
    private JwtService jwtService;

    @Test
    @WithMockUser(roles = "ADMIN")
    void createPatientForUser_ShouldReturnSuccess_WhenUserExistsAndNoPatient() throws Exception {
        // Given
        UUID userId = UUID.randomUUID();
        User user = new User();
        user.setId(userId);
        user.setEmail("user@test.com");

        Patient patient = new Patient();
        patient.setId(UUID.randomUUID());
        patient.setUser(user);
        patient.setMedicalRecordId("MR-ABCD1234");

        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(patientRepository.findByUserId(userId)).thenReturn(Optional.empty());
        when(patientRepository.save(any(Patient.class))).thenReturn(patient);

        // When & Then
        mockMvc.perform(post("/v1/admin/create-patient/" + userId)
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("Patient créé avec succès")));

        verify(userRepository).findById(userId);
        verify(patientRepository).findByUserId(userId);
        verify(patientRepository).save(any(Patient.class));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void createPatientForUser_ShouldReturnBadRequest_WhenPatientAlreadyExists() throws Exception {
        // Given
        UUID userId = UUID.randomUUID();
        User user = new User();
        user.setId(userId);
        user.setEmail("user@test.com");

        Patient existingPatient = new Patient();
        existingPatient.setId(UUID.randomUUID());

        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(patientRepository.findByUserId(userId)).thenReturn(Optional.of(existingPatient));

        // When & Then
        mockMvc.perform(post("/v1/admin/create-patient/" + userId)
                        .with(csrf()))
                .andExpect(status().isBadRequest())
                .andExpect(content().string("Un patient existe déjà pour cet utilisateur"));

        verify(userRepository).findById(userId);
        verify(patientRepository).findByUserId(userId);
        verify(patientRepository, never()).save(any());
    }
}
