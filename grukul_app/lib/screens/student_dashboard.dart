import 'package:flutter/material.dart';
import 'package:mcq_learning_app/screens/pre_login_screen.dart';
import 'package:mcq_learning_app/screens/quiz_listing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';

class StudentDashboardScreen extends StatefulWidget {
  final String token;

  const StudentDashboardScreen({super.key, required this.token});

  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _selectedIndex = 0;
  final List<String> _appBarTitles = ['Home', 'Quizzes', 'Leaderboard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex],
            style: const TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.gradientStart,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: AppColors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem(Icons.person, 'Profile', context),
            _buildDrawerItem(Icons.settings, 'Settings', context),
            _buildDrawerItem(
                Icons.notifications, 'Notification Preferences', context),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.white),
              title: const Text('Logout',
                  style: TextStyle(color: AppColors.white)),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.white),
      title: Text(title, style: const TextStyle(color: AppColors.white)),
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white70,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(token: widget.token);
      case 1:
        return QuizListingScreen(token: widget.token);
      case 2:
        return LeaderboardScreen(token: widget.token);
      default:
        return Container();
    }
  }

  Future<void> _handleLogout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PreLoginScreen(title: "School")),
    );
  }
}
