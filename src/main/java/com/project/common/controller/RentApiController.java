package com.project.common.controller;

import com.project.client.seoulApi.ApiTemplate;
import com.project.common.dto.RentHouseDto;
import com.project.common.service.RentHouseService;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.util.List;


@Controller
@Log4j
public class RentApiController {

    private RentHouseService rentHouseService;
    private ApiTemplate apiTemp;

    @Autowired
    public RentApiController(RentHouseService rentHouseService){
        this.rentHouseService = rentHouseService;
    }

    @GetMapping("/openApi")
    public void searchInfo(Model model) throws ParserConfigurationException, SAXException, IOException {

        log.info("파싱 스타트 체크");

        ApiTemplate apiTemp = new ApiTemplate();

        //파싱하여 리턴한 데이터 값들을 list에 담아주기 위해 사용
        List<RentHouseDto> list = apiTemp.parsingData();

        //List에 담겨있는 정보들을 db에 넣기 위해서 사용
        for (RentHouseDto dataDto : list) {

            rentHouseService.insertData(dataDto);

        }

        model.addAttribute("houseList", rentHouseService.houseList());

        log.info("파싱 정보 입력끝");
    }


}
