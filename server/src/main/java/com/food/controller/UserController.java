package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.dto.LoginRequest;
import com.food.dto.LoginResponse;
import com.food.dto.UserRegisterRequest;
import com.food.entity.User;
import com.food.exception.BusinessException;
import com.food.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * 用户控制器
 * 处理用户注册、登录等请求
 */
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
@Tag(name = "用户接口", description = "用户相关接口")
public class UserController {
    /**
     * 用户服务
     */
    private final UserService userService;

    /**
     * 用户注册接口
     * 
     * @param request 注册请求参数
     * @return 注册结果
     */
    @PostMapping("/register")
    @Operation(summary = "用户注册")
    public ResponseEntity<ApiResponse<User>> register(@RequestBody @Valid UserRegisterRequest request) {
        try {
            User user = userService.registerUser(request);
            return ResponseEntity.ok(new ApiResponse<>(
                "SUCCESS",
                "注册成功",
                user
            ));
        } catch (BusinessException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ApiResponse<>("ERROR", e.getMessage(), null));
        }
    }
    
    /**
     * 用户登录接口
     * 
     * @param request 登录请求参数
     * @return 登录结果，包含用户信息和token
     */
    @PostMapping("/login")
    @Operation(summary = "用户登录")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@RequestBody @Valid LoginRequest request) {
        try {
            LoginResponse response = userService.login(request);
            return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "登录成功", response));
        } catch (BusinessException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ApiResponse<>("ERROR", e.getMessage(), null));
        }
    }
} 