package com.sfd.grukul.quizzes;

import com.sfd.grukul.questions.DifficultyLevel;
import com.sfd.grukul.questions.QuestionService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class QuizService {
    private final QuestionService questionService;

    private final List<Quiz> quizzes = new ArrayList<>();

    @PostConstruct
    public void init() {
        loadSchoolsFromJson();
    }

    private void loadSchoolsFromJson() {
        // Maths mathsQuiz
        Quiz mathsQuiz = new Quiz();
        mathsQuiz.setId("maths-mathsQuiz-id");
        mathsQuiz.setTitle("Maths Quiz");
        mathsQuiz.setSubject("Maths");
        mathsQuiz.setClassName("Class 7");
        mathsQuiz.setDifficulty(DifficultyLevel.HARD);
        mathsQuiz.setDuration(30);
        mathsQuiz.setQuestionCount(20);
        mathsQuiz.setAverageScore(0.0);
        mathsQuiz.setParticipants(0);
        mathsQuiz.setCreatedAt(LocalDateTime.now());
        populateQuizWithQuestions(mathsQuiz, "Maths");

        // Science scienceQuiz
        Quiz scienceQuiz = new Quiz();
        scienceQuiz.setId("science-scienceQuiz-id");
        scienceQuiz.setTitle("Science Quiz");
        scienceQuiz.setSubject("Science");
        scienceQuiz.setClassName("Class 7");
        scienceQuiz.setDifficulty(DifficultyLevel.EASY);
        scienceQuiz.setDuration(30);
        scienceQuiz.setQuestionCount(20);
        scienceQuiz.setAverageScore(0.0);
        scienceQuiz.setParticipants(0);
        scienceQuiz.setCreatedAt(LocalDateTime.now());
        populateQuizWithQuestions(scienceQuiz, "Science");

        // History historyQuiz
        Quiz historyQuiz = new Quiz();
        historyQuiz.setId("history-historyQuiz-id");
        historyQuiz.setTitle("History Quiz");
        historyQuiz.setSubject("History");
        historyQuiz.setClassName("Class 7");
        historyQuiz.setDifficulty(DifficultyLevel.EASY);
        historyQuiz.setDuration(30);
        historyQuiz.setQuestionCount(20);
        historyQuiz.setAverageScore(0.0);
        historyQuiz.setParticipants(0);
        historyQuiz.setCreatedAt(LocalDateTime.now());
        populateQuizWithQuestions(historyQuiz, "History");
        quizzes.add(mathsQuiz);
        quizzes.add(historyQuiz);
        quizzes.add(scienceQuiz);
        System.out.println(quizzes);
    }

    public void populateQuizWithQuestions(Quiz quiz, String subject) {
        questionService.getQuestionBySubject(subject)
                .collectList()
                .subscribe(questions -> {
                    quiz.setQuestions(questions);
                    System.out.println("Quiz questions set successfully!");
                });
    }

    public Flux<Quiz> getRandomQuizzes() {
        return Flux.fromIterable(quizzes);
    }

    public Flux<Quiz> getAllQuizzes() {
        return Flux.fromIterable(quizzes);
    }

    public Mono<Map<String, List<String>>> getQuizFilters() {
        Map<String, List<String>> filters = new HashMap<>();
        filters.put("subject", Arrays.asList("Maths", "Science", "History"));
        filters.put("difficulty", Arrays.asList("EASY", "MEDIUM", "HARD"));
        filters.put("class", Arrays.asList("Class 1",
                "Class 2",
                "Class 3",
                "Class 4",
                "Class 5",
                "Class 6",
                "Class 7",
                "Class 8",
                "Class 9",
                "Class 10",
                "Class 11",
                "Class 12"));
        return Mono.just(filters);
    }
}
