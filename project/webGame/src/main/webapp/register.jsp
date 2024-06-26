<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Game Warrior</title>
    <link rel="stylesheet" href="css/login.css">
    <script>
        $(document).ready(function() {
            $('#checkId').click(function() {
                var id = $('#id').val();
                if (id.trim() === "") {
                    alert("ID를 입력하세요.");
                    return;
                }
                checkDuplicate('id', id);
            });

            $('#checkNickname').click(function() {
                var nickname = $('#nickname').val();
                if (nickname.trim() === "") {
                    alert("닉네임을 입력하세요.");
                    return;
                }
                checkDuplicate('nickname', nickname);
            });

            $('#checkEmail').click(function() {
                var email = $('#userid').val() + "@" + $('#emailDomain').val();
                if ($('#emailDomain').val() === "other") {
                    email = $('#userid').val() + "@" + $('#otherDomain').val();
                }
                if (email.trim() === "") {
                    alert("이메일을 입력하세요.");
                    return;
                }
                checkDuplicate('email', email);
            });

            function checkDuplicate(field, value) {
                $.post('CheckDuplicateFieldServlet', { field: field, value: value }, function(response) {
                    if (response === "DUPLICATE") {
                        alert(field + "가 중복됩니다.");
                    } else {
                        alert(field + "를 사용할 수 있습니다.");
                    }
                });
            }

            $('#emailDomain').change(function() {
                if ($(this).val() === "other") {
                    $('#otherDomain').show().attr('required', true);
                } else {
                    $('#otherDomain').hide().attr('required', false);
                }
            });
        });
    </script>
</head>
<body>
    <div class="login-container">
        <div class="header">
            <a class="site-logo" href="index.jsp">
                <img src="img/logo.png" alt="Game Warrior Logo">
            </a>
        </div>
        <div class="login-form">
            <h2>Register</h2>
            <form id="registerForm" method="post" action="UserServlet">
                <div class="input-group">
                    <label for="nickname">Nickname</label> 
                    <input type="text" id="nickname" name="nickname" required>
                    <button type="button" id="checkNickname">중복 검사</button>
                </div>
                <div class="input-group">
                    <label for="id">ID</label> 
                    <input type="text" id="id" name="id" required>
                    <button type="button" id="checkId">중복 검사</button>
                </div>
                <div class="input-group">
                    <label for="email">Email</label>
                    <div class="email-input">
                        <input type="text" id="userid" name="userid" placeholder="Username" required> 
                        <span>@</span> 
                        <select id="emailDomain" name="emailDomain" onchange="checkOther()">
                            <option value="gmail.com">gmail.com</option>
                            <option value="naver.com">naver.com</option>
                            <option value="hanmail.net">hanmail.net</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    <input type="text" id="otherDomain" name="otherDomain" placeholder="Other Domain" style="display: none;">
                    <button type="button" id="checkEmail">중복 검사</button>
                </div>
                <div class="input-group">
                    <label for="password">Password</label> 
                    <input type="password" id="password" name="password" required>
                </div>
                <!-- Hidden input으로 pagecode부분 -->
                <input type="hidden" name="pagecode" value="register">
                <button type="submit" class="btn">Register</button>
                <p>
                    Already have an account? <a href="login.jsp">Login</a>
                </p>
            </form>
        </div>
    </div>
</body>
</html>
