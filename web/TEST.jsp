<%@ page import="com.ptc.core.lwc.server.LWCNormalizedObject" %>
<%@ page import="wt.change2.*" %>
<%@ page import="com.ptc.core.meta.common.impl.WCTypeInstanceIdentifier" %>
<%@ page import="wt.org.WTUser" %>
<%@ page import="com.ptc.core.meta.container.common.AttributeTypeSummary" %>
<%@ page import="com.ptc.core.lwc.server.LWCEnumerationEntryValuesFactory" %>
<%@ page import="wt.change2.ChangeHelper2" %>
<%@ page import="wt.part.WTPart" %>
<%@ page import="wt.doc.WTDocument" %>
<%@ page import="wt.epm.EPMDocument" %>
<%@ page import="wt.util.WTException" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.jasperreports.engine.util.JRLoader" %>
<%@ page import="net.sf.jasperreports.engine.data.JRBeanCollectionDataSource" %>
<%@ page import="wt.fc.*" %>
<%@ page import="wt.fc.collections.WTArrayList" %>
<%@ page import="wt.workflow.work.*" %>
<%@ page import="wt.workflow.engine.*" %>
<%@ page import="wt.workflow.engine.WfVotingEventAudit" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="com.ptc.core.meta.common.*" %>
<%@ page import="wt.iba.value.IBAHolder" %>
<%@ page import="wt.iba.value.service.IBAValueHelper" %>
<%@ page import="wt.iba.value.DefaultAttributeContainer" %>
<%@ page import="wt.iba.value.IBAValueUtility" %>
<%@ page import="wt.iba.value.litevalue.AbstractValueView" %>
<%@ page import="wt.iba.definition.litedefinition.AttributeDefDefaultView" %>
<%@ page import="wt.session.SessionHelper" %>
<%@ page import="com.ptc.netmarkets.model.NmOid" %>
<%@ page import="com.ptc.windchill.enterprise.workflow.WorkflowCommands" %>
<%@ page import="wt.vc.Iterated" %>
<%@ page import="wt.util.WTProperties" %>
<%@ page import="net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter" %>
<%@ page import="net.sf.jasperreports.export.SimpleXlsxReportConfiguration" %>
<%@ page import="net.sf.jasperreports.export.SimpleExporterInput" %>
<%@ page import="net.sf.jasperreports.export.SimpleOutputStreamExporterOutput" %>
<%@ page import="java.io.*" %>
<%@ page import="wt.query.QuerySpec" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>TestJSP</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<p align="center"><strong>История согласования объектов изменения</strong></p>
<%

    ReferenceFactory refFact = new ReferenceFactory();
    WTReference wtRef = null;
    Locale locale = null;
    try {
        locale = SessionHelper.manager.getLocale();
    } catch (WTException e) {
        e.printStackTrace();
    }

    // для хранения id заданий и ролей.
    // id генерируются свои
    Map<String, String> idWorkItem = new HashMap<>();
    Map<String, String> idRole = new HashMap<>();

    List<DataBean> listData = new ArrayList<DataBean>(); //коллекция с данными, которую мы будем передавать в отчет
    List<WorkItem> listWI = new ArrayList<WorkItem>();
    List<WorkItem> listWINotFinished = new ArrayList<WorkItem>();
    List<WTChangeActivity2> listWTCA2 = new ArrayList<WTChangeActivity2>();
    Map<String, Object> params = new HashMap<String, Object>(); //мапа с параметрами, которую мы передаем в наш отчет (параметры нужны для заголовка в отчёте)

    DateFormat dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm", locale);
    dateFormat.setTimeZone(TimeZone.getTimeZone("Europe/Minsk"));
    DateFormat dateFormatTPP = new SimpleDateFormat("dd.MM.yy", locale);
    dateFormatTPP.setTimeZone(TimeZone.getTimeZone("Europe/Minsk"));

    QueryResult qr;
    LWCNormalizedObject lwcNormalizedObject;
    WTChangeActivity2 ca2;

    // получаем все извещения
    List<WTChangeOrder2> WTChangeOrder2 = getAllWTChangeOrder2();

    for (WTChangeOrder2 wt : WTChangeOrder2) {

        //TODO: возможно нужно удалить это
        try {
            lwcNormalizedObject = new LWCNormalizedObject(wt, null, locale, new DisplayOperationIdentifier());
            lwcNormalizedObject.load("ATR_COMPLEXITY", "ATR_ECN_TYPE");

            String changeNoticeName = wt.getDisplayType().getLocalizedMessage(locale) + " " + wt.getNumber();
            params.put("CHANGE_NOTICE_NAME", changeNoticeName);
            String changeNoticeComplexity = (String) lwcNormalizedObject.get("ATR_COMPLEXITY");
            String changeNoticeType = (String) lwcNormalizedObject.get("ATR_ECN_TYPE");
            params.put("CHANGE_NOTICE_COMPLEXITY", DataBean.getShortComplexity(changeNoticeComplexity, changeNoticeType));
        } catch (WTException e) {
            e.printStackTrace();
        }

        try {
            qr = ChangeHelper2.service.getChangeActivities(wt); //получили все ChangeActivity (чемоданчики), которые присутствуют в извещении

            while (qr.hasMoreElements()) {
                ca2 = (WTChangeActivity2) qr.nextElement();
                lwcNormalizedObject = new LWCNormalizedObject(ca2, null, locale, new DisplayOperationIdentifier());
                lwcNormalizedObject.load("ATR_TYPE_CA");
                if (lwcNormalizedObject.get("ATR_TYPE_CA") == null)
                    listWTCA2.add(ca2); //"добавляем синий чемоданчик"
            }

            Collections.sort(listWTCA2, new Comparator<WTChangeActivity2>() {
                @Override
                public int compare(WTChangeActivity2 o1, WTChangeActivity2 o2) {
                    return o1.getNumber().compareTo(o2.getNumber());
                }
            });

            for (WTChangeActivity2 x1 : listWTCA2) {
                //для синего чемоданчика получаем все необходимые атрибуты: номер, когда и кем был создан, состояние и номер подразделения.
                lwcNormalizedObject = new LWCNormalizedObject(x1, null, locale, new DisplayOperationIdentifier());
                lwcNormalizedObject.load("number", "ATR_DEPARTMENT", "iterationInfo.modifier", "thePersistInfo.modifyStamp");
                String numberCA2 = (String) lwcNormalizedObject.get("number");

//////////////////////////////////////////////////// WorkItem
                //здесь мы получаем все наши процессы (интересовать нас будут только процессы, находящиеся в любом состоянии, кроме состояния "Прекращено")
                Enumeration processes = WfEngineHelper.service.getAssociatedProcesses(x1, null, null);
                while (processes.hasMoreElements()) {
                    WfProcess process = (WfProcess) processes.nextElement();

                    if (!process.getState().equals(WfState.CLOSED_TERMINATED)) {
                        NmOid nmOid = new NmOid(process);
                        QueryResult status = WorkflowCommands.getRouteStatus(nmOid);

                        while (status.hasMoreElements()) {
                            Object obj = status.nextElement();

                            if (obj.getClass().isAssignableFrom(WorkItem.class) && ((WorkItem) obj).getStatus().equals(WfAssignmentState.COMPLETED)) {
                                listWI.add((WorkItem) obj);
                            } else if (obj.getClass().isAssignableFrom(WorkItem.class) && ((WorkItem) obj).getStatus().equals(WfAssignmentState.POTENTIAL)) {
                                listWINotFinished.add((WorkItem) obj);
                            } else if (obj.getClass().isAssignableFrom(WfVotingEventAudit.class)) {
                                WfVotingEventAudit wfVotingEventAudit = (WfVotingEventAudit) obj;
                                listWI.add(wfVotingEventAudit.getWorkItem());
                            }

                        }
                    }

                }

                // TODO
                int i = listWI.size() - 1;
                //проходим по всем WorkItem-ам и получаем все необходимые атрибуты
                for (WorkItem x : listWI) {
                    WfAssignedActivity wfaa = (WfAssignedActivity) x.getSource().getObject();
                    WTArrayList wtArrayList = (WTArrayList) WfEngineHelper.service.getVotingEvents(wfaa.getParentProcess(), null, null, null);
                    System.out.println("######");
                    System.out.println(refFact.getReference(wtArrayList.get(i).toString()));
                    System.out.println("######");
                    wtRef = refFact.getReference(wtArrayList.get(i).toString());
                    WfVotingEventAudit vea = (WfVotingEventAudit) wtRef.getObject();
                    wtRef = vea.getUserRef();
                    WTUser user = (WTUser) wtRef.getObject();

                    String nameWorkItem = vea.getActivityName();
                    String nameRole = vea.getRole().getLocalizedMessage(locale);

                    //WorkItem
                    // берем id, если нет такого, то добавляем в список
                    String idWI = checkIdWI(idWorkItem, nameWorkItem);

                    //Role
                    // берем id, если нет такого, то добавляем в список
                    String idR = checkIdR(idRole, nameRole);

                    // TODO
                    listData.add(new DataBean(numberCA2, idWI, vea.getActivityName(), idR, vea.getRole().getLocalizedMessage(locale), user.getFullName(),
                            dateFormat.format(vea.getWorkItem().getCreateTimestamp()), dateFormat.format(vea.getCreateTimestamp())));

                    i--;
                }
                listWI.clear();

                //TODO
                for (WorkItem x : listWINotFinished) {
                    WfAssignedActivity wfaa = (WfAssignedActivity) x.getSource().getObject();

                    String nameWorkItem = wfaa.getName();
                    String nameRole = x.getRole().getDisplay(locale);

                    //WorkItem
                    // берем id, если нет такого, то добавляем в список
                    String idWI = checkIdWI(idWorkItem, nameWorkItem);

                    //Role
                    // берем id, если нет такого, то добавляем в список
                    String idR = checkIdR(idRole, nameRole);

                    listData.add(new DataBean(numberCA2, idWI, wfaa.getName(), idR, x.getRole().getDisplay(locale), x.getOwnership().getOwner().getFullName(),
                            "", ""));
                }
                listWINotFinished.clear();

                Collections.sort(listData, new Comparator<DataBean>() {
                    @Override
                    public int compare(DataBean o1, DataBean o2) {
                        if (o1.getNumberWT() == null || o2.getNumberWT() == null)
                            return 0;
                        else if (o1.getNumberCA2().equals(o2.getNumberCA2()))
                            return o1.getNumberWT().compareTo(o2.getNumberWT());
                        return 0;
                    }
                });
            }

            //TODO
            // запись в файл
            String fileOut = "D:\\ptc\\Windchill_11.0\\Windchill\\codebase\\netmarkets\\jsp\\by\\peleng\\reports\\notice\\writingToFileCSVReportECNAll.csv";
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(fileOut, false))) {
                for (DataBean s : listData) {
                    writer.write(s.toString());
                    writer.newLine();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        } catch (WTException e) {
            e.printStackTrace();
        }
    }
