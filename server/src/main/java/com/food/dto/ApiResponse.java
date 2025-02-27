package com.food.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 统一API响应结构
 * 
 * @param <T> 响应数据类型
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponse<T> {
    /**
     * 响应结果代码，SUCCESS表示成功，ERROR表示失败
     */
    private String result;
    
    /**
     * 响应消息，成功或错误的描述信息
     */
    private String message;
    
    /**
     * 响应数据，可以是任何类型
     */
    private T data;
} 