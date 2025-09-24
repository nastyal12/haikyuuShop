<%@ page import="java.sql.*" %>
<%
String userId = (String) session.getAttribute("user_id");
if (userId == null) {
    out.println("<script>alert('Пожалуйста, войдите в систему.'); location.href='login.jsp';</script>");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("oracle.jdbc.OracleDriver");
    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "아이디", "비밀번호");

    String sql = "SELECT c.product_id, p.product_name, c.quantity, p.price, (c.quantity * p.price) as total " +
                 "FROM cart c JOIN products p ON c.product_id = p.product_id " +
                 "WHERE c.user_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, userId);
    rs = pstmt.executeQuery();

    int grandTotal = 0;
%>
    <table border="1">
        <tr><th>Товар</th><th>Количество</th><th>Цена за шт.</th><th>Итого</th></tr>
<%
    while (rs.next()) {
        String productName = rs.getString("product_name");
        int quantity = rs.getInt("quantity");
        int price = rs.getInt("price");
        int total = rs.getInt("total");
        grandTotal += total;
%>
        <tr>
            <td><%=productName%></td>
            <td><%=quantity%></td>
            <td><%=price%></td>
            <td><%=total%></td>
        </tr>
<%
    }
%>
        <tr>
            <td colspan="3" align="right"><b>Итого:</b></td>
            <td><b><%=grandTotal%></b></td>
        </tr>
    </table>

    <form action="checkout.jsp" method="post">
        <input type="hidden" name="total_price" value="<%=grandTotal%>">
        <input type="submit" value="Оформить заказ">
    </form>
<%
} catch (Exception e) {
    e.printStackTrace();
    out.println("Ошибка загрузки корзины.");
} finally {
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
}
%>
