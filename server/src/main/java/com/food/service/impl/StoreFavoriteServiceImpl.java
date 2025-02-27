package com.food.service.impl;

import com.food.dto.StoreDTO;
import com.food.entity.Store;
import com.food.entity.StoreFavorite;
import com.food.exception.BusinessException;
import com.food.repository.StoreFavoriteRepository;
import com.food.repository.StoreRepository;
import com.food.service.StoreFavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StoreFavoriteServiceImpl implements StoreFavoriteService {
    private final StoreFavoriteRepository favoriteRepository;
    private final StoreRepository storeRepository;

    @Override
    public List<StoreDTO> getFavoriteStores(Long userId) {
        List<StoreFavorite> favorites = favoriteRepository.findByUserId(userId);
        return favorites.stream()
                .map(favorite -> {
                    Store store = favorite.getStore();
                    store.setIsFavorite(true);
                    return convertToDTO(store);
                })
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void addFavorite(Long userId, Long storeId) {
        if (favoriteRepository.existsByUserIdAndStoreId(userId, storeId)) {
            throw new BusinessException("该门店已收藏");
        }

        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new BusinessException("门店不存在"));

        StoreFavorite favorite = new StoreFavorite();
        favorite.setUserId(userId);
        favorite.setStoreId(storeId);
        favorite.setStore(store);
        favoriteRepository.save(favorite);
    }

    @Override
    @Transactional
    public void removeFavorite(Long userId, Long storeId) {
        favoriteRepository.deleteByUserIdAndStoreId(userId, storeId);
    }

    @Override
    public void setFavoriteStatus(List<Store> stores, Long userId) {
        List<Long> favoriteStoreIds = favoriteRepository.findStoreIdsByUserId(userId);
        stores.forEach(store -> 
            store.setIsFavorite(favoriteStoreIds.contains(store.getId()))
        );
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
        dto.setIsFavorite(store.getIsFavorite());
        return dto;
    }
} 