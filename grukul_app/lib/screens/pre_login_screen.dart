import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mcq_learning_app/apis/constants.dart';
import 'dart:convert';

import 'package:mcq_learning_app/screens/login_screen.dart';
import 'package:mcq_learning_app/shared_preferences/tenant_config.dart';

class PreLoginScreen extends StatefulWidget {
  final String title;
  const PreLoginScreen({super.key, required this.title});

  @override
  State<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  List<String> schools = [];
  String? selectedSchool;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchSchools();
  }

  Future<void> fetchSchools() async {
    try {
      final response = await http.get(
        Uri.parse("${await ApiConstants.getApiBaseUrl()}/api/v1/schools"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          schools = data.map((school) => school['name'].toString()).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch schools')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 10),
        ),
      );
    }
  }

  Future<void> _fetchTenantConfig(String? schoolName) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${await ApiConstants.getApiBaseUrl()}/api/v1/schools/name/$schoolName'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final TenantConfig config = TenantConfig.fromJson(jsonResponse);
        await saveTenantConfig(config);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginScreen(tenantConfig: config),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School not found. Try again!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
            colors: [Colors.blue.shade800, Colors.purple.shade600],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to MCQ Learning',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  const CircularProgressIndicator(color: Colors.white)
                else
                  DropdownButtonFormField<String>(
                    value: selectedSchool,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: 'Select School',
                      prefixIcon: const Icon(Icons.school),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: schools.map((school) {
                      return DropdownMenuItem(
                        value: school,
                        child: Text(school),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSchool = value;
                      });
                    },
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _fetchTenantConfig(selectedSchool),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
