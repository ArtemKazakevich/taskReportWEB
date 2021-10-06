<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Task Report</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/css/indexStyleTaskReport.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
</head>

<body class="row align-items-center justify-content-center bg-light">

<div class="block col-xs-8 col-sm-6 col-md-3">
    <form method="post" action="${pageContext.request.contextPath}/servlet/taskReportWEB/index">
        <div class="form-floating mb-3">
            <input type="text" id="lastName" name="lastName" class="form-control form_input" placeholder="Иванов*"
                   autocomplete="off" required>
            <label for="lastName">Введите фамилию:</label>
        </div>

        <h5>Выберите дату:</h5>
        <div class="form-floating mb-3">
            <label for="startDate"></label>
            <input type="date" id="startDate" name="startDate" autocomplete="off" required>

            <label for="endDate"></label>
            <input type="date" id="endDate" name="endDate" autocomplete="off" required>
        </div>

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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ"
        crossorigin="anonymous"></script>
<script src="https://use.fontawesome.com/releases/v5.0.8/js/all.js"></script>
</body>

</html>
