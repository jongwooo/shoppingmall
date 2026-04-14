<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="주문 상세" />
</jsp:include>

<h2 style="margin-bottom:1rem;">주문 상세 #${order.id}</h2>

<div style="display:flex; gap:2rem; flex-wrap:wrap;">
    <div style="flex:2; min-width:400px;">
        <div class="card">
            <h3 style="margin-bottom:1rem;">주문 상품</h3>
            <table>
                <thead>
                    <tr><th>상품</th><th>가격</th><th>수량</th><th>소계</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.items}">
                        <tr>
                            <td>${item.productName}</td>
                            <td><fmt:formatNumber value="${item.price}" type="number" />원</td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${item.subtotal}" type="number" />원</td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" class="text-right" style="font-weight:bold;">합계</td>
                        <td style="font-weight:bold; color:#e74c3c;">
                            <fmt:formatNumber value="${order.totalPrice}" type="number" />원
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
    <div style="flex:1; min-width:250px;">
        <div class="card">
            <h3 style="margin-bottom:1rem;">주문 정보</h3>
            <p><strong>주문일:</strong> <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm" /></p>
            <p style="margin-top:0.5rem;"><strong>상태:</strong>
                <span class="badge badge-${order.status.toLowerCase()}">${order.status}</span>
            </p>
            <p style="margin-top:0.5rem;"><strong>배송지:</strong> ${order.address}</p>
        </div>
    </div>
</div>

<a href="${pageContext.request.contextPath}/order/" class="btn mt-1" style="border:1px solid #ddd;">목록으로</a>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
