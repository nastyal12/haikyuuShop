<%@page import="java.text.DecimalFormat"%> 
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ include file="dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
<div class="footer" style="background:#333; padding:15px; color:#fff; position:fixed; bottom:0; width:100%; box-sizing:border-box; z-index:999;">
  <div class="cartList" style="max-height:120px; overflow-y:auto; margin-bottom:10px;">
    <ul style="list-style:none; padding:0; margin:0; display:flex; gap:10px;">
    <%
    String userId = (String) session.getAttribute("userId");
    if(userId == null) {
        userId = ""; // или сделайте перенаправление, если нужно
    }

      long totalPrice = 0;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      try {
          String sql = "SELECT c.cart_id, c.quantity, p.product_name, p.product_price " +
                       "FROM cart c INNER JOIN product p ON c.product_id = p.product_id " +
                       "WHERE c.user_id = ? ORDER BY c.cart_id ASC";
          pstmt = conn.prepareStatement(sql);
          pstmt.setString(1, userId);
          rs = pstmt.executeQuery();

          boolean hasItems = false;
          while(rs.next()) {
              hasItems = true;
              int quantity = rs.getInt("quantity");
              long price = rs.getLong("product_price") * quantity;
              totalPrice += price;
              String productName = rs.getString("product_name");
              String cartId = rs.getString("cart_id");
    %>
      <li style="background:#444; padding:8px; border-radius:5px; display:flex; align-items:center;">
        <div style="flex-grow:1;">
          <div style="font-weight:bold; font-size:14px;"><%= productName %></div>
          <div style="font-size:12px; color:#ccc;">수량: <%= quantity %></div>
        </div>
        <div style="color:#ff5555; cursor:pointer; font-weight:bold;" onclick="delCart('<%=cartId%>');">X</div>
      </li>
    <%
          }
          if(!hasItems) {
    %>
      <li style="text-align:center; width:100%; color:#bbb;">장바구니가 비어있습니다.</li>
    <%
          }
      } catch(Exception e) {
          out.println("<li style='color:red;'>오류 발생: " + e.getMessage() + "</li>");
      } finally {
          if(rs != null) rs.close();
          if(pstmt != null) pstmt.close();
      }
    %>
    </ul>
  </div>

  <div class="amount" style="display:flex; justify-content:space-between; align-items:center;">
    <div class="lblPayTxt" style="font-size:16px; font-weight:bold;">
      총결제금액:
    </div>
    <div class="lblPayAmountTxt" style="font-size:18px; font-weight:bold; color:#FFA500;">
      &#8361; <%= totalPrice %>
    </div>
    <div class="lblPayCancel" style="cursor:pointer; color:#FFA500;" onclick="delCartAll();">
      전체취소
    </div>
    <div class="pay" onclick="processPayment()" style="background:#FFA500; color:#333; padding:8px 16px; border-radius:5px; font-weight:bold; cursor:pointer; user-select:none;">
      결제
    </div>
  </div>
</div>

<script>
function delCart(cartId) {
    var frm = document.getElementById("frmCartDel");
    frm.processType.value = "P";  // Удаление одного товара
    frm.cartId.value = cartId;
    frm.submit();
}
function delCartAll() {
    var frm = document.getElementById("frmCartDel");
    frm.processType.value = "A";  // Удаление всех товаров
    frm.submit();
}
function processPayment() {
    if(confirm("결제 하시겠습니까?")) {
        var frm = document.getElementById("frmPay");
        frm.submit();
    }
}
</script>



</body>
</html>
