<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat" %>

<%
    String categoryCd = request.getParameter("categoryCd");
    if (categoryCd == null) {
    	categoryCd = "01"; // значение по умолчанию, например "MANGA"
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="styles.css">
    <title>상품 목록</title>
</head>
<body>

<!-- Хедер -->
<jsp:include page="header.jsp" flush="true" />

<!-- Меню -->
<jsp:include page="menu.jsp" flush="true" />

<!-- Секция с продуктами -->
<section>
  <div class="product-wrapper">
       <ul class="productList">
    <% if ("01".equals(categoryCd)) { %>
        <!-- MANGA -->
        <li>
            <div class="item-container">
                <div class="productImg">
                    <img src="./images/manga.jpg" alt="Manga 1" />
                </div>
                <div class="productName"><label>Haikyuu Manga Vol.1</label></div>
                <div class="price"><label>&#8361; 15,500</label></div>
            </div>
            </li>
            <li>
            <div class="item-container">
                <div class="productImg">
                    <img src="./images/manga2.jpg" alt="Manga 2" />
                </div>
                <div class="productName"><label>Haikyuu Manga Vol.2</label></div>
                <div class="price"><label>&#8361; 15,500</label></div>
            </div>
            </li>
            <li>
               <div class="item-container">
                <div class="productImg">
                    <img src="./images/manga2.jpg" alt="Manga 2" />
                </div>
                <div class="productName"><label>Haikyuu Manga Vol.3</label></div>
                <div class="price"><label>&#8361; 15,500</label></div>
            </div>
            </li>
            <li>
            
               <div class="item-container">
                <div class="productImg">
                    <img src="./images/manga2.jpg" alt="Manga 2" />
                </div>
                <div class="productName"><label>Haikyuu Manga Vol.4</label></div>
                <div class="price"><label>&#8361; 15,500</label></div>
            </div>
            </li>
            <li>
               <div class="item-container">
                <div class="productImg">
                    <img src="./images/manga2.jpg" alt="Manga 2" />
                </div>
                <div class="productName"><label>Haikyuu Manga Vol.5</label></div>
                <div class="price"><label>&#8361; 15,500</label></div>
            </div>
            </li>
            <li>
               <div class="item-container">
                <div class="productImg">
                    <img src="./images/manga2.jpg" alt="Manga 2" />
                </div>
                <div class="productName"><label>Haikyuu Manga Vol.6</label></div>
                <div class="price"><label>&#8361; 15,500</label></div>
            </div>
        </li>
        <li>
            <div class="item-container">
                <div class="productImg">
                    <img src="./images/manga.jpg" alt="Manga 2" />
                </div>
                <div class="productName"><label>Haikyuu Manga Vol.7</label></div>
                <div class="price"><label>&#8361; 15,500</label></div>
            </div>
        </li>
    <% } else if ("02".equals(categoryCd)) { %>
        <!-- TOYS -->
        <li>
            <div class="item-container">
                <div class="productImg">
                    <img src="./images/toys1.jpg" alt="Toy 1" />
                </div>
                <div class="productName"><label>Hinata Figure</label></div>
                <div class="price"><label>&#8361; 25,000</label></div>
            </div>
        </li>
        <li>
            <div class="item-container">
                <div class="productImg">
                    <img src="./images/toys2.jpg" alt="Toy 2" />
                </div>
                <div class="productName"><label>Kageyama Figure</label></div>
                <div class="price"><label>&#8361; 25,000</label></div>
            </div>
            </li>
            <li>
                        <div class="item-container">
                <div class="productImg">
                    <img src="./images/toyscouple.jpg" alt="Toy 2" />
                </div>
                <div class="productName"><label>Kageyama & Hinata</label></div>
                <div class="price"><label>&#8361; 25,000</label></div>
            </div>
            </li>
            <li>
                        <div class="item-container">
                <div class="productImg">
                    <img src="./images/toy.jpg" alt="Toy 2" />
                </div>
                <div class="productName"><label>Random</label></div>
                <div class="price"><label>&#8361; 20,000</label></div>
            </div>
        </li>
    <% } else if ("03".equals(categoryCd)) { %>
        <!-- ACCESSORIES -->
        <li>
            <div class="item-container">
                <div class="productImg">
                    <img src="./images/keychain.jpg" alt="Keychain" />
                </div>
                <div class="productName"><label>Team Karasuno Keychain</label></div>
                <div class="price"><label>&#8361; 5,000</label></div>
            </div>
            </li>
            <li>
             <div class="item-container">
                <div class="productImg">
                    <img src="./images/brelok.jpg" alt="Keychain" />
                </div>
                <div class="productName"><label>Team Karasuno Keychain</label></div>
                <div class="price"><label>&#8361; 5,000</label></div>
            </div>
            </li>
             <li>
             <div class="item-container">
                <div class="productImg">
                    <img src="./images/chigap.jpg" alt="Keychain" />
                </div>
                <div class="productName"><label>Team Karasuno Keychain</label></div>
                <div class="price"><label>&#8361; 5,000</label></div>
            </div>
            </li>
            <li>
             <div class="item-container">
                <div class="productImg">
                    <img src="./images/keychain2.jpg" alt="Keychain" />
                </div>
                <div class="productName"><label>Team Karasuno Keychain</label></div>
                <div class="price"><label>&#8361; 5,000</label></div>
            </div>
            
        </li>
    <% } else if ("04".equals(categoryCd)) { %>
        <!-- CLOTHES -->
        <li>
            <div class="item-container">
                <div class="productImg">
                    <img src="./images/tshirt.jpg" alt="T-Shirt" />
                </div>
                <div class="productName"><label>Haikyuu Team T-Shirt</label></div>
                <div class="price"><label>&#8361; 18,000</label></div>
            </div>
            </li>
              <li>
              <div class="item-container">
                <div class="productImg">
                    <img src="./images/tshirt2.jpg" alt="T-Shirt" />
                </div>
                <div class="productName"><label>Haikyuu Team T-Shirt</label></div>
                <div class="price"><label>&#8361; 18,000</label></div>
            </div>
        </li>
          
            <li>
              <div class="item-container">
                <div class="productImg">
                    <img src="./images/tshirt4.jpg" alt="T-Shirt" />
                </div>
                <div class="productName"><label>Haikyuu Team T-Shirt</label></div>
                <div class="price"><label>&#8361; 18,000</label></div>
            </div>
        </li>
            <li>
              <div class="item-container">
                <div class="productImg">
                    <img src="./images/tshirt4.jpg" alt="T-Shirt" />
                </div>
                <div class="productName"><label>Haikyuu Team T-Shirt</label></div>
                <div class="price"><label>&#8361; 18,000</label></div>
            </div>
        </li>
            <li>
              <div class="item-container">
                <div class="productImg">
                    <img src="./images/clothes.jpg" alt="T-Shirt" />
                </div>
                <div class="productName"><label>Haikyuu Team T-Shirt</label></div>
                <div class="price"><label>&#8361; 18,000</label></div>
            </div>
        </li>
            <li>
              <div class="item-container">
                <div class="productImg">
                    <img src="./images/clothes2.jpg" alt="T-Shirt" />
                </div>
                <div class="productName"><label>Haikyuu Team T-Shirt</label></div>
                <div class="price"><label>&#8361; 18,000</label></div>
            </div>
                <li>
              <div class="item-container">
                <div class="productImg">
                    <img src="./images/hoodie.jpg" alt="T-Shirt" />
                </div>
                <div class="productName"><label>Haikyuu Team T-Shirt</label></div>
                <div class="price"><label>&#8361; 18,000</label></div>
            </div>
        </li>
            <li>
              <div class="item-container">
                <div class="productImg">
                    <img src="./images/shirt.jpg" alt="T-Shirt" />
                </div>
                <div class="productName"><label>Haikyuu Team T-Shirt</label></div>
                <div class="price"><label>&#8361; 18,000</label></div>
            </div>
        </li>
        </li>
    <% } %>
</ul>

    </div>
</section>

<!-- Футер -->
<jsp:include page="footer.jsp" flush="true" />

</body>
</html>

