<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Task Report</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/css/indexStyleTaskReport.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
</head>

<body>

<div class="block row offset-xs-3 col-xs-6">
    <form class="col-xs-6" method="post" action="${pageContext.request.contextPath}/servlet/taskReportWEB/index">
        <div class="form-floating mb-3">
            <input type="text" id="lastName" name="lastName" class="form-control" placeholder="Иванов*" autocomplete="off" required>
            <label for="lastName">Введите фамилию:</label>
        </div>

        <h5>Выберите дату:</h5>
        <div class="form-floating mb-3">
            <label for="startDate"></label>
            <input type="date" id="startDate" name="startDate" autocomplete="off" required>

            <label for="endDate"></label>
            <input type="date" id="endDate" name="endDate" autocomplete="off" required>
        </div>

        <div class="d-grid gap-2 col-6 mx-auto">
            <button class="btn btn-primary mt-3" type="submit">Ввод</button>
        </div>
    </form>
</div>

</body>

</html>
