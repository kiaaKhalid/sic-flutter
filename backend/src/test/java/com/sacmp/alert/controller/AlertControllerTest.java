package com.sacmp.alert.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sacmp.alert.dto.AcknowledgeAlertRequest;
import com.sacmp.alert.dto.AlertResponse;
import com.sacmp.alert.dto.ResolveAlertRequest;
import com.sacmp.alert.service.AlertService;
import com.sacmp.security.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.*;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AlertController.class)
class AlertControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private AlertService alertService;

    @MockBean
    private JwtService jwtService;

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void getActiveAlerts_ShouldReturnPagedAlerts() throws Exception {
        AlertResponse alert = AlertResponse.builder()
                .id(UUID.randomUUID().toString())
                .title("High Heart Rate")
                .priority("HIGH")
                .status("ACTIVE")
                .build();
        Page<AlertResponse> alertPage = new PageImpl<>(Collections.singletonList(alert), PageRequest.of(0, 10), 1);

        when(alertService.getActiveAlerts(any())).thenReturn(alertPage);

        mockMvc.perform(get("/v1/alerts")
                        .param("page", "0")
                        .param("size", "10")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].title").value("High Heart Rate"));

        verify(alertService).getActiveAlerts(any());
    }

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void getPatientAlerts_ShouldReturnAlerts() throws Exception {
        UUID patientId = UUID.randomUUID();
        AlertResponse alert = AlertResponse.builder()
                .id(UUID.randomUUID().toString())
                .title("Mood Alert")
                .build();

        when(alertService.getPatientAlerts(patientId)).thenReturn(Collections.singletonList(alert));

        mockMvc.perform(get("/v1/alerts/patient/" + patientId)
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].title").value("Mood Alert"));

        verify(alertService).getPatientAlerts(patientId);
    }

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void getAlertById_ShouldReturnAlert() throws Exception {
        UUID alertId = UUID.randomUUID();
        AlertResponse alert = AlertResponse.builder()
                .id(alertId.toString())
                .title("Test Alert")
                .build();

        when(alertService.getAlertById(alertId)).thenReturn(alert);

        mockMvc.perform(get("/v1/alerts/" + alertId)
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Test Alert"));

        verify(alertService).getAlertById(alertId);
    }

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void acknowledgeAlert_ShouldReturnSuccess() throws Exception {
        UUID alertId = UUID.randomUUID();
        AcknowledgeAlertRequest request = new AcknowledgeAlertRequest();
        request.setNote("Acknowledged by doctor");

        doNothing().when(alertService).acknowledgeAlert(eq(alertId), any(UUID.class), any());

        mockMvc.perform(post("/v1/alerts/" + alertId + "/acknowledge")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(content().string("Alerte accusée réception"));

        verify(alertService).acknowledgeAlert(eq(alertId), any(UUID.class), any());
    }

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void resolveAlert_ShouldReturnSuccess() throws Exception {
        UUID alertId = UUID.randomUUID();
        ResolveAlertRequest request = new ResolveAlertRequest();
        request.setResolutionNote("Issue resolved");

        doNothing().when(alertService).resolveAlert(eq(alertId), any(UUID.class), any());

        mockMvc.perform(post("/v1/alerts/" + alertId + "/resolve")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(content().string("Alerte résolue"));

        verify(alertService).resolveAlert(eq(alertId), any(UUID.class), any());
    }
}
