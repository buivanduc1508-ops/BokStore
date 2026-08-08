<%@ page import="java.util.*,model.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
private String imageSrc(jakarta.servlet.http.HttpServletRequest request, Book book) {
  String image = book == null || book.getImage() == null ? "" : book.getImage().trim();
  if (image.startsWith("//")) image = "https:" + image;
  if (image.toLowerCase(java.util.Locale.ROOT).startsWith("www.")) image = "https://" + image;
  if (image.isEmpty()
      || image.startsWith("http://")
      || image.startsWith("https://")
      || image.startsWith("/")
      || image.startsWith("data:")) {
    return image;
  }
  return request.getContextPath() + "/" + image;
}

private String attr(String value) {
  if (value == null) return "";
  return value.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
}
%>
<%
List<Book> books = (List<Book>) request.getAttribute("books");
%>
<section class="container content-section">
  <h1>Sách yêu thích</h1>
  <div class="book-grid">
    <% int color = 0; for (Book b : books) { color++; String img = imageSrc(request, b); %>
      <article class="book-card">
        <a class="cover-link" href="<%=request.getContextPath()%>/book?id=<%=b.getId()%>">
          <div class="book-cover cover-<%=(color % 4) + 1%> <%=img.isEmpty() ? "" : "has-image"%>">
            <% if (!img.isEmpty()) { %>
              <img class="book-cover-img" src="<%=attr(img)%>" alt="<%=attr(b.getName())%>" loading="lazy">
            <% } %>
            <strong><%=b.getName().substring(0, 1)%></strong>
          </div>
        </a>
        <div class="book-info">
          <h3><a href="<%=request.getContextPath()%>/book?id=<%=b.getId()%>"><%=b.getName()%></a></h3>
          <p><%=b.getAuthor()%></p>
          <strong><%=String.format("%,d", b.getPrice())%> đ</strong>
          <form method="post" action="<%=request.getContextPath()%>/favorite">
            <input type="hidden" name="id" value="<%=b.getId()%>">
            <input type="hidden" name="returnTo" value="/wishlist">
            <button class="wishlist-btn">Bỏ yêu thích</button>
          </form>
        </div>
      </article>
    <% } %>
  </div>
  <% if (books.isEmpty()) { %>
    <p>Danh sách yêu thích đang trống.</p>
  <% } %>
</section>
