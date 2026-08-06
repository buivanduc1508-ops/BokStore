package controller;

import dao.StoreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import model.*;
import utils.PasswordUtils;

@WebServlet(
    urlPatterns = {
      "/shop",
      "/book",
      "/login",
      "/logout",
      "/register",
      "/profile",
      "/avatar",
      "/cart",
      "/checkout",
      "/orders",
      "/order-detail",
      "/wishlist",
      "/favorite",
      "/review",
      "/about",
      "/contact",
      "/admin/manage",
      "/admin/book-form"
    })
public class StoreServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final StoreDAO dao = StoreDAO.get();
  private final Map<String, List<Long>> failedLogins = new ConcurrentHashMap<>();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");
    resp.setCharacterEncoding("UTF-8");
    String path = req.getServletPath();
    if ("/logout".equals(path)) {
      req.getSession().invalidate();
      resp.sendRedirect(req.getContextPath() + "/home");
      return;
    }
    if (path.startsWith("/admin") && !isAdmin(req)) {
      resp.sendRedirect(req.getContextPath() + "/login?error=admin");
      return;
    }
    switch (path) {
      case "/shop":
        shop(req);
        client(req, resp, "Cửa hàng", "shop", "/WEB-INF/views/client/pages/shop.jsp");
        break;
      case "/book":
        {
          Book b = dao.book(i(req, "id"));
          if (b != null) {
            b.setViews(b.getViews() + 1);
            rememberViewed(req, b.getId());
          }
          req.setAttribute("book", b);
          req.setAttribute("reviews", dao.reviews(i(req, "id")));
          req.setAttribute("rating", dao.rating(i(req, "id")));
          req.setAttribute(
              "related",
              b == null
                  ? List.of()
                  : dao.books().stream()
                      .filter(x -> x.getCategoryId() == b.getCategoryId() && x.getId() != b.getId())
                      .limit(4)
                      .toList());
          User u = user(req);
          req.setAttribute("favorite", u != null && dao.isFavorite(u.getId(), i(req, "id")));
          client(req, resp, "Chi tiết sách", "shop", "/WEB-INF/views/client/pages/book.jsp");
          break;
        }
      case "/cart":
        req.setAttribute("cart", cart(req));
        client(req, resp, "Giỏ hàng", "cart", "/WEB-INF/views/client/pages/cart.jsp");
        break;
      case "/orders":
        {
          User u = user(req);
          if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
          }
          req.setAttribute("orders", dao.ordersFor(u.getId()));
          client(req, resp, "Lịch sử mua hàng", "orders", "/WEB-INF/views/client/pages/orders.jsp");
          break;
        }
      case "/order-detail":
        {
          User u = user(req);
          Order o = dao.order(i(req, "id"));
          if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
          }
          if (o == null || (!"ADMIN".equals(u.getRole()) && o.getUserId() != u.getId())) {
            resp.sendError(403);
            return;
          }
          req.setAttribute("order", o);
          req.setAttribute("print", "1".equals(req.getParameter("print")));
          client(
              req,
              resp,
              "Chi tiết đơn hàng",
              "orders",
              "/WEB-INF/views/client/pages/order-detail.jsp");
          break;
        }
      case "/wishlist":
        {
          User u = user(req);
          if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
          }
          req.setAttribute("books", dao.favorites(u.getId()));
          client(
              req, resp, "Sách yêu thích", "wishlist", "/WEB-INF/views/client/pages/wishlist.jsp");
          break;
        }
      case "/profile":
        if (user(req) == null) {
          resp.sendRedirect(req.getContextPath() + "/login");
        } else client(req, resp, "Tài khoản", "profile", "/WEB-INF/views/client/pages/profile.jsp");
        break;
      case "/about":
        client(req, resp, "Về BokStore", "about", "/WEB-INF/views/client/pages/about.jsp");
        break;
      case "/contact":
        client(req, resp, "Liên hệ", "contact", "/WEB-INF/views/client/pages/contact.jsp");
        break;
      case "/admin/manage":
        admin(req, resp);
        break;
      case "/admin/book-form":
        {
          req.setAttribute("book", dao.book(i(req, "id")));
          req.setAttribute("categories", dao.categories());
          req.setAttribute("tab", "books");
          req.setAttribute("contentPage", "/WEB-INF/views/admin/pages/book-form.jsp");
          req.setAttribute("pageTitle", "Chỉnh sửa sản phẩm");
          req.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(req, resp);
          break;
        }
      default:
        client(req, resp, "Đăng nhập", "login", "/WEB-INF/views/client/pages/auth.jsp");
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");
    String path = req.getServletPath();
    try {
      if ("/login".equals(path)) {
        String key = req.getRemoteAddr();
        List<Long> attempts = failedLogins.computeIfAbsent(key, k -> new ArrayList<>());
        attempts.removeIf(t -> t < System.currentTimeMillis() - 300000);
        if (attempts.size() >= 5)
          throw new IllegalArgumentException(
              "Bạn đăng nhập sai quá nhiều lần. Vui lòng thử lại sau 5 phút");
        User u = dao.login(s(req, "account"), s(req, "password"));
        if (u == null) {
          attempts.add(System.currentTimeMillis());
          throw new IllegalArgumentException(
              "Tài khoản, mật khẩu không đúng hoặc tài khoản đã bị khóa");
        }
        attempts.clear();
        req.getSession().setAttribute("user", u);
        resp.sendRedirect(
            req.getContextPath() + ("ADMIN".equals(u.getRole()) ? "/admin/manage" : "/home"));
        return;
      }
      if ("/register".equals(path)) {
        validateUser(req, true);
        User u =
            dao.saveUser(
                0,
                s(req, "name"),
                s(req, "email"),
                s(req, "address"),
                s(req, "phone"),
                s(req, "username"),
                s(req, "password"),
                "USER");
        req.getSession().setAttribute("user", u);
        resp.sendRedirect(req.getContextPath() + "/home");
        return;
      }
      if ("/cart".equals(path)) {
        cartAction(req);
        resp.sendRedirect(req.getContextPath() + "/cart");
        return;
      }
      if ("/checkout".equals(path)) {
        User u = user(req);
        if (u == null) {
          resp.sendRedirect(req.getContextPath() + "/login");
          return;
        }
        dao.checkout(
            u,
            cart(req),
            s(req, "customer"),
            s(req, "address"),
            s(req, "phone"),
            s(req, "payment"));
        cart(req).clear();
        flash(req, "Đặt hàng thành công");
        resp.sendRedirect(req.getContextPath() + "/orders");
        return;
      }
      if ("/orders".equals(path)) {
        User u = user(req);
        if (u != null && dao.cancel(i(req, "id"), u)) flash(req, "Đã hủy đơn và hoàn lại tồn kho");
        resp.sendRedirect(req.getContextPath() + "/orders");
        return;
      }
      if ("/favorite".equals(path)) {
        User u = requireUser(req);
        boolean added = dao.toggleFavorite(u.getId(), i(req, "id"));
        flash(req, added ? "Đã thêm vào danh sách yêu thích" : "Đã bỏ khỏi danh sách yêu thích");
        resp.sendRedirect(req.getContextPath() + s(req, "returnTo"));
        return;
      }
      if ("/review".equals(path)) {
        User u = requireUser(req);
        dao.review(u, i(req, "bookId"), i(req, "rating"), required(req, "content"));
        flash(req, "Cảm ơn bạn đã đánh giá sách");
        resp.sendRedirect(req.getContextPath() + "/book?id=" + i(req, "bookId"));
        return;
      }
      if ("/profile".equals(path)) {
        profile(req);
        resp.sendRedirect(req.getContextPath() + "/profile");
        return;
      }
      if ("/avatar".equals(path)) {
        User u = requireUser(req);
        dao.updateAvatar(u.getId(), req.getParameter("avatarData"));
        flash(req, "Đã cập nhật ảnh đại diện");
        resp.sendRedirect(req.getContextPath() + "/home");
        return;
      }
      if ("/contact".equals(path)) {
        flash(req, "Cảm ơn bạn đã liên hệ. BokStore sẽ phản hồi sớm nhất.");
        resp.sendRedirect(req.getContextPath() + "/contact");
        return;
      }
      if ("/admin/manage".equals(path)) {
        if (!isAdmin(req)) {
          resp.sendError(403);
          return;
        }
        adminAction(req);
        resp.sendRedirect(req.getContextPath() + "/admin/manage?tab=" + s(req, "tab"));
        return;
      }
    } catch (IllegalArgumentException ex) {
      req.setAttribute("error", ex.getMessage());
      doGet(req, resp);
    }
  }

  private void shop(HttpServletRequest r) {
    List<Book> all =
        new ArrayList<>(
            dao.books(
                r.getParameter("q"),
                i(r, "category"),
                r.getParameter("publisher"),
                r.getParameter("availability")));
    String shelf = s(r, "shelf");
    String sort = s(r, "sort");

    if ("viewed".equals(shelf)) {
      List<Integer> viewed = viewedBooks(r);
      Map<Integer, Integer> order = new HashMap<>();
      for (int x = 0; x < viewed.size(); x++) order.put(viewed.get(x), x);
      all.removeIf(book -> !order.containsKey(book.getId()));
      all.sort(Comparator.comparingInt(book -> order.get(book.getId())));
      r.setAttribute("shopTitle", "Sách đã xem");
      r.setAttribute("shopSubtitle", "Những cuốn sách bạn vừa mở gần đây.");
    } else if ("new".equals(shelf)) {
      all.sort(Comparator.comparingInt(Book::getId).reversed());
      r.setAttribute("shopTitle", "Sách mới");
      r.setAttribute("shopSubtitle", "Các đầu sách mới được thêm vào BokStore.");
    } else if ("promo".equals(shelf)) {
      all.removeIf(book -> book.getPrice() > 100000);
      all.sort(Comparator.comparingLong(Book::getPrice));
      r.setAttribute("shopTitle", "Sách khuyến mãi");
      r.setAttribute("shopSubtitle", "Các đầu sách giá tốt dưới 100.000 đ.");
    } else {
      r.setAttribute("shopTitle", "Cửa hàng sách");
      r.setAttribute("shopSubtitle", "Tất cả đầu sách đang có tại BokStore.");
      if (sort.isBlank()) all.sort(Comparator.comparingInt(Book::getId).reversed());
    }

    if ("priceAsc".equals(sort)) all.sort(Comparator.comparingLong(Book::getPrice));
    else if ("priceDesc".equals(sort))
      all.sort(Comparator.comparingLong(Book::getPrice).reversed());
    else if ("name".equals(sort)) all.sort(Comparator.comparing(Book::getName));
    else if ("sold".equals(sort)) all.sort(Comparator.comparingInt(Book::getSold).reversed());
    int page = Math.max(1, i(r, "page")),
        size = 8,
        totalPages = Math.max(1, (all.size() + size - 1) / size),
        from = Math.min((page - 1) * size, all.size()),
        to = Math.min(from + size, all.size());
    r.setAttribute("books", all.subList(from, to));
    r.setAttribute("totalItems", all.size());
    r.setAttribute("page", page);
    r.setAttribute("totalPages", totalPages);
    r.setAttribute("categories", dao.categories());
    r.setAttribute("topBooks", dao.top10());
    r.setAttribute("shopShelf", shelf);
  }

  @SuppressWarnings("unchecked")
  private List<Integer> viewedBooks(HttpServletRequest r) {
    List<Integer> viewed = (List<Integer>) r.getSession().getAttribute("viewedBooks");
    if (viewed == null) {
      viewed = new LinkedList<>();
      r.getSession().setAttribute("viewedBooks", viewed);
    }
    return viewed;
  }

  private void rememberViewed(HttpServletRequest r, int bookId) {
    List<Integer> viewed = viewedBooks(r);
    viewed.remove(Integer.valueOf(bookId));
    viewed.add(0, bookId);
    while (viewed.size() > 12) viewed.remove(viewed.size() - 1);
  }

  @SuppressWarnings("unchecked")
  private Map<Integer, Integer> cart(HttpServletRequest r) {
    Map<Integer, Integer> c = (Map<Integer, Integer>) r.getSession().getAttribute("cart");
    if (c == null) {
      c = new LinkedHashMap<>();
      r.getSession().setAttribute("cart", c);
    }
    return c;
  }

  private void cartAction(HttpServletRequest r) {
    Map<Integer, Integer> c = cart(r);
    int id = i(r, "id"), qty = Math.max(1, i(r, "qty"));
    String a = s(r, "action");
    if ("remove".equals(a)) c.remove(id);
    else if ("clear".equals(a)) c.clear();
    else if (dao.book(id) != null)
      c.put(id, "update".equals(a) ? qty : c.getOrDefault(id, 0) + qty);
    flash(r, "Đã cập nhật giỏ hàng");
  }

  private void profile(HttpServletRequest r) {
    User u = user(r);
    String action = s(r, "action");
    if ("password".equals(action)) {
      if (!PasswordUtils.verify(s(r, "oldPassword"), u.getPassword()))
        throw new IllegalArgumentException("Mật khẩu hiện tại không đúng");
      if (s(r, "password").length() < 8)
        throw new IllegalArgumentException("Mật khẩu mới cần ít nhất 8 ký tự");
      u.setPassword(PasswordUtils.hash(s(r, "password")));
    } else {
      validateUser(r, false);
      dao.saveUser(
          u.getId(),
          s(r, "name"),
          s(r, "email"),
          s(r, "address"),
          s(r, "phone"),
          u.getUsername(),
          "",
          u.getRole());
    }
    flash(r, "Cập nhật tài khoản thành công");
  }

  private void admin(HttpServletRequest r, HttpServletResponse p)
      throws ServletException, IOException {
    String tab = s(r, "tab");
    if (tab.isBlank()) tab = "dashboard";
    LocalDate to = date(r, "to", LocalDate.now()), from = date(r, "from", to.minusMonths(1));
    if (from.isAfter(to)) {
      LocalDate swap = from;
      from = to;
      to = swap;
    }
    r.setAttribute("tab", tab);
    r.setAttribute("from", from);
    r.setAttribute("to", to);
    r.setAttribute("categories", dao.categories());
    r.setAttribute("books", dao.books());
    r.setAttribute("deletedBooks", dao.deletedBooks());
    r.setAttribute("users", dao.users());
    r.setAttribute("orders", dao.orders());
    r.setAttribute("topBooks", dao.top10());
    r.setAttribute("lowStock", dao.lowStock());
    r.setAttribute("statusCounts", dao.statusCounts());
    r.setAttribute("revenue", dao.revenue(from, to));
    r.setAttribute("contentPage", "/WEB-INF/views/admin/pages/manage.jsp");
    r.setAttribute("pageTitle", "Quản trị BokStore");
    r.getRequestDispatcher("/WEB-INF/views/admin/layout/layout.jsp").forward(r, p);
  }

  private void adminAction(HttpServletRequest r) {
    String type = s(r, "type"), action = s(r, "action");
    int id = i(r, "id");
    if ("category".equals(type)) {
      if ("delete".equals(action)) {
        if (!dao.deleteCategory(id))
          throw new IllegalArgumentException("Không thể xóa danh mục đang có sản phẩm");
      } else dao.saveCategory(id, required(r, "name"));
    } else if ("book".equals(type)) {
      if ("delete".equals(action)) dao.deleteBook(id);
      else if ("restore".equals(action)) dao.restoreBook(id);
      else if ("stock".equals(action)) dao.addStock(id, i(r, "quantity"));
      else {
        if (l(r, "price") < 0 || i(r, "stock") < 0)
          throw new IllegalArgumentException("Giá và tồn kho không được âm");
        dao.saveBook(
            id,
            required(r, "name"),
            required(r, "author"),
            required(r, "publisher"),
            l(r, "price"),
            s(r, "image"),
            required(r, "description"),
            i(r, "categoryId"),
            i(r, "stock"));
      }
    } else if ("user".equals(type)) {
      User actor = user(r);
      if ("delete".equals(action)) dao.deleteUser(id, actor.getId());
      else if ("toggle".equals(action)) dao.toggleUser(id, actor.getId());
      else
        dao.saveUser(
            id,
            required(r, "name"),
            required(r, "email"),
            s(r, "address"),
            s(r, "phone"),
            required(r, "username"),
            s(r, "password"),
            s(r, "role"));
    } else if ("order".equals(type)) dao.status(id, s(r, "status"));
    flash(r, "Thao tác quản trị thành công");
  }

  private void client(
      HttpServletRequest r, HttpServletResponse p, String title, String active, String page)
      throws ServletException, IOException {
    r.setAttribute("pageTitle", title);
    r.setAttribute("activePage", active);
    r.setAttribute("contentPage", page);
    r.setAttribute("cartSize", cart(r).values().stream().mapToInt(Integer::intValue).sum());
    User currentUser = user(r);
    r.setAttribute("avatarData", currentUser == null ? "" : dao.avatar(currentUser.getId()));
    r.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(r, p);
  }

  private User user(HttpServletRequest r) {
    return (User) r.getSession().getAttribute("user");
  }

  private boolean isAdmin(HttpServletRequest r) {
    User u = user(r);
    return u != null && "ADMIN".equals(u.getRole());
  }

  private User requireUser(HttpServletRequest r) {
    User u = user(r);
    if (u == null) throw new IllegalArgumentException("Vui lòng đăng nhập để tiếp tục");
    return u;
  }

  private int i(HttpServletRequest r, String n) {
    try {
      return Integer.parseInt(s(r, n));
    } catch (Exception e) {
      return 0;
    }
  }

  private long l(HttpServletRequest r, String n) {
    try {
      return Long.parseLong(s(r, n));
    } catch (Exception e) {
      return 0;
    }
  }

  private String s(HttpServletRequest r, String n) {
    String v = r.getParameter(n);
    return v == null ? "" : v.trim();
  }

  private String required(HttpServletRequest r, String n) {
    String v = s(r, n);
    if (v.isBlank()) throw new IllegalArgumentException("Vui lòng nhập đầy đủ thông tin");
    return v;
  }

  private LocalDate date(HttpServletRequest r, String n, LocalDate fallback) {
    try {
      return LocalDate.parse(s(r, n));
    } catch (Exception e) {
      return fallback;
    }
  }

  private void validateUser(HttpServletRequest r, boolean password) {
    if (!s(r, "email").matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))
      throw new IllegalArgumentException("Email không hợp lệ");
    if (!s(r, "phone").isBlank() && !s(r, "phone").matches("0\\d{9}"))
      throw new IllegalArgumentException("Số điện thoại phải gồm 10 chữ số");
    if (password && s(r, "password").length() < 8)
      throw new IllegalArgumentException("Mật khẩu cần ít nhất 8 ký tự");
  }

  private void flash(HttpServletRequest r, String m) {
    r.getSession().setAttribute("flash", m);
  }
}
