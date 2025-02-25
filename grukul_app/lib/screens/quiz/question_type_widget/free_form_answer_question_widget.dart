import 'package:flutter/material.dart';

class FreeFormAnswerQuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String?)? onAnswerSelected;
  final int timeRemaining;
  final String? selectedAnswer;

  const FreeFormAnswerQuestionWidget({
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
        // Display hint (if available)
        if (question['details']['answerHint'] != null)
          Text(
            'Hint: ${question['details']['answerHint']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        const SizedBox(height: 20),
        // Display text input field
        TextField(
          decoration: const InputDecoration(
            hintText: 'Enter your answer',
            border: OutlineInputBorder(),
          ),
          enabled: selectedAnswer == null, // Disable after submission
          onChanged: onAnswerSelected != null && selectedAnswer == null
              ? (value) => onAnswerSelected!(value)
              : null,
        ),
      ],
    );
  }
}
