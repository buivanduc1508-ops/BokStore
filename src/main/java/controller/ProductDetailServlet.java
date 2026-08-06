package controller;

import dao.ProductDAO;
import model.SanPham;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        try {
            int id = Integer.parseInt(idRaw);
            // Bạn cần viết thêm hàm getProductById(id) trong ProductDAO
            SanPham sp = productDAO.getProductById(id);

            request.setAttribute("product", sp);
            request.setAttribute("pageTitle", sp != null ? sp.getName() : "Chi tiết sản phẩm");
            request.setAttribute("contentPage", "/WEB-INF/views/client/pages/product-detail.jsp");

            request.getRequestDispatcher("/WEB-INF/views/client/layout/layout.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}