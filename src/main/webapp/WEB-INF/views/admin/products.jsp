<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="상품 관리" />
</jsp:include>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
    <h2>상품 관리</h2>
    <a href="${pageContext.request.contextPath}/admin/product-form" class="btn btn-primary">상품 등록</a>
</div>

<div class="card">
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>상품명</th>
                <th>카테고리</th>
                <th>가격</th>
                <th>재고</th>
                <th>상태</th>
                <th>등록일</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>${p.id}</td>
                    <td>${p.name}</td>
                    <td>${p.categoryName}</td>
                    <td><fmt:formatNumber value="${p.price}" type="number" />원</td>
                    <td>${p.stock}</td>
                    <td>
                        <c:choose>
                            <c:when test="${p.active}">
                                <span style="color:#27ae60;">판매중</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color:#95a5a6;">비활성</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd" /></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/product-form?id=${p.id}"
                           class="btn btn-primary" style="padding:0.3rem 0.6rem;">수정</a>
                        <form action="${pageContext.request.contextPath}/admin/product-delete" method="post"
                              style="display:inline;"
                              onsubmit="return confirm('정말 삭제하시겠습니까?');">
                            <input type="hidden" name="id" value="${p.id}">
                            <button type="submit" class="btn btn-danger" style="padding:0.3rem 0.6rem;">삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
