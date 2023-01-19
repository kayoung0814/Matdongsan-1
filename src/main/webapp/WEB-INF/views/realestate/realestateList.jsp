<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="list" value="${map.list}"/>
<c:set var="pi" value="${map.pi}"/>
<c:set var="l" value="${localList}"/>
<c:set var="r" value="com.project.common.vo.RealEstateRent"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<c:url value="/resources/css/realeatate/realestateList.css"/>">
    <script src="https://kit.fontawesome.com/2e05403237.js" crossorigin="anonymous"></script>
    <title>부동산</title>
</head>
<body>
<div id="content">
    <div id="content_left">
        <form name="searchArea" action="">
            <div id="search_box">
                <div class ="search city">
                    <select name="condition" onchange="changeLocation(this)">
                        <option value="0">자치구 선택</option>
                        <c:forEach var="l" items="${localList}">
                            <option value="${l.sggCd}">${l.sggNm}</option>
                        </c:forEach>
                    </select>
                    <select name="dong">
                        <option value="0">동 선택</option>

                    </select>
                </div>
                <div class ="search option">
                    <select>
                        <option value="">전/월세</option>
                        <option value="a">전세</option>
                        <option value="b">월세</option>
                    </select>
                    <select>

                    </select>
                    <select>평수</select>
                </div>
                <div class="btn_box">
                    <button type="submit">조회</button>
                </div>
            </div>
        </form>
        <div id="place">

        </div>
    </div>
    <div id="content_right">
        <div id="search_map">

        </div>
        <div id="search_list">
            <table class="table">
                <tr>
                    <th>자치구명</th>
                    <th>아파트명</th>
                    <th>전/월세</th>
                    <th>보증금</th>
                    <th>임대면적</th>
                </tr>
                <c:forEach var="r" items="${ list }">
                    <tr>
                        <td class="rno">${ r.sggNm }</td>
                        <td>${r.buildName }</td>
                        <td>${r.rentGbn }</td>
                        <td>${r.rentGtn}</td>
                        <td>${r.rentArea }</td>
                    </tr>
                </c:forEach>

            </table>
        </div>

        <div id="paging">
            <c:set var="url" value="?currentPage="/>
            <ul class="pagination">
                <c:choose>
                <c:when test="${pi.currentPage eq 1 }">
                <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                </c:when>
                <c:otherwise>
                <li class="page-item"><a class="page-link" href="${url}${pi.currentPage-1 }${sUrl}">Previous</a></li>
                </c:otherwise>
                </c:choose>

                <c:forEach var="item" begin="${pi.startPage }" end="${pi.endPage }">
                <li class="page-item"><a class="page-link" href="${url}${item }${sUrl}">${item }</a></li>
                </c:forEach>

                <c:choose>
                <c:when test="${pi.currentPage eq pi.maxPage }">
                <li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
                </c:when>
                <c:otherwise>
                <li class="page-item"><a class="page-link" href="${url}${pi.currentPage+1 }${sUrl}">Next</a></li>
                </c:otherwise>
                </c:choose>
        </div>
    </div>
</div>

<%--검색 동 변경--%>
<script>
    function changeLocation(e){
        $.ajax({
            type: 'GET',
            url: '/' + option1,
            contentType: "application/json; charset=UTF-8",
            dataType: 'json',
            success: function (result) {
                console.log(result)
                for (i = 0; i < result.length; i++) {
                    selectOption.options[i] = new Option(result[i], i);
                }
            }
        }).fail(function (error) {
            alert(JSON.stringify(error));
        })
    }
</script>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=035c35f196fa7c757e49e610029837b1"></script>
<script>
    const container = document.getElementById('search_map'); //지도를 담을 영역의 DOM 레퍼런스
    let options = { //지도를 생성할 때 필요한 기본 옵션
        center: new kakao.maps.LatLng(37.566826, 126.9786567), //지도의 중심좌표.
        level: 3 //지도의 레벨(확대, 축소 정도)
    };
    let map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

    // HTML5의 geolocation으로 사용할 수 있는지 확인
    if (navigator.geolocation) {

        // GeoLocation을 이용해서 접속 위치를 얻어옵니다
        navigator.geolocation.getCurrentPosition(function(position) {

            var lat = position.coords.latitude, // 위도
                lon = position.coords.longitude; // 경도

            var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성
                message = '<div style="padding:5px;">현재 위치</div>'; // 인포윈도우에 표시될 내용

            // 마커와 인포윈도우를 표시
            displayMarker(locPosition, message);

        });

    } else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정

        var locPosition = new kakao.maps.LatLng(37.566826, 126.9786567),
            message = 'geolocation을 사용할수 없어요..'

        displayMarker(locPosition, message);
    }

    // 지도에 마커와 인포윈도우를 표시하는 함수
    function displayMarker(locPosition, message) {

        // 마커를 생성합니다
        var marker = new kakao.maps.Marker({
            map: map,
            position: locPosition
        });

        var iwContent = message, // 인포윈도우에 표시할 내용
            iwRemoveable = true;

        // 인포윈도우를 생성합니다
        var infowindow = new kakao.maps.InfoWindow({
            content : iwContent,
            removable : iwRemoveable
        });

        // 인포윈도우를 마커위에 표시
        infowindow.open(map, marker);

        // 지도 중심좌표를 접속위치로 변경
        map.setCenter(locPosition);
    }
</script>

</body>
</html>