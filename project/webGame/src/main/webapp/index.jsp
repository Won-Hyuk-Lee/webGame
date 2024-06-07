<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="User.UserVO" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
    // 세션 변수를 중복 선언하지 않도록 기존 세션이 있는지 확인하고 가져옵니다.
    HttpSession currentSession = request.getSession(false);
    UserVO user = null;
    if (currentSession != null) {
        user = (UserVO) currentSession.getAttribute("user");
    }
    System.out.println(user);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Game Warrior Template</title>
    <meta charset="UTF-8">
    <meta name="description" content="Game Warrior Template">
    <meta name="keywords" content="warrior, game, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 파비콘 -->
    <link href="img/favicon.ico" rel="shortcut icon"/>

    <!-- 구글 폰트 -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,400i,500,500i,700,700i" rel="stylesheet">

    <!-- 스타일시트 -->
    <link rel="stylesheet" href="css/bootstrap.min.css"/>
    <link rel="stylesheet" href="css/font-awesome.min.css"/>
    <link rel="stylesheet" href="css/owl.carousel.css"/>
    <link rel="stylesheet" href="css/style.css"/>
    <link rel="stylesheet" href="css/animate.css"/>

    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
    <!-- 페이지 프리로더 -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- 헤더 섹션 -->
    <header class="header-section">
        <div class="container">
            <!-- 로고 -->
            <a class="site-logo" href="index.jsp">
                <img src="img/logo.png" alt="">
            </a>
            <div class="user-panel">
                <% if (user != null) { %>
                    <a href="UserServlet?action=logout">로그아웃</a>
                <% } else { %>
                    <a href="login.jsp">로그인</a> / <a href="register.jsp">회원가입</a>
                <% } %>
            </div>
            <!-- 반응형 메뉴 -->
            <div class="nav-switch">
                <i class="fa fa-bars"></i>
            </div>
            <!-- 사이트 메뉴 -->
            <nav class="main-menu">
                <ul>
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="document.html">Document</a></li>
                    <li><a href="pageinfo.html">PageInfo</a></li>
                    <li><a href="contact.html">Contact</a></li>
                    <% if (user != null) { %>
                        <li><a href="UserServlet?action=mypage">마이페이지</a></li>
                        <li><a href="UploadServlet?pagecode=contactMove">게임등록</a></li>
                    <% } %>

                </ul>
            </nav>
        </div>
    </header>
    <!-- 헤더 섹션 끝 -->

    <!-- 페이지 정보 섹션 -->
    <section class="page-info-section set-bg" data-setbg="img/page-top-bg/3.jpg">
        <div class="pi-content">
            <div class="container">
                <div class="row">
                    <div class="col-xl-5 col-lg-6 text-white">
                        <h2>게임 리뷰</h2>
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec malesuada lorem maximus mauris scelerisque, at rutrum nulla dictum.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- 페이지 정보 섹션 끝 -->

 <!-- 페이지 섹션 -->
<section class="page-section review-page spad">
    <div class="container">
        <div class="row" id="gameList">
            <!-- 게임 목록은 JavaScript에서 동적으로 추가될 예정입니다. -->
        </div>
    </div>
</section>
<!-- 페이지 섹션 끝 -->

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $.ajax({
        method: 'POST',
        url: '<%= request.getContextPath() %>/GameServlet?pagecode=gameTableAll',
        success: function(response) {
            console.log(response);
            var myval_obj = JSON.parse(response);

            var gameListHtml = ""; // gameListHtml 변수를 반복문 외부에 선언

            myval_obj.forEach(function(item) {
                var webGL = item["webGL"];
                var gameName = item["gameName"];
                var contents = item["contents"];
                var grade = item["grade"];
                var updated_date = item["updated_date"];
                var user_seq = item["user_seq"];

                var clickHandler = function(webGL) {
                    return function() {
                        redirectToCommunity(webGL);
                    };
                };

                gameListHtml += '<div class="col-md-6">' +
                '<div class="review-item">' +
                '<img class="review-cover" src="img/gameLogo/'+webGL+'.png" data-webgl="' + webGL + '">' +
                '<div class="review-text">' +
                '<h4>' + gameName + '</h4>' +
                '<div class="rating">' +
                '<i class="fa fa-star"></i>' +
                '<i class="fa fa-star"></i>' +
                '<i class="fa fa-star"></i>' +
                '<i class="fa fa-star"></i>' +
                '<i class="fa fa-star is-fade"></i>' +
                '</div>' +
                '<p>' + contents + '</p>' +
                '</div>' +
                '</div>' +
                '</div>';


            });

            // 생성된 HTML을 게임 목록에 추가
            $("#gameList").append(gameListHtml);

            $(".review-cover").click(function() {
                var webGL = $(this).attr('data-webgl');
                redirectToCommunity(webGL);
            });
        },
        error: function(xhr, status, error) {
            console.error(xhr.responseText);
        }
    });
});

</script>
 

<script>
    // 커뮤니티 페이지로 리다이렉트하는 함수
    function redirectToCommunity(webGLName) {
        var url = '<%= request.getContextPath() %>/GameServlet?webGLName=' + encodeURIComponent(webGLName);
        window.location.href = url;
    }
</script>

    <!--====== 자바스크립트 및 제이쿼리 ======-->
    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/owl.carousel.min.js"></script>
    <script src="js/jquery.marquee.min.js"></script>
    <script src="js/main.js"></script>
</body>
</html>
