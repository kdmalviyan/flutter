package com.sfd.grukul.quizzes;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1/quizzes")
@RequiredArgsConstructor
@Slf4j
public class QuizController {
    private final QuizService quizService;

    @GetMapping
    public Flux<Quiz> getAllQuizzes() {
        return quizService.getAllQuizzes();
    }

    @GetMapping("/{id}")
    public Mono<Quiz> getQuizById(@PathVariable Long id) {
        return Mono.just(new Quiz());
    }

    @PostMapping("/create")
    public Mono<Quiz> createQuiz(@RequestBody Quiz quiz) {
        return Mono.just(new Quiz());
    }

    @PutMapping("/update/{id}")
    public Mono<Quiz> updateQuiz(@PathVariable Long id, @RequestBody Quiz quiz) {
        return Mono.just(new Quiz());
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteQuiz(@PathVariable Long id) {
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/random")
    public Mono<QuizResponseDto> getRandomQuizzes(
            @RequestParam("page") int page,
            @RequestParam("limit") int limit,
            @RequestParam(value = "classFilter", required = false) String classFilter,
            @RequestParam(value = "subjectFilter", required = false) String subjectFilter,
            @RequestParam(value = "difficultyFilter", required = false) String difficultyFilter,
            @RequestParam(value = "searchQuery", required = false) String searchQuery,
            @RequestParam(value = "sortBy", required = false) String sortBy) {
        log.info("Fetching quizzes with {} {} {} {} {} {} {}",
        page, limit, classFilter, subjectFilter, difficultyFilter, searchQuery, sortBy);
        Flux<Quiz> quizzes = quizService.getRandomQuizzes();
        return quizzes
                .collectList()
                .flatMap(quizList -> quizService.getQuizFilters()
                        .map(filters -> QuizResponseDto.builder()
                                .success(true)
                                .quizzes(quizList)
                                .filters(filters)
                                .build()
                        )
                );
    }

    @PostMapping("/submit-answers")
    @ResponseStatus(HttpStatus.OK)
    public Mono<SubmitQuizAnswersDto> submitQuizResponse(@RequestBody SubmitQuizAnswersDto submitQuizAnswersDto) {
        return Mono.just(submitQuizAnswersDto);
    }
}
