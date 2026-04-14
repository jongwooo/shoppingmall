<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="장바구니" />
</jsp:include>

<h2 style="margin-bottom:1rem;">장바구니</h2>

<c:choose>
    <c:when test="${not empty cartItems}">
        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>상품</th>
                        <th>가격</th>
                        <th>수량</th>
                        <th>소계</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="total" value="0" />
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/product/detail?id=${item.productId}"
                                   style="color:#3498db;">${item.productName}</a>
                            </td>
                            <td><fmt:formatNumber value="${item.productPrice}" type="number" />원</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/cart/update" method="post"
                                      style="display:inline-flex; gap:0.3rem; align-items:center;">
                                    <input type="hidden" name="productId" value="${item.productId}">
                                    <input type="number" name="quantity" value="${item.quantity}" min="1"
                                           max="${item.productStock}"
                                           style="width:60px; padding:0.3rem; border:1px solid #ddd; border-radius:4px;">
                                    <button type="submit" class="btn btn-primary" style="padding:0.3rem 0.6rem;">변경</button>
                                </form>
                            </td>
                            <td><fmt:formatNumber value="${item.subtotal}" type="number" />원</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/cart/remove" method="post"
                                      style="display:inline;">
                                    <input type="hidden" name="productId" value="${item.productId}">
                                    <button type="submit" class="btn btn-danger" style="padding:0.3rem 0.6rem;">삭제</button>
                                </form>
                            </td>
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
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        </div>
        <div class="text-right mt-1">
            <a href="${pageContext.request.contextPath}/order/checkout" class="btn btn-success" style="font-size:1.1rem; padding:0.7rem 2rem;">
                주문하기
            </a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="card" style="text-align:center; padding:3rem;">
            <p style="color:#999;">장바구니가 비어있습니다.</p>
            <a href="${pageContext.request.contextPath}/product/list" class="btn btn-primary mt-1">쇼핑하러 가기</a>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
