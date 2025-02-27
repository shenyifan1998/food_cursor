package com.food.service;

import com.food.dto.UserRegisterRequest;
import com.food.entity.User;

public interface UserService {
    User registerUser(UserRegisterRequest request);
    
    Long getCurrentUserId();
} 