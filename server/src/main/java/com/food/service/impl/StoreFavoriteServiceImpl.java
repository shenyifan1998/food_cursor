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

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 门店收藏服务实现类
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StoreFavoriteServiceImpl implements StoreFavoriteService {
    private final StoreFavoriteRepository favoriteRepository;
    private final StoreRepository storeRepository;

    /**
     * 获取用户收藏的门店列表
     *
     * @param userId 用户ID
     * @return 收藏的门店列表
     */
    @Override
    public List<StoreDTO> getFavoriteStores(Long userId) {
        List<StoreFavorite> favorites = favoriteRepository.findByUserId(userId);
        return favorites.stream()
                .map(favorite -> {
                    Store store = favorite.getStore();
                    StoreDTO dto = new StoreDTO();
                    dto.setId(store.getId());
                    dto.setName(store.getName());
                    dto.setAddress(store.getAddress());
                    dto.setPhone(store.getPhone());
                    dto.setBusinessHours(store.getBusinessHours());
//                    dto.setLatitude(store.getLatitude());
//                    dto.setLongitude(store.getLongitude());
                    dto.setIsFavorite(true);
                    return dto;
                })
                .collect(Collectors.toList());
    }

    /**
     * 添加收藏
     *
     * @param userId  用户ID
     * @param storeId 门店ID
     */
    @Override
    @Transactional
    public void addFavorite(Long userId, Long storeId) {
        // 检查是否已收藏
        if (favoriteRepository.existsByUserIdAndStoreId(userId, storeId)) {
            throw new BusinessException("已收藏该门店");
        }

        // 检查门店是否存在
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new BusinessException("门店不存在"));

        // 创建收藏记录
        StoreFavorite favorite = new StoreFavorite();
        favorite.setUserId(userId);
        favorite.setStoreId(store.getId());
//        favorite.setStore(store);
        favorite.setCreatedAt(LocalDateTime.now()); // 设置创建时间
        favorite.setUpdatedAt(LocalDateTime.now()); // 设置更新时间
        favoriteRepository.save(favorite);
    }

    /**
     * 取消收藏
     *
     * @param userId  用户ID
     * @param storeId 门店ID
     */
    @Override
    @Transactional
    public void removeFavorite(Long userId, Long storeId) {
//        StoreFavorite favorite = favoriteRepository.findByUserIdAndStoreId(userId, storeId)
//                .orElseThrow(() -> new BusinessException("未收藏该门店"));
//        favoriteRepository.delete(favorite);
        favoriteRepository.deleteByUserIdAndStoreId(userId, storeId);
    }

    @Override
    public void setFavoriteStatus(List<StoreDTO> stores, Long userId) {
        // 获取用户收藏的所有门店ID
        Set<Long> favoriteStoreIds = favoriteRepository
            .findStoreIdsByUserId(userId)
            .stream()
            .collect(Collectors.toSet());
        
        // 设置每个门店的收藏状态
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