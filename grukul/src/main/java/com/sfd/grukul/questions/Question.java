package com.sfd.grukul.questions;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class Question {
    private String id;
    private String className;
    private String subject;
    private String chapter;
    private String topic;
    private String question;
    private QuestionType questionType;
    private DifficultyLevel difficulty;
    private QuestionDetails details;
    private List<String> options = new ArrayList<>();
    private List<String> correctAnswer = new ArrayList<>();
    //Free Form Questions
    private String answerHint;
    private String answer; // Long answer
    //For Scale Question
    private int scaleMin;
    private int scaleMax;

    @Data
    public static class QuestionDetails {
        private String explanation;
        private String hint;
        private String image;
        private String video;
        private String reference;
        private String additionalResources;
        private String[] relatedQuestions;
        private String[] relatedExercises;
        private String[] relatedQuizzes;
    }
}
