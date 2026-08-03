package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {
  public static Connection con = null;

  public static Connection getConnect() {
    String host = env("BOOKSTORE_DB_HOST", "localhost");
    String port = env("BOOKSTORE_DB_PORT", "1433");
    String database = env("BOOKSTORE_DB_NAME", "BOOKSTORE");
    String user = env("BOOKSTORE_DB_USER", "sa");
    String password = env("BOOKSTORE_DB_PASSWORD", "");
    String strDbUrl =
        "jdbc:sqlserver://"
            + host
            + ":"
            + port
            + ";"
            + "databaseName="
            + database
            + ";"
            + "user="
            + user
            + ";password="
            + password
            + ";"
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
