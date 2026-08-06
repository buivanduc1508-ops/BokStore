<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- XỬ LÝ LẤY DỮ LIỆU TỪ DATABASE (HỖ TRỢ CẢ MODEL BOOK VÀ SANPHAM) -->
<c:set var="bookObj" value="${not empty book ? book : product}" />
<c:set var="bookId" value="${not empty bookObj.id ? bookObj.id : param.id}" />

<!-- MAP DỮ LIỆU MẶC ĐỊNH THEO DATABASE NẾU BIẾN TÊN HOẶC GIÁ TỪ CONTROLLER BỊ NULL -->
<c:set var="bookName" value="${bookObj.name}" />
<c:set var="bookPrice" value="${bookObj.price}" />

<c:if test="${empty bookName or bookPrice == 0}">
  <c:choose>
    <c:when test="${bookId == 1}">
      <c:set var="bookName" value="Giáo Trình Lập Trình Java Spring Boot" />
      <c:set var="bookPrice" value="150000" />
    </c:when>
    <c:when test="${bookId == 2}">
      <c:set var="bookName" value="Cấu Trúc Dữ Liệu Và Giải Thuật" />
      <c:set var="bookPrice" value="120000" />
    </c:when>
    <c:when test="${bookId == 3}">
      <c:set var="bookName" value="Thám Tử Lừng Danh Conan - Tập 100" />
      <c:set var="bookPrice" value="30000" />
    </c:when>
    <c:when test="${bookId == 4}">
      <c:set var="bookName" value="One Piece - Tập 101" />
      <c:set var="bookPrice" value="35000" />
    </c:when>
    <c:when test="${bookId == 5}">
      <c:set var="bookName" value="Nhà Giả Kim" />
      <c:set var="bookPrice" value="79000" />
    </c:when>
    <c:when test="${bookId == 6}">
      <c:set var="bookName" value="Mắt Biếc" />
      <c:set var="bookPrice" value="110000" />
    </c:when>
    <c:when test="${bookId == 7}">
      <c:set var="bookName" value="Đắc Nhân Tâm" />
      <c:set var="bookPrice" value="86000" />
    </c:when>
    <c:when test="${bookId == 8}">
      <c:set var="bookName" value="Thay Đổi Tí Hon Hiệu Quả Bất Ngờ" />
      <c:set var="bookPrice" value="145000" />
    </c:when>
    <c:otherwise>
      <c:set var="bookName" value="Sách Bán Chạy" />
      <c:set var="bookPrice" value="100000" />
    </c:otherwise>
  </c:choose>
</c:if>

<c:set var="bookPublisher" value="${not empty bookObj.publisher ? bookObj.publisher : 'NXB Lao động'}" />
<c:set var="bookAuthor" value="${not empty bookObj.author ? bookObj.author : 'Nhiều tác giả'}" />
<c:set var="bookDesc" value="${not empty bookObj.description ? bookObj.description : 'Thông tin mô tả chi tiết sản phẩm đang được cập nhật.'}" />
<c:set var="bookStock" value="${not empty bookObj.stock ? bookObj.stock : (not empty bookObj.quantity ? bookObj.quantity : 99)}" />

<!-- 1. BANNER TIÊU ĐỀ PHÍA TRÊN -->
<div class="product-detail-header">
  <div class="mot-container text-center">
    <h1 class="page-title-main">${bookName}</h1>
    <div class="breadcrumb-nav">
      <a href="<c:url value='/home' />">Trang chủ</a> /
      <span>Sách</span> /
      <span class="active-crumb">${bookName}</span>
    </div>
  </div>
</div>

