package com.food.dto;

import lombok.Data;

@Data
public class LeftSideMenuDTO {
    private Long id;
    private String type;
    private String typeName;
    private Integer orderNum;
    private boolean isSelected;  // 前端用于标记选中状态
}