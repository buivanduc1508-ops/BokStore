package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class ConnectDB {
  private ConnectDB() {}

  static {
    try {
      Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (ClassNotFoundException e) {
      throw new IllegalStateException("Khong tim thay SQL Server JDBC driver", e);
    }
  }

  public static Connection getConnect() throws SQLException {
    String customUrl = System.getenv("DB_URL");
    String url = customUrl == null || customUrl.isBlank() ? defaultUrl() : customUrl;
    return DriverManager.getConnection(url, env("DB_USER", "sa"), env("DB_PASSWORD", ""));
  }

  private static String defaultUrl() {
    return "jdbc:sqlserver://localhost:1433;"
        + "databaseName=BOOKSTORE;"
        + "encrypt=true;"
        + "trustServerCertificate=true";
  }

  private static String env(String name, String fallback) {
    String value = System.getenv(name);
    return value == null || value.isBlank() ? fallback : value;
  }

  public static void main(String[] args) throws SQLException {
    try (Connection connection = getConnect()) {
      System.out.println("SQL Server connected: " + connection.getMetaData().getURL());
    }
  }
}
