<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="상품목록" />
</jsp:include>

<h2 style="margin-bottom:1rem;">
    <c:choose>
        <c:when test="${not empty keyword}">검색: "${keyword}"</c:when>
        <c:otherwise>상품 목록</c:otherwise>
    </c:choose>
</h2>

<form action="${pageContext.request.contextPath}/product/search" method="get" style="margin-bottom:1.5rem;">
    <input type="text" name="keyword" placeholder="상품 검색..." value="${keyword}"
           style="padding:0.5rem; width:300px; border:1px solid #ddd; border-radius:4px;">
    <button type="submit" class="btn btn-primary">검색</button>
</form>

<div style="display:flex; gap:2rem;">
    <div class="sidebar">
        <div class="card">
            <h3 style="margin-bottom:0.75rem; font-size:1rem;">카테고리</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/product/list"
                       class="${empty selectedCategoryId ? 'active' : ''}">전체</a></li>
                <c:forEach var="cat" items="${categories}">
                    <li><a href="${pageContext.request.contextPath}/product/list?categoryId=${cat.id}"
                           class="${selectedCategoryId == cat.id ? 'active' : ''}">${cat.name}</a></li>
                </c:forEach>
            </ul>
        </div>
    </div>
    <div class="main-content">
        <div class="product-grid">
            <c:forEach var="p" items="${products}">
                <a href="${pageContext.request.contextPath}/product/detail?id=${p.id}" class="product-card">
                    <c:choose>
                        <c:when test="${not empty p.imageUrl}">
                            <img src="${p.imageUrl}" alt="${p.name}">
                        </c:when>
                        <c:otherwise>
                            <div style="width:100%;height:200px;background:#ecf0f1;display:flex;align-items:center;justify-content:center;color:#bdc3c7;font-size:3rem;">No Image</div>
                        </c:otherwise>
                    </c:choose>
                    <div class="info">
                        <h3>${p.name}</h3>
                        <span class="price"><fmt:formatNumber value="${p.price}" type="number" />원</span>
                        <c:if test="${not empty p.categoryName}">
                            <div><span class="category-tag">${p.categoryName}</span></div>
                        </c:if>
                    </div>
                </a>
            </c:forEach>
        </div>
        <c:if test="${empty products}">
            <div class="card" style="text-align:center; padding:3rem;">
                <p style="color:#999;">상품이 없습니다.</p>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
