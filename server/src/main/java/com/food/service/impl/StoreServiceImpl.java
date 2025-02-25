package com.food.service.impl;

import com.food.dto.StoreDTO;
import com.food.entity.Store;
import com.food.repository.StoreRepository;
import com.food.service.StoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StoreServiceImpl implements StoreService {
    private final StoreRepository storeRepository;
    private static final double DEFAULT_RADIUS = 5000.0; // 默认5公里范围

    @Override
    public List<StoreDTO> getNearbyStores(Double longitude, Double latitude, String cityCode) {
        List<Store> stores = storeRepository.findNearbyStores(longitude, latitude, cityCode, DEFAULT_RADIUS);
        return stores.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoreDTO> getStoresByCity(String cityCode) {
        List<Store> stores = storeRepository.findByCityCode(cityCode);
        return stores.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public StoreDTO getStoreById(Long id) {
        return storeRepository.findById(id)
                .map(this::convertToDTO)
                .orElse(null);
    }

    private StoreDTO convertToDTO(Store store) {
        StoreDTO dto = new StoreDTO();
        dto.setId(store.getId());
        dto.setName(store.getName());
        dto.setAddress(store.getAddress());
        dto.setBusinessHours(store.getBusinessHours());
        dto.setIsOpen(store.getStatus() == 1);
        dto.setSupportsTakeout(store.getSupportsTakeout());
        dto.setCityName(store.getCityName());
        dto.setPhone(store.getPhone());
        return dto;
    }
} 