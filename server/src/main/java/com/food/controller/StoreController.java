package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.dto.StoreDTO;
import com.food.service.StoreService;
import com.food.service.StoreFavoriteService;
import com.food.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 门店控制器
 */
@RestController
@RequestMapping("/api/stores")
@RequiredArgsConstructor
@Tag(name = "门店接口", description = "门店相关接口")
public class StoreController {
    private final StoreService storeService;
    private final StoreFavoriteService favoriteService;
    private final UserService userService;

    @GetMapping("/nearby")
    @Operation(summary = "获取附近门店")
    public ResponseEntity<ApiResponse<List<StoreDTO>>> getNearbyStores(
            @RequestParam Double longitude,
            @RequestParam Double latitude,
            @RequestParam String cityCode) {
        List<StoreDTO> stores = storeService.getNearbyStores(longitude, latitude, cityCode);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", stores));
    }

    /**
     * 根据城市代码获取门店列表
     *
     * @param cityCode 城市代码
     * @param token    用户认证token（可选）
     * @return 门店列表
     */
    @GetMapping("/city/{cityCode}")
    @Operation(summary = "获取城市门店列表")
    public ResponseEntity<ApiResponse<List<StoreDTO>>> getStoresByCity(
            @PathVariable String cityCode,
            @RequestHeader(value = "Authorization", required = false) String token) {
        List<StoreDTO> stores = storeService.getStoresByCity(cityCode);
        
        // 如果用户已登录，设置收藏状态
        if (token != null && !token.isEmpty()) {
            try {
                Long userId = userService.getCurrentUserId(token);
                favoriteService.setFavoriteStatus(stores, userId);
            } catch (Exception e) {
                // 如果token无效，忽略错误，继续返回门店列表
                stores.forEach(store -> store.setIsFavorite(false));
            }
        } else {
            // 未登录用户，所有门店都设置为未收藏
            stores.forEach(store -> store.setIsFavorite(false));
        }
        
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", stores));
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取门店详情")
    public ResponseEntity<ApiResponse<StoreDTO>> getStoreById(
            @PathVariable Long id) {
        StoreDTO store = storeService.getStoreById(id);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", store));
    }
} 