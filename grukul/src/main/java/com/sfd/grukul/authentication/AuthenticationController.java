package com.sfd.grukul.authentication;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/authentication")
@Slf4j
public class AuthenticationController {
    @PostMapping("login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequestPayload loginRequestPayload) {
        log.info("Login request {}", loginRequestPayload);
        return ResponseEntity.ok(LoginResponse.builder()
                        .token("Auth token")
                        .username(loginRequestPayload.getUsername())
                        .schoolCode(loginRequestPayload.getSchoolCode())
                        .message("Login Successfully")
                .build());
    }
}

