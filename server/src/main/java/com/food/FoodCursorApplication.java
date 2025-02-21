package com.food;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class FoodCursorApplication {
    public static void main(String[] args) {
        SpringApplication.run(FoodCursorApplication.class, args);
    }
} 