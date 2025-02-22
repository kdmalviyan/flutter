import 'dart:async'; // Add this import
import 'package:flutter/material.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';
import 'package:mcq_learning_app/helper/app_theme.dart';
import 'package:mcq_learning_app/helper/quiz.dart';
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
  String? _selectedAnswer;
  int _timeRemaining = 12; // Example timer
  Timer? _timer; // Store the timer

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    // Simulate fetching questions from an API
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _questions = [
          {
            'question':
                'Which soccer team won the FIFA World Cup for the first time?',
            'options': ['Uruguay', 'Brazil', 'Italy', 'Germany'],
            'correctAnswer': 'Uruguay',
          },
          {
            'question': 'What is the capital of France?',
            'options': ['London', 'Paris', 'Berlin', 'Madrid'],
            'correctAnswer': 'Paris',
          },
          // Add more questions here
        ];
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        if (mounted) {
          setState(() {
            _timeRemaining--;
          });
        }
      } else {
        _handleAnswer(null); // Time's up
        _timer?.cancel(); // Stop the timer
      }
    });
  }

  void _handleAnswer(String? selectedAnswer) {
    if (mounted) {
      setState(() {
        _selectedAnswer = selectedAnswer;
      });
    }

    final correctAnswer = _questions[_currentQuestionIndex]['correctAnswer'];
    if (selectedAnswer == correctAnswer) {
      if (mounted) {
        setState(() {
          _score++;
        });
      }
    }

    // Show feedback before moving to the next question
    _showFeedback(selectedAnswer == correctAnswer);
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct! 🎉' : 'Incorrect! 😢'),
        backgroundColor:
            isCorrect ? AppColors.successColor : AppColors.errorColor,
        duration: const Duration(seconds: 1),
      ),
    );

    // Move to the next question after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (_currentQuestionIndex < _questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
            _selectedAnswer = null; // Reset selected answer
            _timeRemaining = 12; // Reset timer
          });
        } else {
          _showResults();
        }
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

              // Question Text
              Text(
                currentQuestion['question'],
                style: AppTheme.lightTheme.textTheme.displayLarge,
              ),
              const SizedBox(height: 20),

              // Options
              Expanded(
                child: ListView(
                  children: (currentQuestion['options'] as List<String>)
                      .map((option) {
                    final isSelected = _selectedAnswer == option;
                    final isCorrect =
                        option == currentQuestion['correctAnswer'];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: isSelected
                          ? (isCorrect
                              ? AppColors.successColor
                              : AppColors.errorColor)
                          : AppColors.white,
                      child: ListTile(
                        title: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.darkGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: _selectedAnswer == null
                            ? () => _handleAnswer(option)
                            : null, // Disable after selection
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
