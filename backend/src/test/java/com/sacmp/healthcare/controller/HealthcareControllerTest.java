package com.sacmp.healthcare.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sacmp.healthcare.dto.AddPatientRequest;
import com.sacmp.healthcare.dto.DashboardResponse;
import com.sacmp.healthcare.dto.PatientDetailResponse;
import com.sacmp.healthcare.service.HealthcareWorkerService;
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

import java.time.LocalDate;
import java.util.Collections;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(HealthcareWorkerController.class)
class HealthcareWorkerControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private HealthcareWorkerService healthcareWorkerService;

    @MockBean
    private JwtService jwtService;

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void getDashboard_ShouldReturnDashboard() throws Exception {
        DashboardResponse response = DashboardResponse.builder()
                .statistics(DashboardResponse.Statistics.builder()
                        .totalPatients(100L)
                        .criticalPatients(5L)
                        .activeAlerts(20L)
                        .build())
                .recentPatients(Collections.emptyList())
                .activeAlerts(Collections.emptyList())
                .build();

        when(healthcareWorkerService.getDashboard()).thenReturn(response);

        mockMvc.perform(get("/v1/healthcare-workers/dashboard")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.statistics.totalPatients").value(100))
                .andExpect(jsonPath("$.statistics.criticalPatients").value(5));

        verify(healthcareWorkerService).getDashboard();
    }

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void addPatient_ShouldReturnPatientDetail() throws Exception {
        AddPatientRequest request = new AddPatientRequest();
        request.setFullName("New Patient");
        request.setEmail("newpatient@test.com");
        request.setMedicalRecordId("MR-12345");
        request.setBirthDate(LocalDate.of(1990, 5, 15));
        request.setSex("M");

        PatientDetailResponse response = PatientDetailResponse.builder()
                .id(UUID.randomUUID().toString())
                .fullName("New Patient")
                .email("newpatient@test.com")
                .medicalRecordId("MR-12345")
                .build();

        when(healthcareWorkerService.addPatient(any(AddPatientRequest.class))).thenReturn(response);

        mockMvc.perform(post("/v1/healthcare-workers/patients")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.fullName").value("New Patient"))
                .andExpect(jsonPath("$.medicalRecordId").value("MR-12345"));

        verify(healthcareWorkerService).addPatient(any(AddPatientRequest.class));
    }

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void getAllPatients_ShouldReturnPagedPatients() throws Exception {
        PatientDetailResponse patient = PatientDetailResponse.builder()
                .id(UUID.randomUUID().toString())
                .fullName("John Doe")
                .medicalRecordId("MR-123456")
                .build();
        Page<PatientDetailResponse> patientPage = new PageImpl<>(
                Collections.singletonList(patient), PageRequest.of(0, 10), 1);

        when(healthcareWorkerService.getAllPatients(any())).thenReturn(patientPage);

        mockMvc.perform(get("/v1/healthcare-workers/patients")
                        .param("page", "0")
                        .param("size", "10")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].fullName").value("John Doe"));

        verify(healthcareWorkerService).getAllPatients(any());
    }

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void getPatientById_ShouldReturnPatient() throws Exception {
        UUID patientId = UUID.randomUUID();
        PatientDetailResponse response = PatientDetailResponse.builder()
                .id(patientId.toString())
                .fullName("Jane Doe")
                .medicalRecordId("MR-789")
                .build();

        when(healthcareWorkerService.getPatientById(patientId)).thenReturn(response);

        mockMvc.perform(get("/v1/healthcare-workers/patients/" + patientId)
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.fullName").value("Jane Doe"));

        verify(healthcareWorkerService).getPatientById(patientId);
    }

    @Test
    @WithMockUser(roles = "HEALTHCARE_WORKER")
    void deletePatient_ShouldReturnSuccess() throws Exception {
        UUID patientId = UUID.randomUUID();
        doNothing().when(healthcareWorkerService).deletePatient(patientId);

        mockMvc.perform(delete("/v1/healthcare-workers/patients/" + patientId)
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(content().string("Patient supprimé avec succès"));

        verify(healthcareWorkerService).deletePatient(patientId);
    }
}
