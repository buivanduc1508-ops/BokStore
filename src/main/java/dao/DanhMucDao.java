package dao;

import java.sql.*;
import java.util.*;

import model.DanhMucModel;
import utils.ConnectDB;

public class DanhMucDao {
	public List<DanhMucModel> getAll() {
		List <DanhMucModel> List = new ArrayList<>();
		try {
			Connection con = ConnectDB.getConnect();
			String sql = "SELECT * FROM danh_muc";
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				DanhMucModel dm = new DanhMucModel();
				dm.setId(rs.getInt("id"));
				dm.setName(rs.getString("name"));
				dm.setDescription(rs.getString("description"));
				dm.setStatus(rs.getString("status"));
				dm.setCreatedAt(rs.getString("created_at"));
				List.add(dm);
				
			}
			} catch (Exception e) {
				System.out.println("Có lỗi get all: " + e.getMessage());
		}
		return List;
	}
}
