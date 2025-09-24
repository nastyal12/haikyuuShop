<%@ page import="java.sql.*" %>
<%
String userId = (String) session.getAttribute("user_id");
String productId = request.getParameter("product_id");

if (userId == null) {
    out.println("<script>alert('Сначала войдите в систему.'); location.href='login.jsp';</script>");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("oracle.jdbc.OracleDriver");
    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "아이디", "비밀번호");

    // Проверим, есть ли уже такой товар в корзине
    String checkSql = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
    pstmt = conn.prepareStatement(checkSql);
    pstmt.setString(1, userId);
    pstmt.setInt(2, Integer.parseInt(productId));
    rs = pstmt.executeQuery();

    if (rs.next()) {
        // Обновим количество
        int quantity = rs.getInt("quantity") + 1;
        pstmt.close();
        String updateSql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setInt(1, quantity);
        pstmt.setString(2, userId);
        pstmt.setInt(3, Integer.parseInt(productId));
        pstmt.executeUpdate();
    } else {
        // Вставим новую запись
        pstmt.close();
        String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, 1)";
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, userId);
        pstmt.setInt(2, Integer.parseInt(productId));
        pstmt.executeUpdate();
    }

    out.println("<script>alert('Товар добавлен в корзину!'); location.href='products.jsp';</script>");
} catch (Exception e) {
    e.printStackTrace();
    out.println("Произошла ошибка при добавлении в корзину.");
} finally {
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
}
%>


