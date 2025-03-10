package com.food.service;

import com.food.dto.MenuDTO;
import java.util.List;

public interface MenuService {
    List<MenuDTO> getMenusByType(String menuType);
    List<MenuDTO> getAllMenus();
} 