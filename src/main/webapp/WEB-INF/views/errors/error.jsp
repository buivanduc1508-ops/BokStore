<%@ page isErrorPage="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%int code=response.getStatus();String title=code==403?"Bạn không có quyền truy cập":code==404?"Không tìm thấy trang":"Hệ thống đang gặp sự cố";%>
<!doctype html>
<html lang="vi">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>
      <%=code%>
      | BokStore
    </title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/bokstore.css">
  </head>
  <body class="client-layout">
    <main class="container content-section" style="text-align:center;max-width:700px;padding-top:15vh">
      <div class="brand-mark" style="margin:auto">
        B
      </div>
      <p class="eyebrow">
        LỖI
        <%=code%>
      </p>
      <h1 style="font-size:44px">
        <%=title%>
      </h1>
      <p>
        <%=code==403?"Vui lòng đăng nhập bằng tài khoản có quyền phù hợp.":code==404?"Đường dẫn có thể đã thay đổi hoặc không còn tồn tại.":"Vui lòng thử lại sau hoặc quay về trang chủ."%>
      </p>
      <a class="bok-btn" href="<%=request.getContextPath()%>/home">
        Về trang chủ
      </a>
    </main>
  </body>
</html>
