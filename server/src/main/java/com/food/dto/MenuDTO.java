package com.food.dto;

import lombok.Data;
import java.util.List;

@Data
public class MenuDTO {
    private Long id;
    private String menuName;
    private String money;
    private String explain;
    private List<String> tags;
    private Double originalPrice;
    private Double discountPrice;
    private String imageUrl;
    private String menuType;
} 