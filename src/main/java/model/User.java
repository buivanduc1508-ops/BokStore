package model;

import java.io.Serializable;

public class User implements Serializable {
  private int id;
  private String name, email, address, phone, username, password, role;
  private boolean active = true;

  public User(
      int id,
      String name,
      String email,
      String address,
      String phone,
      String username,
      String password,
      String role) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.address = address;
    this.phone = phone;
    this.username = username;
    this.password = password;
    this.role = role;
  }

  public int getId() {
    return id;
  }

  public String getName() {
    return name;
  }

  public void setName(String v) {
    name = v;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String v) {
    email = v;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String v) {
    address = v;
  }

  public String getPhone() {
    return phone;
  }

  public void setPhone(String v) {
    phone = v;
  }

  public String getUsername() {
    return username;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String v) {
    password = v;
  }

  public String getRole() {
    return role;
  }

  public void setRole(String v) {
    role = v;
  }

  public boolean isActive() {
    return active;
  }

  public void setActive(boolean v) {
    active = v;
  }
}
