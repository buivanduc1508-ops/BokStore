package dao;

import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.Book;
import model.Category;
import model.Order;
import model.Review;
import model.User;
import utils.ConnectDB;

final class StoreDatabase {
  StoreDatabase() {
    initialize();
  }

  private void initialize() {
    String sql =
        "IF OBJECT_ID('dbo.app_state', 'U') IS NULL "
            + "CREATE TABLE dbo.app_state ("
            + "id INT PRIMARY KEY, "
            + "payload VARBINARY(MAX) NOT NULL, "
            + "updated_at DATETIME2 DEFAULT SYSDATETIME())";
    try (Connection connection = ConnectDB.getConnect();
        Statement statement = connection.createStatement()) {
      statement.execute(sql);
      widenImageColumnIfPresent(statement);
    } catch (Exception e) {
      throw new IllegalStateException("Khong the khoi tao database SQL Server", e);
    }
  }

  private void widenImageColumnIfPresent(Statement statement) throws Exception {
    statement.execute(
        "IF OBJECT_ID('dbo.san_pham', 'U') IS NOT NULL "
        + "AND COL_LENGTH('dbo.san_pham', 'image') IS NOT NULL "
        + "AND COL_LENGTH('dbo.san_pham', 'image') < 2000 "
        + "ALTER TABLE dbo.san_pham ALTER COLUMN image NVARCHAR(1000) NULL");
  }

  @SuppressWarnings("unchecked")
  boolean load(
      List<Category> categories,
      List<Book> books,
      List<User> users,
      List<Order> orders,
      List<Review> reviews,
      Map<Integer, Set<Integer>> favorites,
      Map<Integer, String> avatars) {
    try (Connection connection = ConnectDB.getConnect();
        PreparedStatement statement =
            connection.prepareStatement("SELECT payload FROM dbo.app_state WHERE id = 1");
        ResultSet result = statement.executeQuery()) {
      if (!result.next()) return false;
      try (ObjectInputStream input = new ObjectInputStream(result.getBinaryStream(1))) {
        Snapshot snapshot = (Snapshot) input.readObject();
        categories.addAll(snapshot.categories);
        books.addAll(snapshot.books);
        users.addAll(snapshot.users);
        orders.addAll(snapshot.orders);
        reviews.addAll(snapshot.reviews);
        if (snapshot.favorites != null) favorites.putAll(snapshot.favorites);
        if (snapshot.avatars != null) avatars.putAll(snapshot.avatars);
        return true;
      }
    } catch (Exception e) {
      throw new IllegalStateException("Khong the doc database SQL Server", e);
    }
  }

  boolean mergeSqlCatalog(List<Category> categories, List<Book> books) {
    try (Connection connection = ConnectDB.getConnect()) {
      if (!tableExists(connection, "danh_muc") || !tableExists(connection, "san_pham")) {
        return false;
      }

      boolean changed = !categories.isEmpty() || !books.isEmpty();
      categories.clear();
      books.clear();

      try (PreparedStatement statement =
              connection.prepareStatement("SELECT id, name, status FROM dbo.danh_muc ORDER BY id");
          ResultSet result = statement.executeQuery()) {
        while (result.next()) {
          Category category = new Category(result.getInt("id"), result.getString("name"));
          category.setDeleted(!"ACTIVE".equalsIgnoreCase(result.getString("status")));
          categories.add(category);
          changed = true;
        }
      }

      try (PreparedStatement statement =
              connection.prepareStatement(
                  "SELECT id, category_id, name, description, price, image, quantity, status "
                      + "FROM dbo.san_pham ORDER BY id");
          ResultSet result = statement.executeQuery()) {
        while (result.next()) {
          Book book =
              new Book(
                  result.getInt("id"),
                  result.getString("name"),
                  "Dang cap nhat",
                  "BokStore",
                  result.getBigDecimal("price").longValue(),
                  normalizeImage(safe(result.getString("image"))),
                  safe(result.getString("description")),
                  result.getInt("category_id"),
                  result.getInt("quantity"));
          book.setDeleted(!"ACTIVE".equalsIgnoreCase(result.getString("status")));
          books.add(book);
          changed = true;
        }
      }
      return changed;
    } catch (Exception e) {
      throw new IllegalStateException("Khong the dong bo san_pham tu SQL Server", e);
    }
  }

