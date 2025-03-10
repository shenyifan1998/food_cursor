package com.food.repository;

import com.food.entity.Menu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MenuRepository extends JpaRepository<Menu, Long> {
    @Query("SELECT m FROM Menu m WHERE m.leftSideMenuId = :leftSideMenuId ORDER BY m.orderNum")
    List<Menu> findByLeftSideMenuId(@Param("leftSideMenuId") Long leftSideMenuId);
    
    @Query("SELECT m FROM Menu m JOIN m.leftSideMenu lsm WHERE lsm.type = :menuType ORDER BY m.orderNum")
    List<Menu> findByMenuType(@Param("menuType") String menuType);

    @Query("SELECT m FROM Menu m WHERE m.leftSideMenuId IN :menuIds ORDER BY m.orderNum")
    List<Menu> findByLeftSideMenuIdIn(@Param("menuIds") List<Long> menuIds);
} 