package com.food.service;

import com.food.dto.StoreDTO;
import com.food.entity.Store;
import java.util.List;

public interface StoreFavoriteService {
    List<StoreDTO> getFavoriteStores(Long userId);
    
    void addFavorite(Long userId, Long storeId);
    
    void removeFavorite(Long userId, Long storeId);
    
    void setFavoriteStatus(List<Store> stores, Long userId);
} 