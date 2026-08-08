<%@ page import="java.time.format.DateTimeFormatter,java.util.*,model.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
private String statusLabel(String status) {
  if ("CONFIRMED".equals(status)) return "&#272;&atilde; x&aacute;c nh&#7853;n";
  if ("SHIPPING".equals(status)) return "&#272;ang giao";
  if ("FINISH".equals(status)) return "Ho&agrave;n th&agrave;nh";
  if ("CANCELLED".equals(status)) return "&#272;&atilde; h&#7911;y";
  return "Ch&#7901; x&aacute;c nh&#7853;n";
}

private int itemCount(Order order) {
  int total = 0;
  for (Integer quantity : order.getItems().values()) total += quantity;
  return total;
}
%>
<%
List<Order> orders = (List<Order>) request.getAttribute("orders");
if (orders == null) orders = List.of();
DateTimeFormatter dateTime = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
long grandTotal = 0;
int purchasedItems = 0;
for (Order order : orders) {
  grandTotal += order.getTotal();
  purchasedItems += itemCount(order);
}
%>

<section class="container content-section purchase-history">
  <div class="history-heading">
    <div>
      <span class="eyebrow">BokStore</span>
      <h1>L&#7883;ch s&#7917; mua h&agrave;ng</h1>
      <p>Theo d&otilde;i c&aacute;c &#273;&#417;n h&agrave;ng b&#7841;n &#273;&atilde; &#273;&#7863;t v&agrave; xem chi ti&#7871;t h&oacute;a &#273;&#417;n.</p>
    </div>
    <a class="history-shop-link" href="<%=request.getContextPath()%>/shop">Ti&#7871;p t&#7909;c mua s&aacute;ch</a>
  </div>

  <div class="history-stats">
    <div><span>T&#7893;ng &#273;&#417;n</span><strong><%=orders.size()%></strong></div>
    <div><span>S&#7843;n ph&#7849;m &#273;&atilde; mua</span><strong><%=purchasedItems%></strong></div>
    <div><span>T&#7893;ng chi ti&ecirc;u</span><strong><%=String.format("%,d", grandTotal)%>&#8363;</strong></div>
  </div>

  <% if (orders.isEmpty()) { %>
    <div class="history-empty">
      <h2>B&#7841;n ch&#432;a c&oacute; &#273;&#417;n h&agrave;ng n&agrave;o</h2>
      <p>Khi b&#7841;n &#273;&#7863;t s&aacute;ch, to&agrave;n b&#7897; l&#7883;ch s&#7917; mua h&agrave;ng s&#7869; hi&#7879;n &#7903; &#273;&acirc;y.</p>
      <a href="<%=request.getContextPath()%>/shop">Mua s&aacute;ch ngay</a>
    </div>
  <% } else { %>
    <div class="history-list">
      <% for (Order order : orders) { %>
        <article class="history-card">
          <div class="history-card-main">
            <div>
              <span class="order-code">#<%=order.getId()%></span>
              <h2><%=order.getCustomer()%></h2>
              <p><%=order.getCreated().format(dateTime)%> &middot; <%=itemCount(order)%> s&#7843;n ph&#7849;m</p>
            </div>
            <span class="order-status status-<%=order.getStatus().toLowerCase(Locale.ROOT)%>"><%=statusLabel(order.getStatus())%></span>
          </div>
          <div class="history-card-meta">
            <span><strong>Thanh to&aacute;n:</strong> <%=order.getPayment()%></span>
            <span><strong>T&#7893;ng ti&#7873;n:</strong> <%=String.format("%,d", order.getTotal())%>&#8363;</span>
          </div>
          <div class="history-actions">
            <a class="history-detail-btn" href="<%=request.getContextPath()%>/order-detail?id=<%=order.getId()%>">Xem chi ti&#7871;t</a>
            <% if ("PENDING".equals(order.getStatus())) { %>
              <form method="post" action="<%=request.getContextPath()%>/orders">
                <input type="hidden" name="id" value="<%=order.getId()%>">
                <button class="history-cancel-btn" type="submit">H&#7911;y &#273;&#417;n</button>
              </form>
            <% } %>
          </div>
        </article>
      <% } %>
    </div>
  <% } %>
</section>
