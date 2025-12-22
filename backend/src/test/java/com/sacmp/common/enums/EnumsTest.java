package com.sacmp.common.enums;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests pour tous les enums de l'application
 */
class EnumsTest {

    @Test
    void userRole_ShouldHaveAllValues() {
        UserRole[] values = UserRole.values();
        assertEquals(3, values.length);
        assertEquals(UserRole.ADMIN, UserRole.valueOf("ADMIN"));
        assertEquals(UserRole.HEALTHCARE_WORKER, UserRole.valueOf("HEALTHCARE_WORKER"));
        assertEquals(UserRole.PATIENT, UserRole.valueOf("PATIENT"));
    }

    @Test
    void alertType_ShouldHaveAllValues() {
        AlertType[] values = AlertType.values();
        assertEquals(6, values.length);
        assertEquals(AlertType.HEART_RATE, AlertType.valueOf("HEART_RATE"));
        assertEquals(AlertType.MOOD, AlertType.valueOf("MOOD"));
        assertEquals(AlertType.SLEEP, AlertType.valueOf("SLEEP"));
        assertEquals(AlertType.CORRELATION, AlertType.valueOf("CORRELATION"));
        assertEquals(AlertType.MEDICATION, AlertType.valueOf("MEDICATION"));
        assertEquals(AlertType.EMERGENCY, AlertType.valueOf("EMERGENCY"));
    }

    @Test
    void alertPriority_ShouldHaveAllValues() {
        AlertPriority[] values = AlertPriority.values();
        assertEquals(4, values.length);
        assertEquals(AlertPriority.CRITICAL, AlertPriority.valueOf("CRITICAL"));
        assertEquals(AlertPriority.HIGH, AlertPriority.valueOf("HIGH"));
        assertEquals(AlertPriority.MEDIUM, AlertPriority.valueOf("MEDIUM"));
        assertEquals(AlertPriority.LOW, AlertPriority.valueOf("LOW"));
    }

    @Test
    void alertStatus_ShouldHaveAllValues() {
        AlertStatus[] values = AlertStatus.values();
        assertEquals(4, values.length);
        assertEquals(AlertStatus.ACTIVE, AlertStatus.valueOf("ACTIVE"));
        assertEquals(AlertStatus.ACKNOWLEDGED, AlertStatus.valueOf("ACKNOWLEDGED"));
        assertEquals(AlertStatus.RESOLVED, AlertStatus.valueOf("RESOLVED"));
        assertEquals(AlertStatus.IGNORED, AlertStatus.valueOf("IGNORED"));
    }

    @Test
    void moodValue_ShouldHaveAllValues() {
        MoodValue[] values = MoodValue.values();
        assertEquals(6, values.length);
        assertEquals(MoodValue.HAPPY, MoodValue.valueOf("HAPPY"));
        assertEquals(MoodValue.CALM, MoodValue.valueOf("CALM"));
        assertEquals(MoodValue.ANXIOUS, MoodValue.valueOf("ANXIOUS"));
        assertEquals(MoodValue.SAD, MoodValue.valueOf("SAD"));
        assertEquals(MoodValue.TIRED, MoodValue.valueOf("TIRED"));
        assertEquals(MoodValue.STRESSED, MoodValue.valueOf("STRESSED"));
    }

    @Test
    void patientStatus_ShouldHaveAllValues() {
        PatientStatus[] values = PatientStatus.values();
        assertEquals(4, values.length);
        assertEquals(PatientStatus.CRITICAL, PatientStatus.valueOf("CRITICAL"));
        assertEquals(PatientStatus.TO_MONITOR, PatientStatus.valueOf("TO_MONITOR"));
        assertEquals(PatientStatus.STABLE, PatientStatus.valueOf("STABLE"));
        assertEquals(PatientStatus.DISCHARGED, PatientStatus.valueOf("DISCHARGED"));
    }

