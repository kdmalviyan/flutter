import 'package:flutter/material.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';
import 'package:mcq_learning_app/helper/app_theme.dart';

class QuestionsReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;

  const QuestionsReviewScreen({
    Key? key,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questions Review',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppColors.gradientStart,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final correctAnswer = question['correctAnswer'];
              final selectedAnswer = question['selectedAnswer'];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Text(
                    'Question ${index + 1}: ${question['question']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...(question['options'] as List<String>)
                              .map((option) {
                            final isCorrect = option == correctAnswer;
                            final isSelected = option == selectedAnswer;

                            return ListTile(
                              leading: Icon(
                                isCorrect
                                    ? Icons.check_circle
                                    : (isSelected
                                        ? Icons.cancel
                                        : Icons.circle),
                                color: isCorrect
                                    ? AppColors.successColor
                                    : (isSelected
                                        ? AppColors.errorColor
                                        : AppColors.lightGrey),
                              ),
                              title: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isCorrect
                                      ? AppColors.successColor
                                      : (isSelected
                                          ? AppColors.errorColor
                                          : AppColors.darkGrey),
                                  fontWeight: isCorrect || isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: isCorrect
                                  ? const Text(
                                      'Correct Answer',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.successColor,
                                      ),
                                    )
                                  : null,
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
