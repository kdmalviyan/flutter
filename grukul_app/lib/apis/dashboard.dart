import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mcq_learning_app/apis/api-constants.dart';

class DashboardApi {
  static Future<Map<String, dynamic>> getLearningStats(String token) async {
    final response = await http.get(
      Uri.parse(
          '${await ApiConstants.getApiBaseUrl()}/api/v1/student/dashboard/learning-stats'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load learning stats');
    }
  }

  // Fetch Progress Over Time
  static Future<List<dynamic>> getProgressOverTime(String token) async {
    final response = await http.get(
      Uri.parse(
          '${await ApiConstants.getApiBaseUrl()}/api/v1/student/dashboard/progress-over-time'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load progress over time');
    }
  }

  // Fetch Last 10 Quizzes
  static Future<List<dynamic>> getLast10Quizzes(String token) async {
    final response = await http.get(
      Uri.parse(
          '${await ApiConstants.getApiBaseUrl()}/api/v1/student/dashboard/last-n-quizzes/10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load last 10 quizzes');
    }
  }

  static Future<List<Map<String, dynamic>>> getLeaderboardData(
    String token, {
    required int page,
    required int limit,
    String searchQuery = '',
    String sortBy = 'averageScore',
  }) async {
    final response = await http.get(
      Uri.parse(
          '${await ApiConstants.getApiBaseUrl()}/api/v1/student/dashboard/leaderboard?page=$page&limit=$limit&searchQuery=$searchQuery&sortBy=$sortBy'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load leaderboard data');
    }
  }

  static Future<Map<String, dynamic>> getQuizzes(
    String token, {
    String? classFilter,
    String? subjectFilter,
    String? levelFilter,
    String? searchQuery,
    String? sortBy,
    int page = 0,
    int limit = 10,
  }) async {
    print(classFilter);
    print(subjectFilter);
    print(levelFilter);
    print(searchQuery);
    final response = await http.get(
      Uri.parse('${await ApiConstants.getApiBaseUrl()}/api/v1/quizzes/random?'
          'classFilter=$classFilter'
          '&subjectFilter=$subjectFilter'
          '&levelFilter=$levelFilter'
          '&searchQuery=$searchQuery'
          '&sortBy=$sortBy'
          '&page=$page'
          '&limit=$limit'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load quizzes');
    }
  }
}
