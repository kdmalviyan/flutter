import 'package:flutter/material.dart';

class ScaleAnswerQuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String?)? onAnswerSelected;
  final String? selectedAnswer;

  const ScaleAnswerQuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    required this.selectedAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaleMin = question['scaleMin'] ?? 1;
    final scaleMax = question['scaleMax'] ?? 10;

    // Parse the selected answer to a double (or use the midpoint if no answer is selected)
    final currentValue = selectedAnswer != null
        ? double.parse(selectedAnswer!)
        : (scaleMin + scaleMax) / 2;

    return Column(
      children: [
        // Display scale slider
        Slider(
          value: currentValue,
          min: scaleMin.toDouble(),
          max: scaleMax.toDouble(),
          divisions: scaleMax - scaleMin,
          label: currentValue.toString(),
          onChanged: onAnswerSelected != null
              ? (value) {
                  // Update the selected value
                  onAnswerSelected!(value.toString());
                }
              : null,
        ),
        // Display the selected value
        Text(
          'Selected Value: ${currentValue.toStringAsFixed(1)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
