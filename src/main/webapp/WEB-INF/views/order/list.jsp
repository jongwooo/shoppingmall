<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="주문내역" />
</jsp:include>

<h2 style="margin-bottom:1rem;">주문 내역</h2>

<c:choose>
    <c:when test="${not empty orders}">
        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>주문번호</th>
                        <th>주문일</th>
                        <th>금액</th>
                        <th>상태</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>#${order.id}</td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                            <td><fmt:formatNumber value="${order.totalPrice}" type="number" />원</td>
                            <td>
                                <span class="badge badge-${order.status.toLowerCase()}">${order.status}</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/order/detail?id=${order.id}"
                                   class="btn btn-primary" style="padding:0.3rem 0.8rem;">상세</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:when>
    <c:otherwise>
        <div class="card" style="text-align:center; padding:3rem;">
            <p style="color:#999;">주문 내역이 없습니다.</p>
            <a href="${pageContext.request.contextPath}/product/list" class="btn btn-primary mt-1">쇼핑하러 가기</a>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
