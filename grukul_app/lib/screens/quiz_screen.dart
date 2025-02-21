import 'package:flutter/material.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';
import 'package:mcq_learning_app/helper/quiz.dart';

class QuizScreen extends StatelessWidget {
  final String token;
  final Quiz quiz;
  const QuizScreen({Key? key, required this.token, required this.quiz})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        backgroundColor: AppColors.gradientStart,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject: ${quiz.subject}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Class: ${quiz.className ?? 'N/A'}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Difficulty: ${quiz.difficulty}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Duration: ${quiz.duration} minutes',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Questions: ${quiz.questionCount}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Average Score: ${quiz.averageScore}%',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
