import 'package:flutter/material.dart';

class ScaleAnswerQuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String?)? onAnswerSelected;
  final int timeRemaining;
  final String? selectedAnswer;

  const ScaleAnswerQuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    required this.timeRemaining,
    required this.selectedAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaleMin = question['scaleMin'] ?? 1;
    final scaleMax = question['scaleMax'] ?? 10;

    return Column(
      children: [
        // Display scale slider
        Slider(
          value: selectedAnswer != null
              ? double.parse(selectedAnswer!)
              : (scaleMin + scaleMax) / 2,
          min: scaleMin.toDouble(),
          max: scaleMax.toDouble(),
          divisions: scaleMax - scaleMin,
          label: selectedAnswer ?? ((scaleMin + scaleMax) / 2).toString(),
          onChanged: onAnswerSelected != null && selectedAnswer == null
              ? (value) => onAnswerSelected!(value.toString())
              : null,
        ),
      ],
    );
  }
}