    @Test
    void auditAction_ShouldHaveAllValues() {
        AuditAction[] values = AuditAction.values();
        assertEquals(9, values.length);
        assertEquals(AuditAction.LOGIN, AuditAction.valueOf("LOGIN"));
        assertEquals(AuditAction.LOGOUT, AuditAction.valueOf("LOGOUT"));
        assertEquals(AuditAction.CREATE, AuditAction.valueOf("CREATE"));
        assertEquals(AuditAction.READ, AuditAction.valueOf("READ"));
        assertEquals(AuditAction.UPDATE, AuditAction.valueOf("UPDATE"));
        assertEquals(AuditAction.DELETE, AuditAction.valueOf("DELETE"));
        assertEquals(AuditAction.EXPORT, AuditAction.valueOf("EXPORT"));
        assertEquals(AuditAction.ACKNOWLEDGE_ALERT, AuditAction.valueOf("ACKNOWLEDGE_ALERT"));
        assertEquals(AuditAction.RESOLVE_ALERT, AuditAction.valueOf("RESOLVE_ALERT"));
    }

    @Test
    void reportStatus_ShouldHaveAllValues() {
        ReportStatus[] values = ReportStatus.values();
        assertEquals(4, values.length);
        assertEquals(ReportStatus.PENDING, ReportStatus.valueOf("PENDING"));
        assertEquals(ReportStatus.GENERATING, ReportStatus.valueOf("GENERATING"));
        assertEquals(ReportStatus.COMPLETED, ReportStatus.valueOf("COMPLETED"));
        assertEquals(ReportStatus.FAILED, ReportStatus.valueOf("FAILED"));
    }

    @Test
    void reportFormat_ShouldHaveAllValues() {
        ReportFormat[] values = ReportFormat.values();
        assertEquals(3, values.length);
        assertEquals(ReportFormat.PDF, ReportFormat.valueOf("PDF"));
        assertEquals(ReportFormat.EXCEL, ReportFormat.valueOf("EXCEL"));
        assertEquals(ReportFormat.CSV, ReportFormat.valueOf("CSV"));
    }

    @Test
    void codeType_ShouldHaveAllValues() {
        CodeType[] values = CodeType.values();
        assertEquals(3, values.length);
        assertEquals(CodeType.LOGIN, CodeType.valueOf("LOGIN"));
        assertEquals(CodeType.PASSWORD_RESET, CodeType.valueOf("PASSWORD_RESET"));
        assertEquals(CodeType.EMAIL_VERIFICATION, CodeType.valueOf("EMAIL_VERIFICATION"));
    }

    @Test
    void accountStatus_ShouldHaveAllValues() {
        AccountStatus[] values = AccountStatus.values();
        assertEquals(4, values.length);
        assertEquals(AccountStatus.ACTIVE, AccountStatus.valueOf("ACTIVE"));
        assertEquals(AccountStatus.INACTIVE, AccountStatus.valueOf("INACTIVE"));
        assertEquals(AccountStatus.SUSPENDED, AccountStatus.valueOf("SUSPENDED"));
        assertEquals(AccountStatus.PENDING_VERIFICATION, AccountStatus.valueOf("PENDING_VERIFICATION"));
    }

    @Test
    void reportType_ShouldHaveAllValues() {
        ReportType[] values = ReportType.values();
        assertEquals(4, values.length);
        assertEquals(ReportType.DAILY, ReportType.valueOf("DAILY"));
        assertEquals(ReportType.WEEKLY, ReportType.valueOf("WEEKLY"));
        assertEquals(ReportType.MONTHLY, ReportType.valueOf("MONTHLY"));
        assertEquals(ReportType.CUSTOM, ReportType.valueOf("CUSTOM"));
    }

    @Test
    void sleepStage_ShouldHaveAllValues() {
        SleepStage[] values = SleepStage.values();
        assertEquals(4, values.length);
        assertEquals(SleepStage.AWAKE, SleepStage.valueOf("AWAKE"));
        assertEquals(SleepStage.LIGHT, SleepStage.valueOf("LIGHT"));
        assertEquals(SleepStage.DEEP, SleepStage.valueOf("DEEP"));
        assertEquals(SleepStage.REM, SleepStage.valueOf("REM"));
    }
}
