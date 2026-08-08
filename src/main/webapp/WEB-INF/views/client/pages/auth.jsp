<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="auth-page">
  <div class="auth-shell">
    <aside class="auth-visual">
      <span class="auth-kicker">BokStore</span>
      <h1>Ch&agrave;o m&#7915;ng b&#7841;n quay l&#7841;i</h1>
      <p>&#272;&#259;ng nh&#7853;p &#273;&#7875; theo d&otilde;i &#273;&#417;n h&agrave;ng, l&#432;u s&aacute;ch y&ecirc;u th&iacute;ch v&agrave; mua s&aacute;ch nhanh h&#417;n.</p>
      <div class="auth-benefits">
        <span>L&#7883;ch s&#7917; mua h&agrave;ng</span>
        <span>Danh s&aacute;ch y&ecirc;u th&iacute;ch</span>
        <span>Thanh to&aacute;n nhanh</span>
      </div>
    </aside>

    <form class="auth-card" method="post" action="${pageContext.request.contextPath}/login">
      <div class="auth-card-head">
        <span class="auth-icon" aria-hidden="true">&#128274;</span>
        <div>
          <h2>&#272;&#259;ng nh&#7853;p</h2>
          <p>Nh&#7853;p t&agrave;i kho&#7843;n c&#7911;a b&#7841;n &#273;&#7875; ti&#7871;p t&#7909;c.</p>
        </div>
      </div>

      <c:if test="${not empty error}">
        <p class="auth-error"><c:out value="${error}" /></p>
      </c:if>

      <label class="auth-field">
        <span>Email / S&#272;T / T&ecirc;n &#273;&#259;ng nh&#7853;p</span>
        <input name="account" required autocomplete="username" placeholder="vd: user">
      </label>

      <label class="auth-field">
        <span>M&#7853;t kh&#7849;u</span>
        <input name="password" required type="password" autocomplete="current-password" placeholder="Nh&#7853;p m&#7853;t kh&#7849;u">
      </label>

      <button class="auth-submit" type="submit">&#272;&#259;ng nh&#7853;p</button>

      <p class="auth-switch">
        Ch&#432;a c&oacute; t&agrave;i kho&#7843;n?
        <a href="${pageContext.request.contextPath}/register">&#272;&#259;ng k&yacute; ngay</a>
      </p>
      <small class="auth-demo">Demo: admin/admin123 ho&#7863;c user/user123</small>
    </form>
  </div>
</section>
