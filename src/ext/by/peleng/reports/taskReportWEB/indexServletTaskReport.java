package ext.by.peleng.reports.taskReportWEB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class indexServletTaskReport extends HttpServlet {
     
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
          
          String lastName = request.getParameter("lastName");
          String startDate = request.getParameter("startDate");
          String endDate = request.getParameter("endDate");
     
          SimpleDateFormat fromUser = new SimpleDateFormat("yyyy-MM-dd");
          SimpleDateFormat myFormat = new SimpleDateFormat("dd.MM.yyyy");
     
          String startD = "";
          String endD = "";
          try {
               startD = myFormat.format(fromUser.parse(startDate));
               endD = myFormat.format(fromUser.parse(endDate));
          } catch (ParseException e) {
               e.printStackTrace();
          }
          
          request.getSession().setAttribute("lastName", lastName);
          request.getSession().setAttribute("startDate", startD);
          request.getSession().setAttribute("endDate", endD);
          
          String path = request.getContextPath() + "/servlet/taskReportWEB/users";
          response.sendRedirect(path);
     }
     
     // TODO: возможно нужно будет заменить на request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/taskReportWEB/index.jsp").forward(request, response);
     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          request.getRequestDispatcher("/netmarkets/jsp/by/peleng/reports/taskReportWEB/index.jsp").forward(request, response);
     }
}
