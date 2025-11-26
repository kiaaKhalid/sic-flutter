import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

class SleepHeartRateScreen extends StatefulWidget {
  static const String routeName = '/sleep-heart-rate';
  
  const SleepHeartRateScreen({super.key});

  @override
  State<SleepHeartRateScreen> createState() => _SleepHeartRateScreenState();
}

class _SleepHeartRateScreenState extends State<SleepHeartRateScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 0; // 0: 24h, 1: 7j, 2: 30j
  bool _isLoading = true;
  
  // Données factices pour les graphiques
  final List<SleepData> _sleepData24h = [
    SleepData('00:00', 6.5, 75),
    SleepData('04:00', 7.0, 72),
    SleepData('08:00', 6.8, 70),
    SleepData('12:00', 6.2, 78),
    SleepData('16:00', 6.0, 80),
    SleepData('20:00', 6.8, 72),
  ];
  
  final List<SleepData> _sleepData7d = [
    SleepData('Lun', 6.5, 74),
    SleepData('Mar', 7.1, 72),
    SleepData('Mer', 6.8, 73),
    SleepData('Jeu', 7.2, 71),
    SleepData('Ven', 6.9, 70),
    SleepData('Sam', 7.5, 69),
    SleepData('Dim', 8.0, 68),
  ];
  
  final List<SleepData> _sleepData30d = [
    SleepData('Sem 1', 6.8, 73),
    SleepData('Sem 2', 7.0, 72),
    SleepData('Sem 3', 7.2, 71),
    SleepData('Sem 4', 7.0, 70),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Simuler un chargement
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Détails Sommeil & Rythme'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.nightlight_round), text: 'Sommeil'),
            Tab(icon: Icon(Icons.favorite), text: 'Rythme Cardiaque'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSleepTab(),
                _buildHeartRateTab(),
              ],
            ),
    );
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _PeriodButton(
            label: '24h', 
            isSelected: _selectedPeriod == 0,
            onTap: () => _updateSelectedPeriod(0),
          ),
          _PeriodButton(
            label: '7j', 
            isSelected: _selectedPeriod == 1,
            onTap: () => _updateSelectedPeriod(1),
          ),
          _PeriodButton(
            label: '30j', 
            isSelected: _selectedPeriod == 2,
            onTap: () => _updateSelectedPeriod(2),
          ),
        ],
      ),
    );
  }

  void _updateSelectedPeriod(int index) {
    setState(() {
      _selectedPeriod = index;
    });
  }

  Widget _buildSleepTab() {
    final data = _getCurrentData();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSleepSummary(),
          const SizedBox(height: 24),
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: _buildSleepChart(data),
          ),
          const SizedBox(height: 24),
          _buildSleepTips(),
        ],
      ),
    );
  }

  Widget _buildHeartRateTab() {
    final data = _getCurrentData();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeartRateSummary(),
          const SizedBox(height: 24),
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: _buildHeartRateChart(data),
          ),
          const SizedBox(height: 24),
          _buildHeartRateInfo(),
        ],
      ),
    );
  }

  Widget _buildSleepSummary() {
    final avgSleep = _calculateAverageSleep();
    
    return Card(
      color: AppTheme.card,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Sommeil Moyen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${avgSleep.toStringAsFixed(1)} heures',
              style: const TextStyle(
                color: AppTheme.neon,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildSleepQualityIndicator(avgSleep),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateSummary() {
    final avgBpm = _calculateAverageHeartRate();
    
    return Card(
      color: AppTheme.card,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Rythme Cardiaque Moyen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${avgBpm.round()} BPM',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildHeartRateStatus(avgBpm),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepQualityIndicator(double hours) {
    String status;
    Color color;
    
    if (hours >= 7) {
      status = 'Excellent';
      color = Colors.green;
    } else if (hours >= 6) {
      status = 'Bon';
      color = Colors.lightGreen;
    } else if (hours >= 5) {
      status = 'Moyen';
      color = Colors.orange;
    } else {
      status = 'Insuffisant';
      color = Colors.red;
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildHeartRateStatus(double bpm) {
    String status;
    Color color;
    
    if (bpm < 60) {
      status = 'Lent';
      color = Colors.blue;
    } else if (bpm < 100) {
      status = 'Normal';
      color = Colors.green;
    } else {
      status = 'Élevé';
      color = Colors.red;
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepChart(List<SleepData> data) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10, // Heures de sommeil max
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[index].time,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}h',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List<BarChartGroupData>.generate(
            data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data[index].sleepHours,
                  color: AppTheme.neon,
                  width: 16,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeartRateChart(List<SleepData> data) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 60,
          maxY: 100,
          lineTouchData: const LineTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[index].time,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}bpm',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (index) => FlSpot(
                  index.toDouble(),
                  data[index].heartRate.toDouble(),
                ),
              ),
              isCurved: true,
              color: Colors.red,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withAlpha(70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepTips() {
    return const Card(
      color: AppTheme.card,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conseils pour un meilleur sommeil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _TipItem(text: '• Établissez une routine de coucher régulière'),
            _TipItem(text: '• Évitez les écrans 1h avant de dormir'),
            _TipItem(text: '• Maintenez une température fraîche dans la chambre'),
            _TipItem(text: '• Limitez la caféine après 14h'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateInfo() {
    return const Card(
      color: AppTheme.card,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'À propos du rythme cardiaque',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Un rythme cardiaque au repos normal se situe entre 60 et 100 BPM. Les athlètes peuvent avoir un rythme plus bas, généralement entre 40 et 60 BPM.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SleepData> _getCurrentData() {
    switch (_selectedPeriod) {
      case 0:
        return _sleepData24h;
      case 1:
        return _sleepData7d;
      case 2:
        return _sleepData30d;
      default:
        return _sleepData24h;
    }
  }

  double _calculateAverageSleep() {
    final data = _getCurrentData();
    if (data.isEmpty) return 0;
    return data.map((e) => e.sleepHours).reduce((a, b) => a + b) / data.length;
  }

  double _calculateAverageHeartRate() {
    final data = _getCurrentData();
    if (data.isEmpty) return 0;
    return data.map((e) => e.heartRate).reduce((a, b) => a + b).toDouble() / data.length;
  }
}

class SleepData {
  final String time;
  final double sleepHours;
  final int heartRate;

  SleepData(this.time, this.sleepHours, this.heartRate);
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.neon.withAlpha(51) : Colors.transparent, // 0.2 * 255 ≈ 51
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.neon : Colors.grey.shade700,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.neon : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }
}
