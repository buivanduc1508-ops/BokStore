<%@ page import="java.util.*,model.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
private String imageSrc(jakarta.servlet.http.HttpServletRequest request, Book book) {
  String image = book == null || book.getImage() == null ? "" : book.getImage().trim();
  if (image.isEmpty()
      || image.startsWith("http://")
      || image.startsWith("https://")
      || image.startsWith("/")
      || image.startsWith("data:")) {
    return image;
  }
  return request.getContextPath() + "/" + image;
}
%>
<%
List<Book> books = (List<Book>) request.getAttribute("books");
List<Category> cats = (List<Category>) request.getAttribute("categories");
int pageNo = (Integer) request.getAttribute("page");
int pages = (Integer) request.getAttribute("totalPages");
String q = request.getParameter("q") == null ? "" : request.getParameter("q");
String shelf = request.getAttribute("shopShelf") == null ? "" : (String) request.getAttribute("shopShelf");
String shopTitle = request.getAttribute("shopTitle") == null ? "Cửa hàng sách" : (String) request.getAttribute("shopTitle");
String shopSubtitle = request.getAttribute("shopSubtitle") == null ? "" : (String) request.getAttribute("shopSubtitle");
String categoryParam = request.getParameter("category") == null ? "" : request.getParameter("category");
String availabilityParam = request.getParameter("availability") == null ? "" : request.getParameter("availability");
String sortParam = request.getParameter("sort") == null ? "" : request.getParameter("sort");
String pageQuery = "";
if (!shelf.isBlank()) pageQuery += "&shelf=" + java.net.URLEncoder.encode(shelf, java.nio.charset.StandardCharsets.UTF_8);
if (!q.isBlank()) pageQuery += "&q=" + java.net.URLEncoder.encode(q, java.nio.charset.StandardCharsets.UTF_8);
if (!categoryParam.isBlank()) pageQuery += "&category=" + java.net.URLEncoder.encode(categoryParam, java.nio.charset.StandardCharsets.UTF_8);
if (!availabilityParam.isBlank()) pageQuery += "&availability=" + java.net.URLEncoder.encode(availabilityParam, java.nio.charset.StandardCharsets.UTF_8);
if (!sortParam.isBlank()) pageQuery += "&sort=" + java.net.URLEncoder.encode(sortParam, java.nio.charset.StandardCharsets.UTF_8);
%>
<section class="shop-hero">
  <div class="container">
    <span class="eyebrow">BỘ SƯU TẬP BOKSTORE</span>
    <h1>Tìm cuốn sách dành cho bạn</h1>
    <p>Từ những câu chuyện truyền cảm hứng đến kiến thức chuyên sâu.</p>
  </div>
</section>
<section class="container content-section">
  <div class="section-heading">
    <div>
      <span class="eyebrow">KHÁM PHÁ</span>
      <h2><%=shopTitle%></h2>
      <% if (!shopSubtitle.isBlank()) { %>
        <p class="shop-subtitle"><%=shopSubtitle%></p>
      <% } %>
    </div>
    <span class="result-count"><%=request.getAttribute("totalItems")%> sản phẩm</span>
  </div>
  <form class="filter-bar" method="get">
    <% if (!shelf.isBlank()) { %>
      <input type="hidden" name="shelf" value="<%=shelf%>">
    <% } %>
    <label class="search-field"><span>⌕</span><input name="q" value="<%=q%>" placeholder="Tìm theo tên sách hoặc tác giả"></label>
    <select name="category">
      <option value="0">Tất cả danh mục</option>
      <% for (Category c : cats) { %>
        <option value="<%=c.getId()%>" <%=String.valueOf(c.getId()).equals(request.getParameter("category")) ? "selected" : ""%>><%=c.getName()%></option>
      <% } %>
    </select>
    <select name="availability">
      <option value="">Tất cả tồn kho</option>
      <option value="in">Còn hàng</option>
      <option value="out">Hết hàng</option>
    </select>
    <select name="sort">
      <option value="">Mới nhất</option>
      <option value="priceAsc">Giá tăng dần</option>
      <option value="priceDesc">Giá giảm dần</option>
      <option value="name">Tên A-Z</option>
      <option value="sold">Bán chạy</option>
    </select>
    <button>Tìm kiếm</button>
  </form>
  <div class="book-grid">
    <% int color = 0; for (Book b : books) { color++; String img = imageSrc(request, b); %>
      <article class="book-card">
        <a class="cover-link" href="<%=request.getContextPath()%>/book?id=<%=b.getId()%>">
          <div class="book-cover cover-<%=(color % 4) + 1%> <%=img.isEmpty() ? "" : "has-image"%>">
            <% if (!img.isEmpty()) { %>
              <img class="book-cover-img" src="<%=img%>" alt="<%=b.getName()%>" loading="lazy">
            <% } %>
            <span class="cover-brand">BOKSTORE</span>
            <strong><%=b.getName().substring(0, 1)%></strong>
            <small><%=b.getAuthor()%></small>
          </div>
        </a>
        <div class="book-info">
          <span class="stock <%=b.getStock() == 0 ? "out" : ""%>"><%=b.getStock() > 0 ? "Còn hàng" : "Hết hàng"%></span>
          <h3><a href="<%=request.getContextPath()%>/book?id=<%=b.getId()%>"><%=b.getName()%></a></h3>
          <p class="author"><%=b.getAuthor()%></p>
          <div class="price-row">
            <strong><%=String.format("%,d", b.getPrice())%> đ</strong>
            <small>Đã bán <%=b.getSold()%></small>
          </div>
          <form method="post" action="<%=request.getContextPath()%>/cart">
            <input type="hidden" name="id" value="<%=b.getId()%>">
            <button <%=b.getStock() == 0 ? "disabled" : ""%>>＋ Thêm vào giỏ</button>
          </form>
        </div>
      </article>
    <% } %>
  </div>
  <% if (books.isEmpty()) { %>
    <p class="empty-state">
      <%= "viewed".equals(shelf) ? "Bạn chưa xem cuốn sách nào. Hãy mở chi tiết một cuốn sách để lưu vào mục này." : "Không tìm thấy sách phù hợp." %>
    </p>
  <% } %>
  <nav class="pagination">
    <% for (int x = 1; x <= pages; x++) { %>
      <a class="<%=x == pageNo ? "active" : ""%>" href="?page=<%=x%><%=pageQuery%>"><%=x%></a>
    <% } %>
  </nav>
</section>
