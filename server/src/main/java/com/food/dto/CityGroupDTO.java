package com.food.dto;

import lombok.Data;
import java.util.List;

@Data
public class CityGroupDTO {
    private List<CityDTO> hotCities;
    private List<CityDTO> allCities;
} 