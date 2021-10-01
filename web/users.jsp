<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Task Report</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/css/usersStyleTaskReport.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
</head>

<body>

<p>Start Date: ${startDate}</p>
<p>End Date: ${endDate}</p>

<c:if test="${flag == true}">
    <div>
        <form method = "post" action="${pageContext.request.contextPath}/servlet/taskReportWEB/users">
            <label>
                <select name="selectedUser" size="5" required>

                    <c:forEach items="${users}" var="u">
                        <option value="${u.getName()}">${u.getFullName().replace(",", "")}</option>
                    </c:forEach>

                </select>
            </label>
            <br>
            <button><span>Ввод </span></button>
        </form>
    </div>
</c:if>

<c:if test="${flag == false}">
    <form method="get" action="${pageContext.request.contextPath}/servlet/taskReportWEB/index">
        <h2>Пользователя не существует.</h2>
        <button><span>На главную </span></button>
    </form>
</c:if>

</body>
</html>
