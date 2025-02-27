import 'package:flutter/material.dart';

class FreeFormAnswerQuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(String?)? onAnswerSelected;
  final String? selectedAnswer;

  const FreeFormAnswerQuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    required this.selectedAnswer,
  }) : super(key: key);

  @override
  _FreeFormAnswerQuestionWidgetState createState() =>
      _FreeFormAnswerQuestionWidgetState();
}

class _FreeFormAnswerQuestionWidgetState
    extends State<FreeFormAnswerQuestionWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the selected answer (if any)
    _controller.text = widget.selectedAnswer ?? '';
  }

  @override
  void didUpdateWidget(FreeFormAnswerQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller text if the selected answer changes
    if (widget.selectedAnswer != oldWidget.selectedAnswer) {
      _controller.text = widget.selectedAnswer ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display hint (if available)
        if (widget.question['details']['answerHint'] != null)
          Text(
            'Hint: ${widget.question['details']['answerHint']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        const SizedBox(height: 20),
        // Display text input field
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter your answer',
            border: OutlineInputBorder(),
          ),
          enabled: true, // Always enabled
        ),
        const SizedBox(height: 20),
        // Submit button
        ElevatedButton(
          onPressed: () {
            if (widget.onAnswerSelected != null) {
              widget.onAnswerSelected!(_controller.text);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
