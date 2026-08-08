<%@ page import="java.time.format.DateTimeFormatter,java.util.*,model.*,dao.StoreDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
private String statusLabel(String status) {
  if ("CONFIRMED".equals(status)) return "&#272;&atilde; x&aacute;c nh&#7853;n";
  if ("SHIPPING".equals(status)) return "&#272;ang giao";
  if ("FINISH".equals(status)) return "Ho&agrave;n th&agrave;nh";
  if ("CANCELLED".equals(status)) return "&#272;&atilde; h&#7911;y";
  return "Ch&#7901; x&aacute;c nh&#7853;n";
}
%>
<%
Order order = (Order) request.getAttribute("order");
DateTimeFormatter dateTime = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<section class="container content-section order-detail-page">
  <div class="history-heading">
    <div>
      <span class="eyebrow">H&oacute;a &#273;&#417;n</span>
      <h1>&#272;&#417;n h&agrave;ng #<%=order.getId()%></h1>
      <p>&#272;&#7863;t l&uacute;c <%=order.getCreated().format(dateTime)%></p>
    </div>
    <div class="history-actions">
      <a class="history-shop-link" href="<%=request.getContextPath()%>/orders">Quay l&#7841;i</a>
      <button class="history-detail-btn" type="button" onclick="window.print()">In h&oacute;a &#273;&#417;n</button>
    </div>
  </div>

  <div class="order-summary-grid">
    <div><span>Ng&#432;&#7901;i nh&#7853;n</span><strong><%=order.getCustomer()%></strong></div>
    <div><span>S&#7889; &#273;i&#7879;n tho&#7841;i</span><strong><%=order.getPhone()%></strong></div>
    <div><span>Thanh to&aacute;n</span><strong><%=order.getPayment()%></strong></div>
    <div><span>Tr&#7841;ng th&aacute;i</span><strong class="order-status status-<%=order.getStatus().toLowerCase(Locale.ROOT)%>"><%=statusLabel(order.getStatus())%></strong></div>
  </div>

  <div class="address-box">
    <span>&#272;&#7883;a ch&#7881; giao h&agrave;ng</span>
    <strong><%=order.getAddress()%></strong>
  </div>

  <div class="history-table-wrap">
    <table class="history-table">
      <thead>
        <tr>
          <th>S&aacute;ch</th>
          <th>&#272;&#417;n gi&aacute;</th>
          <th>S&#7889; l&#432;&#7907;ng</th>
          <th>Th&agrave;nh ti&#7873;n</th>
        </tr>
      </thead>
      <tbody>
        <% for (Map.Entry<Integer,Integer> item : order.getItems().entrySet()) {
          Book book = StoreDAO.get().book(item.getKey());
          long price = order.getPrices().getOrDefault(item.getKey(), book == null ? 0 : book.getPrice());
        %>
          <tr>
            <td><%=book == null ? "S&aacute;ch &#273;&atilde; &#7849;n" : book.getName()%></td>
            <td><%=String.format("%,d", price)%>&#8363;</td>
            <td><%=item.getValue()%></td>
            <td><%=String.format("%,d", price * item.getValue())%>&#8363;</td>
          </tr>
        <% } %>
      </tbody>
      <tfoot>
        <tr>
          <th colspan="3">T&#7893;ng c&#7897;ng</th>
          <th><%=String.format("%,d", order.getTotal())%>&#8363;</th>
        </tr>
      </tfoot>
    </table>
  </div>

  <section class="status-timeline">
    <h2>L&#7883;ch s&#7917; tr&#7841;ng th&aacute;i</h2>
    <ul>
      <% for (String history : order.getHistory()) { %>
        <li><%=history%></li>
      <% } %>
    </ul>
  </section>
</section>
