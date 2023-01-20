package com.project.realestate.service;

import com.project.realestate.dto.RealEstateRentListRequest;
import com.project.realestate.dto.RealEstateRentListResponse;
import com.project.realestate.vo.RealEstateRent;

import java.util.List;
import java.util.Map;

public interface RealEstateService {

    public int selectListCount();
    public int selectListCount(Map<String, Object> paramMap);

    public RealEstateRentListResponse selectList(RealEstateRentListRequest req);

    Map<String, Object> selectList(Map<String, Object> paramMap);

    // 자치구 리스트,
   public List<RealEstateRent> searchLocalList();

   // 동 리스트
   public List<String> selectOption(String local);

   public List<String> getSellList();


}
