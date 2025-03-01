package com.sfd.grukul.quizzes;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class SubmitQuizAnswersDto {
    private String quizId;
    private List<Response> responses = new ArrayList<>();

    @Data
    public static class Response {
        private String questionId;
        private List<String> selectedAnswers;
    }
}
