import 'package:flutter/material.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';
import 'package:mcq_learning_app/apis/quiz.dart';
import 'package:mcq_learning_app/screens/quiz/quiz_rules_guidelines_screen.dart';

class QuizScreen extends StatelessWidget {
  final String token;
  final Quiz quiz;
  const QuizScreen({Key? key, required this.token, required this.quiz})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quiz.title,
          style: const TextStyle(
              color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.gradientStart,
        elevation: 0,
        iconTheme:
            const IconThemeData(color: AppColors.white), // Back button color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quiz Title
              Text(
                quiz.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Quiz Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject
                      _buildDetailRow(Icons.subject, 'Subject', quiz.subject),
                      const SizedBox(height: 10),

                      // Class
                      _buildDetailRow(
                          Icons.school, 'Class', quiz.className ?? 'N/A'),
                      const SizedBox(height: 10),

                      // Difficulty
                      _buildDetailRow(
                          Icons.bolt, 'Difficulty', quiz.difficulty.name),
                      const SizedBox(height: 10),

                      // Duration
                      _buildDetailRow(
                          Icons.timer, 'Duration', '${quiz.duration} minutes'),
                      const SizedBox(height: 10),

                      // Questions
                      _buildDetailRow(Icons.format_list_numbered, 'Questions',
                          '${quiz.questionCount}'),
                      const SizedBox(height: 10),

                      // Average Score
                      _buildDetailRow(Icons.bar_chart, 'Average Score',
                          '${quiz.averageScore}%'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Start Quiz Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RulesAndGuidelinesScreen(
                          token: token,
                          quiz: quiz,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a detail row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
