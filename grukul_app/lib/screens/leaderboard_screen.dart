import 'package:flutter/material.dart';
import 'package:mcq_learning_app/apis/dashboard.dart';

class LeaderboardScreen extends StatefulWidget {
  final String token;

  const LeaderboardScreen({Key? key, required this.token}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;
  bool hasMore = true;
  int page = 1;
  final int limit = 20;
  String searchQuery = '';
  String sortBy = 'averageScore'; // Default sorting by average score

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  Future<void> _fetchLeaderboardData() async {
    try {
      final data = await DashboardApi.getLeaderboardData(
        widget.token,
        page: page,
        limit: limit,
        searchQuery: searchQuery,
        sortBy: sortBy,
      );

      setState(() {
        if (page == 1) {
          students = data;
        } else {
          students.addAll(data);
        }
        hasMore = data.length == limit;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load leaderboard: $e')),
      );
    }
  }

  void _loadMore() {
    if (hasMore) {
      setState(() {
        page++;
      });
      _fetchLeaderboardData();
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      page = 1;
    });
    _fetchLeaderboardData();
  }

  void _onSort(String sortBy) {
    setState(() {
      this.sortBy = sortBy;
      page = 1;
    });
    _fetchLeaderboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: RefreshIndicator(
        onRefresh: _fetchLeaderboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: _onSearch,
                ),
                const SizedBox(height: 20),
                // Sorting Dropdown
                DropdownButton<String>(
                  value: sortBy,
                  dropdownColor: const Color(0xFF1565C0),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    if (value != null) {
                      _onSort(value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'averageScore',
                      child: Text('Sort by Average Score'),
                    ),
                    DropdownMenuItem(
                      value: 'name',
                      child: Text('Sort by Name'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Top 3 Students Stats
                if (students.isNotEmpty)
                  Row(
                    children: [
                      _buildTopStudentCard(students[0], 1),
                      const SizedBox(width: 10),
                      _buildTopStudentCard(students[1], 2),
                      const SizedBox(width: 10),
                      _buildTopStudentCard(students[2], 3),
                    ],
                  ),
                const SizedBox(height: 20),
                // Leaderboard List
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (students.isEmpty)
                  const Center(
                    child: Text(
                      'No students found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: students.length + (hasMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.white54),
                    itemBuilder: (context, index) {
                      if (index == students.length) {
                        return Center(
                          child: TextButton(
                            onPressed: _loadMore,
                            child: const Text(
                              'Show More',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      final student = students[index];
                      final stats = student['studentLearningStats'];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade200,
                          backgroundImage: NetworkImage(student['image']),
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          student['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Average Score: ${stats['averageScore']}%',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          'Quizzes: ${stats['totalQuizzes']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopStudentCard(Map<String, dynamic> student, int rank) {
    final stats = student['studentLearningStats'];
    return Expanded(
      child: Card(
        elevation: 4,
        color: rank == 1
            ? Colors.amber.withOpacity(0.8)
            : rank == 2
                ? Colors.grey.withOpacity(0.8)
                : Colors.brown.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(student['image']),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                student['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Average Score: ${stats['averageScore']}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Quizzes: ${stats['totalQuizzes']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
