package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Review implements Serializable {
  private final int id, userId, bookId, rating;
  private final String userName, content;
  private final LocalDateTime created = LocalDateTime.now();

  public Review(int id, int userId, int bookId, String userName, int rating, String content) {
    this.id = id;
    this.userId = userId;
    this.bookId = bookId;
    this.userName = userName;
    this.rating = rating;
    this.content = content;
  }

  public int getId() {
    return id;
  }

  public int getUserId() {
    return userId;
  }

  public int getBookId() {
    return bookId;
  }

  public String getUserName() {
    return userName;
  }

  public int getRating() {
    return rating;
  }

  public String getContent() {
    return content;
  }

  public LocalDateTime getCreated() {
    return created;
  }
}
