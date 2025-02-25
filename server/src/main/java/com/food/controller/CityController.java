package com.food.controller;

import com.food.dto.ApiResponse;
import com.food.dto.CityGroupDTO;
import com.food.service.CityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/cities")
@RequiredArgsConstructor
@Tag(name = "城市接口", description = "城市相关接口")
public class CityController {
    private final CityService cityService;

    @GetMapping("/groups")
    @Operation(summary = "获取城市分组信息")
    public ResponseEntity<ApiResponse<CityGroupDTO>> getCityGroups() {
        CityGroupDTO cityGroups = cityService.getCityGroups();
        return ResponseEntity.ok(new ApiResponse<>("SUCCESS", "获取成功", cityGroups));
    }
} 