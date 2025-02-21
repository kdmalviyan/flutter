package com.sfd.grukul.quizzes;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Quiz {
    private String id;
    private String title;
    private String subject;
    private String className;
    private String level;
    private int duration;
    private int questionCount;
    private double averageScore;
    private int participants;
    private LocalDateTime createdAt;
}
