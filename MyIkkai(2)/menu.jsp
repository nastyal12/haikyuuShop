<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="styles.css">
    <style>
        ul {
            margin: 0;
            padding: 0;
            display:inline-block;
            list-style: none; /* Убирает буллеты */
        }
        li {
            float: left;
            display:inline;
            margin: 0;
            padding: 0;
            padding-right: 2rem;
        }
    </style>
</head>
<body>
<nav id="menuArea">
    <form id="frmMenu" name="frmMenu" method="post" action="product.jsp">
        <input type="hidden" id="categoryCd" name="categoryCd">
    </form>
    <ul>
        <li><a href="#" onclick="goMenu('01'); return false;">MANGA</a></li>
        <li><a href="#" onclick="goMenu('02'); return false;">TOYS</a></li>
        <li><a href="#" onclick="goMenu('03'); return false;">ACCESSORIES</a></li>
        <li><a href="#" onclick="goMenu('04'); return false;">CLOTHES</a></li>
    </ul>
</nav>

<script>
function goMenu(categoryCd) {
	var frm = document.getElementById("frmMenu");
	frm.categoryCd.value = categoryCd;
	frm.submit();
    }
</script>
</body>
</html>

