package dao;

import model.SanPham;
import utils.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<SanPham> getNewProducts() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM san_pham WHERE status = 'ACTIVE' ORDER BY created_at DESC";

        try (Connection conn = ConnectDB.getConnect(); // Gọi phương thức kết nối
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SanPham sp = new SanPham();
                sp.setId(rs.getInt("id"));
                sp.setCategoryId(rs.getInt("category_id"));
                sp.setName(rs.getString("name"));
                sp.setDescription(rs.getString("description"));
                sp.setPrice(rs.getBigDecimal("price"));
                sp.setImage(rs.getString("image"));
                sp.setQuantity(rs.getInt("quantity"));
                sp.setStatus(rs.getString("status"));
                sp.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(sp);
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại ProductDAO.getNewProducts: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách sản phẩm theo danh mục (Sách theo từng thể loại)
    public List<SanPham> getProductsByCategoryId(int categoryId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM san_pham WHERE category_id = ? AND status = 'ACTIVE'";

        try (Connection conn = ConnectDB.getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setId(rs.getInt("id"));
                    sp.setCategoryId(rs.getInt("category_id"));
                    sp.setName(rs.getString("name"));
                    sp.setDescription(rs.getString("description"));
                    sp.setPrice(rs.getBigDecimal("price"));
                    sp.setImage(rs.getString("image"));
                    sp.setQuantity(rs.getInt("quantity"));
                    sp.setStatus(rs.getString("status"));
                    sp.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(sp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Lấy thông tin chi tiết 1 sản phẩm theo ID
    public SanPham getProductById(int id) {
        String sql = "SELECT * FROM san_pham WHERE id = ? AND status = 'ACTIVE'";

        try (Connection conn = ConnectDB.getConnect(); // Sử dụng hàm kết nối của dự án
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setId(rs.getInt("id"));
                    sp.setCategoryId(rs.getInt("category_id"));
                    sp.setName(rs.getString("name"));
                    sp.setDescription(rs.getString("description"));
                    sp.setPrice(rs.getBigDecimal("price"));
                    sp.setImage(rs.getString("image"));
                    sp.setQuantity(rs.getInt("quantity"));
                    sp.setStatus(rs.getString("status"));
                    sp.setCreatedAt(rs.getTimestamp("created_at"));
                    return sp;
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại ProductDAO.getProductById: " + e.getMessage());
            e.printStackTrace();
        }
        return null; // Trả về null nếu không tìm thấy sản phẩm
    }
}