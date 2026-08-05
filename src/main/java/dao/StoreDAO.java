package dao;

import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import model.*;
import utils.PasswordUtils;

/**
 * Kho dữ liệu dùng chung. Có thể thay các phương thức này bằng JDBC mà không đổi controller/view.
 */
public final class StoreDAO {
  private static final StoreDAO INSTANCE = new StoreDAO();
  private final StoreDatabase database = new StoreDatabase();
  private final List<Category> categories = Collections.synchronizedList(new ArrayList<>());
  private final List<Book> books = Collections.synchronizedList(new ArrayList<>());
  private final List<User> users = Collections.synchronizedList(new ArrayList<>());
  private final List<Order> orders = Collections.synchronizedList(new ArrayList<>());
  private final List<Review> reviews = Collections.synchronizedList(new ArrayList<>());
  private final Map<Integer, Set<Integer>> favorites = new HashMap<>();
  private final Map<Integer, String> avatars = new HashMap<>();
  private final AtomicInteger categorySeq = new AtomicInteger(), bookSeq = new AtomicInteger(),
      userSeq = new AtomicInteger(), orderSeq = new AtomicInteger(), reviewSeq = new AtomicInteger();

  private StoreDAO() {
    if (database.load(categories, books, users, orders, reviews, favorites, avatars)) {
      resetSequences();
      return;
    }
    categories.add(new Category(1, "Văn học"));
    categories.add(new Category(2, "Kỹ năng"));
    categories.add(new Category(3, "Công nghệ"));
    books.add(
        new Book(
            1,
            "Nhà giả kim",
            "Paulo Coelho",
            "Nhã Nam",
            79000,
            "",
            "Hành trình theo đuổi ước mơ.",
            1,
            20));
    books.add(
        new Book(
            2,
            "Đắc nhân tâm",
            "Dale Carnegie",
            "Tổng hợp",
            86000,
            "",
            "Nghệ thuật giao tiếp và ứng xử.",
            2,
            16));
    books.add(
        new Book(
            3,
            "Clean Code",
            "Robert C. Martin",
            "Pearson",
            245000,
            "",
            "Cẩm nang viết mã nguồn sạch.",
            3,
            8));
    books.add(
        new Book(
            4,
            "Tuổi trẻ đáng giá bao nhiêu",
            "Rosie Nguyễn",
            "Hội Nhà Văn",
            90000,
            "",
            "Sách truyền cảm hứng cho người trẻ.",
            2,
            12));
    books.add(
        new Book(
            5,
            "Dế Mèn phiêu lưu ký",
            "Tô Hoài",
            "Kim Đồng",
            65000,
            "",
            "Tác phẩm văn học thiếu nhi kinh điển.",
            1,
            25));
    books.add(
        new Book(
            6,
            "Java Core",
            "Cay Horstmann",
            "Pearson",
            320000,
            "",
            "Nền tảng lập trình Java.",
            3,
            5));
    users.add(
        new User(
            1,
            "Quản trị viên",
            "admin@bokstore.vn",
            "BokStore",
            "0900000000",
            "admin",
            PasswordUtils.hash("admin123"),
            "ADMIN"));
    users.add(
        new User(
            2,
            "Khách hàng mẫu",
            "user@bokstore.vn",
            "TP. Hồ Chí Minh",
            "0911111111",
            "user",
            PasswordUtils.hash("user123"),
            "USER"));
    resetSequences();
    persist();
  }

  private void resetSequences() {
    categorySeq.set(categories.stream().mapToInt(Category::getId).max().orElse(0) + 1);
    bookSeq.set(books.stream().mapToInt(Book::getId).max().orElse(0) + 1);
    userSeq.set(users.stream().mapToInt(User::getId).max().orElse(0) + 1);
    orderSeq.set(orders.stream().mapToInt(Order::getId).max().orElse(0) + 1);
    reviewSeq.set(reviews.stream().mapToInt(Review::getId).max().orElse(0) + 1);
  }

