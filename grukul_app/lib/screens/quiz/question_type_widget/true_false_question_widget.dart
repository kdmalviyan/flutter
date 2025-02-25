import 'package:flutter/material.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';

class TrueFalseQuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String?)? onAnswerSelected;
  final int timeRemaining;
  final String? selectedAnswer;

  const TrueFalseQuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    required this.timeRemaining,
    required this.selectedAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display True/False buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: onAnswerSelected != null && selectedAnswer == null
                  ? () => onAnswerSelected!('True')
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedAnswer == 'True'
                    ? AppColors.primaryColor
                    : AppColors.white,
              ),
              child: Text(
                'True',
                style: TextStyle(
                  color: selectedAnswer == 'True' ? Colors.white : Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onAnswerSelected != null && selectedAnswer == null
                  ? () => onAnswerSelected!('False')
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedAnswer == 'False'
                    ? AppColors.primaryColor
                    : AppColors.white,
              ),
              child: Text(
                'False',
                style: TextStyle(
                  color:
                      selectedAnswer == 'False' ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
