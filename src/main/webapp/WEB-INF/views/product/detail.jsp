<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="${product.name}" />
</jsp:include>

<div class="card" style="display:flex; gap:2rem; flex-wrap:wrap;">
    <div style="flex:1; min-width:300px;">
        <c:choose>
            <c:when test="${not empty product.imageUrl}">
                <img src="${product.imageUrl}" alt="${product.name}"
                     style="width:100%; max-height:400px; object-fit:cover; border-radius:8px;">
            </c:when>
            <c:otherwise>
                <div style="width:100%;height:400px;background:#ecf0f1;display:flex;align-items:center;justify-content:center;color:#bdc3c7;font-size:4rem;border-radius:8px;">No Image</div>
            </c:otherwise>
        </c:choose>
    </div>
    <div style="flex:1; min-width:300px;">
        <c:if test="${not empty product.categoryName}">
            <span class="category-tag" style="margin-bottom:0.5rem;">${product.categoryName}</span>
        </c:if>
        <h1 style="margin:0.5rem 0;">${product.name}</h1>
        <p style="font-size:1.5rem; color:#e74c3c; font-weight:bold; margin:1rem 0;">
            <fmt:formatNumber value="${product.price}" type="number" />원
        </p>

        <c:choose>
            <c:when test="${product.stock > 0}">
                <p style="color:#27ae60; margin-bottom:1rem;">재고: ${product.stock}개</p>
            </c:when>
            <c:otherwise>
                <p style="color:#e74c3c; margin-bottom:1rem;">품절</p>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty product.description}">
            <div style="margin-bottom:1.5rem; line-height:1.6; color:#666;">
                ${product.description}
            </div>
        </c:if>

        <c:if test="${product.stock > 0}">
            <form action="${pageContext.request.contextPath}/cart/add" method="post"
                  style="display:flex; gap:0.5rem; align-items:center;">
                <input type="hidden" name="productId" value="${product.id}">
                <label>수량:</label>
                <input type="number" name="quantity" value="1" min="1" max="${product.stock}"
                       style="width:80px; padding:0.5rem; border:1px solid #ddd; border-radius:4px;">
                <button type="submit" class="btn btn-primary">장바구니 담기</button>
            </form>
        </c:if>

        <a href="${pageContext.request.contextPath}/product/list" class="btn" style="margin-top:1rem; display:inline-block; border:1px solid #ddd;">
            목록으로
        </a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
