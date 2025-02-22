import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; // For confetti animation
import 'package:mcq_learning_app/helper/app_colors.dart';
import 'package:mcq_learning_app/helper/app_theme.dart';
import 'package:mcq_learning_app/helper/quiz.dart';
import 'package:mcq_learning_app/screens/quiz/quiz_questions_screen.dart'; // For retry quiz
import 'package:mcq_learning_app/screens/home_screen.dart'; // For back to home

class QuizResultsScreen extends StatefulWidget {
  final String token;
  final Quiz quiz;
  final List<Map<String, dynamic>> questions;
  final int score;

  const QuizResultsScreen({
    Key? key,
    required this.token,
    required this.quiz,
    required this.questions,
    required this.score,
  }) : super(key: key);

  @override
  _QuizResultsScreenState createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play(); // Start confetti animation

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Initialize fade animation
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Dispose the confetti controller
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  void _retryQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizQuestionsScreen(
          token: widget.token,
          quiz: widget.quiz,
        ),
      ),
    );
  }

  void _backToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(token: widget.token),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalQuestions = widget.questions.length;
    final int rank = 432; // Replace with actual rank logic
    final double percentage = (widget.score / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Results',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppColors.gradientStart,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ),
            ),
          ),

          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),

          // Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Score Summary
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      width: double.infinity, // Make it full width
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Your Score',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${widget.score} / $totalQuestions', // Fixed score display
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Rank $rank',
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Percentage: ${percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Congratulations Message
                  Text(
                    'Congratulations, you\'ve completed this quiz!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Let\'s keep testing your knowledge by playing more quizzes!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Explore More Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to explore more quizzes
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Explore More',
                      style: TextStyle(fontSize: 18, color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Retry Quiz Button
                  ElevatedButton(
                    onPressed: _retryQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Retry Quiz',
                      style: TextStyle(fontSize: 18, color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Back to Home Button
                  ElevatedButton(
                    onPressed: _backToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(fontSize: 18, color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