  void save(
      List<Category> categories,
      List<Book> books,
      List<User> users,
      List<Order> orders,
      List<Review> reviews,
      Map<Integer, Set<Integer>> favorites,
      Map<Integer, String> avatars) {
    Snapshot snapshot =
        new Snapshot(
            List.copyOf(categories),
            List.copyOf(books),
            List.copyOf(users),
            List.copyOf(orders),
            List.copyOf(reviews),
            Map.copyOf(favorites),
            Map.copyOf(avatars));
    try (ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        ObjectOutputStream output = new ObjectOutputStream(bytes)) {
      output.writeObject(snapshot);
      output.flush();
      try (Connection connection = ConnectDB.getConnect()) {
        connection.setAutoCommit(false);
        try {
          saveAppState(connection, bytes.toByteArray());
          syncSqlCatalog(connection, categories, books);
          connection.commit();
        } catch (Exception e) {
          connection.rollback();
          throw e;
        }
      }
    } catch (Exception e) {
      throw new IllegalStateException("Khong the luu database SQL Server", e);
    }
  }

  private void saveAppState(Connection connection, byte[] payload) throws Exception {
    try (PreparedStatement update =
        connection.prepareStatement(
            "UPDATE dbo.app_state SET payload = ?, updated_at = SYSDATETIME() WHERE id = 1")) {
      update.setBytes(1, payload);
      if (update.executeUpdate() > 0) return;
    }
    try (PreparedStatement insert =
        connection.prepareStatement(
            "INSERT INTO dbo.app_state (id, payload, updated_at) VALUES (1, ?, SYSDATETIME())")) {
      insert.setBytes(1, payload);
      insert.executeUpdate();
    }
  }

  private void syncSqlCatalog(Connection connection, List<Category> categories, List<Book> books)
      throws Exception {
    if (!tableExists(connection, "danh_muc") || !tableExists(connection, "san_pham")) {
      return;
    }
    syncCategories(connection, categories);
    syncBooks(connection, books);
  }

  private void syncCategories(Connection connection, List<Category> categories) throws Exception {
    boolean identity = hasIdentityId(connection, "danh_muc");
    if (identity) setIdentityInsert(connection, "danh_muc", true);
    try {
      for (Category category : categories) {
        try (PreparedStatement update =
            connection.prepareStatement(
                "UPDATE dbo.danh_muc SET name = ?, status = ? WHERE id = ?")) {
          update.setString(1, category.getName());
          update.setString(2, category.isDeleted() ? "INACTIVE" : "ACTIVE");
          update.setInt(3, category.getId());
          if (update.executeUpdate() > 0) continue;
        }
        try (PreparedStatement insert =
            connection.prepareStatement(
                "INSERT INTO dbo.danh_muc (id, name, description, status) VALUES (?, ?, ?, ?)")) {
          insert.setInt(1, category.getId());
          insert.setString(2, category.getName());
          insert.setString(3, "");
          insert.setString(4, category.isDeleted() ? "INACTIVE" : "ACTIVE");
          insert.executeUpdate();
        }
      }
    } finally {
      if (identity) setIdentityInsert(connection, "danh_muc", false);
    }
  }

