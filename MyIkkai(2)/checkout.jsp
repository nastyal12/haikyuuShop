<%@ page import="java.sql.*, java.util.UUID" %>
<%@ include file="dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");
String userId = (String) session.getAttribute("user_id");
if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

int iTotalPrice = Integer.parseInt(request.getParameter("total_price"));
String sOrderUuid = UUID.randomUUID().toString();

PreparedStatement pstmt = null;

try {
    Class.forName("oracle.jdbc.OracleDriver");
    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "아이디", "비밀번호");
    conn.setAutoCommit(false);

    if(iTotalPrice > 0) {
        // Вставляем заказ
        String sqlOrder = "INSERT INTO orders (order_uuid, user_id, order_status, total_price, order_date) VALUES (?, ?, 'NEW', ?, SYSDATE)";
        pstmt = conn.prepareStatement(sqlOrder);
        pstmt.setString(1, sOrderUuid);
        pstmt.setString(2, userId);
        pstmt.setInt(3, iTotalPrice);
        pstmt.executeUpdate();
        pstmt.close();

        // Вставляем позиции заказа
        String sqlItems = "INSERT INTO order_items (order_item_uuid, order_uuid, product_id, quantity, price) " +
                          "SELECT SYS_GUID(), ?, product_id, quantity, " +
                          "(SELECT price FROM products WHERE products.product_id = cart.product_id) " +
                          "FROM cart WHERE user_id = ?";
        pstmt = conn.prepareStatement(sqlItems);
        pstmt.setString(1, sOrderUuid);
        pstmt.setString(2, userId);
        pstmt.executeUpdate();
        pstmt.close();

        // Обновляем количество товара
        String sqlUpdateProduct = "UPDATE products p SET p.product_quantity = p.product_quantity - (" +
                                  "SELECT c.quantity FROM cart c WHERE c.product_id = p.product_id AND c.user_id = ?) " +
                                  "WHERE EXISTS (SELECT 1 FROM cart WHERE product_id = p.product_id AND user_id = ?)";
        pstmt = conn.prepareStatement(sqlUpdateProduct);
        pstmt.setString(1, userId);
        pstmt.setString(2, userId);
        pstmt.executeUpdate();
        pstmt.close();

        // Очищаем корзину
        String sqlClearCart = "DELETE FROM cart WHERE user_id = ?";
        pstmt = conn.prepareStatement(sqlClearCart);
        pstmt.setString(1, userId);
        pstmt.executeUpdate();
        pstmt.close();

        conn.commit();

        out.println("<script>alert('Заказ оформлен успешно!'); location.href='orders.jsp';</script>");
    } else {
        out.println("<script>alert('В корзине нет товаров.'); location.href='cart.jsp';</script>");
    }
} catch(Exception e) {
    if(conn != null) conn.rollback();
    e.printStackTrace();
    out.println("<script>alert('Ошибка оформления заказа'); location.href='cart.jsp';</script>");
} finally {
    if(pstmt != null) pstmt.close();
    if(conn != null) conn.close();
}
%>

