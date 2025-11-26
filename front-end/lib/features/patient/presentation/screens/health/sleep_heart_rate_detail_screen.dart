import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:travel_auth_ui/theme/app_theme.dart';

class SleepHeartRateDetailScreen extends StatefulWidget {
  static const String routeName = '/sleep-heart-rate-detail';
  
  const SleepHeartRateDetailScreen({super.key});

  @override
  State<SleepHeartRateDetailScreen> createState() => _SleepHeartRateDetailScreenState();
}

class _SleepHeartRateDetailScreenState extends State<SleepHeartRateDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '24h';
  
  // Données de démonstration pour les graphiques
  final List<FlSpot> _sleepData24h = [
    const FlSpot(0, 7.5),
    const FlSpot(1, 6.8),
    const FlSpot(2, 7.2),
    const FlSpot(3, 7.0),
    const FlSpot(4, 7.8),
    const FlSpot(5, 8.0),
    const FlSpot(6, 7.5),
  ];

  final List<FlSpot> _heartRateData24h = [
    const FlSpot(0, 72),
    const FlSpot(1, 75),
    const FlSpot(2, 70),
    const FlSpot(3, 68),
    const FlSpot(4, 72),
    const FlSpot(5, 74),
    const FlSpot(6, 70),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Détails Sommeil & Rythme',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.neon,
          unselectedLabelColor: Colors.white54,
          indicatorColor: AppTheme.neon,
          tabs: const [
            Tab(text: 'Sommeil'),
            Tab(text: 'Rythme Cardiaque'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Sélecteur de période
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['24h', '7j', '30j'].map((period) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTimeRange = period;
                      // Ici, vous pourriez charger les données pour la période sélectionnée
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedTimeRange == period 
                          ? AppTheme.neon.withAlpha(50) 
                          : Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedTimeRange == period 
                            ? AppTheme.neon 
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      period,
                      style: TextStyle(
                        color: _selectedTimeRange == period 
                            ? AppTheme.neon 
                            : Colors.white70,
                        fontWeight: _selectedTimeRange == period 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Onglet Sommeil
                _buildSleepTab(),
                // Onglet Rythme Cardiaque
                _buildHeartRateTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphique de sommeil
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                        return Text(
                          days[value.toInt() % 7],
                          style: const TextStyle(color: Colors.white54, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: const TextStyle(color: Colors.white54, fontSize: 10),
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
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: _sleepData24h,
                    isCurved: true,
                    color: AppTheme.neon,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.neon.withAlpha(30),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Statistiques de sommeil
          const Text(
            'Statistiques de sommeil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Moyenne', '7.5h', Icons.nightlight_round),
              _buildStatCard('Qualité', '82%', Icons.star_border),
              _buildStatCard('Endormi', '11:30 PM', Icons.nightlight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphique de rythme cardiaque
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                        return Text(
                          days[value.toInt() % 7],
                          style: const TextStyle(color: Colors.white54, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} BPM',
                          style: const TextStyle(color: Colors.white54, fontSize: 10),
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
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 60,
                maxY: 90,
                lineBarsData: [
                  LineChartBarData(
                    spots: _heartRateData24h,
                    isCurved: true,
                    color: Colors.red[400],
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withAlpha(30),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Statistiques de rythme cardiaque
          const Text(
            'Statistiques cardiaques',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Moyenne', '72 BPM', Icons.favorite_border, color: Colors.red[400]!),
              _buildStatCard('Min', '65 BPM', Icons.arrow_downward, color: Colors.blue[400]!),
              _buildStatCard('Max', '85 BPM', Icons.arrow_upward, color: Colors.red[400]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {Color color = Colors.white}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
