package com.food.service;

import com.food.dto.ApiResponse;
import com.food.dto.RegisterRequest;
import org.springframework.http.ResponseEntity;

public interface AuthService {
    ResponseEntity<ApiResponse<?>> register(RegisterRequest request);
} 