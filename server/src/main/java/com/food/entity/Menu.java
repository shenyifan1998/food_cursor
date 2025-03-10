package com.food.entity;

import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "menu")
public class Menu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "left_side_menu_id", nullable = false)
    private Long leftSideMenuId;
    
    @Column(name = "menu_name", nullable = false)
    private String menuName;
    
    @Column(nullable = false)
    private String money;
    
    @Column(name = "order_num", nullable = false)
    private Integer orderNum;
    
    @Column(name = "create_time", nullable = false, updatable = false)
    private LocalDateTime createTime;
    
    @Column(name = "explain")
    private String explain;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "left_side_menu_id", insertable = false, updatable = false)
    private LeftSideMenu leftSideMenu;
    
    @PrePersist
    protected void onCreate() {
        createTime = LocalDateTime.now();
    }
} 