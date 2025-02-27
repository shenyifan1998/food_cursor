package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.dto.StoreDTO;
import com.food.service.StoreFavoriteService;
import com.food.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stores")
@RequiredArgsConstructor
@Tag(name = "门店收藏接口", description = "门店收藏相关接口")
public class StoreFavoriteController {
    private final StoreFavoriteService favoriteService;
    private final UserService userService;

    @GetMapping("/user/favorites")
    @Operation(summary = "获取用户收藏的门店")
    public ResponseEntity<ApiResponse<List<StoreDTO>>> getFavoriteStores() {
        Long userId = userService.getCurrentUserId();
        List<StoreDTO> stores = favoriteService.getFavoriteStores(userId);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", stores));
    }

    @PostMapping("/{storeId}/favorite")
    @Operation(summary = "收藏门店")
    public ResponseEntity<ApiResponse<Void>> addFavorite(@PathVariable Long storeId) {
        Long userId = userService.getCurrentUserId();
        favoriteService.addFavorite(userId, storeId);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "收藏成功", null));
    }

    @DeleteMapping("/{storeId}/favorite")
    @Operation(summary = "取消收藏门店")
    public ResponseEntity<ApiResponse<Void>> removeFavorite(@PathVariable Long storeId) {
        Long userId = userService.getCurrentUserId();
        favoriteService.removeFavorite(userId, storeId);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "取消收藏成功", null));
    }
} 