%>

<%!
    public static class DataBean {
        private String numberCA2;
        private String idWorkItem;
        private String nameVEA;
        private String idRole;
        private String roleVEA;
        private String userVEA;
        private String startDateVEA;
        private String deadLineVEA;
        private String numberWT;

        public DataBean(String numberCA2, String idWorkItem, String nameVEA, String idRole, String roleVEA, String userVEA,
                        String startDateVEA, String deadLineVEA) {
            this.numberCA2 = numberCA2;
            this.idWorkItem = idWorkItem;
            this.nameVEA = nameVEA;
            this.idRole = idRole;
            this.roleVEA = roleVEA;
            this.userVEA = userVEA;
            this.startDateVEA = startDateVEA;
            this.deadLineVEA = deadLineVEA;
        }

        public String getNumberCA2() {
            return numberCA2;
        }

        public void setNumberCA2(String numberCA2) {
            this.numberCA2 = numberCA2;
        }

        public String getIdWorkItem() {
            return idWorkItem;
        }

        public void setIdWorkItem(String idWorkItem) {
            this.idWorkItem = idWorkItem;
        }

        public String getNameVEA() {
            return nameVEA;
        }

        public void setNameVEA(String nameVEA) {
            this.nameVEA = nameVEA;
        }

        public String getIdRole() {
            return idRole;
        }

        public void setIdRole(String idRole) {
            this.idRole = idRole;
        }

        public String getRoleVEA() {
            return roleVEA;
        }

        public void setRoleVEA(String roleVEA) {
            this.roleVEA = roleVEA;
        }

        public String getUserVEA() {
            return userVEA;
        }

        public void setUserVEA(String userVEA) {
            this.userVEA = userVEA;
        }

        public String getStartDateVEA() {
            return startDateVEA;
        }

        public void setStartDateVEA(String startDateVEA) {
            this.startDateVEA = startDateVEA;
        }

        public String getDeadLineVEA() {
            return deadLineVEA;
        }

        public void setDeadLineVEA(String deadLineVEA) {
            this.deadLineVEA = deadLineVEA;
        }

        public String getNumberWT() {
            return numberWT;
        }

        public void setNumberWT(String numberWT) {
            this.numberWT = numberWT;
        }

        public static String getShortComplexity(String changeNoticeComplexity, String changeNoticeType) {
            if ((changeNoticeComplexity + " " + changeNoticeType).equals("Подготовка производства ИИ"))
                return "П";
            else if ((changeNoticeComplexity + " " + changeNoticeType).equals("Подготовка производства ПИ"))
                return "ПИП";
            else if ((changeNoticeComplexity + " " + changeNoticeType).equals("Без подготовки производства ИИ"))
                return "";
            else
                return "ПИ";
        }

        @Override
        public String toString() {
            return numberCA2 + ";" +
                    idWorkItem + ";" +
                    nameVEA + ";" +
                    idRole + ";" +
                    roleVEA + ";" +
                    userVEA + ";" +
                    startDateVEA + ";" +
                    deadLineVEA;
        }
    }
