import 'package:flutter/material.dart';
import 'package:mcq_learning_app/screens/pre_login_screen.dart';
import 'package:mcq_learning_app/screens/student_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mcq_learning_app/helper/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCQ',
      theme: AppTheme.lightTheme, // Use the custom light theme
      darkTheme: AppTheme.darkTheme, // Use the custom dark theme (optional)
      home: token == null
          ? const PreLoginScreen(title: 'MCQ Home Page')
          : StudentDashboardScreen(token: token!),
    );
  }
}
