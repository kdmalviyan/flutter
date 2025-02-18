import 'package:flutter/material.dart';
import 'package:mcq_learning_app/screens/pre_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';
import 'leaderboard_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  final String token;

  const StudentDashboardScreen({super.key, required this.token});

  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _selectedIndex = 0; // Initialize to 0 for Home tab
  final List<String> _appBarTitles = [
    'Home',
    'Quiz',
    'Leaderboard'
  ]; // App bar titles

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]), // Dynamic app bar title
        backgroundColor: const Color(0xFF1565C0), // Match the gradient color
        elevation: 0, // Remove shadow
      ),
      drawer: _buildDrawer(context), // Add the drawer
      body: _buildBody(), // Build the body based on the selected tab
      bottomNavigationBar:
          _buildBottomNavigationBar(), // Add bottom navigation bar
    );
  }

  // Function to build the drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xFF1565C0), // Equivalent to Colors.blue.shade800
              Color(0xFF6A1B9A), // Equivalent to Colors.purple.shade600
            ])),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xFF1565C0), // Equivalent to Colors.blue.shade800
                    Color(0xFF6A1B9A), // Equivalent to Colors.purple.shade600
                  ])),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Profile Screen
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Settings Screen
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text(
                'Notification Preferences',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Notification Preferences Screen
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1565C0), // Equivalent to Colors.blue.shade800
            Color(0xFF6A1B9A), // Equivalent to Colors.purple.shade600
          ],
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set current index
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent, // Make the background transparent
        selectedItemColor: Colors.white, // Selected icon and label color
        unselectedItemColor: Colors.white70, // Unselected icon and label color
        elevation: 0, // Remove shadow
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
        ],
      ),
    );
  }

  // Function to handle bottom navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  // Function to build the body based on the selected tab
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: // Home Tab
        return HomeScreen(
          scores: [3, 5, 4, 7, 6],
          leaderboardData: List.generate(5, (index) => 'Student ${index + 1}'),
          isLoading: false,
          onRefresh: () async {
            // Handle refresh logic
          },
        );
      case 1: // Quiz Tab
        return const QuizScreen();
      case 2: // Leaderboard Tab
        return const LeaderboardScreen();
      default:
        return Container();
    }
  }

  Future<void> _handleLogout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PreLoginScreen(
          title: "School",
        ),
      ),
    );
  }
}
