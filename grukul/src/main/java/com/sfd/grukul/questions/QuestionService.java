package com.sfd.grukul.questions;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sfd.grukul.schools.School;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuestionService {
    private final ObjectMapper objectMapper;
    private List<Question> history = new ArrayList<Question>();
    private List<Question> science = new ArrayList<Question>();
    private List<Question> maths = new ArrayList<Question>();
    private List<Question> allQuestions = new ArrayList<Question>();

    @PostConstruct
    public void init() {
        loadSchoolsFromJson();
    }

    private void loadSchoolsFromJson() {
        this.history = loadQuestions("questions/history.json");
        this.science = loadQuestions("questions/science.json");
        this.maths = loadQuestions("questions/maths.json");
        allQuestions.addAll(history);
        allQuestions.addAll(science);
        allQuestions.addAll(maths);
    }

    private List<Question> loadQuestions(String fileName) {
        try {
            ClassPathResource resource = new ClassPathResource(fileName);
            InputStream inputStream = resource.getInputStream();
            return objectMapper.readValue(inputStream, new TypeReference<>() {
            });
        } catch (IOException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public Mono<Question> createQuestion(Question question) {
        return Mono.just(new Question());
    }

    public Flux<Question> getAllQuestions() {
        return Flux.fromIterable(allQuestions);
    }

    public Mono<Question> getQuestionById(String id) {
        return Mono.just(Objects.requireNonNull(allQuestions.stream()
                .filter(question -> Objects.equals(question.getId(), id))
                .findFirst().orElse(null)));
    }

    public Flux<Question> getQuestionBySubject(String subject) {
        return Flux.fromIterable(allQuestions.stream()
                .filter(question -> Objects.equals(question.getSubject().toLowerCase(), subject.toLowerCase())).collect(Collectors.toList()));
    }

    public Flux<Question> getQuestionByClassName(String className) {
        return Flux.fromIterable(allQuestions.stream()
                .filter(question -> Objects.equals(question.getClassName().toLowerCase(), className.toLowerCase())).collect(Collectors.toList()));
    }

    public Flux<Question> getQuestionByDifficulty(DifficultyLevel difficulty) {
        return Flux.fromIterable(allQuestions.stream()
                .filter(question -> Objects.equals(question.getDifficulty(), difficulty)).collect(Collectors.toList()));
    }

    public Flux<Question> getQuestionByType(QuestionType questionType) {
        return Flux.fromIterable(allQuestions.stream()
                .filter(question -> Objects.equals(question.getQuestionType(), questionType)).collect(Collectors.toList()));
    }

    public Mono<Question> updateQuestion(String id, Question question) {
        return Mono.just(new Question());
    }

    public Mono<Void> deleteQuestion(String id) {
        return Mono.empty();
    }
}