package dao;

import java.util.*;
import model.*;

public class StoreDAOTest {
  public static void main(String[] args) {
    StoreDAO d = StoreDAO.get();
    User u = d.login("user", "user123");
    check(u != null, "Đăng nhập");
    int before = d.book(1).getStock();
    Map<Integer, Integer> cart = new LinkedHashMap<>();
    cart.put(1, 2);
    Order o = d.checkout(u, cart, "Test", "Hải Phòng", "0900000001", "COD");
    check(d.book(1).getStock() == before - 2, "Trừ kho");
    check(d.cancel(o.getId(), u), "Hủy đơn");
    check(d.book(1).getStock() == before, "Hoàn kho");
    check(d.toggleFavorite(u.getId(), 1), "Yêu thích");
    d.review(u, 1, 5, "Sách rất hay");
    check(d.rating(1) == 5, "Đánh giá");
    System.out.println("PASS: BokStore core flows");
  }

  private static void check(boolean ok, String name) {
    if (!ok) throw new AssertionError(name);
  }
}
