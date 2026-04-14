package com.shop.dao;

import com.shop.model.Product;
import com.shop.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {

    private static final String SELECT_WITH_CATEGORY =
            "SELECT p.*, c.name AS category_name FROM products p " +
            "LEFT JOIN categories c ON p.category_id = c.id";

    public List<Product> findAll() throws SQLException {
        String sql = SELECT_WITH_CATEGORY + " ORDER BY p.created_at DESC";
        return query(sql);
    }

    public List<Product> findActive() throws SQLException {
        String sql = SELECT_WITH_CATEGORY + " WHERE p.is_active = TRUE ORDER BY p.created_at DESC";
        return query(sql);
    }

    public List<Product> findByCategory(long categoryId) throws SQLException {
        String sql = SELECT_WITH_CATEGORY + " WHERE p.is_active = TRUE AND p.category_id = ? ORDER BY p.created_at DESC";
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<Product> search(String keyword) throws SQLException {
        String sql = SELECT_WITH_CATEGORY + " WHERE p.is_active = TRUE AND (LOWER(p.name) LIKE ? OR LOWER(p.description) LIKE ?) ORDER BY p.created_at DESC";
        String like = "%" + keyword.toLowerCase() + "%";
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public Product findById(long id) throws SQLException {
        String sql = SELECT_WITH_CATEGORY + " WHERE p.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public void insert(Product product) throws SQLException {
        String sql = "INSERT INTO products (name, description, price, stock, image_url, category_id, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setParams(ps, product);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) product.setId(keys.getLong(1));
            }
        }
    }

    public void update(Product product) throws SQLException {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, stock = ?, image_url = ?, category_id = ?, is_active = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setParams(ps, product);
            ps.setLong(8, product.getId());
            ps.executeUpdate();
        }
    }

    public void delete(long id) throws SQLException {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    public void updateStock(long productId, int quantity, Connection conn) throws SQLException {
        String sql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setLong(2, productId);
            ps.setInt(3, quantity);
            int rows = ps.executeUpdate();
            if (rows == 0) {
                throw new SQLException("Insufficient stock for product " + productId);
            }
        }
    }

    private void setParams(PreparedStatement ps, Product p) throws SQLException {
        ps.setString(1, p.getName());
        ps.setString(2, p.getDescription());
        ps.setBigDecimal(3, p.getPrice());
        ps.setInt(4, p.getStock());
        ps.setString(5, p.getImageUrl());
        if (p.getCategoryId() != null) {
            ps.setLong(6, p.getCategoryId());
        } else {
            ps.setNull(6, Types.BIGINT);
        }
        ps.setBoolean(7, p.isActive());
    }

    private List<Product> query(String sql) throws SQLException {
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getLong("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStock(rs.getInt("stock"));
        p.setImageUrl(rs.getString("image_url"));
        long catId = rs.getLong("category_id");
        p.setCategoryId(rs.wasNull() ? null : catId);
        try {
            p.setCategoryName(rs.getString("category_name"));
        } catch (SQLException ignored) {}
        p.setActive(rs.getBoolean("is_active"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }
}
