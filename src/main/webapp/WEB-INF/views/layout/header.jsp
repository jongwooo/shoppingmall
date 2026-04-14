<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} - ShopMall</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { height: 100%; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; color: #333; min-height: 100%; display: flex; flex-direction: column; }
        a { text-decoration: none; color: inherit; }

        .navbar {
            background: #2c3e50; padding: 0 2rem; display: flex;
            align-items: center; justify-content: space-between; height: 60px;
        }
        .navbar .logo { color: #fff; font-size: 1.4rem; font-weight: bold; }
        .navbar nav a {
            color: #ecf0f1; margin-left: 1.5rem; font-size: 0.95rem;
            transition: color 0.2s;
        }
        .navbar nav a:hover { color: #3498db; }

        .container { max-width: 1200px; width: 100%; margin: 2rem auto; padding: 0 1rem; flex: 1; }

        .btn {
            display: inline-block; padding: 0.5rem 1.2rem; border: none;
            border-radius: 4px; cursor: pointer; font-size: 0.9rem;
            transition: background 0.2s;
        }
        .btn-primary { background: #3498db; color: #fff; }
        .btn-primary:hover { background: #2980b9; }
        .btn-danger { background: #e74c3c; color: #fff; }
        .btn-danger:hover { background: #c0392b; }
        .btn-success { background: #27ae60; color: #fff; }
        .btn-success:hover { background: #219a52; }

        .card {
            background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 1.5rem; margin-bottom: 1rem;
        }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 0.75rem; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f8f9fa; font-weight: 600; }

        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.3rem; font-weight: 500; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 0.5rem; border: 1px solid #ddd;
            border-radius: 4px; font-size: 0.95rem;
        }
        .form-group input[type="checkbox"] {
            width: auto; vertical-align: middle; margin-right: 0.4rem;
        }

        .toggle-switch { position: relative; display: inline-block; width: 44px; height: 24px; vertical-align: middle; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .toggle-switch .slider {
            position: absolute; inset: 0; background: #ccc; border-radius: 24px;
            cursor: pointer; transition: background 0.2s;
        }
        .toggle-switch .slider::before {
            content: ''; position: absolute; width: 18px; height: 18px;
            left: 3px; bottom: 3px; background: #fff; border-radius: 50%;
            transition: transform 0.2s;
        }
        .toggle-switch input:checked + .slider { background: #3498db; }
        .toggle-switch input:checked + .slider::before { transform: translateX(20px); }
        .form-group textarea { resize: vertical; min-height: 80px; }

        .alert { padding: 0.75rem 1rem; border-radius: 4px; margin-bottom: 1rem; }
        .alert-error { background: #fde8e8; color: #c0392b; border: 1px solid #f5c6cb; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }

        .product-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 1.5rem;
        }
        .product-card {
            background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden; transition: transform 0.2s;
        }
        .product-card:hover { transform: translateY(-4px); }
        .product-card img {
            width: 100%; height: 200px; object-fit: cover; background: #eee;
        }
        .product-card .info { padding: 1rem; }
        .product-card .info h3 { margin-bottom: 0.5rem; font-size: 1.1rem; }
        .product-card .info .price { color: #e74c3c; font-weight: bold; font-size: 1.1rem; }
        .product-card .info .category-tag {
            display: inline-block; background: #ecf0f1; padding: 0.2rem 0.5rem;
            border-radius: 3px; font-size: 0.8rem; margin-top: 0.3rem;
        }

        .sidebar { flex-shrink: 0; width: 200px; }
        .sidebar ul { list-style: none; }
        .sidebar ul li a {
            display: block; padding: 0.5rem 0.75rem; border-radius: 4px;
            margin-bottom: 0.25rem; transition: background 0.2s;
        }
        .sidebar ul li a:hover, .sidebar ul li a.active { background: #3498db; color: #fff; }
        .main-content { flex: 1; min-width: 0; }

        .text-right { text-align: right; }
        .mt-1 { margin-top: 1rem; }
        .mb-1 { margin-bottom: 1rem; }

        .badge {
            display: inline-block; padding: 0.25rem 0.6rem; border-radius: 12px;
            font-size: 0.8rem; color: #fff;
        }
        .badge-pending { background: #f39c12; }
        .badge-paid { background: #3498db; }
        .badge-shipping { background: #9b59b6; }
        .badge-delivered { background: #27ae60; }
        .badge-cancelled { background: #95a5a6; }
    </style>
</head>
<body>
<div class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="logo">ShopMall</a>
    <nav>
        <a href="${pageContext.request.contextPath}/product/list">상품</a>
        <a href="${pageContext.request.contextPath}/cart/">장바구니</a>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/order/">주문내역</a>
                <c:if test="${sessionScope.user.admin}">
                    <a href="${pageContext.request.contextPath}/admin/products">관리자</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/user/mypage">마이페이지</a>
                <a href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/user/login">로그인</a>
                <a href="${pageContext.request.contextPath}/user/register">회원가입</a>
            </c:otherwise>
        </c:choose>
    </nav>
</div>
<div class="container">
