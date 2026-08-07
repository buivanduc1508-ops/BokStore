package dao;

import java.io.ByteArrayInputStream;
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
    String sql = "CREATE TABLE IF NOT EXISTS app_state (id INT PRIMARY KEY, payload BLOB NOT NULL, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
    try (Connection connection = ConnectDB.getConnect(); Statement statement = connection.createStatement()) {
      statement.execute(sql);
    } catch (Exception e) {
      throw new IllegalStateException("Không thể khởi tạo database H2", e);
    }
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
        PreparedStatement statement = connection.prepareStatement("SELECT payload FROM app_state WHERE id = 1");
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
      System.err.println("Cảnh báo: Không thể đọc snapshot cũ từ H2 DB (" + e.getMessage() + "). Ứng dụng sẽ nạp dữ liệu khởi tạo chuẩn.");
      return false;
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
        new Snapshot(List.copyOf(categories), List.copyOf(books), List.copyOf(users),
            List.copyOf(orders), List.copyOf(reviews), Map.copyOf(favorites), Map.copyOf(avatars));
    try (ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        ObjectOutputStream output = new ObjectOutputStream(bytes)) {
      output.writeObject(snapshot);
      output.flush();
      try (Connection connection = ConnectDB.getConnect()) {
        connection.setAutoCommit(false);
        try (PreparedStatement statement =
            connection.prepareStatement(
                "MERGE INTO app_state (id, payload, updated_at) KEY(id) VALUES (1, ?, CURRENT_TIMESTAMP)")) {
          statement.setBytes(1, bytes.toByteArray());
          statement.executeUpdate();
          connection.commit();
        } catch (Exception e) {
          connection.rollback();
          throw e;
        }
      }
    } catch (Exception e) {
      throw new IllegalStateException("Không thể lưu database H2", e);
    }
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

    Snapshot(List<Category> categories, List<Book> books, List<User> users, List<Order> orders,
        List<Review> reviews, Map<Integer, Set<Integer>> favorites, Map<Integer, String> avatars) {
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
