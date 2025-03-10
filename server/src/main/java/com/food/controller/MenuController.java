package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.dto.MenuDTO;
import com.food.service.MenuService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Tag(name = "菜单")
@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class MenuController {
    private final MenuService menuService;
    
    @GetMapping
    @Operation(summary = "获取所有菜品")
    public ResponseEntity<ApiResponse<List<MenuDTO>>> getAllMenus() {
        List<MenuDTO> menus = menuService.getAllMenus();
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", menus));
    }
    
    @GetMapping("/type/{menuType}")
    @Operation(summary = "根据类型获取菜品")
    public ResponseEntity<ApiResponse<List<MenuDTO>>> getMenusByType(@PathVariable String menuType) {
        List<MenuDTO> menus = menuService.getMenusByType(menuType);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", menus));
    }
} 