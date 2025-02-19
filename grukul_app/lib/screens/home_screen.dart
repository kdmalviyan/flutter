import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mcq_learning_app/apis/dashboard.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double> scores = [];
  List<String> leaderboardData = [];
  bool isLoading = true;
  Map<String, dynamic> learningStats = {};
  List<Map<String, dynamic>> quizzes = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch learning stats
      final stats = await DashboardApi.getLearningStats(widget.token);
      final progress = await DashboardApi.getProgressOverTime(widget.token);
      final quizzesData = await DashboardApi.getLast10Quizzes(widget.token);

      setState(() {
        learningStats = stats;
        scores = progress.map<double>((e) => e['score'].toDouble()).toList();
        quizzes = quizzesData.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = scores.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: _buildHomeContent(spots),
    );
  }

  Widget _buildHomeContent(List<FlSpot> spots) {
    final theme = Theme.of(context); // Access the theme

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientStart, // Use custom gradient start color
            AppColors.gradientEnd, // Use custom gradient end color
          ],
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Welcome Back, Student!',
                style: theme.textTheme.displayLarge, // Use theme text style
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildQuickAccessButton(
                    icon: Icons.quiz,
                    label: 'Quizzes',
                    onPressed: () {
                      // Navigate to Quizzes Screen
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildQuickAccessButton(
                    icon: Icons.library_books,
                    label: 'Study Materials',
                    onPressed: () {
                      // Navigate to Study Materials Screen
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Your Learning Stats',
                style: theme.textTheme.displayLarge, // Use theme text style
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildStatCard(
                      'Total Quizzes',
                      learningStats['totalQuizzes'].toString(),
                      AppColors.statCardBlue),
                  const SizedBox(width: 10),
                  _buildStatCard(
                      'Correct Answers',
                      learningStats['correctAnswers'].toString(),
                      AppColors.statCardGreen),
                  const SizedBox(width: 10),
                  _buildStatCard(
                      'Average Score',
                      '${learningStats['averageScore']}%',
                      AppColors.statCardOrange),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white
                      .withOpacity(0.2), // Use custom white color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Over Time',
                      style:
                          theme.textTheme.displayLarge, // Use theme text style
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                              ),
                            ),
                          ],
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    'Day ${value.toInt() + 1}',
                                    style: theme.textTheme
                                        .bodySmall, // Use theme text style
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: theme.textTheme
                                        .bodySmall, // Use theme text style
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 1,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: AppColors.white
                                    .withOpacity(0.1), // Use custom white color
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: AppColors.white
                                    .withOpacity(0.1), // Use custom white color
                                strokeWidth: 1,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white
                      .withOpacity(0.2), // Use custom white color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Quizzes',
                      style:
                          theme.textTheme.displayLarge, // Use theme text style
                    ),
                    const SizedBox(height: 10),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: quizzes.length,
                            separatorBuilder: (context, index) => Divider(
                                color: AppColors.white.withOpacity(
                                    0.5)), // Use custom white color
                            itemBuilder: (context, index) {
                              final quiz = quizzes[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors
                                      .blueShade200, // Use custom blue color
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(
                                  quiz['title'],
                                  style: theme.textTheme
                                      .bodyLarge, // Use theme text style
                                ),
                                subtitle: Text(
                                  'Score: ${quiz['score']}%',
                                  style: theme.textTheme
                                      .bodyMedium, // Use theme text style
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2), // Use custom white color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 40, color: AppColors.white), // Use custom white color
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white, // Use custom white color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        color: color.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white), // Use custom white color
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white, // Use custom white color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