%>

<%!
    public static List<WTChangeOrder2> getAllWTChangeOrder2() {
        List<WTChangeOrder2> WTChangeOrder2 = new ArrayList<>();

        try {
            QuerySpec querySpec = new QuerySpec(WTChangeOrder2.class);
            QueryResult qr = PersistenceHelper.manager.find(querySpec);

            while (qr.hasMoreElements()) {
                WTChangeOrder2 p = (WTChangeOrder2) qr.nextElement();

                WTChangeOrder2.add(p);
            }
        } catch (WTException e) {
            e.printStackTrace();
        }

        return WTChangeOrder2;
    }
%>

<%!
    public static String checkIdWI(Map<String, String> idWorkItem, String nameWorkItem) {
        String idWI = "";

        //WorkItem
        // берем id, если нет такого, то добавляем в список
        if (idWorkItem.containsValue(nameWorkItem)) {

            for (Map.Entry<String, String> item : idWorkItem.entrySet()) {

                if (item.getValue().equals(nameWorkItem)) {
                    idWI = item.getKey();
                }
            }
        } else {
            String strKey = String.valueOf(idWorkItem.size() + 1);
            idWorkItem.put(strKey, nameWorkItem);
            idWI = strKey;
        }

        return idWI;
    }
%>

<%!
    public static String checkIdR(Map<String, String> idRole, String nameRole) {
        String idR = "";

        //Role
        // берем id, если нет такого, то добавляем в список
        if (idRole.containsValue(nameRole)) {

            for (Map.Entry<String, String> item : idRole.entrySet()) {

                if (item.getValue().equals(nameRole)) {
                    idR = item.getKey();
                }
            }
        } else {
            String strKey = String.valueOf(idRole.size() + 1);
            idRole.put(strKey, nameRole);
            idR = strKey;
        }

        return idR;
    }
%>

</html>