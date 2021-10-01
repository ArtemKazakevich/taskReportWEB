package ext.by.peleng.reports.taskReportWEB;

import wt.change2.WTChangeActivity2;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.maturity.PromotionNotice;
import wt.org.OrganizationServicesHelper;
import wt.org.WTUser;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.util.WTException;
import wt.workflow.work.WorkItem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

public class taskReportServlet extends HttpServlet {
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          
          WTUser user = findUserByLastName((String) request.getSession().getAttribute("selectedUser"));
          String startDate = (String) request.getSession().getAttribute("startDate");
          String endDate = (String) request.getSession().getAttribute("endDate");
     
          List<WorkItem> listWorkItem = new ArrayList<>();
          HashSet<PromotionNotice> listPromotionNotice = new HashSet<>();
          HashSet<WTChangeActivity2> listWtChangeActivity2 = new HashSet<>();
          
          DateFormat dateFormat = new SimpleDateFormat("dd.MM.yyyy");
          Timestamp startTimeStamp = null;
          Timestamp endTimeStamp = null;
          try {
               startTimeStamp = new Timestamp(dateFormat.parse(startDate).getTime());
               endTimeStamp = new Timestamp(dateFormat.parse(endDate).getTime());
          } catch (ParseException e) {
               e.printStackTrace();
          }
     
          QuerySpec criteriaWorkItem;
          QueryResult qrWorkItem = null;
          try {
               criteriaWorkItem = new QuerySpec(WorkItem.class);
     
               criteriaWorkItem.appendWhere(new SearchCondition(WorkItem.class, WorkItem.MODIFY_TIMESTAMP, SearchCondition.GREATER_THAN, startTimeStamp), new int[]{0});
               criteriaWorkItem.appendAnd();
               criteriaWorkItem.appendWhere(new SearchCondition(WorkItem.class, WorkItem.MODIFY_TIMESTAMP, SearchCondition.LESS_THAN, endTimeStamp), new int[]{0});
               criteriaWorkItem.appendAnd();
               criteriaWorkItem.appendWhere(new SearchCondition(WorkItem.class, WorkItem.STATUS, SearchCondition.EQUAL, "COMPLETED"), new int[]{0});
               criteriaWorkItem.appendAnd();
               criteriaWorkItem.appendWhere(new SearchCondition(WorkItem.class, WorkItem.COMPLETED_BY, SearchCondition.EQUAL, user.getName()), new int[]{0});
     
               qrWorkItem = PersistenceHelper.manager.find(criteriaWorkItem);
          } catch (WTException e) {
               e.printStackTrace();
          }
     
          while (qrWorkItem.hasMoreElements()) {
               WorkItem workItem = (WorkItem) qrWorkItem.nextElement();
               listWorkItem.add(workItem);
          
               if (workItem.getPrimaryBusinessObject().getObject() instanceof PromotionNotice) {
                    PromotionNotice p = (PromotionNotice) workItem.getPrimaryBusinessObject().getObject();
                    listPromotionNotice.add(p);
               }
               if (workItem.getPrimaryBusinessObject().getObject() instanceof WTChangeActivity2) {
                    WTChangeActivity2 p = (WTChangeActivity2) workItem.getPrimaryBusinessObject().getObject();
                    listWtChangeActivity2.add(p);
               }
          
          }
     
          listWorkItem.sort((WorkItem o1, WorkItem o2) -> o2.getModifyTimestamp().compareTo(o1.getModifyTimestamp()));
          
          request.getSession().setAttribute("listWorkItem", listWorkItem);
          request.getSession().setAttribute("listPromotionNotice", listPromotionNotice);
          request.getSession().setAttribute("listWtChangeActivity2", listWtChangeActivity2);
          
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/taskReportWEB/taskReport.jsp").forward(request, response);
     }
     
     private WTUser findUserByLastName(String userLastName) {
          try {
               return OrganizationServicesHelper.manager.getUser(userLastName);
          } catch (WTException e) {
               e.printStackTrace();
          }
          return null;
     }
}
