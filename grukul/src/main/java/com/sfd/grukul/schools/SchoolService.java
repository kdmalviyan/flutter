package com.sfd.grukul.schools;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SchoolService {
    private final ReactiveMongoTemplate mongoTemplate;
    private final ObjectMapper objectMapper;

    private List<School> schools;

    @PostConstruct
    public void init() {
        loadSchoolsFromJson();
    }

    private void loadSchoolsFromJson() {
        try {
            ClassPathResource resource = new ClassPathResource("schools.json");
            InputStream inputStream = resource.getInputStream();
            schools = objectMapper.readValue(inputStream, new TypeReference<List<School>>() {});
        } catch (IOException e) {
            e.printStackTrace();
            schools = List.of(); // Initialize with an empty list if file reading fails
        }
    }

    public Flux<School> getAllSchools() {
        //return mongoTemplate.findAll(School.class);
        return Flux.fromIterable(schools);
    }

    public Mono<School> getSchoolById(String id) {
        return mongoTemplate.findById(id, School.class);
    }

    public Flux<School> getSchoolsByGrade(String grade) {
        Query query = new Query(Criteria.where("grade").is(grade));
        return mongoTemplate.find(query, School.class);
    }

    public Mono<School> createSchool(School school) {
        return mongoTemplate.save(school);
    }

    public Mono<School> updateSchool(String id, School school) {
        school.setId(id);
        return mongoTemplate.save(school);
    }

    public Mono<Void> deleteSchool(String id) {
        return mongoTemplate.remove(Query.query(Criteria.where("id").is(id)), School.class).then();
    }

    public Mono<SchoolDto> getSchoolsByName(String name) {
        // Query query = new Query(Criteria.where("name").regex(name, "i"));
        // return mongoTemplate.find(query, School.class);
        return Mono.just(schools
                .stream()
                .filter(school -> school.getName().toLowerCase().contains(name.toLowerCase()))
                .map(School::toSchoolDto)
                .findFirst().orElseThrow(() -> new RuntimeException("School not found"))
        );
    }
}