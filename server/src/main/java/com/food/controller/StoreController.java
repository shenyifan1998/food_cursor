package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.dto.StoreDTO;
import com.food.service.StoreService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stores")
@RequiredArgsConstructor
@Tag(name = "门店接口", description = "门店相关接口")
public class StoreController {
    private final StoreService storeService;

    @GetMapping("/nearby")
    @Operation(summary = "获取附近门店")
    public ResponseEntity<ApiResponse<List<StoreDTO>>> getNearbyStores(
            @RequestParam Double longitude,
            @RequestParam Double latitude,
            @RequestParam String cityCode) {
        List<StoreDTO> stores = storeService.getNearbyStores(longitude, latitude, cityCode);
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", stores));
    }

    @GetMapping("/city/{cityCode}")
    @Operation(summary = "获取城市门店")
    public ResponseEntity<ApiResponse<List<StoreDTO>>> getStoresByCity(
            @PathVariable String cityCode) {
        List<StoreDTO> stores = storeService.getStoresByCity(cityCode);
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