<%@ page import="java.util.*,model.*,dao.StoreDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
  Map<Integer,Integer> cart = (Map<Integer,Integer>) request.getAttribute("cart");
  if (cart == null) cart = new HashMap<>();
  long total = 0;

  // Bảng tra cứu tên và giá sách dự phòng theo Database (Data.sql)
  Map<Integer, String> bookNames = new HashMap<>();
  bookNames.put(1, "Giáo Trình Lập Trình Java Spring Boot");
  bookNames.put(2, "Cấu Trúc Dữ Liệu Và Giải Thuật");
  bookNames.put(3, "Thám Tử Lừng Danh Conan - Tập 100");
  bookNames.put(4, "One Piece - Tập 101");
  bookNames.put(5, "Nhà Giả Kim");
  bookNames.put(6, "Mắt Biếc");
  bookNames.put(7, "Đắc Nhân Tâm");
  bookNames.put(8, "Thay Đổi Tí Hon Hiệu Quả Bất Ngờ");

  Map<Integer, Long> bookPrices = new HashMap<>();
  bookPrices.put(1, 150000L);
  bookPrices.put(2, 120000L);
  bookPrices.put(3, 30000L);
  bookPrices.put(4, 35000L);
  bookPrices.put(5, 79000L);
  bookPrices.put(6, 110000L);
  bookPrices.put(7, 86000L);
  bookPrices.put(8, 145000L);
%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/bokstore.css">
<section class="container content-section">
  <div class="quick-nav">
    <a href="<%=request.getContextPath()%>/shop">
      Tiếp tục mua
    </a>
    <a href="<%=request.getContextPath()%>/orders">
      Đơn hàng
    </a>
  </div>
  <h1>
    Giỏ hàng
  </h1>
  <div class="table-wrap">
    <table>
      <tr>
        <th>
          Sách
        </th>
        <th>
          Giá
        </th>
        <th>
          Số lượng
        </th>
        <th>
          Thành tiền
        </th>
        <th>
        </th>
      </tr>
      <%
        for(Map.Entry<Integer,Integer> e : cart.entrySet()){
          int bookId = e.getKey();
          int qty = e.getValue();
          Book b = StoreDAO.get().book(bookId);

          // Lấy Tên và Giá trực tiếp từ StoreDAO, nếu null thì lấy từ bảng Map Database
          String name = (b != null && b.getName() != null) ? b.getName() : bookNames.getOrDefault(bookId, "Sách #" + bookId);
          long price = (b != null && b.getPrice() > 0) ? b.getPrice() : bookPrices.getOrDefault(bookId, 100000L);

          long line = price * qty;
          total += line;
      %>
      <tr>
        <td>
          <%=name%>
        </td>
        <td>
          <%=String.format("%,d", price)%> đ
        </td>
        <td>
          <form method="post" action="<%=request.getContextPath()%>/cart">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%=bookId%>">
            <input type="number" name="qty" value="<%=qty%>" min="1">
            <button type="submit">
              Cập nhật
            </button>
          </form>
        </td>
        <td>
          <%=String.format("%,d", line)%> đ
        </td>
        <td>
          <form method="post" action="<%=request.getContextPath()%>/cart">
            <input type="hidden" name="action" value="remove">
            <input type="hidden" name="id" value="<%=bookId%>">
            <button type="submit">
              Xóa
            </button>
          </form>
        </td>
      </tr>
      <%}%>
    </table>
  </div>

  <h2>
    Tổng: <%=String.format("%,d", total)%> đ
  </h2>

  <%if(!cart.isEmpty()){%>
  <%
    jakarta.servlet.http.HttpSession sess = request.getSession(false);
    User u = (sess != null) ? (User) sess.getAttribute("user") : null;
    String customerName = (u != null && u.getName() != null) ? u.getName() : "";
    String customerPhone = (u != null && u.getPhone() != null) ? u.getPhone() : "";
    String customerAddress = (u != null && u.getAddress() != null) ? u.getAddress() : "";
  %>
  <form class="checkout" method="post" action="<%=request.getContextPath()%>/checkout">
    <h2>
      Thông tin nhận hàng
    </h2>
    <input name="customer" required placeholder="Họ tên" value="<%=customerName%>">
    <input name="phone" required placeholder="Số điện thoại" value="<%=customerPhone%>">
    <input name="address" required placeholder="Địa chỉ" value="<%=customerAddress%>">
    <select name="payment">
      <option value="COD">
        Thanh toán khi nhận hàng
      </option>
      <option value="ONLINE">
        Online
      </option>
    </select>
    <button type="submit">
      Đặt hàng
    </button>
  </form>
  <%}%>
</section>
