package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.setAttribute("pageTitle", "Trang chủ");
    request.setAttribute("activePage", "home");
    request.setAttribute("contentPage", "/WEB-INF/views/client/pages/home.jsp");

    request
        .getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp")
        .forward(request, response);
  }
}
