package utils;

import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Creates connections to the embedded H2 database. No database server is required. */
public final class ConnectDB {
  private ConnectDB() {}

  static {
    try {
      Class.forName("org.h2.Driver");
    } catch (ClassNotFoundException e) {
      throw new IllegalStateException("Không tìm thấy H2 JDBC driver", e);
    }
  }

  public static Connection getConnect() throws SQLException {
    String customUrl = System.getenv("DB_URL");
    String url = customUrl == null || customUrl.isBlank() ? defaultUrl() : customUrl;
    return DriverManager.getConnection(url, env("DB_USER", "sa"), env("DB_PASSWORD", ""));
  }

  private static String defaultUrl() {
    String base = System.getProperty("catalina.base", System.getProperty("user.dir"));
    String file = Path.of(base, "data", "bokstore").toAbsolutePath().toString().replace('\\', '/');
    return "jdbc:h2:file:" + file + ";AUTO_SERVER=TRUE";
  }

  private static String env(String name, String fallback) {
    String value = System.getenv(name);
    return value == null || value.isBlank() ? fallback : value;
  }

  public static void main(String[] args) throws SQLException {
    try (Connection connection = getConnect()) {
      System.out.println("H2 connected: " + connection.getMetaData().getURL());
    }
  }
}
