package com.sfd.grukul.questions;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1/questions")
@RequiredArgsConstructor
public class QuestionController {

    private final QuestionService questionService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<Question> createQuestion(@RequestBody Question question) {
        return questionService.createQuestion(question);
    }

    @GetMapping
    public Flux<Question> getAllQuestions() {
        return questionService.getAllQuestions();
    }

    @GetMapping("/{id}")
    public Mono<Question> getQuestionById(@PathVariable String id) {
        return questionService.getQuestionById(id);
    }

    @GetMapping("/subject/{subject}")
    public Flux<Question> getQuestionBySubject(@PathVariable String subject) {
        return questionService.getQuestionBySubject(subject);
    }

    @GetMapping("/class-name/{className}")
    public Flux<Question> getQuestionByClassName(@PathVariable String className) {
        return questionService.getQuestionByClassName(className);
    }

    @GetMapping("/difficulty/{difficulty}")
    public Flux<Question> getQuestionByDifficulty(@PathVariable DifficultyLevel difficulty) {
        return questionService.getQuestionByDifficulty(difficulty);
    }

    @GetMapping("/question-type/{questionType}")
    public Flux<Question> getQuestionByType(@PathVariable QuestionType questionType) {
        return questionService.getQuestionByType(questionType);
    }

    @PutMapping("/{id}")
    public Mono<Question> updateQuestion(@PathVariable String id, @RequestBody Question question) {
        return questionService.updateQuestion(id, question);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> deleteQuestion(@PathVariable String id) {
        return questionService.deleteQuestion(id);
    }
}