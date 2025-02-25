import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mcq_learning_app/apis/api-constants.dart';
import 'package:mcq_learning_app/screens/student_dashboard.dart';
import 'dart:convert';
import 'package:mcq_learning_app/shared_preferences/tenant_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';

class LoginScreen extends StatefulWidget {
  final TenantConfig tenantConfig;

  const LoginScreen({super.key, required this.tenantConfig});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late TenantConfig tenantConfig;
  late String schoolCode;

  @override
  void initState() {
    super.initState();
    tenantConfig = widget.tenantConfig;
    schoolCode = tenantConfig.schoolCode;
  }

  Future<void> _handleLogin() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both username and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '${await ApiConstants.getApiBaseUrl()}/api/v1/authentication/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['token'];

        await saveToken(token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDashboardScreen(token: token),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: ClipOval(
                      child: Image.network(
                        'https://example.com/images/$schoolCode.png',
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'images/school_default_logo.png',
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Login to ${widget.tenantConfig.name}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: AppColors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: AppColors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.statCardOrange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style:
                                TextStyle(fontSize: 18, color: AppColors.white),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }
}
