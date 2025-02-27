package com.food.service.impl;

import com.food.config.JwtConfig;
import com.food.dto.LoginRequest;
import com.food.dto.LoginResponse;
import com.food.dto.UserRegisterRequest;
import com.food.entity.User;
import com.food.exception.BusinessException;
import com.food.repository.UserRepository;
import com.food.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtConfig jwtConfig;

    @Override
    @Transactional
    public User registerUser(UserRegisterRequest request) {
        // 检查用户名是否已存在
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new BusinessException("用户名已存在");
        }

        // 检查邮箱是否已存在
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BusinessException("邮箱已被注册");
        }

        // 创建新用户
        User user = new User();
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        return userRepository.save(user);
    }

    @Override
    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new BusinessException("用户名或密码错误"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }

        String token = jwtConfig.generateToken(user.getUsername(), user.getId());
        return new LoginResponse(user.getId(), user.getUsername(), token);
    }

    @Override
    public Long getCurrentUserId(String token) {
        if (token == null || token.isEmpty()) {
            throw new BusinessException("未登录");
        }
        
        try {
            return jwtConfig.extractUserId(token.replace("Bearer ", ""));
        } catch (Exception e) {
            throw new BusinessException("登录已过期，请重新登录");
        }
    }
} 