package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {
  public static Connection con = null;

    public static Connection getConnect() {
        // Thay tên database, tài khoản và mật khẩu theo máy của nhóm.
        String strDbUrl = "jdbc:sqlserver://localhost:1433;"
                + "databaseName=BOOKSTORE;"
                + "user=sa;password=1234;"
                + "encrypt=true;trustServerCertificate=true";

    try {
      con = DriverManager.getConnection(strDbUrl);
      System.out.println("Kết nối BOOKSTORE thành công");
    } catch (SQLException e) {
      System.err.println("Không thể kết nối BOOKSTORE: " + e.getMessage());
    }

    return con;
  }

  private static String env(String name, String fallback) {
    String value = System.getenv(name);
    return value == null || value.isBlank() ? fallback : value;
  }

  public static void main(String[] args) {
    ConnectDB.getConnect();
  }
}
