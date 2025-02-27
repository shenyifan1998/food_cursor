package com.food.service;

import com.food.dto.StoreDTO;
import com.food.entity.Store;
import java.util.List;

public interface StoreFavoriteService {
    List<StoreDTO> getFavoriteStores(Long userId);
    
    void addFavorite(Long userId, Long storeId);
    
    void removeFavorite(Long userId, Long storeId);
    
//    void setFavoriteStatus(List<Store> stores, Long userId);

    /**
     * 设置门店列表的收藏状态
     *
     * @param stores 门店列表
     * @param userId 用户ID
     */
    void setFavoriteStatus(List<StoreDTO> stores, Long userId);
} 