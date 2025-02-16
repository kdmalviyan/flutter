package com.sfd.grukul.schools;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/public/api/v1/schools")
@RequiredArgsConstructor
public class SchoolPublicApiController {
    private final SchoolService schoolService;

    @GetMapping
    public Flux<SchoolDto> getAllSchools() {
        return schoolService.getAllSchools().map(School::toSchoolDto);
    }
}
