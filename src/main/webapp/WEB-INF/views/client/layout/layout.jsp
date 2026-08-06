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
<link rel="stylesheet" href="<c:url value='/assets/css/mot-header.css' />?v=20260806d">
</head>
<body class="client-layout">
	<header class="mot-header">
		<div class="container mot-topbar">
			<a class="mot-brand" href="<c:url value='/home' />" aria-label="MOT Bookstore">
				<span class="mot-logo-icon" aria-hidden="true"></span>
				<span class="mot-logo-text">MOT<br>BOOKSTORE</span>
			</a>

			<form class="mot-search" action="<c:url value='/shop' />" method="get" role="search">
				<input type="search" name="q" value="${param.q}" placeholder="Tìm kiếm..." aria-label="Tìm kiếm sách">
				<button type="submit" aria-label="Tìm kiếm">⌕</button>
			</form>

			<div class="mot-actions">
				<c:choose>
					<c:when test="${not empty sessionScope.user}">
						<a class="mot-action-link" href="<c:url value='/orders' />">⇥ Đơn hàng</a>
						<c:if test="${sessionScope.user.role eq 'ADMIN'}">
							<a class="mot-action-link" href="<c:url value='/admin/manage' />">✎ Quản trị</a>
						</c:if>
					</c:when>
					<c:otherwise>
						<a class="mot-action-link" href="<c:url value='/login' />">⇥ Đăng nhập</a>
						<a class="mot-action-link" href="<c:url value='/login' />">✎ Đăng ký</a>
					</c:otherwise>
				</c:choose>
				<a class="mot-cart" href="<c:url value='/cart' />" aria-label="Giỏ hàng">
					<span class="mot-cart-count">${empty cartSize ? 0 : cartSize}</span>
					<span class="mot-cart-icon" aria-hidden="true"></span>
				</a>
				<c:if test="${not empty sessionScope.user}">
					<div class="account-menu" data-account-menu>
						<button class="account-trigger" type="button" aria-label="Mở menu tài khoản" aria-expanded="false" aria-controls="accountDropdown">
							<span class="account-avatar" aria-hidden="true"><c:choose><c:when test="${not empty avatarData}"><img src="<c:out value='${avatarData}' />" alt=""></c:when><c:otherwise><c:out value="${sessionScope.user.name.substring(0,1)}" /></c:otherwise></c:choose></span>
							<span class="account-chevron" aria-hidden="true">⌄</span>
						</button>
						<div class="account-dropdown" id="accountDropdown" hidden>
							<div class="account-summary">
								<form class="avatar-form" method="post" action="<c:url value='/avatar' />">
									<label class="avatar-change-button" title="Thay đổi ảnh đại diện">
										<span class="account-avatar account-avatar-large"><c:choose><c:when test="${not empty avatarData}"><img src="<c:out value='${avatarData}' />" alt="Ảnh đại diện"></c:when><c:otherwise><c:out value="${sessionScope.user.name.substring(0,1)}" /></c:otherwise></c:choose></span>
										<span class="avatar-camera" aria-hidden="true">✎</span>
										<input class="avatar-file-input" type="file" accept="image/png,image/jpeg,image/webp" aria-label="Chọn ảnh đại diện">
									</label>
									<input type="hidden" name="avatarData" value="">
								</form>
								<div><strong><c:out value="${sessionScope.user.name}" /></strong><small><c:out value="${sessionScope.user.email}" /></small><button class="avatar-change-text" type="button">Thay đổi avatar</button></div>
							</div>
							<p class="avatar-status" role="status" hidden></p>
							<a href="<c:url value='/profile' />"><span aria-hidden="true">☺</span> Thông tin tài khoản</a>
							<a href="<c:url value='/wishlist' />"><span aria-hidden="true">♡</span> Yêu thích</a>
							<a class="account-logout" href="<c:url value='/logout' />"><span aria-hidden="true">→</span> Đăng xuất</a>
						</div>
					</div>
				</c:if>
			</div>
		</div>

		<div class="mot-nav-wrap">
			<div class="container mot-nav-shell">
				<aside class="mot-category-box" aria-label="Danh mục">
					<div class="mot-category-title">☰ DANH MỤC</div>
					<a href="<c:url value='/home' />">📖 Trang chủ</a>
					<a href="<c:url value='/shop' />">📖 Sản phẩm</a>
					<a href="<c:url value='/contact' />">📖 Liên hệ</a>
					<a href="<c:url value='/about' />">📖 Giới thiệu</a>
					<c:if test="${not empty sessionScope.user}">
						<a href="<c:url value='/wishlist' />">📖 Yêu thích</a>
						<a href="<c:url value='/orders' />">📖 Đơn hàng</a>
						<c:if test="${sessionScope.user.role eq 'ADMIN'}">
							<a href="<c:url value='/admin/manage' />">📖 Quản trị</a>
						</c:if>
					</c:if>
				</aside>

				<nav class="mot-main-nav" aria-label="Điều hướng chính">
					<a href="<c:url value='/shop' />">SÁCH ĐÃ XEM⌄</a>
					<a href="<c:url value='/shop' />">TẤT CẢ SÁCH</a>
					<a href="<c:url value='/shop?sort=name' />">SÁCH MỚI</a>
					<a href="<c:url value='/shop?availability=in' />">SÁCH KHUYẾN MÃI</a>
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
			<div><strong>BokStore</strong><p>Tri thức trong tầm tay bạn.</p></div>
			<p>© <span data-current-year></span> BokStore · Giao hàng toàn quốc</p>
		</div>
	</footer>
	<script src="<c:url value='/assets/js/app.js' />"></script>
	<script>document.querySelectorAll('form[method="post"],form[method="POST"]').forEach(function(f){if(!f.querySelector('[name="csrfToken"]')){var i=document.createElement('input');i.type='hidden';i.name='csrfToken';i.value='${sessionScope.csrfToken}';f.appendChild(i);}});var t=document.getElementById('appToast');if(t)setTimeout(function(){t.classList.add('hide')},3500);</script>
</body>
</html>
