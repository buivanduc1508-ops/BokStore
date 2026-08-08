<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:out value="${empty pageTitle ? 'BokStore' : pageTitle}" /> | BokStore</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&family=Lora:wght@600;700&family=Playfair+Display:wght@500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<c:url value='/assets/css/app.css' />">
<link rel="stylesheet" href="<c:url value='/assets/css/bokstore.css' />">
<link rel="stylesheet" href="<c:url value='/assets/css/bokstore-extra.css' />">
<link rel="stylesheet" href="<c:url value='/assets/css/bokstore-images.css' />">
<link rel="stylesheet" href="<c:url value='/assets/css/account-menu.css' />">
<link rel="stylesheet" href="<c:url value='/assets/css/mot-header.css' />?v=20260808c">
</head>
<body class="client-layout">
  <header class="mot-header">
    <div class="mot-contact-strip">
      <div class="container">
        <span>&#272;&#7890;NG H&Agrave;NH T&Igrave;M TRI TH&#7912;C</span>
        <span>(+84)902 978 990</span>
        <span>hotro@bokstore.vn</span>
      </div>
    </div>

    <div class="container mot-topbar">
      <a class="mot-brand" href="<c:url value='/home' />" aria-label="BokStore">
        <span class="mot-logo-icon" aria-hidden="true"></span>
        <span class="mot-logo-text">Bok<br>Store</span>
      </a>

      <form class="mot-search" action="<c:url value='/shop' />" method="get" role="search">
        <input type="search" name="q" value="${param.q}" placeholder="T&igrave;m ki&#7871;m..." aria-label="T&igrave;m ki&#7871;m s&aacute;ch">
        <button type="submit" aria-label="T&igrave;m ki&#7871;m">&#8981;</button>
      </form>

      <div class="mot-actions">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <a class="mot-action-link" href="<c:url value='/orders' />">&#272;&#417;n h&agrave;ng</a>
            <c:if test="${sessionScope.user.role eq 'ADMIN'}">
              <a class="mot-action-link" href="<c:url value='/admin/manage' />">Qu&#7843;n tr&#7883;</a>
            </c:if>
          </c:when>
          <c:otherwise>
            <a class="mot-action-link" href="<c:url value='/login' />">&#272;&#259;ng nh&#7853;p</a>
            <a class="mot-action-link" href="<c:url value='/login' />">&#272;&#259;ng k&yacute;</a>
          </c:otherwise>
        </c:choose>
        <a class="mot-cart" href="<c:url value='/cart' />" aria-label="Gi&#7887; h&agrave;ng">
          <span class="mot-cart-count">${empty cartSize ? 0 : cartSize}</span>
          <span class="mot-cart-icon" aria-hidden="true"></span>
        </a>
        <c:if test="${not empty sessionScope.user}">
          <div class="account-menu" data-account-menu>
            <button class="account-trigger" type="button" aria-label="M&#7903; menu t&agrave;i kho&#7843;n" aria-expanded="false" aria-controls="accountDropdown">
              <span class="account-avatar" aria-hidden="true"><c:choose><c:when test="${not empty avatarData}"><img src="<c:out value='${avatarData}' />" alt=""></c:when><c:otherwise><c:out value="${sessionScope.user.name.substring(0,1)}" /></c:otherwise></c:choose></span>
              <span class="account-chevron" aria-hidden="true">&#8964;</span>
            </button>
            <div class="account-dropdown" id="accountDropdown" hidden>
              <div class="account-summary">
                <form class="avatar-form" method="post" action="<c:url value='/avatar' />">
                  <label class="avatar-change-button" title="Thay &#273;&#7893;i &#7843;nh &#273;&#7841;i di&#7879;n">
                    <span class="account-avatar account-avatar-large"><c:choose><c:when test="${not empty avatarData}"><img src="<c:out value='${avatarData}' />" alt="&#7842;nh &#273;&#7841;i di&#7879;n"></c:when><c:otherwise><c:out value="${sessionScope.user.name.substring(0,1)}" /></c:otherwise></c:choose></span>
                    <span class="avatar-camera" aria-hidden="true">&#9998;</span>
                    <input class="avatar-file-input" type="file" accept="image/png,image/jpeg,image/webp" aria-label="Ch&#7885;n &#7843;nh &#273;&#7841;i di&#7879;n">
                  </label>
                  <input type="hidden" name="avatarData" value="">
                </form>
                <div><strong><c:out value="${sessionScope.user.name}" /></strong><small><c:out value="${sessionScope.user.email}" /></small><button class="avatar-change-text" type="button">Thay &#273;&#7893;i avatar</button></div>
              </div>
              <p class="avatar-status" role="status" hidden></p>
              <a href="<c:url value='/profile' />">Th&ocirc;ng tin t&agrave;i kho&#7843;n</a>
              <a href="<c:url value='/wishlist' />">Y&ecirc;u th&iacute;ch</a>
              <a class="account-logout" href="<c:url value='/logout' />">&#272;&#259;ng xu&#7845;t</a>
            </div>
          </div>
        </c:if>
      </div>
    </div>

    <div class="mot-nav-wrap">
      <div class="container mot-nav-shell">
        <aside class="mot-category-box" aria-label="Danh m&#7909;c">
          <div class="mot-category-title">DANH M&#7908;C</div>
          <a href="<c:url value='/home' />">Trang ch&#7911;</a>
          <a href="<c:url value='/shop' />">T&#7845;t c&#7843; s&aacute;ch</a>
          <a href="<c:url value='/shop?shelf=new' />">S&aacute;ch m&#7899;i</a>
          <a href="<c:url value='/shop?shelf=promo' />">S&aacute;ch khuy&#7871;n m&atilde;i</a>
          <a href="<c:url value='/contact' />">Li&ecirc;n h&#7879;</a>
          <a href="<c:url value='/about' />">Gi&#7899;i thi&#7879;u</a>
        </aside>

        <nav class="mot-main-nav" aria-label="&#272;i&#7873;u h&#432;&#7899;ng ch&iacute;nh">
          <a class="${activePage eq 'home' ? 'is-active' : ''}" href="<c:url value='/home' />">TRANG CH&#7910;</a>
          <a class="${activePage eq 'shop' and shopShelf eq 'viewed' ? 'is-active' : ''}" href="<c:url value='/shop?shelf=viewed' />">S&Aacute;CH &#272;&Atilde; XEM</a>
          <a class="${activePage eq 'shop' and empty shopShelf ? 'is-active' : ''}" href="<c:url value='/shop' />">T&#7844;T C&#7842; S&Aacute;CH</a>
          <a class="${activePage eq 'shop' and shopShelf eq 'new' ? 'is-active' : ''}" href="<c:url value='/shop?shelf=new' />">S&Aacute;CH M&#7898;I</a>
          <a class="${activePage eq 'shop' and shopShelf eq 'promo' ? 'is-active' : ''}" href="<c:url value='/shop?shelf=promo' />">S&Aacute;CH KHUY&#7870;N M&Atilde;I</a>
        </nav>
      </div>
    </div>
  </header>

  <main class="site-main">
    <c:if test="${not empty sessionScope.flash}"><div class="toast-message" id="appToast"><c:out value="${sessionScope.flash}"/></div><c:remove var="flash" scope="session"/></c:if>
    <jsp:include page="${contentPage}" />
  </main>

  <footer class="site-footer">
    <div class="container footer-inner">
      <div><strong>BokStore</strong><p>Tri th&#7913;c trong t&#7847;m tay b&#7841;n.</p></div>
      <p>&copy; <span data-current-year></span> BokStore &middot; Giao h&agrave;ng to&agrave;n qu&#7889;c</p>
    </div>
  </footer>
  <script src="<c:url value='/assets/js/app.js' />"></script>
  <script>document.querySelectorAll('form[method="post"],form[method="POST"]').forEach(function(f){if(!f.querySelector('[name="csrfToken"]')){var i=document.createElement('input');i.type='hidden';i.name='csrfToken';i.value='${sessionScope.csrfToken}';f.appendChild(i);}});var t=document.getElementById('appToast');if(t)setTimeout(function(){t.classList.add('hide')},3500);</script>
</body>
</html>
