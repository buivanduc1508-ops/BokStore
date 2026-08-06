package dao;

import java.util.LinkedHashMap;
import java.util.Map;
import model.Book;
import model.Order;
import model.User;

public class StoreDAOTest {
  public static void main(String[] args) {
    StoreDAO dao = StoreDAO.get();
    User user = dao.login("user", "user123");
    check(user != null, "Đăng nhập");

    Book book = dao.book(1);
    int stockBefore = book.getStock();
    Map<Integer, Integer> cart = new LinkedHashMap<>();
    cart.put(book.getId(), 2);
    Order order = dao.checkout(user, cart, "Test", "Hải Phòng", "0900000001", "COD");
    check(dao.book(book.getId()).getStock() == stockBefore - 2, "Trừ kho");
    check(dao.cancel(order.getId(), user), "Hủy đơn");
    check(dao.book(book.getId()).getStock() == stockBefore, "Hoàn kho");

    boolean favoriteBefore = dao.isFavorite(user.getId(), book.getId());
    boolean favoriteAfter = dao.toggleFavorite(user.getId(), book.getId());
    check(favoriteAfter != favoriteBefore, "Yêu thích");

    dao.review(user, book.getId(), 5, "Sách rất hay");
    check(dao.rating(book.getId()) == 5, "Đánh giá");
    System.out.println("PASS: BokStore core flows");
  }

  private static void check(boolean ok, String name) {
    if (!ok) throw new AssertionError(name);
  }
}
