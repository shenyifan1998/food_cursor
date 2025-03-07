package com.food.service.impl;

import com.food.dto.LeftSideMenuDTO;
import com.food.entity.LeftSideMenu;
import com.food.repository.LeftSideMenuRepository;
import com.food.service.LeftSideMenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LeftSideMenuServiceImpl implements LeftSideMenuService {
    private final LeftSideMenuRepository leftSideMenuRepository;

    @Override
    public List<LeftSideMenuDTO> getMenuList() {
        List<LeftSideMenu> menus = leftSideMenuRepository.findAll();
        return menus.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    private LeftSideMenuDTO convertToDTO(LeftSideMenu menu) {
        LeftSideMenuDTO dto = new LeftSideMenuDTO();
        dto.setId(menu.getId());
        dto.setType(menu.getType());
        dto.setTypeName(menu.getTypeName());
        dto.setOrderNum(menu.getOrderNum());
        dto.setSelected(false);
        return dto;
    }
} 