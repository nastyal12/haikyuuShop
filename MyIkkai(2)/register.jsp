<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    
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

<div class="register-container">
    <h2>회원가입</h2>

<%
    String result = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        Map<String, String> users = (Map<String, String>) session.getAttribute("users");
        if (users == null) {
            users = new HashMap<>();
            session.setAttribute("users", users);
        }

        if (!password.equals(confirm)) {
            result = "<p style='color:red;'>비밀번호가 일치하지 않습니다.</p>";
        } else if (users.containsKey(username)) {
            result = "<p style='color:red;'>이미 존재하는 아이디입니다.</p>";
        } else {
            users.put(username, password);
            result = "<p style='color:green;'>회원가입 완료! <a href='login.jsp'>로그인 하기</a></p>";
        }
    }
%>

    <form method="post" action="register.jsp">
        <label for="username">아이디:</label>
        <input type="text" name="username" id="username" required>

        <label for="password">비밀번호:</label>
        <input type="password" name="password" id="password" required>

        <label for="confirmPassword">비밀번호 확인:</label>
        <input type="password" name="confirmPassword" id="confirmPassword" required>

        <button type="submit">회원가입</button>
    </form>

    <%= result %>
</div>

<jsp:include page="footer.jsp" flush="true" />

</body>
</html>

</html>