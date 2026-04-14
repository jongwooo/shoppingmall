<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="500" />
</jsp:include>
<div class="card" style="text-align:center; padding:3rem;">
    <h1 style="font-size:4rem; color:#bdc3c7;">500</h1>
    <p style="color:#999; margin:1rem 0;">서버 오류가 발생했습니다.</p>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">홈으로</a>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
