# BokStore

Ứng dụng bán sách Java Servlet/JSP, dùng Java 17, Maven, Tomcat 10.1 và database H2 nhúng.

## Chạy trong IntelliJ IDEA

1. Mở thư mục dự án và chọn **Load Maven Project** khi IntelliJ nhận ra `pom.xml`.
2. Chọn Project SDK là JDK 17 trở lên.
3. Với IntelliJ IDEA Ultimate, tạo cấu hình **Tomcat Server > Local**, deploy artifact `BokStore:war exploded` với application context `/BokStore`.
4. Với IntelliJ IDEA Community, mở Terminal của IntelliJ và chạy `run-intellij-runtime.bat`.
5. Truy cập <http://localhost:8080/BokStore/home>.

Hướng dẫn chi tiết nằm trong [INTELLIJ.md](INTELLIJ.md).

## Cơ sở dữ liệu

Không cần cài SQL Server. Ứng dụng tự tạo database H2 ở `.runtime/apache-tomcat-10.1.54/data/bokstore.mv.db` khi mở trang sản phẩm lần đầu. Tài khoản, sản phẩm, đơn hàng, yêu thích và đánh giá được giữ lại sau khi khởi động lại Tomcat.

Muốn đặt database ở vị trí khác, cấu hình biến môi trường `DB_URL`, ví dụ `jdbc:h2:file:D:/bokstore-data/bokstore;AUTO_SERVER=TRUE`.

Hai script SQL Server cũ được giữ trong `Data.sql` và `database/BOOKSTORE_UPGRADE.sql` để tham khảo khi học chuyển đổi hệ quản trị cơ sở dữ liệu.

Tài khoản mẫu: `admin/admin123` và `user/user123`.
