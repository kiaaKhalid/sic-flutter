
class HealthData {
  final String patientId;
  final DateTime timestamp;
  final HeartRateData? heartRate;
  final MoodData? mood;
  final SleepData? sleep;

  const HealthData({
    required this.patientId,
    required this.timestamp,
    this.heartRate,
    this.mood,
    this.sleep,
  });
}

class HeartRateData {
  final int bpm;
  final int? vfc; // Variabilité de la fréquence cardiaque
  final int? minBpm;
  final int? maxBpm;
  final List<HeartRateMeasurement> last24h;
  final List<HeartRateMeasurement> last7d;

  const HeartRateData({
    required this.bpm,
    this.vfc,
    this.minBpm,
    this.maxBpm,
    required this.last24h,
    required this.last7d,
  });
}

class HeartRateMeasurement {
  final DateTime timestamp;
  final int bpm;

  const HeartRateMeasurement({
    required this.timestamp,
    required this.bpm,
  });
}

class MoodData {
  final String mood;
  final String? notes;
  final DateTime timestamp;
  final List<MoodEntry> last7d;

  const MoodData({
    required this.mood,
    this.notes,
    required this.timestamp,
    required this.last7d,
  });
}

class MoodEntry {
  final String mood;
  final DateTime date;
  final String? notes;

  const MoodEntry({
    required this.mood,
    required this.date,
    this.notes,
  });
}

class SleepData {
  final DateTime startTime;
  final DateTime endTime;
  final int totalMinutes;
  final List<SleepCycle> cycles;
  final List<SleepDataPoint> lastNight;
  final List<SleepSummary> last7d;

  const SleepData({
    required this.startTime,
    required this.endTime,
    required this.totalMinutes,
    required this.cycles,
    required this.lastNight,
    required this.last7d,
  });

  String get formattedDuration {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}

enum SleepStage { awake, light, deep, rem }

class SleepCycle {
  final SleepStage stage;
  final int durationMinutes;
  final DateTime startTime;

  const SleepCycle({
    required this.stage,
    required this.durationMinutes,
    required this.startTime,
  });
}

class SleepDataPoint {
  final DateTime timestamp;
  final SleepStage stage;

  const SleepDataPoint({
    required this.timestamp,
    required this.stage,
  });
}

class SleepSummary {
  final DateTime date;
  final int totalMinutes;
  final int lightSleepMinutes;
  final int deepSleepMinutes;
  final int remSleepMinutes;
  final int awakeMinutes;
  final DateTime? bedtime;
  final DateTime? wakeTime;

  const SleepSummary({
    required this.date,
    required this.totalMinutes,
    required this.lightSleepMinutes,
    required this.deepSleepMinutes,
    required this.remSleepMinutes,
    required this.awakeMinutes,
    this.bedtime,
    this.wakeTime,
  });
}

// Données de démonstration
extension HealthDataDemo on HealthData {
  static HealthData demo(String patientId) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    return HealthData(
      patientId: patientId,
      timestamp: now,
      heartRate: HeartRateData(
        bpm: 72,
        vfc: 45,
        minBpm: 65,
        maxBpm: 125,
        last24h: List.generate(24, (i) {
          return HeartRateMeasurement(
            timestamp: now.subtract(Duration(hours: 23 - i)),
            bpm: 65 + (i % 10) + (i * 0.2).round(),
          );
        }),
        last7d: List.generate(7, (i) {
          return HeartRateMeasurement(
            timestamp: now.subtract(Duration(days: 6 - i)),
            bpm: 68 + (i * 2) + (i % 3),
          );
        }),
      ),
      mood: MoodData(
        mood: 'Calme',
        notes: 'Le patient semble détendu aujourd\'hui',
        timestamp: now,
        last7d: [
          MoodEntry(mood: 'Heureux', date: now.subtract(const Duration(days: 6))),
          MoodEntry(mood: 'Fatigué', date: now.subtract(const Duration(days: 5))),
          MoodEntry(mood: 'Stressé', date: now.subtract(const Duration(days: 4))),
          MoodEntry(mood: 'Calme', date: now.subtract(const Duration(days: 3))),
          MoodEntry(mood: 'Anxieux', date: now.subtract(const Duration(days: 2))),
          MoodEntry(mood: 'Heureux', date: now.subtract(const Duration(days: 1))),
          MoodEntry(mood: 'Calme', date: now),
        ],
      ),
      sleep: SleepData(
        startTime: yesterday.subtract(const Duration(hours: 8)),
        endTime: yesterday.add(const Duration(hours: 8)),
        totalMinutes: 7 * 60 + 30, // 7h30
        cycles: [
          SleepCycle(stage: SleepStage.light, durationMinutes: 30, startTime: yesterday.subtract(const Duration(hours: 8))),
          SleepCycle(stage: SleepStage.deep, durationMinutes: 90, startTime: yesterday.subtract(const Duration(hours: 7, minutes: 30))),
          SleepCycle(stage: SleepStage.rem, durationMinutes: 60, startTime: yesterday.subtract(const Duration(hours: 6))),
          SleepCycle(stage: SleepStage.light, durationMinutes: 30, startTime: yesterday.subtract(const Duration(hours: 5))),
          SleepCycle(stage: SleepStage.deep, durationMinutes: 90, startTime: yesterday.subtract(const Duration(hours: 4, minutes: 30))),
          SleepCycle(stage: SleepStage.rem, durationMinutes: 60, startTime: yesterday.subtract(const Duration(hours: 3))),
        ],
        lastNight: List.generate(480, (i) { // 8h de sommeil en minutes
          final time = yesterday.subtract(Duration(minutes: 479 - i));
          // Simulation de cycles de sommeil
          final cyclePos = i % 120; // 120 minutes par cycle
          SleepStage stage;
          if (cyclePos < 10) {
            stage = SleepStage.light;
          } else if (cyclePos < 40) {
            stage = SleepStage.deep;
          } else if (cyclePos < 70) {
            stage = SleepStage.rem;
          } else {
            stage = SleepStage.light;
          }
          return SleepDataPoint(timestamp: time, stage: stage);
        }),
        last7d: List.generate(7, (i) {
          final date = now.subtract(Duration(days: 6 - i));
          final total = 6 * 60 + 15 + (i * 15); // Entre 6h15 et 7h30
          return SleepSummary(
            date: date,
            totalMinutes: total,
            lightSleepMinutes: (total * 0.5).round(),
            deepSleepMinutes: (total * 0.25).round(),
            remSleepMinutes: (total * 0.2).round(),
            awakeMinutes: (total * 0.05).round(),
            bedtime: date.subtract(const Duration(hours: 8)),
            wakeTime: date.add(const Duration(hours: 8)),
          );
        }),
      ),
    );
  }
}
