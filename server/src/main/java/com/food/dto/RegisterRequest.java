package com.food.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;

@Data
@Schema(description = "用户注册请求")
public class RegisterRequest {
    @Schema(description = "用户名", example = "zhangsan", required = true)
    @NotEmpty(message = "用户名不能为空")
    @Size(min = 2, max = 50, message = "用户名长度必须在2-50个字符之间")
    private String username;

    @Schema(description = "邮箱", example = "zhangsan@example.com", required = true)
    @NotEmpty(message = "邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    private String email;

    @Schema(description = "密码", example = "123456", required = true)
    @NotEmpty(message = "密码不能为空")
    @Size(min = 6, message = "密码长度不能小于6位")
    private String password;
} 