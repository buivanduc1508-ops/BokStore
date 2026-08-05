# BokStore

Ứng dụng bán sách Java Servlet/JSP, dùng Java 17, Maven và Tomcat 10.1.

## Chạy trong IntelliJ IDEA

1. Mở thư mục dự án và chọn **Load Maven Project** khi IntelliJ nhận ra `pom.xml`.
2. Chọn Project SDK là JDK 17 trở lên.
3. Với IntelliJ IDEA Ultimate, tạo cấu hình **Tomcat Server > Local**, deploy artifact `BokStore:war exploded` với application context `/BokStore`.
4. Với IntelliJ IDEA Community, mở Terminal của IntelliJ và chạy `run-intellij-runtime.bat`.
5. Truy cập <http://localhost:8080/BokStore/home>.

Hướng dẫn chi tiết nằm trong [INTELLIJ.md](INTELLIJ.md).

## Cơ sở dữ liệu

Khởi tạo SQL Server bằng `Data.sql` và `database/BOOKSTORE_UPGRADE.sql`. Có thể cấu hình kết nối bằng các biến môi trường `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`. Giá trị mặc định dành cho môi trường phát triển là `localhost:1433`, database `BOOKSTORE`, tài khoản `sa`, mật khẩu `1234`.

Tài khoản mẫu: `admin/admin123` và `user/user123`.
