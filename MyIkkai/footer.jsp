<%@page import="java.text.DecimalFormat"%> 
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp" %>
<%@ include file="dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<% 

StringBuffer keySql = new StringBuffer();
keySql.append("SELECT SYS_GUID() AS UUID FROM DUAL");
StringBuffer totPriceSelSql = new StringBuffer();
totPriceSelSql.append("/* paySave -TotalPriceSql */\n");
totPriceSelSql.append("select sum(b.\"product_price\" * a.\"quantity\") as \"tot_price\"\n");
totPriceSelSql.append("TOT_PRICE\n");
totPriceSelSql.append(" FROM 장바구니 A\n");
totPriceSelSql.append(" INNER JOIN 상품 B\n");
totPriceSelSql.append("    on a.\"product_uuid\" = b.\"product_uuid\"\n");
totPriceSelSql.append("where a.\"shop_uuid\" = ?\n");
totPriceSelSql.append("  and a.\"shop_device_id\" = ?\n");
totPriceSelSql.append("group by a.\"shop_uuid\", a.\"shop_device_id\"\n");

if(iTotalPrice > 0) { // 합계 금액이 0이상일때
	StringBuffer masterInsSql = new StringBuffer();
	masterInsSql.append("/* paySave - masterInsertSql */\n");
	masterInsSql.append("INSERT INTO 주문 ( \n");
	  masterInsSql.append("(\"shop_uuid\", \"order_uuid\", \"order_status\", \"tot_price\", \"reg_dt\")\n");   
	  masterInsSql.append(" ) VALUES (\n");
	  masterInsSql.append(" ?, ?, 'PC', ?, SYSDATE)\n"); // Pay Complete
	  System.out.println(masterInsSql.toString());
	  
	  pstmt = conn.prepareStatement(masterInsSql.toString());
	  pstmt.setString(1, sShopUuid);
	  pstmt.setString(2, sOrderUuid);
	  pstmt.setInt(3, iTotalPrice);
	  iMasterResult = pstmt.executeUpdate();
	  } else {
	  out.println("<script>alert('선택된 상품이 없습니다.');history.go (-1);</script>");
	  }
StringBuffer itemInsSql = new StringBuffer();
itemInsSql.append("/* paySave - itemInsertSql */\n");
itemInsSql.append("INSERT INTO 주문_아이템 ( \n");
itemInsSql.append("    \"order_item_uuid\", \"shop_uuid\", \"order_uuid\", \"product_uuid\",\n");
itemInsSql.append("    \"drink_temp\", \"quantity\", \"price\", \"reg_dt\")\n");
itemInsSql.append("select sys_guid(), a.\"shop_uuid\", ?, a.\"product_uuid\",\n");
itemInsSql.append("       a.\"drink_temp\", a.\"quantity\", b.\"product_price\", sysdate\n");
itemInsSql.append(" FROM 장바구니 A\n");
itemInsSql.append(" INNER JOIN 상품 B\n");
itemInsSql.append("    on a.\"product_uuid\" = b.\"product_uuid\"\n");
itemInsSql.append("where a.\"shop_uuid\" = ?\n");
itemInsSql.append("  and a.\"shop_device_id\" = ?\n");


    StringBuffer productUpdateSql = new StringBuffer();
    productUpdateSql.append("UPDATE 상품 a \n");
    productUpdateSql.append("set a.\"product_quantity\" = a.\"product_quantity\" - (\n");
    productUpdateSql.append("    select b.\"quantity\"\n");
    productUpdateSql.append(" FROM 장바구니 b\n");
    productUpdateSql.append("    where b.\"shop_uuid\" = ?\n");
    productUpdateSql.append("      and b.\"shop_device_id\" = ?\n");
    productUpdateSql.append("      and a.\"product_uuid\" = b.\"product_uuid\"\n");
    productUpdateSql.append(" )\n");
    productUpdateSql.append(" WHERE EXISTS (\n");
    productUpdateSql.append(" SELECT 1\n");
    productUpdateSql.append(" FROM 장바구니 B\n");
    productUpdateSql.append("    where b.\"shop_uuid\" = ?\n");
    productUpdateSql.append("      and b.\"shop_device_id\" = ?\n");
    productUpdateSql.append("      and a.\"product_uuid\" = b.\"product_uuid\"\n");
    productUpdateSql.append(" )\n");
    
    StringBuffer cartDelSql = new StringBuffer();
    cartDelSql.append("/* paySave - cartDelSql */\n");
    cartDelSql.append("DELETE FROM 장바구니 \n");
    cartDelSql.append("where \"shop_uuid\" = ?\n");
    cartDelSql.append("  and \"shop_device_id\" = ?\n");
    System.out.println(cartDelSql.toString());



