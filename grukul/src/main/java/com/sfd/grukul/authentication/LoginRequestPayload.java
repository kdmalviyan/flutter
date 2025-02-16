package com.sfd.grukul.authentication;

import lombok.Data;

@Data
public class LoginRequestPayload {
    private String username;
    private String password;
    private String schoolCode;
}