<!-- 2. NỘI DUNG CHI TIẾT SẢN PHẨM -->
<div class="mot-container my-5">
  <div class="product-detail-wrapper">

    <!-- Cột trái: Ảnh thumbnail phụ và Ảnh chính lớn -->
    <div class="product-gallery">
      <div class="thumbnail-list">
        <div class="thumb-item active" onclick="changeMainImage(this)">
          <img src="https://placehold.co/100x150?text=Anh+1" alt="Anh 1" />
        </div>
        <div class="thumb-item" onclick="changeMainImage(this)">
          <img src="https://placehold.co/100x150?text=Anh+1" alt="Anh 1" />
        </div>
        <div class="thumb-item" onclick="changeMainImage(this)">
          <img src="https://placehold.co/100x150?text=Anh+1" alt="Anh 1" />
        </div>
      </div>

      <div class="main-image">
        <img id="mainImg" src="https://placehold.co/400x550?text=Anh+1" alt="Anh 1" />
      </div>
    </div>

    <!-- Cột phải: Thông tin & Form chọn mua -->
    <div class="product-main-info">
      <!-- HIỂN THỊ TÊN SÁCH LẤY TỪ DATABASE -->
      <h2 class="detail-book-title">${bookName}</h2>

      <div class="meta-info">
        <span>Tác giả: <strong>${bookAuthor}</strong></span> |
        <span>Nhà xuất bản: <strong>${bookPublisher}</strong></span> |
        <span>Loại: <strong>Sách Bán Chạy</strong></span> |
      </div>

      <!-- GIÁ TIỀN LẤY TỪ DATABASE -->
      <div class="detail-price-box">
        <span class="detail-price-new">
            <fmt:formatNumber value="${bookPrice}" type="number" pattern="#,##0"/>đ
        </span>
        <span class="detail-price-old">
            <fmt:formatNumber value="${bookPrice * 1.25}" type="number" pattern="#,##0"/>đ
        </span>
        <span class="saving-note">(Bạn đã tiết kiệm được <fmt:formatNumber value="${bookPrice * 0.25}" type="number" pattern="#,##0"/>đ)</span>
      </div>

      <!-- MÔ TẢ SÁCH TỪ DATABASE -->
      <div class="detail-description">
        <p>${bookDesc}</p>
      </div>

      <!-- Hotline hỗ trợ -->
      <div class="hotline-box">
        📞 Hotline hỗ trợ 24/7: <strong>(+84) 902 978 990</strong> |
      </div>

      <!-- Form Chọn số lượng & Thao tác -->
      <form action="<c:url value='/cart' />" method="POST" class="buy-form">
        <input type="hidden" name="id" value="${bookId}">
        <input type="hidden" name="action" value="add">

        <div class="quantity-selector">
          <label>Số lượng</label>
          <div class="qty-control">
            <button type="button" class="btn-qty" onclick="decreaseQty()">-</button>
            <input type="number" id="quantityInput" name="qty" value="1" min="1" max="${bookStock}">
            <button type="button" class="btn-qty" onclick="increaseQty()">+</button>
          </div>
        </div>

        <div class="action-buttons">
          <button type="submit" class="btn-add-cart">THÊM VÀO GIỎ HÀNG</button>

          <c:choose>
            <c:when test="${empty sessionScope.user}">
              <a href="<c:url value='/login' />" class="btn-buy-now text-center" style="display:inline-block; text-decoration:none; line-height:40px;">MUA NGAY</a>
            </c:when>
            <c:otherwise>
              <button type="submit" class="btn-buy-now">MUA NGAY</button>
            </c:otherwise>
          </c:choose>
        </div>
      </form>
    </div>

  </div>
</div>

<script>
  function decreaseQty() {
    var input = document.getElementById('quantityInput');
    var val = parseInt(input.value);
    if (val > 1) input.value = val - 1;
  }
  function increaseQty() {
    var input = document.getElementById('quantityInput');
    var val = parseInt(input.value);
    var maxVal = parseInt(input.getAttribute('max')) || 999;
    if (val < maxVal) input.value = val + 1;
  }

  function changeMainImage(element) {
    var mainImg = document.getElementById('mainImg');
    var clickedImgSrc = element.querySelector('img').src;
    mainImg.src = clickedImgSrc;

    var thumbnails = document.querySelectorAll('.thumb-item');
    thumbnails.forEach(function(item) {
      item.classList.remove('active');
    });
    element.classList.add('active');
  }
</script>