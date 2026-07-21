<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:out
		value="${empty pageTitle ? 'Tên dự án' : pageTitle}" /></title>
<link rel="stylesheet" href="<c:url value='/assets/css/app.css' />">
</head>
<body class="client-layout">
	<header class="site-header">
		<div class="container header-inner">
			<a class="brand" href="<c:url value='/home' />">LOGO / TÊN DỰ ÁN</a>

			<nav class="main-nav" aria-label="Điều hướng chính">
				<a
					class="${activePage eq 'home' ? 'nav-link is-active' : 'nav-link'}"
					href="<c:url value='/home' />">Trang chủ</a> <a class="nav-link"
					href="#">Sản phẩm</a> <a class="nav-link" href="#">Liên hệ</a> <a
					class="nav-link" href="<c:url value='/admin' />">Quản trị</a>
			</nav>
		</div>
	</header>


	<main class="site-main">
		<%-- Controller truyền đường dẫn JSP nội dung qua thuộc tính contentPage. --%>
		<jsp:include page="${contentPage}" />
	</main>

	<footer class="site-footer">
		<div class="container footer-inner">
			<p>
				© <span data-current-year></span> Tên dự án. Thay phần này bằng
				footer giao diện thật.
			</p>
		</div>
	</footer>
	<script src="<c:url value='/assets/js/app.js' />"></script>
</body>
</html>
