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

/**
 * 门店收藏控制器
 * 处理门店收藏相关的请求
 */
@RestController
@RequestMapping("/api/stores")
@RequiredArgsConstructor
@Tag(name = "门店收藏接口", description = "门店收藏相关接口")
public class StoreFavoriteController {
    /**
     * 门店收藏服务
     */
    private final StoreFavoriteService favoriteService;
    
    /**
     * 用户服务
     */
    private final UserService userService;

    /**
     * 获取用户收藏的门店列表
     * 
     * @param token 用户认证token
     * @return 收藏的门店列表
     */
    @GetMapping("/user/favorites")
    @Operation(summary = "获取用户收藏的门店")
    public ResponseEntity<ApiResponse<List<StoreDTO>>> getFavoriteStores(
            @RequestHeader("Authorization") String token) {
        Long userId = userService.getCurrentUserId(token);
        List<StoreDTO> stores = favoriteService.getFavoriteStores(userId);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", stores));
    }

    /**
     * 收藏门店
     * 
     * @param storeId 门店ID
     * @param token 用户认证token
     * @return 收藏结果
     */
    @PostMapping("/{storeId}/favorite")
    @Operation(summary = "收藏门店")
    public ResponseEntity<ApiResponse<Void>> addFavorite(
            @PathVariable Long storeId,
            @RequestHeader("Authorization") String token) {
        Long userId = userService.getCurrentUserId(token);
        favoriteService.addFavorite(userId, storeId);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "收藏成功", null));
    }

    /**
     * 取消收藏门店
     * 
     * @param storeId 门店ID
     * @param token 用户认证token
     * @return 取消收藏结果
     */
    @DeleteMapping("/{storeId}/favorite")
    @Operation(summary = "取消收藏门店")
    public ResponseEntity<ApiResponse<Void>> removeFavorite(
            @PathVariable Long storeId,
            @RequestHeader("Authorization") String token) {
        Long userId = userService.getCurrentUserId(token);
        favoriteService.removeFavorite(userId, storeId);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "取消收藏成功", null));
    }
} 