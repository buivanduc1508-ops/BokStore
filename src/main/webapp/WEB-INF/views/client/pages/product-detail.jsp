<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- 1. BANNER TIÊU ĐỀ PHÍA TRÊN (BACKGROUND TỐI MÀU) -->
<div class="product-detail-header">
  <div class="mot-container text-center">
    <h1 class="page-title-main">${product.name}</h1>
    <div class="breadcrumb-nav">
      <a href="<c:url value='/home' />">Trang chủ</a> /
      <span>Sách</span> /
      <span class="active-crumb">${product.name}</span>
    </div>
  </div>
</div>

<!-- 2. NỘI DUNG CHI TIẾT SẢN PHẨM -->
<div class="mot-container my-5">
  <div class="product-detail-wrapper">

    <!-- Cột trái: Ảnh thumbnail phụ và Ảnh chính lớn -->
    <div class="product-gallery">
      <div class="thumbnail-list">
        <div class="thumb-item active">
          <img src="${product.image}" alt="${product.name}" onerror="this.onerror=null; this.src='https://picsum.photos/100/150?random=${product.id}';" />
        </div>
        <div class="thumb-item">
          <img src="https://picsum.photos/100/150?random=88" alt="Preview 1" />
        </div>
        <div class="thumb-item">
          <img src="https://picsum.photos/100/150?random=99" alt="Preview 2" />
        </div>
      </div>

      <div class="main-image">
        <img id="mainImg" src="${product.image}" alt="${product.name}" onerror="this.onerror=null; this.src='https://picsum.photos/400/550?random=${product.id}';" />
      </div>
    </div>

    <!-- Cột phải: Thông tin & Form chọn mua -->
    <div class="product-main-info">
      <h2 class="detail-book-title">${product.name}</h2>
      <div class="meta-info">
        <span>Nhà xuất bản: <strong>NXB Lao động</strong></span> |
        <span>Loại: <strong>Sách Bán Chạy</strong></span> |
      </div>

      <!-- Giá tiền & Giảm giá -->
      <div class="detail-price-box">
                <span class="detail-price-new">
                    <fmt:formatNumber value="${product.price}" type="number" pattern="#,##0"/>đ
                </span>
        <span class="detail-price-old">
                    <fmt:formatNumber value="${product.price * 1.25}" type="number" pattern="#,##0"/>đ
                </span>
        <span class="saving-note">(Bạn đã tiết kiệm được <fmt:formatNumber value="${product.price * 0.25}" type="number" pattern="#,##0"/>đ)</span>
      </div>

      <!-- Mô tả chi tiết -->
      <div class="detail-description">
        <p>${product.description}</p>
      </div>

      <!-- Hotline hỗ trợ -->
      <div class="hotline-box">
        📞 Hotline hỗ trợ 24/7: <strong>(+84) 902 978 990</strong> |
      </div>

      <!-- Form Chọn số lượng & Nút thao tác -->
      <form action="<c:url value='/add-to-cart' />" method="POST" class="buy-form">
        <input type="hidden" name="productId" value="${product.id}">

        <div class="quantity-selector">
          <label>Số lượng</label>
          <div class="qty-control">
            <button type="button" class="btn-qty" onclick="decreaseQty()">-</button>
            <input type="number" id="quantityInput" name="quantity" value="1" min="1" max="${product.quantity}">
            <button type="button" class="btn-qty" onclick="increaseQty()">+</button>
          </div>
        </div>

        <div class="action-buttons">
          <button type="submit" class="btn-add-cart">THÊM VÀO GIỎ HÀNG</button>
          <button type="submit" formaction="<c:url value='/checkout' />" class="btn-buy-now">MUA NGAY</button>
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
    input.value = val + 1;
  }
</script>