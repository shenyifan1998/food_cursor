package com.food.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class StoreDTO {
    private Long id;
    private String name;
    private String address;
    private String businessHours;
    private Double distance;  // 计算得出的距离
    private Boolean isOpen;   // 根据营业时间和状态判断
    private Boolean supportsTakeout;
    private String cityName;
    private String phone;
} 