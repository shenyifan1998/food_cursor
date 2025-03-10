package com.food.repository;

import com.food.entity.LeftSideMenu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface LeftSideMenuRepository extends JpaRepository<LeftSideMenu, Long> {
    @Query("SELECT l FROM LeftSideMenu l ORDER BY l.orderNum")
    List<LeftSideMenu> findAll();

    List<LeftSideMenu> findByType(String type);
}