<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty pageTitle ? 'Quản trị BokStore' : pageTitle}" /></title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.css'/>">
<link rel="stylesheet" href="<c:url value='/assets/vendors/perfect-scrollbar/perfect-scrollbar.css'/>">
<link rel="stylesheet" href="<c:url value='/assets/vendors/bootstrap-icons/bootstrap-icons.css'/>">
<link rel="stylesheet" href="<c:url value='/assets/css/app.css'/>">
<link rel="stylesheet" href="<c:url value='/assets/css/bokstore-admin.css'/>">
<link rel="stylesheet" href="<c:url value='/assets/css/bokstore-extra.css'/>">
<link rel="stylesheet" href="<c:url value='/assets/css/bokstore-dashboard.css'/>">
</head>
<body>
<div id="app">
    <aside id="sidebar" class="active">
        <div class="sidebar-wrapper active bok-sidebar">
            <div class="sidebar-header">
                <div class="d-flex justify-content-between align-items-center">
                    <a href="<c:url value='/admin/manage'/>"><span class="admin-brand-mark">B</span><span class="admin-brand-text">BokStore<small>TRANG QUẢN TRỊ</small></span></a>
                    <a href="#" class="sidebar-hide d-xl-none d-block"><i class="bi bi-x bi-middle"></i></a>
                </div>
            </div>
            <div class="sidebar-menu">
                <ul class="menu">
                    <li class="sidebar-title">QUẢN LÝ CỬA HÀNG</li>
                    <li class="sidebar-item ${empty tab or tab eq 'dashboard' ? 'active' : ''}"><a href="<c:url value='/admin/manage?tab=dashboard'/>" class="sidebar-link"><i class="bi bi-grid-fill"></i><span>Tổng quan</span></a></li>
                    <li class="sidebar-item ${tab eq 'categories' ? 'active' : ''}"><a href="<c:url value='/admin/manage?tab=categories'/>" class="sidebar-link"><i class="bi bi-tags-fill"></i><span>Quản lý danh mục</span></a></li>
                    <li class="sidebar-item ${tab eq 'books' ? 'active' : ''}"><a href="<c:url value='/admin/manage?tab=books'/>" class="sidebar-link"><i class="bi bi-book-fill"></i><span>Quản lý sản phẩm</span></a></li>
                    <li class="sidebar-item ${tab eq 'orders' ? 'active' : ''}"><a href="<c:url value='/admin/manage?tab=orders'/>" class="sidebar-link"><i class="bi bi-receipt"></i><span>Quản lý hóa đơn</span></a></li>
                    <li class="sidebar-item ${tab eq 'users' ? 'active' : ''}"><a href="<c:url value='/admin/manage?tab=users'/>" class="sidebar-link"><i class="bi bi-people-fill"></i><span>Quản lý tài khoản</span></a></li>
                    <li class="sidebar-title">BÁO CÁO &amp; GIÁM SÁT</li>
                    <li class="sidebar-item ${tab eq 'reports' ? 'active' : ''}"><a href="<c:url value='/admin/manage?tab=reports'/>" class="sidebar-link"><i class="bi bi-bar-chart-fill"></i><span>Thống kê doanh thu</span></a></li>
                    <li class="sidebar-item"><a href="<c:url value='/admin/manage?tab=reports'/>&view=top" class="sidebar-link"><i class="bi bi-trophy-fill"></i><span>Top sách bán chạy</span></a></li>
                    <li class="sidebar-title">TÀI KHOẢN</li>
                    <li class="sidebar-item"><a href="<c:url value='/shop'/>" class="sidebar-link"><i class="bi bi-shop"></i><span>Xem cửa hàng</span></a></li>
                    <li class="sidebar-item"><a href="<c:url value='/profile'/>" class="sidebar-link"><i class="bi bi-person-circle"></i><span>Hồ sơ cá nhân</span></a></li>
                    <li class="sidebar-item"><a href="<c:url value='/logout'/>" class="sidebar-link logout-link"><i class="bi bi-box-arrow-right"></i><span>Đăng xuất</span></a></li>
                </ul>
            </div>
            <div class="sidebar-user"><span class="user-avatar">${sessionScope.user.name.substring(0,1)}</span><div><strong><c:out value="${sessionScope.user.name}"/></strong><small>Quản trị viên</small></div></div>
            <button class="sidebar-toggler btn x"><i data-feather="x"></i></button>
        </div>
    </aside>
    <main id="main" class="admin-main">
        <a href="#" class="burger-btn d-block d-xl-none"><i class="bi bi-justify fs-3"></i></a>
        <c:if test="${not empty sessionScope.flash}"><div class="toast-message" id="appToast"><c:out value="${sessionScope.flash}"/></div><c:remove var="flash" scope="session"/></c:if>
        <jsp:include page="${contentPage}" />
        <footer class="admin-footer"><span>© <span data-current-year></span> BokStore</span><span>Hệ thống quản lý nhà sách</span></footer>
    </main>
</div>
<div class="admin-confirm" id="adminConfirm" hidden>
    <div class="admin-confirm-backdrop" data-confirm-cancel></div>
    <section class="admin-confirm-dialog" role="alertdialog" aria-modal="true" aria-labelledby="confirmTitle" aria-describedby="confirmMessage">
        <div class="admin-confirm-icon" aria-hidden="true">?</div>
        <h2 id="confirmTitle">Xác nhận thao tác</h2>
        <p id="confirmMessage">Bạn có chắc chắn muốn thực hiện thao tác này không?</p>
        <div class="admin-confirm-actions">
            <button type="button" class="confirm-cancel" data-confirm-cancel>Hủy</button>
            <button type="button" class="confirm-accept" data-confirm-accept>Xác nhận</button>
        </div>
    </section>
</div>
<script src="<c:url value='/assets/vendors/perfect-scrollbar/perfect-scrollbar.min.js'/>"></script>
<script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
<script src="<c:url value='/assets/js/main.js'/>"></script>
<script>document.querySelectorAll('[data-current-year]').forEach(function(el){el.textContent=new Date().getFullYear();});document.querySelectorAll('form[method="post"],form[method="POST"]').forEach(function(f){if(!f.querySelector('[name="csrfToken"]')){var i=document.createElement('input');i.type='hidden';i.name='csrfToken';i.value='${sessionScope.csrfToken}';f.appendChild(i);}});var t=document.getElementById('appToast');if(t)setTimeout(function(){t.classList.add('hide')},3500);</script>
<script src="<c:url value='/assets/js/admin-confirm.js'/>"></script>
</body>
</html>
