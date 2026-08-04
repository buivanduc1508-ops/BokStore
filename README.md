# BokStore

Ứng dụng bán sách Java Servlet/JSP chạy trên Tomcat 10.1.

## Chạy thử

1. Cấu hình dự án với JDK 17 trở lên và Tomcat 10.1.
2. Thêm JSTL Jakarta vào `WEB-INF/lib`.
3. Chạy ứng dụng và mở `/BokStore/home`.

Tài khoản mẫu: `admin/admin123` và `user/user123`.

## Chức năng

- Khách hàng: tìm kiếm, lọc, sắp xếp, giỏ hàng, đặt/hủy đơn, yêu thích, đánh giá, hồ sơ và đổi mật khẩu.
- Quản trị: danh mục, sản phẩm, nhập kho, ẩn/khôi phục, tài khoản, hóa đơn, doanh thu, bán chạy và cảnh báo tồn kho.
- Bảo mật: PBKDF2, CSRF token, phân quyền server-side, giới hạn đăng nhập sai và security headers.
