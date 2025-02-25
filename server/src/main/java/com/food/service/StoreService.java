package com.food.service;

import com.food.dto.StoreDTO;
import java.util.List;

public interface StoreService {
    List<StoreDTO> getNearbyStores(Double longitude, Double latitude, String cityCode);
    List<StoreDTO> getStoresByCity(String cityCode);
    StoreDTO getStoreById(Long id);
} 