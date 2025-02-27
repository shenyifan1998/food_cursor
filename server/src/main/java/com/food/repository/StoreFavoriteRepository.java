package com.food.repository;

import com.food.entity.StoreFavorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface StoreFavoriteRepository extends JpaRepository<StoreFavorite, Long> {
    List<StoreFavorite> findByUserId(Long userId);
    
    boolean existsByUserIdAndStoreId(Long userId, Long storeId);
    
    @Transactional
    void deleteByUserIdAndStoreId(Long userId, Long storeId);
    
    @Query("SELECT sf.storeId FROM StoreFavorite sf WHERE sf.userId = :userId")
    List<Long> findStoreIdsByUserId(@Param("userId") Long userId);
} 