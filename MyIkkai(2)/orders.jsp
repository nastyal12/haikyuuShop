<%@ page import="java.sql.*" %>
<%@ include file="dbconn.jsp" %>

<%
String userId = (String) session.getAttribute("user_id");
if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("oracle.jdbc.OracleDriver");
    conn = DriverManager.getConnection("jdbc:oracle:thin:@211.210.75.86:1521:XE", "AT0004", "AT0004");

    String sql = "SELECT order_uuid, order_status, total_price, order_date FROM orders WHERE user_id = ? ORDER BY order_date DESC";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, userId);
    rs = pstmt.executeQuery();
%>

<h2>История заказов</h2>
<table border="1">
    <tr><th>Номер заказа</th><th>Статус</th><th>Сумма</th><th>Дата</th></tr>
<%
    while (rs.next()) {
        String orderUuid = rs.getString("order_uuid");
        String status = rs.getString("order_status");
        int totalPrice = rs.getInt("total_price");
        java.sql.Timestamp orderDate = rs.getTimestamp("order_date");
%>
    <tr>
        <td><%= orderUuid %></td>
        <td><%= status %></td>
        <td><%= totalPrice %></td>
        <td><%= orderDate %></td>
    </tr>
<%
    } // ← закрытие while
%>
</table>

<%
} catch (Exception e) {
    e.printStackTrace();
    out.println("<p>Ошибка при загрузке истории заказов.</p>");
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>

   