  private void syncBooks(Connection connection, List<Book> books) throws Exception {
    boolean identity = hasIdentityId(connection, "san_pham");
    if (identity) setIdentityInsert(connection, "san_pham", true);
    try {
      for (Book book : books) {
        try (PreparedStatement update =
            connection.prepareStatement(
                "UPDATE dbo.san_pham SET category_id = ?, name = ?, description = ?, price = ?, "
                    + "image = ?, quantity = ?, status = ? WHERE id = ?")) {
          update.setInt(1, book.getCategoryId());
          update.setString(2, book.getName());
          update.setString(3, book.getDescription());
          update.setLong(4, book.getPrice());
          update.setString(5, book.getImage());
          update.setInt(6, book.getStock());
          update.setString(7, book.isDeleted() ? "INACTIVE" : "ACTIVE");
          update.setInt(8, book.getId());
          if (update.executeUpdate() > 0) continue;
        }
        try (PreparedStatement insert =
            connection.prepareStatement(
                "INSERT INTO dbo.san_pham "
                    + "(id, category_id, name, description, price, image, quantity, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
          insert.setInt(1, book.getId());
          insert.setInt(2, book.getCategoryId());
          insert.setString(3, book.getName());
          insert.setString(4, book.getDescription());
          insert.setLong(5, book.getPrice());
          insert.setString(6, book.getImage());
          insert.setInt(7, book.getStock());
          insert.setString(8, book.isDeleted() ? "INACTIVE" : "ACTIVE");
          insert.executeUpdate();
        }
      }
    } finally {
      if (identity) setIdentityInsert(connection, "san_pham", false);
    }
  }

  private boolean tableExists(Connection connection, String tableName) throws Exception {
    try (PreparedStatement statement =
        connection.prepareStatement(
            "SELECT 1 FROM INFORMATION_SCHEMA.TABLES "
                + "WHERE TABLE_SCHEMA = 'dbo' AND LOWER(TABLE_NAME) = LOWER(?)")) {
      statement.setString(1, tableName);
      try (ResultSet result = statement.executeQuery()) {
        return result.next();
      }
    }
  }

  private boolean hasIdentityId(Connection connection, String tableName) throws Exception {
    try (PreparedStatement statement =
        connection.prepareStatement(
            "SELECT COLUMNPROPERTY(OBJECT_ID('dbo.' + ?), 'id', 'IsIdentity')")) {
      statement.setString(1, tableName);
      try (ResultSet result = statement.executeQuery()) {
        return result.next() && result.getInt(1) == 1;
      }
    }
  }

  private void setIdentityInsert(Connection connection, String tableName, boolean enabled)
      throws Exception {
    try (Statement statement = connection.createStatement()) {
      statement.execute("SET IDENTITY_INSERT dbo." + tableName + (enabled ? " ON" : " OFF"));
    }
  }

  private String safe(String value) {
    return value == null ? "" : value;
  }

  private String normalizeImage(String value) {
    String image = value == null ? "" : value.trim();
    if (image.startsWith("//")) return "https:" + image;
    if (image.toLowerCase(java.util.Locale.ROOT).startsWith("www.")) return "https://" + image;

    String drivePrefix = "https://drive.google.com/file/d/";
    if (image.startsWith(drivePrefix)) {
      int start = drivePrefix.length();
      int end = image.indexOf('/', start);
      if (end > start) return "https://drive.google.com/thumbnail?id=" + image.substring(start, end) + "&sz=w800";
    }

    String driveOpen = "https://drive.google.com/open?id=";
    if (image.startsWith(driveOpen)) {
      String id = image.substring(driveOpen.length());
      int amp = id.indexOf('&');
      if (amp > 0) id = id.substring(0, amp);
      if (!id.isBlank()) return "https://drive.google.com/thumbnail?id=" + id + "&sz=w800";
    }
    return image;
  }

  private static final class Snapshot implements Serializable {
    private static final long serialVersionUID = 1L;
    final List<Category> categories;
    final List<Book> books;
    final List<User> users;
    final List<Order> orders;
    final List<Review> reviews;
    final Map<Integer, Set<Integer>> favorites;
    final Map<Integer, String> avatars;

    Snapshot(
        List<Category> categories,
        List<Book> books,
        List<User> users,
        List<Order> orders,
        List<Review> reviews,
        Map<Integer, Set<Integer>> favorites,
        Map<Integer, String> avatars) {
      this.categories = categories;
      this.books = books;
      this.users = users;
      this.orders = orders;
      this.reviews = reviews;
      this.favorites = favorites;
      this.avatars = avatars;
    }
  }
}
