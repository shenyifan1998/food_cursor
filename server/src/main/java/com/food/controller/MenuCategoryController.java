package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.entity.LeftSideMenu;
import com.food.repository.LeftSideMenuRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@Tag(name = "菜单分类")
@RestController
@RequestMapping("/api/menu")
@RequiredArgsConstructor
public class MenuCategoryController {
    private final LeftSideMenuRepository leftSideMenuRepository;
    
    @GetMapping("/categories")
    @Operation(summary = "获取所有菜单分类")
    public ResponseEntity<ApiResponse<List<LeftSideMenu>>> getAllCategories() {
        List<LeftSideMenu> categories = leftSideMenuRepository.findAll();
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", categories));
    }
} 