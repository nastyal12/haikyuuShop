<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
body {
    font-family: Arial, sans-serif;
    background: #f9f9f9;
}

.form-container {
    width: 300px;
    margin: 50px auto;
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background: #fff;
}

.form-container h2 {
    text-align: center;
    margin-bottom: 20px;
}

input[type="text"], 
input[type="password"] {
    width: 100%;
    padding: 8px;
    margin: 10px 0;
    box-sizing: border-box;
    border: 1px solid #ccc;
    border-radius: 3px;
}

button {
    width: 100%;
    padding: 10px;
    background: #333;
    color: white;
    border: none;
    border-radius: 3px;
    cursor: pointer;
    font-size: 14px;
}

.register-button {
    width: 100%;
    margin-top: 10px;
    padding: 10px;
    background: #ddd;
    color: #333;
    border: none;
    border-radius: 3px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    cursor: pointer;
    font-size: 14px;
}

.message {
    margin-top: 10px;
    text-align: center;
}

.message.error {
    color: red;
}

.message.success {
    color: green;
}</style>
</head>
<body>
<jsp:include page="header.jsp" flush="true" />

<div class="login-container">
    <h2>로그인</h2>
<form action=login_check.jsp method="post">
        <label for="username">아이디:</label>
        <input type="text" name="username" id="username" required>

        <label for="password">비밀번호:</label>
        <input type="password" name="password" id="password" required>

        <button type="submit">로그인</button>
    </form>

    <a class="register-button" href="register.jsp">회원가입</a>

    <% 
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <p style="color: red; margin-top: 10px;">아이디 또는 비밀번호가 잘못되었습니다.</p>
    <% } %>
</div>

<jsp:include page="footer.jsp" flush="true" />
</body>
</html>
