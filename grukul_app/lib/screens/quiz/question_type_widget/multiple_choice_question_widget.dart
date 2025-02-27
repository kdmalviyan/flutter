import 'package:flutter/material.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';

class MultipleChoiceQuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String?)? onAnswerSelected;
  final List<String>? selectedAnswers;

  const MultipleChoiceQuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    required this.selectedAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display options
        ...(question['options'] as List<String>).map((option) {
          final isSelected = selectedAnswers?.contains(option) ?? false;
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: isSelected ? AppColors.primaryColor : AppColors.white,
            child: ListTile(
              title: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              onTap: onAnswerSelected != null
                  ? () => onAnswerSelected!(option) // Allow re-selection
                  : null,
            ),
          );
        }).toList(),
      ],
    );
  }
}
