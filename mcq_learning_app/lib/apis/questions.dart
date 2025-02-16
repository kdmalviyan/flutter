import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<MCQ>> fetchMCQs(String apiEndpoint) async {
  final response = await http.get(Uri.parse('$apiEndpoint/mcqs'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((mcq) => MCQ.fromJson(mcq)).toList();
  } else {
    throw Exception('Failed to load MCQs');
  }
}

class MCQ {
  final String question;
  final List<String> options;
  final String correctAnswer;

  MCQ(
      {required this.question,
      required this.options,
      required this.correctAnswer});

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }
}
