package com.food.service.impl;

import com.food.dto.CityDTO;
import com.food.dto.CityGroupDTO;
import com.food.entity.City;
import com.food.repository.CityRepository;
import com.food.repository.HotCityRepository;
import com.food.service.CityService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CityServiceImpl implements CityService {
    private final CityRepository cityRepository;
    private final HotCityRepository hotCityRepository;

    @Override
    @Transactional(readOnly = true)
    public CityGroupDTO getCityGroups() {
        CityGroupDTO groupDTO = new CityGroupDTO();
        
        // 获取热门城市
        List<CityDTO> hotCities = hotCityRepository.findHotCitiesOrdered()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        // 获取所有城市（按拼音排序）
        List<CityDTO> allCities = cityRepository.findAllByOrderByNameAsc()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        groupDTO.setHotCities(hotCities);
        groupDTO.setAllCities(allCities);
        
        return groupDTO;
    }

    private CityDTO convertToDTO(City city) {
        CityDTO dto = new CityDTO();
        dto.setCode(city.getCode());
        dto.setName(city.getName());
        dto.setProvinceCode(city.getProvinceCode());
        return dto;
    }
} 