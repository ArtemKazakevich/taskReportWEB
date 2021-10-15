<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Task Report</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/css/usersStyleTaskReport.css">
    <link type="text/css" rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/css/cssBootstrap/bootstrap.min.css">
</head>

<body class="row align-items-center justify-content-center bg-light">

<c:if test="${flag == true}">
    <div class="block col-md-3">
        <form class="d-grid mx-auto" method = "post" action="${pageContext.request.contextPath}/servlet/taskReportWEB/users">
            <label>
                <select select class="form-select" multiple aria-label="multiple select example" name="selectedUser" size="5" required>

                    <c:forEach items="${users}" var="u">
                        <option value="${u.getName()}">${u.getFullName().replace(",", "")}</option>
                    </c:forEach>

                </select>
            </label>
            <div class="d-grid col-4 mx-auto">
                <button class="btn btn-primary mt-3" type="submit">Ввод
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                         class="bi bi-arrow-right-square-fill" viewBox="0 0 16 16">
                        <path
                                d="M0 14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2a2 2 0 0 0-2 2v12zm4.5-6.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5a.5.5 0 0 1 0-1z"/>
                    </svg>
                </button>
            </div>
        </form>
    </div>
</c:if>

<c:if test="${flag == false}">
    <form class="block col-md-4" method="get" action="${pageContext.request.contextPath}/servlet/taskReportWEB/index">
        <h2 class="text-center" style="color: #485460;">Пользователя не существует.</h2>
        <div class="d-grid col-4 mx-auto">
            <button class="btn btn-primary mt-3" type="submit">На главную
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                     class="bi bi-arrow-right-square-fill" viewBox="0 0 16 16">
                    <path
                            d="M0 14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2a2 2 0 0 0-2 2v12zm4.5-6.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5a.5.5 0 0 1 0-1z"/>
                </svg>
            </button>
        </div>
    </form>
</c:if>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/js/jsBootstrap/bootstrap.min.js"></script>
</body>
</html>
