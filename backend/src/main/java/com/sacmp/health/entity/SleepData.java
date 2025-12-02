package com.sacmp.health.entity;

import com.sacmp.common.enums.SleepStage;
import com.sacmp.patient.entity.Patient;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "sleep_data", indexes = {
    @Index(name = "idx_patient_id", columnList = "patient_id"),
    @Index(name = "idx_sleep_start", columnList = "sleep_start"),
    @Index(name = "idx_sleep_end", columnList = "sleep_end")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class SleepData {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "sleep_start", nullable = false)
    private LocalDateTime sleepStart;

    @Column(name = "sleep_end", nullable = false)
    private LocalDateTime sleepEnd;

    @Column(name = "total_minutes", nullable = false)
    private Integer totalMinutes;

    @Column(name = "light_sleep_minutes")
    private Integer lightSleepMinutes;

    @Column(name = "deep_sleep_minutes")
    private Integer deepSleepMinutes;

    @Column(name = "rem_sleep_minutes")
    private Integer remSleepMinutes;

    @Column(name = "awake_minutes")
    private Integer awakeMinutes;

    @Column(name = "sleep_quality")
    private Integer sleepQuality;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
