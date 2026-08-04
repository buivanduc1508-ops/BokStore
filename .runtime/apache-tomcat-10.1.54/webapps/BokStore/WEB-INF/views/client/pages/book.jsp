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
Book b = (Book) request.getAttribute("book");
List<Review> reviews = (List<Review>) request.getAttribute("reviews");
List<Book> related = (List<Book>) request.getAttribute("related");
double rating = (Double) request.getAttribute("rating");
%>
<section class="container content-section">
  <a href="<%=request.getContextPath()%>/shop">← Quay lại cửa hàng</a>
  <% if (b == null) { %>
    <h1>Không tìm thấy sách</h1>
  <% } else { String img = imageSrc(request, b); %>
    <div class="detail-grid" style="margin-top:24px">
      <div class="book-cover cover-2 large <%=img.isEmpty() ? "" : "has-image"%>">
        <% if (!img.isEmpty()) { %>
          <img class="book-cover-img" src="<%=img%>" alt="<%=b.getName()%>">
        <% } %>
        <span class="cover-brand">BOKSTORE</span>
        <strong><%=b.getName().substring(0, 1)%></strong>
        <small><%=b.getAuthor()%></small>
      </div>
      <div>
        <span class="stock"><%=b.getStock() > 0 ? "Còn hàng" : "Hết hàng"%></span>
        <h1><%=b.getName()%></h1>
        <p>Tác giả: <strong><%=b.getAuthor()%></strong> · NXB: <%=b.getPublisher()%></p>
        <p class="rating-stars">★★★★★ <span style="color:#718183"><%=String.format("%.1f", rating)%> (<%=reviews.size()%> đánh giá)</span></p>
        <h2><%=String.format("%,d", b.getPrice())%> đ</h2>
        <p><%=b.getDescription()%></p>
        <p>Tồn kho: <%=b.getStock()%> · Lượt xem: <%=b.getViews()%> · Đã bán: <%=b.getSold()%></p>
        <div class="action-links">
          <form method="post" action="<%=request.getContextPath()%>/cart">
            <input type="hidden" name="id" value="<%=b.getId()%>">
            <input type="number" name="qty" min="1" max="<%=b.getStock()%>" value="1">
            <button>Thêm vào giỏ</button>
          </form>
          <form method="post" action="<%=request.getContextPath()%>/favorite">
            <input type="hidden" name="id" value="<%=b.getId()%>">
            <input type="hidden" name="returnTo" value="/book?id=<%=b.getId()%>">
            <button class="wishlist-btn"><%=Boolean.TRUE.equals(request.getAttribute("favorite")) ? "♥ Đã yêu thích" : "♡ Thêm yêu thích"%></button>
          </form>
        </div>
      </div>
    </div>
    <section class="related-section">
      <h2>Đánh giá của khách hàng</h2>
      <% if (session.getAttribute("user") != null) { %>
        <form class="checkout" method="post" action="<%=request.getContextPath()%>/review">
          <input type="hidden" name="bookId" value="<%=b.getId()%>">
          <select name="rating">
            <option value="5">5 sao - Tuyệt vời</option>
            <option value="4">4 sao - Tốt</option>
            <option value="3">3 sao - Bình thường</option>
            <option value="2">2 sao</option>
            <option value="1">1 sao</option>
          </select>
          <textarea name="content" required maxlength="500" placeholder="Chia sẻ cảm nhận của bạn"></textarea>
          <button>Gửi đánh giá</button>
        </form>
      <% } %>
      <div class="review-list">
        <% for (Review rv : reviews) { %>
          <article class="review-card">
            <strong><%=rv.getUserName()%></strong>
            <span class="rating-stars"><% for (int x = 0; x < rv.getRating(); x++) { %>★<% } %></span>
            <p><%=rv.getContent()%></p>
            <small><%=rv.getCreated()%></small>
          </article>
        <% } %>
        <% if (reviews.isEmpty()) { %>
          <p>Chưa có đánh giá. Hãy là người đầu tiên nhận xét cuốn sách này.</p>
        <% } %>
      </div>
    </section>
    <section class="related-section">
      <h2>Sách cùng danh mục</h2>
      <div class="book-grid">
        <% for (Book rb : related) { String rbImg = imageSrc(request, rb); %>
          <article class="book-card">
            <a class="cover-link" href="<%=request.getContextPath()%>/book?id=<%=rb.getId()%>">
              <div class="book-cover cover-3 <%=rbImg.isEmpty() ? "" : "has-image"%>">
                <% if (!rbImg.isEmpty()) { %>
                  <img class="book-cover-img" src="<%=rbImg%>" alt="<%=rb.getName()%>" loading="lazy">
                <% } %>
                <strong><%=rb.getName().substring(0, 1)%></strong>
              </div>
            </a>
            <div class="book-info">
              <h3><a href="<%=request.getContextPath()%>/book?id=<%=rb.getId()%>"><%=rb.getName()%></a></h3>
              <strong><%=String.format("%,d", rb.getPrice())%> đ</strong>
            </div>
          </article>
        <% } %>
      </div>
    </section>
  <% } %>
</section>
