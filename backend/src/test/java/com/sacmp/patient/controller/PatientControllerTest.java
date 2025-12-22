package com.sacmp.patient.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sacmp.common.enums.MoodValue;
import com.sacmp.patient.dto.MoodDeclarationRequest;
import com.sacmp.patient.dto.MoodHistoryResponse;
import com.sacmp.patient.dto.PatientDashboardResponse;
import com.sacmp.patient.service.PatientService;
import com.sacmp.security.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.*;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(PatientController.class)
class PatientControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private PatientService patientService;

    @MockBean
    private JwtService jwtService;

    @Test
    @WithMockUser(username = "patient@test.com", roles = "PATIENT")
    void getDashboard_ShouldReturnDashboard() throws Exception {
        UUID userId = UUID.randomUUID();
        PatientDashboardResponse.PatientInfo patientInfo = PatientDashboardResponse.PatientInfo.builder()
                .id(userId.toString())
                .fullName("John Doe")
                .email("patient@test.com")
                .medicalRecordId("MR-123456")
                .build();

        PatientDashboardResponse response = PatientDashboardResponse.builder()
                .patient(patientInfo)
                .build();

        when(patientService.getUserIdByEmail("patient@test.com")).thenReturn(userId);
        when(patientService.getDashboard(any(UUID.class))).thenReturn(response);

        mockMvc.perform(get("/v1/patients/dashboard")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.patient.fullName").value("John Doe"));

        verify(patientService).getDashboard(any(UUID.class));
    }

    @Test
    @WithMockUser(username = "patient@test.com", roles = "PATIENT")
    void declareMood_ShouldReturnSuccess() throws Exception {
        UUID userId = UUID.randomUUID();
        MoodDeclarationRequest request = new MoodDeclarationRequest();
        request.setMoodValue(MoodValue.HAPPY);
        request.setNotes("Feeling great!");
        request.setRecordedAt(LocalDateTime.now());

        when(patientService.getUserIdByEmail("patient@test.com")).thenReturn(userId);
        doNothing().when(patientService).declareMood(any(UUID.class), any());

        mockMvc.perform(post("/v1/patients/mood")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(content().string("Humeur déclarée avec succès"));

        verify(patientService).declareMood(any(UUID.class), any());
    }

    @Test
    @WithMockUser(username = "patient@test.com", roles = "PATIENT")
    void getMoodHistory_ShouldReturnHistory() throws Exception {
        UUID userId = UUID.randomUUID();
        MoodHistoryResponse response = MoodHistoryResponse.builder()
                .history(Collections.emptyList())
                .frequency(new HashMap<>())
                .dominantMood("CALM")
                .build();

        when(patientService.getUserIdByEmail("patient@test.com")).thenReturn(userId);
        when(patientService.getMoodHistory(any(UUID.class), eq(30))).thenReturn(response);

        mockMvc.perform(get("/v1/patients/mood/history")
                        .param("days", "30")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.dominantMood").value("CALM"));

        verify(patientService).getMoodHistory(any(UUID.class), eq(30));
    }

    @Test
    @WithMockUser(username = "patient@test.com", roles = "PATIENT")
    void getAlerts_ShouldReturnOk() throws Exception {
        mockMvc.perform(get("/v1/patients/alerts")
                        .with(csrf()))
                .andExpect(status().isOk());
    }
}
