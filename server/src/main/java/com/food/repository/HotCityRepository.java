package com.food.repository;

import com.food.entity.City;
import com.food.entity.HotCity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface HotCityRepository extends JpaRepository<HotCity, String> {
    @Query("SELECT c FROM City c JOIN HotCity h ON c.code = h.cityCode ORDER BY h.sortOrder")
    List<City> findHotCitiesOrdered();
} 