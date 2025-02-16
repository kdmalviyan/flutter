package com.sfd.grukul.schools;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1/schools")
public class SchoolController {

    @Autowired
    private SchoolService schoolService;

    @GetMapping
    public Flux<School> getAllSchools() {
        return schoolService.getAllSchools();
    }


    @GetMapping("/name/{name}")
    public Mono<SchoolDto> getSchoolsByName(@PathVariable String name) {
        return schoolService.getSchoolsByName(name);
    }


    @GetMapping("/{id}")
    public Mono<School> getSchoolById(@PathVariable String id) {
        return schoolService.getSchoolById(id);
    }

    @GetMapping("/grade/{grade}")
    public Flux<School> getSchoolsByGrade(@PathVariable String grade) {
        return schoolService.getSchoolsByGrade(grade);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<School> createSchool(@RequestBody School school) {
        return schoolService.createSchool(school);
    }

    @PutMapping("/{id}")
    public Mono<School> updateSchool(@PathVariable String id, @RequestBody School school) {
        return schoolService.updateSchool(id, school);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> deleteSchool(@PathVariable String id) {
        return schoolService.deleteSchool(id);
    }
}