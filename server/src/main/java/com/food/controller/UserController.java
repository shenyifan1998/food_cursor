package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.dto.UserRegisterRequest;
import com.food.entity.User;
import com.food.exception.GlobalExceptionHandler;
import com.food.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<?>> register(@RequestBody @Valid UserRegisterRequest request) {
        try {
            User user = userService.registerUser(request);
            return ResponseEntity.ok(new ApiResponse<>(
                "SUCCESS",
                "注册成功",
                user
            ));
        } catch (Exception e) {
            return GlobalExceptionHandler.errorResponseEntity(
                e.getMessage(),
                HttpStatus.BAD_REQUEST
            );
        }
    }
} 