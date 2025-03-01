import 'package:mcq_learning_app/apis/questions.dart';

class Quiz {
  final String id;
  final String title;
  final String subject;
  final String className;
  final int duration;
  final int questionCount;
  final Difficulty difficulty;
  final double averageScore;
  final int participants;
  final List<dynamic> questions;
  final String createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.subject,
    required this.className,
    required this.duration,
    required this.questionCount,
    required this.difficulty,
    required this.averageScore,
    required this.participants,
    required this.questions,
    required this.createdAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      className: json['className'],
      duration: json['duration'],
      questionCount: json['questionCount'],
      difficulty: _parseDifficulty(json['difficulty']),
      averageScore: json['averageScore'] ?? 0.0,
      participants: json['participants'] ?? 0,
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
      createdAt: json['createdAt'],
    );
  }

  static Difficulty _parseDifficulty(String difficulty) {
    switch (difficulty) {
      case 'EASY':
        return Difficulty.EASY;
      case 'MEDIUM':
        return Difficulty.MEDIUM;
      case 'HARD':
        return Difficulty.HARD;
      default:
        throw ArgumentError('Invalid difficulty: $difficulty');
    }
  }
}
