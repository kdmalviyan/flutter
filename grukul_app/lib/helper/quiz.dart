enum Difficulty { EASY, MEDIUM, HARD }

enum QuestionType { MCQ, TRUE_FALSE, FREE_FORM_ANSWER, SCALE_ANSWER }

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
      questionType: _parseQuestionType(json['questionType']),
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

  static QuestionType _parseQuestionType(String type) {
    switch (type) {
      case 'MCQ':
        return QuestionType.MCQ;
      case 'TRUE_FALSE':
        return QuestionType.TRUE_FALSE;
      case 'FREE_FORM_ANSWER':
        return QuestionType.FREE_FORM_ANSWER;
      case 'SCALE_ANSWER':
        return QuestionType.SCALE_ANSWER;
      default:
        throw ArgumentError('Invalid question type: $type');
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
