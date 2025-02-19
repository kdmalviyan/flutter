package com.sfd.grukul.student;

import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1/student/dashboard")
@RequiredArgsConstructor
@Slf4j
public class StudentDashboardController {

    @GetMapping("learning-stats")
    public ResponseEntity<StudentLearningStats> learningStats() {
        return ResponseEntity.ok(StudentLearningStats.builder()
                        .averageScore(85.5)
                        .correctAnswers(120)
                        .totalQuizzes(25)
                        .incorrectAnswers(30)
                .build());
    }

    @GetMapping("progress-over-time")
    public ResponseEntity<List<StudentProgressOverTime>> progressOverTime() {
        return ResponseEntity.ok(List.of(
                StudentProgressOverTime.builder()
                        .score(80)
                        .date(LocalDate.of(2025, 2, 10)).build(),
                StudentProgressOverTime.builder()
                        .score(90)
                        .date(LocalDate.of(2025, 2, 11)).build(),
                StudentProgressOverTime.builder()
                        .score(85)
                        .date(LocalDate.of(2025, 2, 12)).build()
        ));
    }


    @GetMapping("last-n-quizzes/{numberOfQuestions}")
    public ResponseEntity<List<StudentQuiz>> lastNQuizzes(
            @PathVariable("numberOfQuestions") int numberOfQuestions) {
        return ResponseEntity.ok(List.of(
                StudentQuiz.builder()
                        .score(20)
                        .date(LocalDate.of(2025, 2, 10))
                        .title("Math Quiz 1")
                        .quizId("1")
                        .build(),
                StudentQuiz.builder()
                        .score(50)
                        .date(LocalDate.of(2025, 2, 11))
                        .title("Science Quiz 1")
                        .quizId("2")
                        .build(),
                StudentQuiz.builder()
                        .score(30)
                        .date(LocalDate.of(2025, 2, 12))
                        .title("History Quiz 1")
                        .quizId("3")
                        .build()
        ));
    }

    @GetMapping("leaderboard")
    public ResponseEntity<List<Student>> getLeaderboard(
            @RequestParam("page") int page,
            @RequestParam("limit") int limit,
            @RequestParam(value = "searchQuery", required = false) String searchQuery,
            @RequestParam(value = "sortBy", required = false) String sortBy
    ) {
        return ResponseEntity.ok(List.of(
                Student.builder()
                        .studentId("80")
                        .image("http://image.com/images/80.png")
                        .name("Kanishka Singh")
                        .studentLearningStats(
                                StudentLearningStats.builder()
                                        .averageScore(85.5)
                                        .studentId("80")
                                        .correctAnswers(120)
                                        .totalQuizzes(25)
                                        .incorrectAnswers(30)
                                        .build())
                        .build(),
                Student.builder()
                        .studentId("120")
                        .image("http://image.com/images/80.png")
                        .name("Kuldeep Singh")
                        .studentLearningStats(
                                StudentLearningStats.builder()
                                        .studentId("120")
                                        .averageScore(90.5)
                                        .correctAnswers(150)
                                        .totalQuizzes(45)
                                        .incorrectAnswers(20)
                                        .build())
                        .build(),
                Student.builder()
                        .studentId("24")
                        .image("http://image.com/images/80.png")
                        .name("John Doe")
                        .studentLearningStats(
                                StudentLearningStats.builder()
                                        .studentId("24")
                                        .averageScore(67)
                                        .correctAnswers(89)
                                        .totalQuizzes(7)
                                        .incorrectAnswers(0)
                                        .build())
                        .build()
        ));
    }


    @Data
    @Builder
    public static class StudentProgressOverTime {
        private LocalDate date;
        private double score;
    }

    @Data
    @Builder
    public static class StudentLearningStats {
        private String studentId;
        private int totalQuizzes;
        private int correctAnswers;
        private int incorrectAnswers;
        private double averageScore;
    }

    @Data
    @Builder
    public static class StudentQuiz {
        private String studentId;
        private String quizId;
        private String title;
        private LocalDate date;
        private double score;
    }

    @Data
    @Builder
    public static class Student {
        private String studentId;
        private String name;
        private String image;
        private StudentLearningStats studentLearningStats;
    }
}

