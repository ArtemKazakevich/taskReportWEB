package ext.by.peleng.reports.taskReportWEB;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTUser;
import wt.pds.StatementSpec;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.util.WTException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class usersServletTaskReport extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
     
          String lastName = request.getParameter("selectedUser");
          request.getSession().setAttribute("selectedUser", lastName);
     
          String path = request.getContextPath() + "/servlet/taskReportWEB/taskReport";
          response.sendRedirect(path);
     }
     
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          String userLastName = (String) request.getSession().getAttribute("lastName");
          List<WTUser> users = findUserByLastName(userLastName);
     
          if (!users.isEmpty()) {
               request.getSession().setAttribute("users", users);
               request.getSession().setAttribute("flag", true);
          } else {
               request.getSession().setAttribute("flag", false);
          }
     
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/taskReportWEB/users.jsp").forward(request, response);
     }
     
     private ArrayList<WTUser> findUserByLastName(String userLastName) {
          ArrayList<WTUser>  users = new ArrayList<WTUser>();
          try {
               QuerySpec qs = new QuerySpec(WTUser.class);
               qs.appendWhere(new SearchCondition(WTUser.class, WTUser.LAST, SearchCondition.LIKE, userLastName.replace("*","%"),false), null);
               QueryResult qr = PersistenceHelper.manager.find((StatementSpec) qs);
               
               while (qr.hasMoreElements()) {
                    WTUser user = (WTUser) qr.nextElement();
                    if (!user.isDisabled()) {
                         users.add(user);
                    }
               }
          } catch (WTException e) {
               e.printStackTrace();
          }
          
          return users;
     }
}
