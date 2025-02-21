package com.sfd.grukul.quizzes;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class QuizService {
    private final ObjectMapper objectMapper;
    private List<Quiz> quizzes;

    @PostConstruct
    public void init() {
        loadSchoolsFromJson();
    }

    private void loadSchoolsFromJson() {
        try {
            ClassPathResource resource = new ClassPathResource("quizzes.json");
            InputStream inputStream = resource.getInputStream();
            quizzes = objectMapper.readValue(inputStream, new TypeReference<List<Quiz>>() {});
        } catch (IOException e) {
            quizzes = List.of(); // Initialize with an empty list if file reading fails
        }
    }

    public Flux<Quiz> getRandomQuizzes() {
        return Flux.fromIterable(quizzes);
    }

    public Flux<Quiz> getAllQuizzes() {
        return Flux.fromIterable(quizzes);
    }

    public Mono<Map<String, List<String>>> getQuizFilters() {
        Map<String, List<String>> filters = new HashMap<>();
        filters.put("subject", Arrays.asList("Math", "Science", "History"));
        filters.put("difficulty", Arrays.asList("Easy", "Medium", "Hard"));
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
