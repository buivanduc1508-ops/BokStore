<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:out
		value="${empty pageTitle ? 'Quản trị' : pageTitle}" /></title>
<link rel="stylesheet" href="<c:url value='/assets/css/app.css' />">
</head>
<body class="admin-layout">
	<header class="admin-header">
		<a class="brand" href="<c:url value='/admin' />">ADMIN / TÊN DỰ ÁN</a>
		<span>Khu vực quản trị</span>
	</header>


	<div class="admin-shell">
		<aside class="admin-sidebar">
			<nav aria-label="Điều hướng quản trị">
				<a
					class="${activePage eq 'dashboard' ? 'nav-link is-active' : 'nav-link'}"
					href="<c:url value='/admin' />">Tổng quan</a> <a class="nav-link"
					href="#">Quản lý dữ liệu</a> <a class="nav-link"
					href="<c:url value='/home' />">Về trang khách</a>
			</nav>
		</aside>

		<main class="admin-main">
			<%-- Controller truyền đường dẫn JSP nội dung qua thuộc tính contentPage. --%>
			<jsp:include page="${contentPage}" />
		</main>
	</div>

	<footer class="admin-footer">
		<p>
			© <span data-current-year></span> Admin layout. Thay phần này bằng
			footer quản trị thật.
		</p>
	</footer>
	<script src="<c:url value='/assets/js/app.js' />"></script>
</body>
</html>