  private synchronized void persist() {
    database.save(categories, books, users, orders, reviews, favorites, avatars);
  }

  public String avatar(int userId) {
    return avatars.getOrDefault(userId, "");
  }

  public synchronized void updateAvatar(int userId, String avatarData) {
    if (user(userId) == null) throw new IllegalArgumentException("Tài khoản không tồn tại");
    if (avatarData == null || avatarData.isBlank()) {
      avatars.remove(userId);
    } else {
      if (!avatarData.matches("^data:image/(png|jpeg|webp);base64,[A-Za-z0-9+/=]+$")
          || avatarData.length() > 750_000)
        throw new IllegalArgumentException("Ảnh đại diện không hợp lệ hoặc quá lớn");
      avatars.put(userId, avatarData);
    }
    persist();
  }

  public static StoreDAO get() {
    return INSTANCE;
  }

  public List<Category> categories() {
    return categories.stream().filter(x -> !x.isDeleted()).collect(Collectors.toList());
  }

  public Category category(int id) {
    return categories.stream().filter(x -> x.getId() == id).findFirst().orElse(null);
  }

  public synchronized Category saveCategory(int id, String name) {
    Category c = category(id);
    if (c == null) {
      c = new Category(categorySeq.getAndIncrement(), name);
      categories.add(c);
    } else c.setName(name);
    persist();
    return c;
  }

  public synchronized boolean deleteCategory(int id) {
    if (books.stream().anyMatch(b -> !b.isDeleted() && b.getCategoryId() == id)) return false;
    Category c = category(id);
    if (c != null) {
      c.setDeleted(true);
      persist();
    }
    return c != null;
  }

  public List<Book> books(String q, int category, String publisher, String availability) {
    return books.stream()
        .filter(b -> !b.isDeleted())
        .filter(
            b ->
                q == null
                    || q.isBlank()
                    || (b.getName() + " " + b.getAuthor()).toLowerCase().contains(q.toLowerCase()))
        .filter(b -> category == 0 || b.getCategoryId() == category)
        .filter(
            b ->
                publisher == null
                    || publisher.isBlank()
                    || b.getPublisher().equalsIgnoreCase(publisher))
        .filter(
            b ->
                availability == null
                    || availability.isBlank()
                    || ("in".equals(availability) ? b.getStock() > 0 : b.getStock() == 0))
        .collect(Collectors.toList());
  }

  public List<Book> books() {
    return books(null, 0, null, null);
  }

  public Book book(int id) {
    return books.stream().filter(x -> x.getId() == id && !x.isDeleted()).findFirst().orElse(null);
  }

  public synchronized Book saveBook(
      int id,
      String name,
      String author,
      String publisher,
      long price,
      String image,
      String description,
      int category,
      int stock) {
    Book b = book(id);
    if (b == null) {
      b =
          new Book(
              bookSeq.getAndIncrement(),
              name,
              author,
              publisher,
              price,
              image,
              description,
              category,
              stock);
      books.add(b);
    } else {
      b.setName(name);
      b.setAuthor(author);
      b.setPublisher(publisher);
      b.setPrice(price);
      b.setImage(image);
      b.setDescription(description);
      b.setCategoryId(category);
      b.setStock(stock);
    }
    persist();
    return b;
  }

  public void deleteBook(int id) {
    Book b = books.stream().filter(x -> x.getId() == id).findFirst().orElse(null);
    if (b != null) {
      b.setDeleted(true);
      persist();
    }
  }

  public void restoreBook(int id) {
    Book b = books.stream().filter(x -> x.getId() == id).findFirst().orElse(null);
    if (b != null) {
      b.setDeleted(false);
      persist();
    }
  }

  public List<Book> deletedBooks() {
    return books.stream().filter(Book::isDeleted).collect(Collectors.toList());
  }

