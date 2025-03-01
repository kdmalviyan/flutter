import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mcq_learning_app/apis/api-constants.dart';

class QuizzesApis {
  static Future submitQuizAnswers(
    String token,
    String quizzId,
    List<dynamic> selectedAnswers,
    List<dynamic> questions,
  ) async {
    final url = Uri.parse(
        '${await ApiConstants.getApiBaseUrl()}/api/v1/quizzes/submit-answers');
    final requestBody = {
      'quizId': quizzId,
      'responses': selectedAnswers.asMap().entries.map((entry) {
        final question = questions[entry.key];
        return {
          'questionId': question['id'],
          'selectedAnswers': entry.value is List ? entry.value : [entry.value],
        };
      }).toList(),
    };

    print('Request Body: ${jsonEncode(requestBody)}');

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );
  }
}
