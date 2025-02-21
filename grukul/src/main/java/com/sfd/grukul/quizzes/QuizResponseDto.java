package com.sfd.grukul.quizzes;

import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@Builder
public class QuizResponseDto {
    private boolean success;
    private List<Quiz> quizzes;
    private Map<String, List<String>> filters;
}
