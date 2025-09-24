<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.DecimalFormat" %>
<%@ page import="javax.naming.*, javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품목록 (Product List)</title>
<style>
/* Простые стили для списка продуктов */
.productList {
    list-style: none;
    padding: 0;
}
.productList li {
    border: 1px solid #ddd;
    margin: 10px 0;
    padding: 10px;
    display: flex;
    align-items: center;
}
.productImg img {
    width: 100px;
    height: 100px;
    object-fit: contain;
}
.productName {
    flex: 1;
    margin-left: 15px;
}
.price {
    font-weight: bold;
    color: #c00;
}
</style>
</head>
<body>

<jsp:include page="header.jsp" />
<section>
<jsp:include page="menu.jsp" />
</section>

<section>
<div>
<ul class="productList">
<%
    String sCategoryId = request.getParameter("category_id");
    if (sCategoryId == null || sCategoryId.trim().isEmpty()) {
        out.println("<li><label>카테고리가 선택되지 않았습니다.</label></li>");
    } else {
        DecimalFormat df = new DecimalFormat("###,###");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            // Подключение к БД (зависит от твоей реализации, пример через DataSource)
            Context initContext = new InitialContext();
            DataSource ds = (DataSource)initContext.lookup("jdbc:oracle:thin:@211.210.75.86:1521:XE");
            conn = ds.getConnection();

            String sql = "SELECT product_id, name, price, stock, image_url, image_path FROM products WHERE category_id = ? ORDER BY name ASC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sCategoryId);
            rs = pstmt.executeQuery();

            boolean hasResult = false;
            while (rs.next()) {
                hasResult = true;
                String productId = rs.getString("product_id");
                String name = rs.getString("name");
                int price = rs.getInt("price");
                int stock = rs.getInt("stock");
                String imageUrl = rs.getString("image_url");
                String imagePath = rs.getString("image_path");

                // Выбираем, что использовать для картинки: image_path или image_url
                String imgSrc = (imagePath != null && !imagePath.isEmpty()) ? imagePath : (imageUrl != null ? imageUrl : "./images/no-image.png");
%>
<li>
    <div class="productImg">
        <img src="<%= imgSrc %>" alt="<%= name %>">
    </div>
    <div class="productName">
        <label><%= name %></label><br>
        <small>재고: <%= stock %> 개</small>
    </div>
    <div class="price">
        <label>&#8361; <%= df.format(price) %></label>
    </div>
</li>
<%
            }
            if (!hasResult) {
%>
<li>
    <label>조회된 상품이 없습니다.</label>
</li>
<%
            }
        } catch(Exception e) {
            out.println("<li>상품 조회 중 오류가 발생했습니다.</li>");
            e.printStackTrace();
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
%>
</ul>
</div>
</section>

<section>
<jsp:include page="footer.jsp" />
</section>

</body>
</html>



