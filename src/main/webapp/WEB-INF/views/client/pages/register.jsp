<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="auth-page">
  <div class="auth-shell register-shell">
    <aside class="auth-visual">
      <span class="auth-kicker">Th&agrave;nh vi&ecirc;n BokStore</span>
      <h1>T&#7841;o t&agrave;i kho&#7843;n &#273;&#7875; mua s&aacute;ch d&#7877; h&#417;n</h1>
      <p>L&#432;u th&ocirc;ng tin nh&#7853;n h&agrave;ng, xem l&#7883;ch s&#7917; mua v&agrave; qu&#7843;n l&yacute; t&#7911; s&aacute;ch y&ecirc;u th&iacute;ch c&#7911;a b&#7841;n.</p>
      <div class="auth-benefits">
        <span>Mi&#7877;n ph&iacute; t&#7841;o t&agrave;i kho&#7843;n</span>
        <span>B&#7843;o m&#7853;t th&ocirc;ng tin</span>
        <span>Qu&#7843;n l&yacute; &#273;&#417;n h&agrave;ng</span>
      </div>
    </aside>

    <form class="auth-card register-card" method="post" action="${pageContext.request.contextPath}/register">
      <div class="auth-card-head">
        <span class="auth-icon" aria-hidden="true">&#9997;</span>
        <div>
          <h2>&#272;&#259;ng k&yacute;</h2>
          <p>Ho&agrave;n t&#7845;t th&ocirc;ng tin &#273;&#7875; b&#7855;t &#273;&#7847;u mua s&aacute;ch.</p>
        </div>
      </div>

      <c:if test="${not empty error}">
        <p class="auth-error"><c:out value="${error}" /></p>
      </c:if>

      <div class="auth-field-grid">
        <label class="auth-field">
          <span>H&#7885; t&ecirc;n</span>
          <input name="name" required autocomplete="name" placeholder="Nguy&#7877;n V&#259;n A">
        </label>

        <label class="auth-field">
          <span>Email</span>
          <input name="email" type="email" required autocomplete="email" placeholder="ban@email.com">
        </label>

        <label class="auth-field">
          <span>S&#7889; &#273;i&#7879;n tho&#7841;i</span>
          <input name="phone" autocomplete="tel" placeholder="09xxxxxxxx">
        </label>

        <label class="auth-field">
          <span>T&ecirc;n &#273;&#259;ng nh&#7853;p</span>
          <input name="username" required autocomplete="username" placeholder="ten_dang_nhap">
        </label>
      </div>

      <label class="auth-field">
        <span>&#272;&#7883;a ch&#7881;</span>
        <input name="address" autocomplete="street-address" placeholder="S&#7889; nh&agrave;, ph&#432;&#7901;ng/x&atilde;, qu&#7853;n/huy&#7879;n">
      </label>

      <label class="auth-field">
        <span>M&#7853;t kh&#7849;u</span>
        <input name="password" required type="password" autocomplete="new-password" placeholder="T&#7889;i thi&#7875;u 6 k&yacute; t&#7921;">
      </label>

      <button class="auth-submit" type="submit">T&#7841;o t&agrave;i kho&#7843;n</button>

      <p class="auth-switch">
        &#272;&atilde; c&oacute; t&agrave;i kho&#7843;n?
        <a href="${pageContext.request.contextPath}/login">&#272;&#259;ng nh&#7853;p</a>
      </p>
    </form>
  </div>
</section>
