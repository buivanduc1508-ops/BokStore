<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- ================= PHẦN THÊM MỚI: SLIDER CHUYỂN CẢNH ================= -->
<style>
  .bok-slider-wrapper {
    position: relative;
    width: 100%;
    overflow: hidden;
    background-color: #e8f0fe;
    padding: 40px 0;
  }

  .bok-slider-track {
    display: flex;
    width: calc(320px * 16); /* Nhân đôi độ dài danh sách để chạy lặp vô tận */
    animation: scrollLeft 30s linear infinite;
  }

  .bok-slider-track:hover {
    animation-play-state: paused; /* Tạm dừng hiệu ứng khi rê chuột vào */
  }

  .bok-slide-card {
    width: 280px;
    margin: 0 20px;
    flex-shrink: 0;
    background: #ffffff;
    border-radius: 12px;
    padding: 16px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .bok-slide-card img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 12px;
  }

  .bok-slide-card h3 {
    font-size: 1rem;
    margin: 8px 0;
    color: #1a1a1a;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  .bok-slide-card .price {
    color: #d97706;
    font-weight: bold;
    font-size: 1.1rem;
    margin-bottom: 12px;
  }

  @keyframes scrollLeft {
    0% {
      transform: translateX(0);
    }
    100% {
      transform: translateX(calc(-320px * 8)); /* Dịch chuyển qua trái 8 sản phẩm */
    }
  }
</style>

<div class="bok-slider-wrapper">
  <div class="bok-slider-track">
    <!-- Danh sách sản phẩm từ Database (Lần 1) -->
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/2b2d42/ffffff?text=Java+Spring" alt="Giáo Trình Lập Trình Java Spring Boot" />
      <h3>Giáo Trình Lập Trình Java Spring Boot</h3>
      <p class="price">150.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=1">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/1d3557/ffffff?text=Data+Structures" alt="Cấu Trúc Dữ Liệu Và Giải Thuật" />
      <h3>Cấu Trúc Dữ Liệu Và Giải Thuật</h3>
      <p class="price">120.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=2">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/457b9d/ffffff?text=Conan+100" alt="Thám Tử Lừng Danh Conan - Tập 100" />
      <h3>Thám Tử Lừng Danh Conan - Tập 100</h3>
      <p class="price">30.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=3">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/e63946/ffffff?text=One+Piece+101" alt="One Piece - Tập 101" />
      <h3>One Piece - Tập 101</h3>
      <p class="price">35.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=4">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/2a9d8f/ffffff?text=Nha+Gia+Kim" alt="Nhà Giả Kim" />
      <h3>Nhà Giả Kim</h3>
      <p class="price">79.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=5">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/e9c46a/ffffff?text=Mat+Biec" alt="Mắt Biếc" />
      <h3>Mắt Biếc</h3>
      <p class="price">110.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=6">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/f4a261/ffffff?text=Dac+Nhan+Tam" alt="Đắc Nhân Tâm" />
      <h3>Đắc Nhân Tâm</h3>
      <p class="price">86.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=7">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/e76f51/ffffff?text=Atomic+Habits" alt="Thay Đổi Tí Hon Hiệu Quả Bất Ngờ" />
      <h3>Thay Đổi Tí Hon Hiệu Quả Bất Ngờ</h3>
      <p class="price">145.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=8">Xem chi tiết</a>
    </div>

    <!-- Duplicate dữ liệu để vòng lặp hiệu ứng trượt mượt mà -->
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/2b2d42/ffffff?text=Java+Spring" alt="Giáo Trình Lập Trình Java Spring Boot" />
      <h3>Giáo Trình Lập Trình Java Spring Boot</h3>
      <p class="price">150.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=1">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/1d3557/ffffff?text=Data+Structures" alt="Cấu Trúc Dữ Liệu Và Giải Thuật" />
      <h3>Cấu Trúc Dữ Liệu Và Giải Thuật</h3>
      <p class="price">120.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=2">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/457b9d/ffffff?text=Conan+100" alt="Thám Tử Lừng Danh Conan - Tập 100" />
      <h3>Thám Tử Lừng Danh Conan - Tập 100</h3>
      <p class="price">30.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=3">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/e63946/ffffff?text=One+Piece+101" alt="One Piece - Tập 101" />
      <h3>One Piece - Tập 101</h3>
      <p class="price">35.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=4">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/2a9d8f/ffffff?text=Nha+Gia+Kim" alt="Nhà Giả Kim" />
      <h3>Nhà Giả Kim</h3>
      <p class="price">79.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=5">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/e9c46a/ffffff?text=Mat+Biec" alt="Mắt Biếc" />
      <h3>Mắt Biếc</h3>
      <p class="price">110.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=6">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/f4a261/ffffff?text=Dac+Nhan+Tam" alt="Đắc Nhân Tâm" />
      <h3>Đắc Nhân Tâm</h3>
      <p class="price">86.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=7">Xem chi tiết</a>
    </div>
    <div class="bok-slide-card">
      <img src="https://placehold.co/400x600/e76f51/ffffff?text=Atomic+Habits" alt="Thay Đổi Tí Hon Hiệu Quả Bất Ngờ" />
      <h3>Thay Đổi Tí Hon Hiệu Quả Bất Ngờ</h3>
      <p class="price">145.000 VNĐ</p>
      <a class="bok-btn" href="${pageContext.request.contextPath}/book?id=8">Xem chi tiết</a>
    </div>
  </div>
</div>
<!-- ================= KẾT THÚC PHẦN THÊM MỚI ================= -->

<!-- CODE CŨ DƯỚI ĐÂY GIỮ NGUYÊN 100% -->
<section class="hero">
  <div class="container">
    <p class="eyebrow">
      NHÀ SÁCH TRỰC TUYẾN
    </p>
    <h1>
      Mở một cuốn sách, mở cả thế giới
    </h1>
    <p>
      Khám phá sách mới, sách bán chạy và đặt hàng nhanh chóng tại BokStore.
    </p>
    <a class="bok-btn" href="${pageContext.request.contextPath}/shop">
      Khám phá ngay
    </a>
  </div>
</section>
<section class="container content-section">
  <h2>
    Mua sách dễ dàng
  </h2>
  <div class="feature-grid">
    <article>
      <h3>
        Tìm kiếm thông minh
      </h3>
      <p>
        Lọc nhanh sách theo từ khóa, danh mục và tồn kho.
      </p>
    </article>
    <article>
      <h3>
        Đặt hàng nhanh
      </h3>
      <p>
        Tự động tính tổng tiền và kiểm tra số lượng.
      </p>
    </article>
    <article>
      <h3>
        Theo dõi thuận tiện
      </h3>
      <p>
        Xem lịch sử và trạng thái giao hàng.
      </p>
    </article>
  </div>
</section>