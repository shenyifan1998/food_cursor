package com.food.entity;

import lombok.Data;
import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
@Table(name = "store")
public class Store {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String address;

    @Column(name = "business_hours")
    private String businessHours;

    @Column(nullable = false)
    private Integer status;

    @Column(name = "supports_takeout")
    private Boolean supportsTakeout;

    @Column(name = "city_code", nullable = false)
    private String cityCode;

    @Column(name = "city_name", nullable = false)
    private String cityName;

    private String phone;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Transient
    private Boolean isFavorite;

    @OneToMany(mappedBy = "store")
    private List<StoreFavorite> favorites;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
} 