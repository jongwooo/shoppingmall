<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="${not empty product ? '상품 수정' : '상품 등록'}" />
</jsp:include>

<div style="display:flex; gap:2rem; flex-wrap:wrap;">
    <div style="flex:2; min-width:400px;">
        <div class="card">
            <h2 style="margin-bottom:1.5rem;">
                <c:choose>
                    <c:when test="${not empty product}">상품 수정</c:when>
                    <c:otherwise>상품 등록</c:otherwise>
                </c:choose>
            </h2>
            <form action="${pageContext.request.contextPath}/admin/product-save" method="post">
                <c:if test="${not empty product}">
                    <input type="hidden" name="id" value="${product.id}">
                </c:if>
                <div class="form-group">
                    <label>상품명</label>
                    <input type="text" name="name" value="${product.name}" required>
                </div>
                <div class="form-group">
                    <label>설명</label>
                    <textarea name="description">${product.description}</textarea>
                </div>
                <div class="form-group">
                    <label>가격</label>
                    <input type="number" name="price" value="${product.price}" min="0" step="1" required>
                </div>
                <div class="form-group">
                    <label>재고</label>
                    <input type="number" name="stock" value="${not empty product ? product.stock : 0}" min="0" required>
                </div>
                <div class="form-group">
                    <label>이미지 URL</label>
                    <input type="text" name="imageUrl" value="${product.imageUrl}">
                </div>
                <div class="form-group">
                    <label>카테고리</label>
                    <select name="categoryId">
                        <option value="">-- 선택 --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>판매 활성화</label>
                    <label class="toggle-switch">
                        <input type="checkbox" name="active" ${(empty product || product.active) ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                </div>
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${not empty product}">수정</c:when>
                        <c:otherwise>등록</c:otherwise>
                    </c:choose>
                </button>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn" style="border:1px solid #ddd;">취소</a>
            </form>
        </div>
    </div>

    <div style="flex:1; min-width:250px;">
        <div class="card">
            <h3 style="margin-bottom:1rem;">카테고리 관리</h3>
            <form action="${pageContext.request.contextPath}/admin/category-save" method="post"
                  style="display:flex; gap:0.5rem; margin-bottom:1rem;">
                <input type="text" name="name" placeholder="새 카테고리명" required
                       style="flex:1; padding:0.5rem; border:1px solid #ddd; border-radius:4px;">
                <button type="submit" class="btn btn-primary">추가</button>
            </form>
            <ul style="list-style:none;">
                <c:forEach var="cat" items="${categories}">
                    <li style="display:flex; justify-content:space-between; align-items:center; padding:0.4rem 0; border-bottom:1px solid #eee;">
                        <span>${cat.name}</span>
                        <form action="${pageContext.request.contextPath}/admin/category-delete" method="post"
                              style="display:inline;">
                            <input type="hidden" name="id" value="${cat.id}">
                            <button type="submit" class="btn btn-danger" style="padding:0.2rem 0.5rem; font-size:0.8rem;">삭제</button>
                        </form>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
