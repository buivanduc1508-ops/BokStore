<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bokstore.css">
<section class="container content-section">
  <h1>
    Liên hệ
  </h1>
  <form class="checkout" method="post">
    <input name="name" required placeholder="Họ tên">
    <input name="email" type="email" required placeholder="Email">
    <textarea name="message" required placeholder="Nội dung">
    </textarea>
    <button>
      Gửi
    </button>
  </form>
</section>
