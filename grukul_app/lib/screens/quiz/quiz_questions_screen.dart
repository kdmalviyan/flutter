import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mcq_learning_app/helper/app_colors.dart';
import 'package:mcq_learning_app/helper/app_theme.dart';
import 'package:mcq_learning_app/helper/quiz.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/free_form_answer_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/mcq_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/multiple_choice_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/scale_answer_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/true_false_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/quiz_results_screen.dart';

class QuizQuestionsScreen extends StatefulWidget {
  final String token;
  final Quiz quiz;

  const QuizQuestionsScreen({
    Key? key,
    required this.token,
    required this.quiz,
  }) : super(key: key);

  @override
  _QuizQuestionsScreenState createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _questions = [];
  int _score = 0;
  List<dynamic> _selectedAnswers =
      []; // Store selected answers for each question
  int _timeRemaining = 1800; // 30 minutes in seconds (global timer)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.quiz.duration * 60 ?? 1800; // Default to 30 minutes
    _initializeQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  QuestionType _getQuestionTypeFromString(String type) {
    switch (type) {
      case "MCQ":
        return QuestionType.MCQ;
      case "TRUE_FALSE":
        return QuestionType.TRUE_FALSE;
      case "MULTIPLE_CHOICE":
        return QuestionType.MULTIPLE_CHOICE;
      case "SCALE_ANSWER":
        return QuestionType.SCALE_ANSWER;
      case "FREE_FORM_ANSWER":
        return QuestionType.FREE_FORM_ANSWER;
      default:
        throw ArgumentError("Unknown question type: $type");
    }
  }

  void _initializeQuestions() {
    if (mounted) {
      setState(() {
        _questions = widget.quiz.questions.map((question) {
          return {
            'question': question['question'] ?? 'No question provided',
            'options':
                (question['options'] as List<dynamic>?)?.cast<String>() ?? [],
            'correctAnswer':
                (question['correctAnswer'] as List<dynamic>?)?.cast<String>() ??
                    [],
            'type':
                _getQuestionTypeFromString(question['questionType'] ?? 'MCQ'),
            'details': question['details'] ?? {},
            'difficulty': question['difficulty'] ?? 'UNKNOWN',
          };
        }).toList();
        // Initialize selected answers list
        _selectedAnswers = List.filled(_questions.length, null);
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_timeRemaining > 0) {
        if (mounted) {
          setState(() {
            _timeRemaining--;
          });
        }
      } else {
        // Timer expired, auto-submit the quiz
        timer.cancel(); // Stop the timer
        await _submitResponses(); // Submit responses
        if (mounted) {
          _showResults(); // Navigate to results screen
        }
      }
    });
  }

  void _handleAnswer(String? selectedAnswer) {
    if (!mounted) return;

    setState(() {
      final currentQuestion = _questions[_currentQuestionIndex];
      final questionType = currentQuestion['type'] as QuestionType;

      if (questionType == QuestionType.MULTIPLE_CHOICE) {
        // For multiple-choice questions, handle multiple selections
        List<String> selectedAnswers =
            (_selectedAnswers[_currentQuestionIndex] as List<String>?) ?? [];
        if (selectedAnswers.contains(selectedAnswer)) {
          // If already selected, remove it
          selectedAnswers.remove(selectedAnswer);
        } else {
          // If not selected, add it
          selectedAnswers.add(selectedAnswer!);
        }
        _selectedAnswers[_currentQuestionIndex] = selectedAnswers;
      } else {
        // For other question types, store a single answer
        _selectedAnswers[_currentQuestionIndex] = selectedAnswer;
      }
    });
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // If it's the last question, submit the quiz
      _submitResponses().then((_) {
        if (mounted) {
          _showResults();
        }
      });
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitResponses() async {
    final url = Uri.parse('https://your-backend-api.com/submit-responses');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'quizId': widget.quiz.id,
          'responses': _selectedAnswers
              .asMap()
              .entries
              .map((entry) => {
                    'question': _questions[entry.key]['question'],
                    'selectedAnswer': entry.value,
                    'correctAnswer': _questions[entry.key]['correctAnswer'],
                  })
              .toList(),
        }),
      );

      if (response.statusCode != 200) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit responses. Please try again.'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please check your connection.'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  void _showResults() {
    if (!mounted) return; // Ensure the widget is still mounted
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          token: widget.token,
          quiz: widget.quiz,
          questions: _questions,
          score: _score,
          userResponses: _selectedAnswers
              .asMap()
              .entries
              .map((entry) => {
                    'question': _questions[entry.key]['question'],
                    'selectedAnswer': entry.value,
                    'correctAnswer': _questions[entry.key]['correctAnswer'],
                  })
              .toList(),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(Map<String, dynamic> question) {
    final questionType = question['type'] as QuestionType;

    switch (questionType) {
      case QuestionType.MCQ:
        return MCQQuestionWidget(
          question: question,
          onAnswerSelected: _handleAnswer,
          selectedAnswer:
              _selectedAnswers[_currentQuestionIndex], // Load selected answer
        );
      case QuestionType.TRUE_FALSE:
        return TrueFalseQuestionWidget(
          question: question,
          onAnswerSelected: _handleAnswer,
          selectedAnswer:
              _selectedAnswers[_currentQuestionIndex], // Load selected answer
        );
      case QuestionType.MULTIPLE_CHOICE:
        return MultipleChoiceQuestionWidget(
          question: question,
          onAnswerSelected: _handleAnswer,
          selectedAnswers: _selectedAnswers[_currentQuestionIndex]
              as List<String>?, // Pass selected answers
        );
      case QuestionType.SCALE_ANSWER:
        return ScaleAnswerQuestionWidget(
          question: question,
          onAnswerSelected: _handleAnswer,
          selectedAnswer:
              _selectedAnswers[_currentQuestionIndex], // Load selected answer
        );
      case QuestionType.FREE_FORM_ANSWER:
        return FreeFormAnswerQuestionWidget(
          question: question,
          onAnswerSelected: _handleAnswer,
          selectedAnswer:
              _selectedAnswers[_currentQuestionIndex], // Load selected answer
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${_currentQuestionIndex + 1}/${_questions.length}',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Global Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.timer, color: AppColors.white),
                  const SizedBox(width: 5),
                  Text(
                    '${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Display difficulty (if available)
              if (currentQuestion['difficulty'] != null)
                Text(
                  'Difficulty: ${currentQuestion['difficulty']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(height: 10),

              // Question Text
              Text(
                currentQuestion['question'],
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),

              // Render the appropriate question widget
              Expanded(
                child: _buildQuestionWidget(currentQuestion),
              ),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  ElevatedButton(
                    onPressed: _currentQuestionIndex > 0
                        ? _goToPreviousQuestion
                        : null, // Disable on first question
                    child: const Text('Previous'),
                  ),

                  // Next Button
                  ElevatedButton(
                    onPressed: _goToNextQuestion,
                    child: Text(
                      _currentQuestionIndex < _questions.length - 1
                          ? 'Next'
                          : 'Submit',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
