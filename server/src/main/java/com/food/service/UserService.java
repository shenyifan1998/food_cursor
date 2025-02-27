package com.food.service;

import com.food.dto.LoginRequest;
import com.food.dto.LoginResponse;
import com.food.dto.UserRegisterRequest;
import com.food.entity.User;

public interface UserService {
    User registerUser(UserRegisterRequest request);
    
    LoginResponse login(LoginRequest request);
    
    Long getCurrentUserId(String token);
} 