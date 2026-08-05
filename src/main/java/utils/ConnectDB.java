package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {
  public static Connection getConnect() {
    String databaseUrl = "jdbc:sqlserver://" + env("DB_HOST", "localhost") + ":" + env("DB_PORT", "1433") + ";"
        + "databaseName=" + env("DB_NAME", "BOOKSTORE") + ";"
        + "user=" + env("DB_USER", "sa") + ";password=" + env("DB_PASSWORD", "1234") + ";"
        + "encrypt=true;trustServerCertificate=true";

    try {
      Connection connection = DriverManager.getConnection(databaseUrl);
      System.out.println("Ket noi BOOKSTORE thanh cong");
      return connection;
    } catch (SQLException e) {
      System.err.println("Khong the ket noi BOOKSTORE: " + e.getMessage());
      return null;
    }
  }

  private static String env(String name, String fallback) {
    String value = System.getenv(name);
    return value == null || value.isBlank() ? fallback : value;
  }

  public static void main(String[] args) {
    ConnectDB.getConnect();
  }
}