  public User login(String account, String password) {
    return users.stream()
        .filter(
            u ->
                u.isActive()
                    && (u.getUsername().equalsIgnoreCase(account)
                        || u.getEmail().equalsIgnoreCase(account)
                        || u.getPhone().equals(account))
                    && PasswordUtils.verify(password, u.getPassword()))
        .findFirst()
        .orElse(null);
  }

  public List<User> users() {
    return new ArrayList<>(users);
  }

  public User user(int id) {
    return users.stream().filter(x -> x.getId() == id).findFirst().orElse(null);
  }

  public synchronized User saveUser(
      int id,
      String name,
      String email,
      String address,
      String phone,
      String username,
      String password,
      String role) {
    User u = user(id);
    if (u == null) {
      if (users.stream()
          .anyMatch(
              x ->
                  x.getUsername().equalsIgnoreCase(username)
                      || x.getEmail().equalsIgnoreCase(email)))
        throw new IllegalArgumentException("Tên đăng nhập hoặc email đã tồn tại");
      u =
          new User(
              userSeq.getAndIncrement(),
              name,
              email,
              address,
              phone,
              username,
              PasswordUtils.hash(password),
              role);
      users.add(u);
    } else {
      u.setName(name);
      u.setEmail(email);
      u.setAddress(address);
      u.setPhone(phone);
      if (password != null && !password.isBlank()) u.setPassword(PasswordUtils.hash(password));
      u.setRole(role);
    }
    persist();
    return u;
  }

  public boolean deleteUser(int id, int actor) {
    if (id == actor) return false;
    boolean removed = users.removeIf(x -> x.getId() == id);
    if (removed) persist();
    return removed;
  }

  public boolean toggleUser(int id, int actor) {
    User u = user(id);
    if (u == null || id == actor) return false;
    u.setActive(!u.isActive());
    persist();
    return true;
  }

