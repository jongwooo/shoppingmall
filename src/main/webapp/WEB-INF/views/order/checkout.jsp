<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.UUID" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<% String idempotencyKey = UUID.randomUUID().toString(); %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="주문서" />
</jsp:include>

<h2 style="margin-bottom:1rem;">주문서</h2>

<c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
</c:if>

<div style="display:flex; gap:2rem; flex-wrap:wrap;">
    <div style="flex:2; min-width:400px;">
        <div class="card">
            <h3 style="margin-bottom:1rem;">주문 상품</h3>
            <table>
                <thead>
                    <tr><th>상품</th><th>가격</th><th>수량</th><th>소계</th></tr>
                </thead>
                <tbody>
                    <c:set var="total" value="0" />
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>${item.productName}</td>
                            <td><fmt:formatNumber value="${item.productPrice}" type="number" />원</td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${item.subtotal}" type="number" />원</td>
                        </tr>
                        <c:set var="total" value="${total + item.subtotal}" />
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" class="text-right" style="font-weight:bold;">합계</td>
                        <td style="font-weight:bold; color:#e74c3c;">
                            <fmt:formatNumber value="${total}" type="number" />원
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
    <div style="flex:1; min-width:300px;">
        <div class="card">
            <h3 style="margin-bottom:1rem;">배송 정보</h3>
            <form action="${pageContext.request.contextPath}/order/place" method="post">
                <input type="hidden" name="idempotencyKey" value="<%= idempotencyKey %>" />
                <div class="form-group">
                    <label>배송지 주소</label>
                    <textarea name="address" required>${user.address}</textarea>
                </div>
                <button type="submit" class="btn btn-success" style="width:100%; font-size:1.1rem; padding:0.7rem;">
                    주문 확정
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
