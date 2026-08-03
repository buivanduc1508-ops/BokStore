package model;

import java.io.Serializable;

public class Book implements Serializable {
  private int id, categoryId, stock, views, sold;
  private String name, author, publisher, image, description;
  private long price;
  private boolean deleted;

  public Book(
      int id,
      String name,
      String author,
      String publisher,
      long price,
      String image,
      String description,
      int categoryId,
      int stock) {
    this.id = id;
    this.name = name;
    this.author = author;
    this.publisher = publisher;
    this.price = price;
    this.image = image;
    this.description = description;
    this.categoryId = categoryId;
    this.stock = stock;
  }

  public int getId() {
    return id;
  }

  public void setId(int v) {
    id = v;
  }

  public int getCategoryId() {
    return categoryId;
  }

  public void setCategoryId(int v) {
    categoryId = v;
  }

  public int getStock() {
    return stock;
  }

  public void setStock(int v) {
    stock = v;
  }

  public int getViews() {
    return views;
  }

  public void setViews(int v) {
    views = v;
  }

  public int getSold() {
    return sold;
  }

  public void setSold(int v) {
    sold = v;
  }

  public String getName() {
    return name;
  }

  public void setName(String v) {
    name = v;
  }

  public String getAuthor() {
    return author;
  }

  public void setAuthor(String v) {
    author = v;
  }

  public String getPublisher() {
    return publisher;
  }

  public void setPublisher(String v) {
    publisher = v;
  }

  public String getImage() {
    return image;
  }

  public void setImage(String v) {
    image = v;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String v) {
    description = v;
  }

  public long getPrice() {
    return price;
  }

  public void setPrice(long v) {
    price = v;
  }

  public boolean isDeleted() {
    return deleted;
  }

  public void setDeleted(boolean v) {
    deleted = v;
  }
}
