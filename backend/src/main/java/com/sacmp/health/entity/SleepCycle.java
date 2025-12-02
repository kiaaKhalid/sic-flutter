package com.sacmp.health.entity;

import com.sacmp.common.enums.SleepStage;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entité Cycle de Sommeil
 */
@Entity
@Table(name = "sleep_cycles")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SleepCycle {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sleep_data_id", nullable = false)
    private SleepData sleepData;

    @Enumerated(EnumType.STRING)
    @Column(name = "stage", nullable = false)
    private SleepStage stage;

    @Column(name = "duration_minutes", nullable = false)
    private Integer durationMinutes;

    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalDateTime endTime;

    @Column(name = "sequence_order")
    private Integer sequenceOrder;
}