%>
<script>
function delCart(cartUuid) {
    var frm = document.getElementById("frmCartDel");
    frm.processType.value = "P";
    frm.cartUuid.value = cartUuid;  // Исправлено на значение, а не переменную
    frm.submit();
}
function delCartAll() {
	var frm = document.getElementById("frmCartDel");
	frm.processType.value = "A";
	frm.submit();
	}

function processPayment() {
    if(confirm("결제 하시겠습니까?")) {
        var frm = document.getElementById("frmPay");
        frm.submit();
    }
}
</script>
</head>
<body>
<%
DecimalFormat df = new DecimalFormat("###,###");
String sCategoryCd = request.getParameter("categoryCd");
%>
<form id="frmCartDel" name="frmCartDel" method="post" action="cartDel.jsp">
    <input type="hidden" id="shopDeviceId" name="shopDeviceId" value="<%=sShopDeviceId%>">
    <input type="hidden" id="categoryCd" name="categoryCd" value="<%=sCategoryCd%>">
    <input type="hidden" id="cartUuid" name="cartUuid" value="">
    <input type="hidden" id="processType" name="processType" value="">
</form>
<form id="frmPay" name="frmPay" method="post" action="paySave.jsp">
</form>
<div class="footer">
<div class="cartList">
<ul>
<%
long lTotPrice = 0;
ResultSet rs = null;
PreparedStatement pstmt = null;
try {
    StringBuffer sql = new StringBuffer();
    sql.append("select a.\"cart_uuid\", a.\"shop_device_id\", a.\"shop_uuid\", a.\"product_uuid\"\n");
    sql.append("     , a.\"quantity\", a.\"drink_temp\"\n");
    sql.append("     , b.\"category_cd\", b.\"product_name\", b.\"product_price\"\n");
    sql.append(" FROM 장바구니 a\n");
    sql.append(" INNER JOIN 상품 b\n");
    sql.append("    on a.\"product_uuid\" = b.\"product_uuid\"\n");
    sql.append("where a.\"shop_uuid\" = ?\n");
    sql.append("  and a.\"shop_device_id\" = ?\n");
    sql.append("order by a.\"reg_dt\" asc\n");
    System.out.println(sql.toString());
    
    pstmt = conn.prepareStatement(sql.toString());
    pstmt.setString(1, sShopUuid);
    pstmt.setString(2, sShopDeviceId);
    rs = pstmt.executeQuery();
    int iResult = 0;
    while (rs.next()) {
        lTotPrice += rs.getLong("PRODUCT_PRICE");
        String sCartUuid = rs.getString("CART_UUID");
%>
<li>
    <div class="cartProduct">
        <div class="cartProductImg"><img src="./images/coffee_png1.png"></div>
<div class="cartProductDel" onclick="delCart('<%=sCartUuid%>');"> <label style="cursor: pointer;"> X</label></div>
    </div>
</li>
<%
iResult++;
} // end While
if(iResult == 0) {
%>
<li>
    <div class="cartProduct">
        <div class="cartProductImg"><img src="./images/coffee_png1.png"></div>
    </div>
</li>
<%
}
} catch (SQLException ex) {
    out.println("Product 테이블 호출이 실패했습니다.<br>");
    out.println("SQLException: " + ex.getMessage());
} finally {
    if (rs != null)
        rs.close();
    if (pstmt != null)
        pstmt.close();
    if (conn != null)
        conn.close();
}
%>
</ul>
</div>
<!-- 하단 결제 버튼 -->
<div class="amount">
<div class="lblPayTxt" style="">
    <label style="width:100%; color:#FFF200">총결제금액</label>
</div>
<div class="lblPayAmountTxt">
    <label id="amountLbl">&#8361; <%=df.format(lTotPrice)%></label>
</div>
<div class="lblPayCancel">
    <label style="width:100%; color: #FFFA99; cursor: pointer;" onclick="delCartAll();">
    전체취소</label>
</div>
</div>
<!-- 하단 결제 버튼 -->
<div class="pay" onclick="processPayment()">
    <label>결제</label>
</div>
</div>
</body>
</html>
