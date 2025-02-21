class Quiz {
  final String id;
  final String title;
  final String subject;
  final String className;
  final int duration;
  final int questionCount;
  final String difficulty;
  final double averageScore;
  final int participants;
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
    required this.createdAt,
  });

  // Optional: Add a factory constructor to parse JSON data
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      className: json['className'],
      duration: json['duration'],
      questionCount: json['questionCount'],
      difficulty: json['difficulty'],
      averageScore: json['averageScore'],
      participants: json['participants'],
      createdAt: json['createdAt'],
    );
  }
}
