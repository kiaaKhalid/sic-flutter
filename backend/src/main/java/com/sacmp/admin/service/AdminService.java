package com.sacmp.admin.service;

import com.sacmp.admin.dto.AdminPatientResponse;
import com.sacmp.admin.dto.AssignPatientRequest;
import com.sacmp.healthcare.entity.HealthcareWorker;
import com.sacmp.healthcare.entity.PatientAssignment;
import com.sacmp.healthcare.repository.HealthcareWorkerRepository;
import com.sacmp.healthcare.repository.PatientAssignmentRepository;
import com.sacmp.patient.entity.Patient;
import com.sacmp.patient.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final PatientRepository patientRepository;
    private final HealthcareWorkerRepository healthcareWorkerRepository;
    private final PatientAssignmentRepository patientAssignmentRepository;

    /**
     * Récupérer tous les patients (paginé)
     */
    public Page<AdminPatientResponse> getAllPatients(Pageable pageable) {
        return patientRepository.findByDeletedFalse(pageable)
                .map(this::mapToAdminPatientResponse);
    }

    /**
     * Récupérer tous les patients par statut
     */
    public Page<AdminPatientResponse> getPatientsByStatus(String status, Pageable pageable) {
        return patientRepository.findByStatusAndDeletedFalse(
                com.sacmp.common.enums.PatientStatus.valueOf(status.toUpperCase()), 
                pageable
        ).map(this::mapToAdminPatientResponse);
    }

    /**
     * Rechercher des patients par nom ou email
     */
    public Page<AdminPatientResponse> searchPatients(String query, Pageable pageable) {
        return patientRepository.searchByNameOrEmail(query, pageable)
                .map(this::mapToAdminPatientResponse);
    }

    /**
     * Assigner un patient à un healthcare worker
     */
    @Transactional
    public String assignPatientToDoctor(AssignPatientRequest request) {
        Patient patient = patientRepository.findById(request.getPatientId())
                .orElseThrow(() -> new RuntimeException("Patient non trouvé"));

        HealthcareWorker healthcareWorker = healthcareWorkerRepository.findById(request.getHealthcareWorkerId())
                .orElseThrow(() -> new RuntimeException("Healthcare worker non trouvé"));

        // Vérifier si l'assignation existe déjà
        if (patientAssignmentRepository.existsByHealthcareWorkerIdAndPatientIdAndActiveTrue(
                request.getHealthcareWorkerId(), request.getPatientId())) {
            throw new RuntimeException("Ce patient est déjà assigné à ce healthcare worker");
        }

        PatientAssignment assignment = PatientAssignment.builder()
                .patient(patient)
                .healthcareWorker(healthcareWorker)
                .assignedDate(LocalDateTime.now())
                .active(true)
                .primary(request.getPrimary() != null ? request.getPrimary() : false)
                .notes(request.getNotes())
                .build();

        patientAssignmentRepository.save(assignment);

        return "Patient " + patient.getUser().getFullName() + " assigné à " + 
               healthcareWorker.getUser().getFullName() + " avec succès";
    }

    /**
     * Désassigner un patient d'un healthcare worker
     */
    @Transactional
    public String unassignPatientFromDoctor(UUID patientId, UUID healthcareWorkerId) {
        PatientAssignment assignment = patientAssignmentRepository
                .findByHealthcareWorkerIdAndPatientId(healthcareWorkerId, patientId)
                .orElseThrow(() -> new RuntimeException("Assignation non trouvée"));

        assignment.setActive(false);
        assignment.setUnassignedDate(LocalDateTime.now());
        patientAssignmentRepository.save(assignment);

        return "Patient désassigné avec succès";
    }

    /**
     * Mapper Patient vers AdminPatientResponse
     */
    private AdminPatientResponse mapToAdminPatientResponse(Patient patient) {
        int assignedDoctorsCount = patientAssignmentRepository
                .findActiveByPatientId(patient.getId()).size();

        return AdminPatientResponse.builder()
                .id(patient.getId())
                .userId(patient.getUser().getId())
                .fullName(patient.getUser().getFullName())
                .email(patient.getUser().getEmail())
                .phoneNumber(patient.getUser().getPhoneNumber())
                .medicalRecordId(patient.getMedicalRecordId())
                .birthDate(patient.getBirthDate())
                .sex(patient.getSex())
                .status(patient.getStatus())
                .roomNumber(patient.getRoomNumber())
                .admissionDate(patient.getAdmissionDate())
                .dischargeDate(patient.getDischargeDate())
                .emergencyContactName(patient.getEmergencyContactName())
                .emergencyContactPhone(patient.getEmergencyContactPhone())
                .alertCount(patient.getAlertCount())
                .assignedDoctorsCount(assignedDoctorsCount)
                .createdAt(patient.getCreatedAt())
                .updatedAt(patient.getUpdatedAt())
                .build();
    }
}
