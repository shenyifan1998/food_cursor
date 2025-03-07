package com.food.entity;

import lombok.Data;
import javax.persistence.*;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "left_side_menu")
public class LeftSideMenu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type;

    @Column(name = "type_name", nullable = false)
    private String typeName;

    @Column(name = "order_num", nullable = false)
    private Integer orderNum;

    @Column(name = "create_time", nullable = false, updatable = false)
    private LocalDateTime createTime;

    @PrePersist
    protected void onCreate() {
        createTime = LocalDateTime.now();
    }
} 