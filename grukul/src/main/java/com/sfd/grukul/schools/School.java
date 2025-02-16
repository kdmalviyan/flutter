package com.sfd.grukul.schools;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Document(collection = "schools")
public class School {
    @Id
    private String id;
    private String name;
    private String address;
    private String grade;
    private String phone;
    private String email;
    private String website;
    private String schoolCode;
    private int establishedYear;
    private SchoolType schoolType;
    private String principal;
    private int totalStudents;
    private boolean accreditation;
    private List<String> facilities;
    private Contact contact;

    public SchoolDto toSchoolDto() {
        SchoolDto schoolDto = new SchoolDto();
        schoolDto.setId(id);
        schoolDto.setName(name);
        schoolDto.setAddress(address);
        schoolDto.setGrade(grade);
        schoolDto.setPhone(phone);
        schoolDto.setEmail(email);
        schoolDto.setWebsite(website);
        schoolDto.setSchoolCode(schoolCode);
        return schoolDto;
    }

    @Data
    public static class Contact {
        private String name;
        private String position;
        private String email;

        public Contact() {}

        public Contact(String name, String position, String email) {
            this.name = name;
            this.position = position;
            this.email = email;
        }
    }

    public enum SchoolType {
        PUBLIC, PRIVATE
    }
}