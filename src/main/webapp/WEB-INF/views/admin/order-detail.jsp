<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="주문 관리 상세" />
</jsp:include>

<h2 style="margin-bottom:1rem;">주문 관리 #${order.id}</h2>

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
            <p><strong>주문자 ID:</strong> ${order.userId}</p>
            <p style="margin-top:0.5rem;"><strong>주문일:</strong>
                <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm" /></p>
            <p style="margin-top:0.5rem;"><strong>배송지:</strong> ${order.address}</p>
            <p style="margin-top:0.5rem;"><strong>현재 상태:</strong>
                <span class="badge badge-${order.status.toLowerCase()}">${order.status}</span>
            </p>

            <h4 style="margin-top:1.5rem; margin-bottom:0.5rem;">상태 변경</h4>
            <form action="${pageContext.request.contextPath}/admin/order-status" method="post"
                  style="display:flex; gap:0.5rem;">
                <input type="hidden" name="orderId" value="${order.id}">
                <select name="status" style="flex:1; padding:0.4rem; border:1px solid #ddd; border-radius:4px;">
                    <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                    <option value="PAID" ${order.status == 'PAID' ? 'selected' : ''}>PAID</option>
                    <option value="SHIPPING" ${order.status == 'SHIPPING' ? 'selected' : ''}>SHIPPING</option>
                    <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                    <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                </select>
                <button type="submit" class="btn btn-primary">변경</button>
            </form>
        </div>
    </div>
</div>

<a href="${pageContext.request.contextPath}/admin/orders" class="btn mt-1" style="border:1px solid #ddd;">목록으로</a>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
