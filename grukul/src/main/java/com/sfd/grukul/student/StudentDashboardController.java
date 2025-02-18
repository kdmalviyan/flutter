package com.sfd.grukul.student;

import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
                        .score(80)
                        .date(LocalDate.of(2025, 2, 10))
                        .title("Math Quiz 1")
                        .quizId(1)
                        .build(),
                StudentQuiz.builder()
                        .score(90)
                        .date(LocalDate.of(2025, 2, 11))
                        .title("Science Quiz 1")
                        .quizId(2)
                        .build(),
                StudentQuiz.builder()
                        .score(85)
                        .date(LocalDate.of(2025, 2, 12))
                        .title("History Quiz 1")
                        .quizId(3)
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
        private int totalQuizzes;
        private int correctAnswers;
        private int incorrectAnswers;
        private double averageScore;
    }

    @Data
    @Builder
    public static class StudentQuiz {
        private int quizId;
        private String title;
        private LocalDate date;
        private double score;
    }
}

