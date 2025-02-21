import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mcq_learning_app/apis/dashboard.dart';
import 'package:mcq_learning_app/helper/app_colors.dart';
import 'package:mcq_learning_app/helper/quiz.dart';
import 'package:mcq_learning_app/screens/quiz_screen.dart';
import 'package:shimmer/shimmer.dart';

class QuizListingScreen extends StatefulWidget {
  final String token;

  const QuizListingScreen({Key? key, required this.token}) : super(key: key);

  @override
  _QuizListingScreenState createState() => _QuizListingScreenState();
}

class _QuizListingScreenState extends State<QuizListingScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> quizzes = [];
  bool isLoading = true;
  String? selectedClass;
  String? selectedSubject;
  String? selectedDifficulty;
  String searchQuery = '';
  String sortBy = 'recent';
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();

  // Filter lists
  List<String> difficultyFilters = [];
  List<String> subjectFilters = [];
  List<String> classFilters = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final response = await DashboardApi.getQuizzes(
        widget.token,
        classFilter: selectedClass,
        subjectFilter: selectedSubject,
        difficultyFilter: selectedDifficulty,
        searchQuery: searchQuery,
        sortBy: sortBy,
        page: 0,
        limit: 10,
      );

      final bool success = response['success'];
      if (success) {
        final List<dynamic> quizzesData = response['quizzes'];
        final Map<String, dynamic> filtersData = response['filters'];

        setState(() {
          quizzes = quizzesData.cast<Map<String, dynamic>>();
          difficultyFilters = filtersData['difficulty']?.cast<String>() ?? [];
          subjectFilters = filtersData['subject']?.cast<String>() ?? [];
          classFilters = filtersData['class']?.cast<String>() ?? [];
          isLoading = false;
        });

        // Trigger animation
        _animationController.forward(from: 0);
      } else {
        // Handle API failure
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to load quizzes: API returned false for success')),
        );
      }
    } catch (e) {
      // Handle errors
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load quizzes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildSearchBar(),
            _buildAppliedFilters(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchQuizzes,
                child: _buildQuizList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final int appliedFiltersCount = [
      selectedClass,
      selectedSubject,
      selectedDifficulty,
    ].where((filter) => filter != null).length;

    return AppBar(
      title: const Text('Quiz Library'),
      backgroundColor: AppColors.primaryColor,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2), // Add background color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list,
                    color: AppColors.white), // Use white color
                onPressed: _showFilterModal,
              ),
              if (appliedFiltersCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.errorColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$appliedFiltersCount',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white.withOpacity(0.9),
          hintText: 'Search quizzes...',
          prefixIcon: Icon(Icons.search, color: AppColors.darkGrey),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: AppColors.darkGrey),
            onPressed: () {
              _searchController.clear();
              setState(() => searchQuery = '');
              _fetchQuizzes();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() => searchQuery = value);
          _debounceSearch();
        },
      ),
    );
  }

  Widget _buildAppliedFilters() {
    final List<String?> appliedFilters = [
      selectedClass,
      selectedSubject,
      selectedDifficulty,
    ].where((filter) => filter != null).toList();

    if (appliedFilters.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: appliedFilters.map((filter) {
          return Chip(
            label: Text(filter!),
            onDeleted: () {
              setState(() {
                if (selectedClass == filter) selectedClass = null;
                if (selectedSubject == filter) selectedSubject = null;
                if (selectedDifficulty == filter) selectedDifficulty = null;
                _fetchQuizzes();
              });
            },
          );
        }).toList(),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align everything to the left
            children: [
              // Difficulty Filters
              _buildFilterSection(
                title: 'Difficulty',
                filters: difficultyFilters,
                selectedFilter: selectedDifficulty,
                onFilterSelected: (filter) {
                  setState(() {
                    selectedDifficulty = filter;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Subject Filters
              _buildFilterSection(
                title: 'Subject',
                filters: subjectFilters,
                selectedFilter: selectedSubject,
                onFilterSelected: (filter) {
                  setState(() {
                    selectedSubject = filter;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Class Filters
              _buildFilterSection(
                title: 'Class',
                filters: classFilters,
                selectedFilter: selectedClass,
                onFilterSelected: (filter) {
                  setState(() {
                    selectedClass = filter;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Apply Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal
                  _fetchQuizzes(); // Refresh quizzes with new filters
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> filters,
    required String? selectedFilter,
    required Function(String?) onFilterSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: filters.map((filter) {
            final bool isSelected = selectedFilter == filter;
            return FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.darkGrey,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                onFilterSelected(selected ? filter : null);
                setState(() {});
              },
              selectedColor: AppColors.primaryColor,
              backgroundColor: AppColors.lightGrey.withOpacity(0.1),
              checkmarkColor: AppColors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuizList() {
    if (isLoading) return _buildShimmerEffect();

    if (quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 60, color: AppColors.white.withOpacity(0.5)),
            const SizedBox(height: 20),
            Text(
              'No quizzes found',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return _buildQuizCard(quiz);
      },
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> quiz) {
    print(quiz);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _navigateToQuiz(quiz),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildDifficultyIndicator(quiz['difficulty']),
                  const Spacer(),
                  _buildQuizStats(quiz),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                quiz['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  _buildInfoChip(
                    icon: Icons.timer,
                    text: '${quiz['duration']} mins',
                  ),
                  _buildInfoChip(
                    icon: Icons.format_list_numbered,
                    text: '${quiz['questionCount']} questions',
                  ),
                  _buildInfoChip(
                    icon: Icons.star,
                    text: '${quiz['averageScore']}% Avg',
                    color: AppColors.secondaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(String difficulty) {
    final color = _getDifficultyColor(difficulty);
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 16),
        const SizedBox(width: 5),
        Text(
          difficulty,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizStats(Map<String, dynamic> quiz) {
    return Row(
      children: [
        Icon(Icons.people_alt, color: AppColors.lightGrey, size: 16),
        const SizedBox(width: 5),
        Text(
          '${quiz['participants']} takers',
          style: TextStyle(color: AppColors.darkGrey),
        ),
      ],
    );
  }

  Widget _buildInfoChip(
      {required IconData icon, required String text, Color? color}) {
    return Chip(
      backgroundColor:
          color?.withOpacity(0.1) ?? AppColors.lightGrey.withOpacity(0.1),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.darkGrey),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: color ?? AppColors.darkGrey)),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color?.withOpacity(0.3) ?? Colors.transparent),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(10),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.successColor;
      case 'medium':
        return AppColors.warningColor;
      case 'hard':
        return AppColors.errorColor;
      default:
        return AppColors.primaryColor;
    }
  }

  void _debounceSearch() {
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _fetchQuizzes();
    });
  }

  void _navigateToQuiz(Map<String, dynamic> quiz) {
    final quizData = Quiz(
      id: quiz['id'],
      title: quiz['title'],
      subject: quiz['subject'],
      className: quiz['className'],
      duration: quiz['duration'],
      questionCount: quiz['questionCount'],
      difficulty: quiz['difficulty'],
      averageScore: quiz['averageScore'],
      participants: quiz['participants'],
      createdAt: quiz['createdAt'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          token: widget.token,
          quiz: quizData,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
