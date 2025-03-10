package com.food.service.impl;

import com.food.dto.MenuDTO;
import com.food.entity.Menu;
import com.food.entity.LeftSideMenu;
import com.food.repository.MenuRepository;
import com.food.repository.LeftSideMenuRepository;
import com.food.service.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Collections;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MenuServiceImpl implements MenuService {
    private final MenuRepository menuRepository;
    private final LeftSideMenuRepository leftSideMenuRepository;
    
    @Override
    public List<MenuDTO> getMenusByType(String menuType) {
        // 先查询对应类型的左侧菜单
        List<LeftSideMenu> leftSideMenus = leftSideMenuRepository.findByType(menuType);
        if (leftSideMenus.isEmpty()) {
            return Collections.emptyList();
        }
        
        // 获取所有符合条件的左侧菜单ID
        List<Long> menuIds = leftSideMenus.stream()
                .map(LeftSideMenu::getId)
                .collect(Collectors.toList());
        
        // 根据左侧菜单ID查询菜品
        List<Menu> menus = menuRepository.findByLeftSideMenuIdIn(menuIds);
        return menus.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    @Override
    public List<MenuDTO> getAllMenus() {
        List<Menu> menus = menuRepository.findAll();
        return menus.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    private MenuDTO convertToDTO(Menu menu) {
        MenuDTO dto = new MenuDTO();
        dto.setId(menu.getId());
        dto.setMenuName(menu.getMenuName());
        dto.setMoney(menu.getMoney());
        dto.setExplain(menu.getExplain());
        
        // 解析金额为原价和折扣价
        try {
            double price = Double.parseDouble(menu.getMoney());
            dto.setOriginalPrice(price);
            dto.setDiscountPrice(price * 0.9); // 假设折扣为9折
        } catch (NumberFormatException e) {
            dto.setOriginalPrice(0.0);
            dto.setDiscountPrice(0.0);
        }
        
        // 设置标签（从说明中提取关键词）
        if (menu.getExplain() != null) {
            String[] keywords = menu.getExplain().split("、|，|,|。|\\s+");
            dto.setTags(Arrays.asList(keywords).stream()
                    .filter(k -> k.length() > 0 && k.length() <= 4)
                    .limit(4)
                    .collect(Collectors.toList()));
        } else {
            dto.setTags(Collections.emptyList());
        }
        
        // 设置图片URL（根据菜品类型设置不同的图片）
        String imageUrl;
        switch (menu.getId().intValue() % 3) {
            case 0:
                imageUrl = "https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&auto=format&fit=crop";
                break;
            case 1:
                imageUrl = "https://images.unsplash.com/photo-1546173159-315724a31696?w=500&auto=format&fit=crop";
                break;
            default:
                imageUrl = "https://images.unsplash.com/photo-1587314168485-3236d6710814?w=500&auto=format&fit=crop";
        }
        dto.setImageUrl(imageUrl);
        
        // 设置菜单类型（通过关联查询获取）
        Optional<LeftSideMenu> leftSideMenu = leftSideMenuRepository.findById(menu.getLeftSideMenuId());
        dto.setMenuType(leftSideMenu.map(LeftSideMenu::getType).orElse("unknown"));
        
        return dto;
    }
} 