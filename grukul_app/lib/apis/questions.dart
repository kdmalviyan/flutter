import 'package:http/http.dart' as http;
import 'dart:convert';

enum Difficulty { EASY, MEDIUM, HARD }

enum QuestionType {
  MCQ,
  TRUE_FALSE,
  MULTIPLE_CHOICE,
  SCALE_ANSWER,
  FREE_FORM_ANSWER
}

class Question {
  final String id;
  final String className;
  final String subject;
  final String chapter;
  final String topic;
  final String question;
  final QuestionType questionType;
  final Difficulty difficulty;
  final Map<String, dynamic> details;
  final List<String> options;
  final List<String> correctAnswer;
  final String? answerHint;
  final String? answer;
  final int scaleMin;
  final int scaleMax;

  Question({
    required this.id,
    required this.className,
    required this.subject,
    required this.chapter,
    required this.topic,
    required this.question,
    required this.questionType,
    required this.difficulty,
    required this.details,
    required this.options,
    required this.correctAnswer,
    this.answerHint,
    this.answer,
    this.scaleMin = 0,
    this.scaleMax = 0,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      className: json['className'],
      subject: json['subject'],
      chapter: json['chapter'],
      topic: json['topic'],
      question: json['question'],
      questionType: parseQuestionType(json['questionType']),
      difficulty: _parseDifficulty(json['difficulty']),
      details: json['details'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: List<String>.from(json['correctAnswer'] ?? []),
      answerHint: json['answerHint'],
      answer: json['answer'],
      scaleMin: json['scaleMin'] ?? 0,
      scaleMax: json['scaleMax'] ?? 0,
    );
  }

  static QuestionType parseQuestionType(String type) {
    switch (type) {
      case 'MCQ':
        return QuestionType.MCQ;
      case 'TRUE_FALSE':
        return QuestionType.TRUE_FALSE;
      case 'FREE_FORM_ANSWER':
        return QuestionType.FREE_FORM_ANSWER;
      case 'SCALE_ANSWER':
        return QuestionType.SCALE_ANSWER;
      case 'MULTIPLE_CHOICE':
        return QuestionType.MULTIPLE_CHOICE;
      default:
        throw ArgumentError('Unknown question type: $type');
    }
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