  public synchronized Order checkout(
      User u,
      Map<Integer, Integer> cart,
      String customer,
      String address,
      String phone,
      String payment) {
    if (cart == null || cart.isEmpty()) throw new IllegalArgumentException("Giỏ hàng đang trống");
    long total = 0;
    for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
      Book b = book(e.getKey());
      if (b == null || e.getValue() < 1 || b.getStock() < e.getValue())
        throw new IllegalArgumentException("Sản phẩm không đủ tồn kho");
      total += b.getPrice() * e.getValue();
    }
    Order o = new Order(orderSeq.getAndIncrement(), u.getId(), customer, address, phone, payment);
    o.getItems().putAll(cart);
    o.setTotal(total);
    o.getHistory().add(o.getCreated() + " - PENDING");
    for (Integer id : cart.keySet()) o.getPrices().put(id, book(id).getPrice());
    for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
      Book b = book(e.getKey());
      b.setStock(b.getStock() - e.getValue());
      b.setSold(b.getSold() + e.getValue());
    }
    orders.add(o);
    persist();
    return o;
  }

  public List<Order> orders() {
    List<Order> r = new ArrayList<>(orders);
    Collections.reverse(r);
    return r;
  }

  public List<Order> ordersFor(int uid) {
    return orders().stream().filter(x -> x.getUserId() == uid).collect(Collectors.toList());
  }

  public Order order(int id) {
    return orders.stream().filter(x -> x.getId() == id).findFirst().orElse(null);
  }

  public boolean cancel(int id, User actor) {
    Order o = order(id);
    if (o == null
        || (!"ADMIN".equals(actor.getRole()) && o.getUserId() != actor.getId())
        || !"PENDING".equals(o.getStatus())) return false;
    o.setStatus("CANCELLED");
    for (Map.Entry<Integer, Integer> e : o.getItems().entrySet()) {
      Book b = book(e.getKey());
      if (b != null) {
        b.setStock(b.getStock() + e.getValue());
        b.setSold(Math.max(0, b.getSold() - e.getValue()));
      }
    }
    persist();
    return true;
  }

  public synchronized boolean status(int id, String status) {
    Order o = order(id);
    if (o == null || status.equals(o.getStatus())) return o != null;
    Map<String, Set<String>> flow =
        Map.of(
            "PENDING",
            Set.of("CONFIRMED", "CANCELLED"),
            "CONFIRMED",
            Set.of("SHIPPING", "CANCELLED"),
            "SHIPPING",
            Set.of("FINISH"),
            "FINISH",
            Set.of(),
            "CANCELLED",
            Set.of());
    if (!flow.getOrDefault(o.getStatus(), Set.of()).contains(status))
      throw new IllegalArgumentException(
          "Không thể chuyển trạng thái " + o.getStatus() + " sang " + status);
    if ("CANCELLED".equals(status))
      for (Map.Entry<Integer, Integer> e : o.getItems().entrySet()) {
        Book b = book(e.getKey());
        if (b != null) {
          b.setStock(b.getStock() + e.getValue());
          b.setSold(Math.max(0, b.getSold() - e.getValue()));
        }
      }
    o.setStatus(status);
    persist();
    return true;
  }

  public long revenue(LocalDate from, LocalDate to) {
    return orders.stream()
        .filter(o -> !"CANCELLED".equals(o.getStatus()))
        .filter(
            o ->
                !o.getCreated().toLocalDate().isBefore(from)
                    && !o.getCreated().toLocalDate().isAfter(to))
        .mapToLong(Order::getTotal)
        .sum();
  }

  public List<Book> top10() {
    return books().stream()
        .sorted(Comparator.comparingInt(Book::getSold).reversed())
        .limit(10)
        .collect(Collectors.toList());
  }

  public List<Book> lowStock() {
    return books().stream()
        .filter(b -> b.getStock() <= 10)
        .sorted(Comparator.comparingInt(Book::getStock))
        .collect(Collectors.toList());
  }

  public Map<String, Long> statusCounts() {
    return orders.stream().collect(Collectors.groupingBy(Order::getStatus, Collectors.counting()));
  }

  public synchronized void addStock(int id, int quantity) {
    Book b = book(id);
    if (b == null || quantity < 1) throw new IllegalArgumentException("Số lượng nhập không hợp lệ");
    b.setStock(b.getStock() + quantity);
    persist();
  }

  public synchronized boolean toggleFavorite(int userId, int bookId) {
    Set<Integer> set = favorites.computeIfAbsent(userId, k -> new LinkedHashSet<>());
    if (set.remove(bookId)) {
      persist();
      return false;
    }
    set.add(bookId);
    persist();
    return true;
  }

  public boolean isFavorite(int userId, int bookId) {
    return favorites.getOrDefault(userId, Set.of()).contains(bookId);
  }

  public List<Book> favorites(int userId) {
    return favorites.getOrDefault(userId, Set.of()).stream()
        .map(this::book)
        .filter(Objects::nonNull)
        .collect(Collectors.toList());
  }

  public synchronized Review review(User u, int bookId, int rating, String content) {
    if (book(bookId) == null || rating < 1 || rating > 5 || content == null || content.isBlank())
      throw new IllegalArgumentException("Đánh giá không hợp lệ");
    reviews.removeIf(x -> x.getUserId() == u.getId() && x.getBookId() == bookId);
    Review r =
        new Review(reviewSeq.getAndIncrement(), u.getId(), bookId, u.getName(), rating, content);
    reviews.add(r);
    persist();
    return r;
  }

  public List<Review> reviews(int bookId) {
    return reviews.stream()
        .filter(r -> r.getBookId() == bookId)
        .sorted(Comparator.comparing(Review::getCreated).reversed())
        .collect(Collectors.toList());
  }

  public double rating(int bookId) {
    return reviews(bookId).stream().mapToInt(Review::getRating).average().orElse(0);
  }
}
