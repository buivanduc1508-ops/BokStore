package utils;

import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

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
    Connection conn = DriverManager.getConnection(url, env("DB_USER", "sa"), env("DB_PASSWORD", ""));
    ensureTablesCreated(conn);
    return conn;
  }

  private static String defaultUrl() {
    String userDir = System.getProperty("user.dir");
    String file = Path.of(userDir, "data", "bokstore").toAbsolutePath().toString().replace('\\', '/');
    return "jdbc:h2:file:" + file + ";AUTO_SERVER=TRUE;DB_CLOSE_DELAY=-1";
  }

  private static synchronized void ensureTablesCreated(Connection conn) {
    try (java.sql.Statement stmt = conn.createStatement()) {
      stmt.execute("CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, full_name VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL UNIQUE, username VARCHAR(100) UNIQUE, password_hash VARCHAR(255) NOT NULL, phone VARCHAR(20), address VARCHAR(255), role VARCHAR(20) NOT NULL DEFAULT 'USER', status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
      stmt.execute("CREATE TABLE IF NOT EXISTS categories (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, description VARCHAR(500), status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
      stmt.execute("CREATE TABLE IF NOT EXISTS books (id INT AUTO_INCREMENT PRIMARY KEY, category_id INT NOT NULL, name VARCHAR(150) NOT NULL, author VARCHAR(150), publisher VARCHAR(150), description CLOB, price DECIMAL(18,2) NOT NULL DEFAULT 0, image VARCHAR(500), quantity INT NOT NULL DEFAULT 0, views INT NOT NULL DEFAULT 0, sold INT NOT NULL DEFAULT 0, status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
      stmt.execute("CREATE TABLE IF NOT EXISTS orders (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, receiver_name VARCHAR(100) NOT NULL, receiver_phone VARCHAR(20) NOT NULL, receiver_address VARCHAR(255) NOT NULL, note VARCHAR(500), total_amount DECIMAL(18,2) NOT NULL DEFAULT 0, payment_method VARCHAR(20) NOT NULL DEFAULT 'COD', order_status VARCHAR(20) NOT NULL DEFAULT 'PENDING', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
      stmt.execute("CREATE TABLE IF NOT EXISTS order_items (id INT AUTO_INCREMENT PRIMARY KEY, invoice_id INT NOT NULL, product_id INT NOT NULL, product_name VARCHAR(150) NOT NULL, product_image VARCHAR(500), price_at_purchase DECIMAL(18,2) NOT NULL, quantity INT NOT NULL, line_total DECIMAL(18,2) NOT NULL)");
      stmt.execute("CREATE TABLE IF NOT EXISTS reviews (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, book_id INT NOT NULL, user_name VARCHAR(100) NOT NULL, rating INT NOT NULL, content VARCHAR(500), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
      stmt.execute("CREATE TABLE IF NOT EXISTS favorites (user_id INT NOT NULL, book_id INT NOT NULL, PRIMARY KEY (user_id, book_id))");
      stmt.execute("CREATE TABLE IF NOT EXISTS danh_muc (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, description VARCHAR(500), status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
      stmt.execute("CREATE TABLE IF NOT EXISTS san_pham (id INT AUTO_INCREMENT PRIMARY KEY, category_id INT NOT NULL, name VARCHAR(150) NOT NULL, description CLOB, price DECIMAL(18,2) NOT NULL DEFAULT 0, image VARCHAR(500), quantity INT NOT NULL DEFAULT 0, status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
    } catch (Exception ignored) {
    }
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
