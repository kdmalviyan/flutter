package com.sfd.grukul.quizzes;

import com.sfd.grukul.questions.DifficultyLevel;
import com.sfd.grukul.questions.Question;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class Quiz {
    private String id;
    private String title;
    private String subject;
    private String className;
    private DifficultyLevel difficulty;
    private int duration;
    private int questionCount;
    private double averageScore;
    private int participants;
    private LocalDateTime createdAt;
    private List<Question> questions;
}
