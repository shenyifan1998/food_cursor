package com.food.service;

import com.food.dto.LeftSideMenuDTO;
import java.util.List;

public interface LeftSideMenuService {
    List<LeftSideMenuDTO> getMenuList();
}