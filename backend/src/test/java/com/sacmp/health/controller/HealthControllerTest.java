package com.sacmp.health.controller;

import com.sacmp.health.dto.HeartRateResponse;
import com.sacmp.health.dto.SleepDataResponse;
import com.sacmp.health.service.HealthDataService;
import com.sacmp.security.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(HealthDataController.class)
class HealthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private HealthDataService healthDataService;

    @MockBean
    private JwtService jwtService;

    @Test
    @WithMockUser(roles = "PATIENT")
    void getHeartRateData_ShouldReturnHeartRateResponse() throws Exception {
        UUID patientId = UUID.randomUUID();
        HeartRateResponse response = HeartRateResponse.builder()
                .currentBpm(75)
                .currentVfc(50)
                .minBpm(60)
                .maxBpm(90)
                .averageBpm(75.0)
                .last24Hours(Collections.emptyList())
                .build();

        when(healthDataService.getHeartRateData(any(UUID.class), anyString())).thenReturn(response);

        mockMvc.perform(get("/v1/health/heart-rate/" + patientId)
                        .param("period", "24h")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.currentBpm").value(75))
                .andExpect(jsonPath("$.currentVfc").value(50));

        verify(healthDataService).getHeartRateData(any(UUID.class), eq("24h"));
    }

    @Test
    @WithMockUser(roles = "PATIENT")
    void getSleepData_ShouldReturnSleepDataResponse() throws Exception {
        UUID patientId = UUID.randomUUID();
        SleepDataResponse response = SleepDataResponse.builder()
                .totalMinutes(480)
                .sleepQuality(85)
                .last7Nights(Collections.emptyList())
                .build();

        when(healthDataService.getSleepData(any(UUID.class), anyString())).thenReturn(response);

        mockMvc.perform(get("/v1/health/sleep/" + patientId)
                        .param("period", "7d")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalMinutes").value(480))
                .andExpect(jsonPath("$.sleepQuality").value(85));

        verify(healthDataService).getSleepData(any(UUID.class), eq("7d"));
    }
}
