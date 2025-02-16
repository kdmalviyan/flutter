package com.sfd.grukul.authentication;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class LoginResponse {
    private String username;
    private String token;
    private String message;
    private String schoolCode;
}
