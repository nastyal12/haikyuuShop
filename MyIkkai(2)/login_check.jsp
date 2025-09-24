<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("UTF-8");

String username = request.getParameter("username");
String password = request.getParameter("password");

out.println("username: " + username + "<br>");
out.println("password: " + password + "<br>");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("oracle.jdbc.OracleDriver");
    conn = DriverManager.getConnection("jdbc:oracle:thin:@211.210.75.86:1521:XE", "AT0004", "AT0004");

    String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, username);
    pstmt.setString(2, password);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        session.setAttribute("user_id", username);
        response.sendRedirect("product.jsp");
    } else {
        response.sendRedirect("login.jsp?error=1");
    }

} catch (Exception e) {
    e.printStackTrace(new java.io.PrintWriter(out));
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>

