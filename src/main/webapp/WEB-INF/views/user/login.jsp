<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="로그인" />
</jsp:include>

<div style="max-width:400px; margin:2rem auto;">
    <div class="card">
        <h2 style="margin-bottom:1.5rem;">로그인</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/login" method="post">
            <div class="form-group">
                <label>이메일</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>비밀번호</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;">로그인</button>
        </form>
        <p style="margin-top:1rem; text-align:center;">
            계정이 없으신가요? <a href="${pageContext.request.contextPath}/user/register" style="color:#3498db;">회원가입</a>
        </p>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
