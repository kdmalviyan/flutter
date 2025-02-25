import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';
import 'package:mcq_learning_app/helper/app_theme.dart';
import 'package:mcq_learning_app/helper/quiz.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/free_form_answer_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/multiple_choice_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/scale_answer_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/quiz_results_screen.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/mcq_question_widget.dart';
import 'package:mcq_learning_app/screens/quiz/question_type_widget/true_false_question_widget.dart';

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
  String? _selectedAnswer;
  int _timeRemaining = 30; // Configurable timer duration
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeRemaining =
        widget.quiz.duration ?? 30; // Default to 30 if not provided
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
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        _handleAnswer(null);
        _timer?.cancel();
      }
    });
  }

  void _handleAnswer(String? selectedAnswer) {
    if (!mounted) return;

    setState(() {
      _selectedAnswer = selectedAnswer;
    });

    final correctAnswers =
        _questions[_currentQuestionIndex]['correctAnswer'] as List<String>?;
    if (correctAnswers != null && correctAnswers.contains(selectedAnswer)) {
      if (mounted) {
        setState(() {
          _score++;
        });
      }
    }

    _showFeedback(
        correctAnswers != null && correctAnswers.contains(selectedAnswer));
  }

  void _showFeedback(bool isCorrect) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct! 🎉' : 'Incorrect! 😢'),
        backgroundColor:
            isCorrect ? AppColors.successColor : AppColors.errorColor,
        duration: const Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswer = null;
          _timeRemaining = widget.quiz.duration ?? 30;
          _startTimer();
        });
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          token: widget.token,
          quiz: widget.quiz,
          questions: _questions,
          score: _score,
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
          onAnswerSelected: _selectedAnswer == null ? _handleAnswer : null,
          timeRemaining: _timeRemaining,
          selectedAnswer: _selectedAnswer,
        );
      case QuestionType.TRUE_FALSE:
        return TrueFalseQuestionWidget(
          question: question,
          onAnswerSelected: _selectedAnswer == null ? _handleAnswer : null,
          timeRemaining: _timeRemaining,
          selectedAnswer: _selectedAnswer,
        );
      case QuestionType.MULTIPLE_CHOICE:
        return MultipleChoiceQuestionWidget(
          question: question,
          onAnswerSelected: _selectedAnswer == null ? _handleAnswer : null,
          timeRemaining: _timeRemaining,
          selectedAnswer: _selectedAnswer,
        );
      case QuestionType.SCALE_ANSWER:
        return ScaleAnswerQuestionWidget(
          question: question,
          onAnswerSelected: _selectedAnswer == null ? _handleAnswer : null,
          timeRemaining: _timeRemaining,
          selectedAnswer: _selectedAnswer,
        );
      case QuestionType.FREE_FORM_ANSWER:
        return FreeFormAnswerQuestionWidget(
          question: question,
          onAnswerSelected: _selectedAnswer == null ? _handleAnswer : null,
          timeRemaining: _timeRemaining,
          selectedAnswer: _selectedAnswer,
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
              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.timer, color: AppColors.white),
                  const SizedBox(width: 5),
                  Text(
                    '$_timeRemaining sec',
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
            ],
          ),
        ),
      ),
    );
  }
}
