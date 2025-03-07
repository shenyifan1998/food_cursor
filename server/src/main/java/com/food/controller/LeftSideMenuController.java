package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.dto.LeftSideMenuDTO;
import com.food.service.LeftSideMenuService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@Tag(name = "左侧菜单")
@RestController
@RequestMapping("/api/menu")
@RequiredArgsConstructor
public class LeftSideMenuController {
    private final LeftSideMenuService leftSideMenuService;

    @GetMapping
    @Operation(summary = "获取左侧菜单列表")
    public ResponseEntity<ApiResponse<List<LeftSideMenuDTO>>> getMenuList() {
        List<LeftSideMenuDTO> menuList = leftSideMenuService.getMenuList();
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", menuList));
    }
} 