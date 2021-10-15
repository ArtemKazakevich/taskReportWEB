<%@ page import="wt.org.WTUser" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page import="wt.query.SearchCondition" %>
<%@ page import="wt.pds.StatementSpec" %>
<%@ page import="wt.util.WTException" %>
<%@ page import="java.util.*" %>
<%@ page import="wt.session.SessionHelper" %>
<%@ page import="com.ptc.core.lwc.server.PersistableAdapter" %>
<%@ page import="com.ptc.core.meta.common.DisplayOperationIdentifier" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="wt.maturity.PromotionNotice" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="wt.workflow.work.WorkItem" %>
<%@ page import="wt.change2.WTChangeActivity2" %>
<%@ page import="wt.maturity.MaturityHelper" %>
<%@ page import="wt.change2.ChangeHelper2" %>
<%@ page import="wt.fc.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Task Report</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/css/taskReportStyle.css">
    <link type="text/css" rel="stylesheet"
          href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/css/cssBootstrap/bootstrap.min.css">
</head>
<body class="bg-light">

<div id="page-preloader" class="preloader d-flex justify-content-center">
    <div class="spinner-border text-primary loader" role="status">
        <span class="visually-hidden">Загрузка...</span>
    </div>
</div>

<div class="my-2 d-flex justify-content-center">
    <form class="col-md-4" method="get" action="${pageContext.request.contextPath}/servlet/taskReportWEB/index">
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
</div>

<div class="my-2 d-flex justify-content-center">
    <h3 class="text-center col-md-8">Список заданий выполненных ${userName} c ${startDate} по ${endDate}</h3>
</div>

<%

    DateFormat df = new SimpleDateFormat("dd.MM.yyyy HH:mm");
    df.setTimeZone(TimeZone.getTimeZone("Europe/Minsk"));

    List<WorkItem> listWorkItem = (List<WorkItem>) request.getSession().getAttribute("listWorkItem");
    HashSet<PromotionNotice> listPromotionNotice = (HashSet<PromotionNotice>) request.getSession().getAttribute("listPromotionNotice");
    HashSet<WTChangeActivity2> listWtChangeActivity2 = (HashSet<WTChangeActivity2>) request.getSession().getAttribute("listWtChangeActivity2");

    List<String> promotionTargets = new ArrayList<>();
    List<String> resultingObjects = new ArrayList<>();

    int number = 0;

%>

<div class="mx-5">
    <table class="table table-hover text-center table-sm">
        <thead class="table-secondary">
        <tr>
            <th scope="col">#</th>
            <th scope="col">Тема</th>
            <th scope="col">Объекты</th>
            <th scope="col">Дата завершения</th>
        </tr>
        </thead>
        <tbody>

        <%

            /*
           Запрос на продвижение
           */
            for (PromotionNotice p : listPromotionNotice) {
                String time = "";
                for (WorkItem workItem : listWorkItem) {
                    if (workItem.getPrimaryBusinessObject().getObject().equals(p)) {
                        time = (df.format(workItem.getModifyTimestamp()));
                        number++;
                        int countObject;
        %>

        <tr>
            <th scope="row"><%=number%>
            </th>
            <td>Запрос на продвижение - <%=p.getNumber()%>
            </td>
            <td>

                <%

                    try {
                        promotionTargets = getPromotionTargets(p); //получаем все объекты для продвижения
                    } catch (WTException e) {
                        e.printStackTrace();
                    }

                    countObject = promotionTargets.size();

                %>

                <div class="d-grid col-6 mx-auto">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
                        Список объектов (<%=countObject%>)
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                             class="bi bi-card-list" viewBox="0 0 16 16">
                            <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h13zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-13z"/>
                            <path d="M5 8a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7A.5.5 0 0 1 5 8zm0-2.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm0 5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm-1-5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0zM4 8a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0zm0 2.5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0z"/>
                        </svg>
                    </button>
                </div>
                <div class="collapse" id="collapseExample">
                    <div class="card card-body">
                        <ul class="list-group list-group-flush">

                            <%

                                for (String s : promotionTargets) {

                            %>

                            <li class="list-group-item"><%=s%>
                            </li>

                            <%

                                }

                            %>

                        </ul>
                    </div>
                </div>
            </td>
            <td><%=time%>
            </td>
        </tr>

        <%

                        break;
                    }
                }
            }

    /*
    Изменение по извещению
     */
            for (WTChangeActivity2 w : listWtChangeActivity2) {
                String time = "";
                for (WorkItem workItem : listWorkItem) {
                    if (workItem.getPrimaryBusinessObject().getObject().equals(w)) {
                        time = (df.format(workItem.getModifyTimestamp()));
                        number++;
                        int countObject;
        %>

        <tr>
            <th scope="row"><%=number%>
            </th>
            <td>Изменение по извещению - <%=w.getNumber()%>
            </td>
            <td>

                <%

                    try {
                        resultingObjects = getResultingObjects(w); // получаем все результирующие объекты
                    } catch (WTException e) {
                        e.printStackTrace();
                    }

                    countObject = resultingObjects.size();

                %>

                <div class="d-grid col-6 mx-auto">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
                        Список объектов (<%=countObject%>)
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                             class="bi bi-card-list" viewBox="0 0 16 16">
                            <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h13zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-13z"/>
                            <path d="M5 8a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7A.5.5 0 0 1 5 8zm0-2.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm0 5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm-1-5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0zM4 8a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0zm0 2.5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0z"/>
                        </svg>
                    </button>
                </div>
                <div class="collapse" id="collapseExample">
                    <div class="card card-body">
                        <ul class="list-group list-group-flush">

                            <%

                                for (String s : resultingObjects) {

                            %>

                            <li class="list-group-item"><%=s%>
                            </li>

                            <%

                                }

                            %>

                        </ul>
                    </div>
                </div>
            </td>
            <td><%=time%>
            </td>
        </tr>

        <%

                        break;
                    }
                }
            }
        %>

        </tbody>
    </table>
</div>

<%!
    private static List<String> getPromotionTargets(PromotionNotice promotionNotice) throws WTException {
        List<String> promotionTargets = new ArrayList<>();
        QueryResult queryResult = MaturityHelper.getService().getPromotionTargets(promotionNotice);

        while (queryResult.hasMoreElements()) {
            Persistable persistable = (Persistable) queryResult.nextElement();
            PersistableAdapter obj = new PersistableAdapter(persistable, null, SessionHelper.manager.getLocale(), new DisplayOperationIdentifier());
            obj.load("number"); // "number" - внутреннее название атрибута "обозначение или номер" в windchille
            String number = (String) obj.get("number");
            promotionTargets.add(number);
        }

        return promotionTargets;
    }
%>


<%!
    private static List<String> getResultingObjects(WTChangeActivity2 wtChangeActivity2) throws WTException {
        List<String> resultingObjects = new ArrayList<>();
        QueryResult queryResult = ChangeHelper2.service.getChangeablesAfter(wtChangeActivity2, true);

        while (queryResult.hasMoreElements()) {
            Persistable persistable = (Persistable) queryResult.nextElement();
            PersistableAdapter obj = new PersistableAdapter(persistable, null, SessionHelper.manager.getLocale(), new DisplayOperationIdentifier());
            obj.load("number"); // "number" - внутреннее название атрибута "обозначение или номер" в windchille
            String number = (String) obj.get("number");
            resultingObjects.add(number);
        }

        return resultingObjects;
    }
%>

<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/js/taskReportScript.js"></script>
<script src="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/js/jsBootstrap/bootstrap.min.js"></script>
</body>
</html>
