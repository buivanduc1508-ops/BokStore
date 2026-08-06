<%@ page import="java.util.*,model.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%String tab=(String)request.getAttribute("tab");List<Category> cats=(List<Category>)request.getAttribute("categories");List<Book> books=(List<Book>)request.getAttribute("books");List<Book> deleted=(List<Book>)request.getAttribute("deletedBooks");List<Book> low=(List<Book>)request.getAttribute("lowStock");List<User> users=(List<User>)request.getAttribute("users");List<Order> orders=(List<Order>)request.getAttribute("orders");List<Book> top=(List<Book>)request.getAttribute("topBooks");Map<String,Long> counts=(Map<String,Long>)request.getAttribute("statusCounts");%>
<div class="bok-admin">
  <header>
    <div>
      <p>
        BOKSTORE
      </p>
      <h1>
        <%="dashboard".equals(tab)?"Tổng quan":"books".equals(tab)?"Quản lý sản phẩm":"categories".equals(tab)?"Quản lý danh mục":"users".equals(tab)?"Quản lý tài khoản":"orders".equals(tab)?"Quản lý hóa đơn":"Thống kê báo cáo"%>
      </h1>
    </div>
    <a href="<%=request.getContextPath()%>/shop">
      Xem cửa hàng
    </a>
  </header>
  <%if("dashboard".equals(tab)){%>
    <div class="stat-grid">
      <article>
        <span>
          Sản phẩm
        </span>
        <strong>
          <%=books.size()%>
        </strong>
      </article>
      <article>
        <span>
          Danh mục
        </span>
        <strong>
          <%=cats.size()%>
        </strong>
      </article>
      <article>
        <span>
          Tài khoản
        </span>
        <strong>
          <%=users.size()%>
        </strong>
      </article>
      <article>
        <span>
          Đơn hàng
        </span>
        <strong>
          <%=orders.size()%>
        </strong>
      </article>
      <article>
        <span>
          Doanh thu
        </span>
        <strong>
          <%=String.format("%,d",request.getAttribute("revenue"))%>
          đ
        </strong>
      </article>
    </div>
    <div class="dashboard-columns">
      <section class="panel">
        <h2>
          Trạng thái đơn hàng
        </h2>
        <%for(String status:new String[]{"PENDING","CONFIRMED","SHIPPING","FINISH","CANCELLED"}){long n=counts.getOrDefault(status,0L);%>
        <div class="chart-row">
          <span>
            <%=status%>
          </span>
          <div>
            <i style="width:<%=orders.isEmpty()?0:(n*100/orders.size())%>%">
            </i>
          </div>
          <strong>
            <%=n%>
          </strong>
        </div>
      <%}%>
    </section>
    <section class="panel">
      <h2>
        Cảnh báo sắp hết hàng
      </h2>
      <table>
        <tr>
          <th>
            Sản phẩm
          </th>
          <th>
            Tồn
          </th>
        </tr>
        <%for(Book b:low){%>
          <tr>
            <td>
              <%=b.getName()%>
            </td>
            <td>
              <strong class="text-danger">
                <%=b.getStock()%>
              </strong>
            </td>
          </tr>
        <%}%>
      </table>
    </section>
  </div>
  <section class="panel">
    <h2>
      Sản phẩm bán chạy
    </h2>
    <table>
      <tr>
        <th>
          Sản phẩm
        </th>
        <th>
          Đã bán
        </th>
        <th>
          Tồn kho
        </th>
      </tr>
      <%for(Book b:top){%>
        <tr>
          <td>
            <%=b.getName()%>
          </td>
          <td>
            <%=b.getSold()%>
          </td>
          <td>
            <%=b.getStock()%>
          </td>
        </tr>
      <%}%>
    </table>
  </section>
<%}else if("categories".equals(tab)){%>
    <section class="panel">
      <h2>
        Danh sách danh mục
      </h2>
      <form class="inline-form" method="post">
        <input type="hidden" name="tab" value="categories">
        <input type="hidden" name="type" value="category">
        <input name="name" required placeholder="Tên danh mục">
        <button>
          Thêm mới
        </button>
      </form>
      <table>
        <tr>
          <th>
            Mã
          </th>
          <th>
            Tên danh mục
          </th>
          <th>
            Thao tác
          </th>
        </tr>
        <%for(Category c:cats){%>
          <tr>
            <td>
              #
              <%=c.getId()%>
            </td>
            <td>
              <form class="inline-form" method="post">
                <input type="hidden" name="tab" value="categories">
                <input type="hidden" name="type" value="category">
                <input type="hidden" name="id" value="<%=c.getId()%>">
                <input name="name" required value="<%=c.getName()%>">
                <button>
                  Lưu
                </button>
              </form>
            </td>
            <td>
              <form method="post">
                <input type="hidden" name="tab" value="categories">
                <input type="hidden" name="type" value="category">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%=c.getId()%>">
                <button class="danger">
                  Xóa
                </button>
              </form>
            </td>
          </tr>
        <%}%>
      </table>
    </section>
  <%}else if("books".equals(tab)){%>
      <section class="panel">
        <div class="panel-heading">
          <h2>
            Sản phẩm đang bán
          </h2>
          <a class="admin-primary" href="<%=request.getContextPath()%>/admin/book-form">
            ＋ Thêm sản phẩm
          </a>
        </div>
        <table>
          <tr>
            <th>
              Mã
            </th>
            <th>
              Sách
            </th>
            <th>
              Giá
            </th>
            <th>
              Tồn
            </th>
            <th>
              Thao tác
            </th>
          </tr>
          <%for(Book b:books){%>
            <tr>
              <td>
                #
                <%=b.getId()%>
              </td>
              <td>
                <strong>
                  <%=b.getName()%>
                </strong>
                <small>
                  <%=b.getAuthor()%>
                  ·
                  <%=b.getPublisher()%>
                </small>
              </td>
              <td>
                <%=String.format("%,d",b.getPrice())%>
                đ
              </td>
              <td>
                <%=b.getStock()%>
              </td>
              <td>
                <div class="actions">
                  <a class="edit-link" href="<%=request.getContextPath()%>/admin/book-form?id=<%=b.getId()%>">
                    Sửa / Nhập kho
                  </a>
                  <form method="post">
                    <input type="hidden" name="tab" value="books">
                    <input type="hidden" name="type" value="book">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%=b.getId()%>">
                    <button class="danger">
                      Ẩn
                    </button>
                  </form>
                </div>
              </td>
            </tr>
          <%}%>
        </table>
      </section>
      <section class="panel">
        <h2>
          Sản phẩm đã ẩn
        </h2>
        <table>
          <%for(Book b:deleted){%>
            <tr>
              <td>
                <%=b.getName()%>
              </td>
              <td>
                <form method="post">
                  <input type="hidden" name="tab" value="books">
                  <input type="hidden" name="type" value="book">
                  <input type="hidden" name="action" value="restore">
                  <input type="hidden" name="id" value="<%=b.getId()%>">
                  <button>
                    Khôi phục
                  </button>
                </form>
              </td>
            </tr>
          <%}%>
        </table>
      </section>
    <%}else if("users".equals(tab)){%>
        <section class="panel">
          <h2>
            Danh sách tài khoản
          </h2>
          <table>
            <tr>
              <th>
                Họ tên
              </th>
              <th>
                Email / SĐT
              </th>
              <th>
                Vai trò
              </th>
              <th>
                Trạng thái
              </th>
              <th>
                Thao tác
              </th>
            </tr>
            <%for(User u:users){%>
              <tr>
                <td>
                  <strong>
                    <%=u.getName()%>
                  </strong>
                  <small>
                    @
                    <%=u.getUsername()%>
                  </small>
                </td>
                <td>
                  <%=u.getEmail()%>
                  <small>
                    <%=u.getPhone()%>
                  </small>
                </td>
                <td>
                  <%=u.getRole()%>
                </td>
                <td>
                  <%=u.isActive()?"Hoạt động":"Đã khóa"%>
                </td>
                <td>
                  <div class="actions">
                    <form method="post">
                      <input type="hidden" name="tab" value="users">
                      <input type="hidden" name="type" value="user">
                      <input type="hidden" name="action" value="toggle">
                      <input type="hidden" name="id" value="<%=u.getId()%>">
                      <button>
                        <%=u.isActive()?"Khóa":"Mở khóa"%>
                      </button>
                    </form>
                    <form method="post">
                      <input type="hidden" name="tab" value="users">
                      <input type="hidden" name="type" value="user">
                      <input type="hidden" name="action" value="delete">
                      <input type="hidden" name="id" value="<%=u.getId()%>">
                      <button class="danger">
                        Xóa
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
            <%}%>
          </table>
        </section>
      <%}else if("orders".equals(tab)){%>
          <section class="panel">
            <h2>
              Danh sách hóa đơn
            </h2>
            <table>
              <tr>
                <th>
                  Mã
                </th>
                <th>
                  Khách hàng
                </th>
                <th>
                  Ngày
                </th>
                <th>
                  Tổng tiền
                </th>
                <th>
                  Trạng thái
                </th>
                <th>
                </th>
              </tr>
              <%for(Order o:orders){%>
                <tr>
                  <td>
                    #
                    <%=o.getId()%>
                  </td>
                  <td>
                    <%=o.getCustomer()%>
                    <small>
                      <%=o.getPhone()%>
                      ·
                      <%=o.getAddress()%>
                    </small>
                  </td>
                  <td>
                    <%=o.getCreated().toLocalDate()%>
                  </td>
                  <td>
                    <%=String.format("%,d",o.getTotal())%>
                    đ
                  </td>
                  <td>
                    <form class="inline-form" method="post">
                      <input type="hidden" name="tab" value="orders">
                      <input type="hidden" name="type" value="order">
                      <input type="hidden" name="id" value="<%=o.getId()%>">
                      <select name="status">
                        <%for(String s:new String[]{"PENDING","CONFIRMED","SHIPPING","FINISH","CANCELLED"}){%>
                          <option <%=s.equals(o.getStatus())?"selected":""%>
                            >
                            <%=s%>
                          </option>
                        <%}%>
                      </select>
                      <button>
                        Cập nhật
                      </button>
                    </form>
                  </td>
                  <td>
                    <a class="edit-link" href="<%=request.getContextPath()%>/order-detail?id=<%=o.getId()%>">
                      Chi tiết
                    </a>
                  </td>
                </tr>
              <%}%>
            </table>
          </section>
        <%}else{%>
            <section class="panel">
              <h2>
                Doanh thu theo khoảng thời gian
              </h2>
              <form class="inline-form" method="get">
                <input type="hidden" name="tab" value="reports">
                <input type="date" name="from" value="<%=request.getAttribute("from")%>">
                <input type="date" name="to" value="<%=request.getAttribute("to")%>">
                <button>
                  Xem báo cáo
                </button>
              </form>
              <div class="report-total">
                <small>
                  Tổng doanh thu
                </small>
                <strong>
                  <%=String.format("%,d",request.getAttribute("revenue"))%>
                  đ
                </strong>
              </div>
              <h2>
                Top 10 sách bán chạy
              </h2>
              <table>
                <tr>
                  <th>
                    Hạng
                  </th>
                  <th>
                    Sản phẩm
                  </th>
                  <th>
                    Đã bán
                  </th>
                  <th>
                    Tồn kho
                  </th>
                </tr>
                <%int rank=1;for(Book b:top){%>
                  <tr>
                    <td>
                      <%=rank++%>
                    </td>
                    <td>
                      <%=b.getName()%>
                    </td>
                    <td>
                      <%=b.getSold()%>
                    </td>
                    <td>
                      <%=b.getStock()%>
                    </td>
                  </tr>
                <%}%>
              </table>
            </section>
          <%}%>
        </div>
