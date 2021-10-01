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
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/netmarkets/jsp/by/peleng/reports/taskReportWEB/css/taskReportStyle.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
</head>
<body>
<%

    DateFormat df = new SimpleDateFormat("dd.MM.yyyy HH:mm");
    df.setTimeZone(TimeZone.getTimeZone("Europe/Minsk"));

    List<WorkItem> listWorkItem = (List<WorkItem>) request.getSession().getAttribute("listWorkItem");
    HashSet<PromotionNotice> listPromotionNotice = (HashSet<PromotionNotice>) request.getSession().getAttribute("listPromotionNotice");
    HashSet<WTChangeActivity2> listWtChangeActivity2 = (HashSet<WTChangeActivity2>) request.getSession().getAttribute("listWtChangeActivity2");

    List<String> promotionTargets = new ArrayList<>();
    List<String> resultingObjects = new ArrayList<>();

        /*
    Запрос на продвижение
     */
    for (PromotionNotice p : listPromotionNotice) {
        String time = "";
        for (WorkItem workItem : listWorkItem) {
            if (workItem.getPrimaryBusinessObject().getObject().equals(p)) {
                time = (df.format(workItem.getModifyTimestamp()));

%>

<p><%=p%>
</p>
<p>Запрос на продвижение - <%=p.getNumber()%>
</p>
<ul>
    <p>Объекты:</p>
    <%

        try {
            promotionTargets = getPromotionTargets(p); //получаем все объекты для продвижения
        } catch (WTException e) {
            e.printStackTrace();
        }

        for (String s : promotionTargets) {

    %>

    <li><%=s%>
    </li>

    <%

        }

    %>

</ul>
<p><%=time%>
</p>
<p>***************************************************************************</p>

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

%>

<p><%=w%>
</p>
<p>Изменение по извещению - <%=w.getNumber()%>
</p>
<ul>
    <p>Объекты:</p>
    <%

        try {
            resultingObjects = getResultingObjects(w); // получаем все результирующие объекты
        } catch (WTException e) {
            e.printStackTrace();
        }

        for (String s : resultingObjects) {

    %>

    <li><%=s%>
    </li>

    <%

        }

    %>

</ul>
<p><%=time%>
</p>
<p>***************************************************************************</p>

<%

                break;
            }
        }
    }
%>

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
</body>
</html>
