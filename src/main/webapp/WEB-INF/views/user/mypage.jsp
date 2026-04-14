<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="title" value="마이페이지" />
</jsp:include>

<div style="max-width:500px; margin:2rem auto;">
    <div class="card">
        <h2 style="margin-bottom:1.5rem;">마이페이지</h2>

        <form action="${pageContext.request.contextPath}/user/mypage" method="post">
            <div class="form-group">
                <label>이메일</label>
                <input type="email" value="${user.email}" disabled>
            </div>
            <div class="form-group">
                <label>이름</label>
                <input type="text" name="name" value="${user.name}" required>
            </div>
            <div class="form-group">
                <label>전화번호</label>
                <input type="text" name="phone" value="${user.phone}">
            </div>
            <div class="form-group">
                <label>주소</label>
                <input type="text" name="address" value="${user.address}">
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;">수정하기</button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
