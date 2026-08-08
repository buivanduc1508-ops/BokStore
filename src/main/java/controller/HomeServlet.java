package controller;

import dao.StoreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Book;
import model.User;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final StoreDAO dao = StoreDAO.get();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.setAttribute("pageTitle", "Trang chủ");
    request.setAttribute("activePage", "home");
    request.setAttribute("contentPage", "/WEB-INF/views/client/pages/home.jsp");
    request.setAttribute(
        "cartSize", cart(request).values().stream().mapToInt(Integer::intValue).sum());

    User currentUser = (User) request.getSession().getAttribute("user");
    request.setAttribute("avatarData", currentUser == null ? "" : dao.avatar(currentUser.getId()));
    List<Book> books = new ArrayList<>(dao.books());
    books.sort(Comparator.comparingInt(Book::getId).reversed());
    request.setAttribute("newBooks", books.stream().limit(10).toList());
    request.setAttribute("topBooks", dao.top10());
    request.setAttribute("categories", dao.categories());
    request.setAttribute("allBooks", books);

    request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
  }

  @SuppressWarnings("unchecked")
  private Map<Integer, Integer> cart(HttpServletRequest request) {
    Map<Integer, Integer> cart =
        (Map<Integer, Integer>) request.getSession().getAttribute("cart");
    if (cart == null) {
      cart = new LinkedHashMap<>();
      request.getSession().setAttribute("cart", cart);
    }
    return cart;
  }
}
