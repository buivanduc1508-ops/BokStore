<%@ page import="java.util.*,model.*,dao.StoreDAO" %>
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

private List<Book> byCategory(List<Book> books, int categoryId, int limit) {
  List<Book> filtered = new ArrayList<>();
  for (Book book : books) {
    if (book.getCategoryId() == categoryId && !book.isDeleted()) filtered.add(book);
    if (filtered.size() == limit) break;
  }
  return filtered;
}
%>
<%
List<Book> newBooks = (List<Book>) request.getAttribute("newBooks");
List<Book> topBooks = (List<Book>) request.getAttribute("topBooks");
List<Category> categories = (List<Category>) request.getAttribute("categories");
List<Book> allBooks = (List<Book>) request.getAttribute("allBooks");
if (newBooks == null) newBooks = List.of();
if (topBooks == null) topBooks = List.of();
if (categories == null) categories = List.of();
if (allBooks == null) allBooks = List.of();
if (newBooks.isEmpty() && allBooks.isEmpty()) {
  StoreDAO dao = StoreDAO.get();
  List<Book> dbBooks = new ArrayList<>(dao.books());
  dbBooks.sort(Comparator.comparingInt(Book::getId).reversed());
  newBooks = dbBooks.stream().limit(10).toList();
  topBooks = dao.top10();
  categories = dao.categories();
  allBooks = dbBooks;
}
%>

<section class="mot-home-hero">
  <div class="container">
    <div class="mot-hero-copy">
      <span>&#272;&#7890;NG H&Agrave;NH T&Igrave;M TRI TH&#7912;C</span>
      <h1>M&#7885;t s&aacute;ch ch&#7885;n l&#7885;c cho ng&#432;&#7901;i &#273;&#7885;c k&#7929; t&iacute;nh</h1>
      <p>T&igrave;m s&aacute;ch m&#7899;i, xem s&aacute;ch b&aacute;n ch&#7841;y v&agrave; &#273;&#7863;t h&agrave;ng nhanh t&#7915; kho s&aacute;ch BokStore.</p>
      <form class="mot-hero-search" action="<%=request.getContextPath()%>/shop" method="get">
        <input name="q" placeholder="T&igrave;m ki&#7871;m t&ecirc;n s&aacute;ch ho&#7863;c t&aacute;c gi&#7843;">
        <button>T&igrave;m ki&#7871;m</button>
      </form>
    </div>
  </div>
</section>

<section class="mot-container">
  <div class="mot-section-head">
    <h2>S&aacute;ch m&#7899;i ph&aacute;t h&agrave;nh</h2>
    <a href="<%=request.getContextPath()%>/shop?shelf=new">Xem t&#7845;t c&#7843;</a>
  </div>
  <div class="mot-grid-5">
    <% for (Book book : newBooks) { String img = imageSrc(request, book); %>
      <article class="mot-card">
        <a class="mot-img-box" href="<%=request.getContextPath()%>/book?id=<%=book.getId()%>">
          <% if (!img.isEmpty()) { %>
            <img src="<%=attr(img)%>" alt="<%=attr(book.getName())%>" loading="lazy">
          <% } else { %>
            <span class="mot-cover-fallback"><%=book.getName().substring(0, 1)%></span>
          <% } %>
        </a>
        <h3 class="mot-book-title"><a href="<%=request.getContextPath()%>/book?id=<%=book.getId()%>"><%=book.getName()%></a></h3>
        <p class="mot-author"><%=book.getAuthor()%></p>
        <div class="mot-price-box">
          <strong class="price-new"><%=String.format("%,d", book.getPrice())%>&#8363;</strong>
        </div>
        <form method="post" action="<%=request.getContextPath()%>/cart">
          <input type="hidden" name="id" value="<%=book.getId()%>">
          <button class="mot-buy-btn" <%=book.getStock() == 0 ? "disabled" : ""%>>Th&ecirc;m v&agrave;o gi&#7887;</button>
        </form>
      </article>
    <% } %>
  </div>
  <% if (newBooks.isEmpty()) { %>
    <p class="empty-state">Ch&#432;a c&oacute; s&aacute;ch trong database.</p>
  <% } %>

  <div class="mot-dual-section">
    <aside class="mot-panel">
      <div class="mot-section-head compact">
        <h2>C&aacute;c s&aacute;ch b&aacute;n ch&#7841;y nh&#7845;t</h2>
      </div>
      <% for (Book book : topBooks.stream().limit(6).toList()) { String img = imageSrc(request, book); %>
        <article class="bestseller-item">
          <a href="<%=request.getContextPath()%>/book?id=<%=book.getId()%>">
            <% if (!img.isEmpty()) { %>
              <img src="<%=attr(img)%>" alt="<%=attr(book.getName())%>" loading="lazy">
            <% } else { %>
              <span class="mini-cover"><%=book.getName().substring(0, 1)%></span>
            <% } %>
          </a>
          <div class="bestseller-info">
            <h4><a href="<%=request.getContextPath()%>/book?id=<%=book.getId()%>"><%=book.getName()%></a></h4>
            <span class="price-new"><%=String.format("%,d", book.getPrice())%>&#8363;</span>
          </div>
        </article>
      <% } %>
    </aside>

    <section class="mot-panel">
      <div class="mot-category-header">
        <h2>S&aacute;ch theo t&#7915;ng th&#7875; lo&#7841;i</h2>
        <ul class="mot-tabs">
          <% for (int i = 0; i < Math.min(3, categories.size()); i++) { Category category = categories.get(i); %>
            <li class="<%=i == 0 ? "active" : ""%>"><a href="<%=request.getContextPath()%>/shop?category=<%=category.getId()%>"><%=category.getName()%></a></li>
          <% } %>
        </ul>
      </div>
      <div class="mot-grid-2">
        <%
        List<Book> categoryBooks = categories.isEmpty() ? allBooks.stream().limit(8).toList() : byCategory(allBooks, categories.get(0).getId(), 8);
        for (Book book : categoryBooks) { String img = imageSrc(request, book);
        %>
          <article class="mot-card horizontal-card">
            <div class="card-inner">
              <a href="<%=request.getContextPath()%>/book?id=<%=book.getId()%>">
                <% if (!img.isEmpty()) { %>
                  <img src="<%=attr(img)%>" alt="<%=attr(book.getName())%>" loading="lazy">
                <% } else { %>
                  <span class="mot-cover-fallback small"><%=book.getName().substring(0, 1)%></span>
                <% } %>
              </a>
              <div class="horizontal-info">
                <h4><a href="<%=request.getContextPath()%>/book?id=<%=book.getId()%>"><%=book.getName()%></a></h4>
                <p class="mot-author"><%=book.getAuthor()%></p>
                <strong class="price-new"><%=String.format("%,d", book.getPrice())%>&#8363;</strong>
                <p class="desc"><%=book.getDescription()%></p>
              </div>
            </div>
          </article>
        <% } %>
      </div>
    </section>
  </div>
</section>
