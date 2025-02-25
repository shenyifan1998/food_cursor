package com.food.repository;

import com.food.entity.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface StoreRepository extends JpaRepository<Store, Long> {
    List<Store> findByCityCode(String cityCode);
    
    @Query(value = "SELECT *, " +
           "ST_Distance_Sphere(point(longitude, latitude), point(?1, ?2)) as distance " +
           "FROM store " +
           "WHERE city_code = ?3 " +
           "HAVING distance <= ?4 " +
           "ORDER BY distance", 
           nativeQuery = true)
    List<Store> findNearbyStores(Double longitude, Double latitude, String cityCode, Double radius);
} 