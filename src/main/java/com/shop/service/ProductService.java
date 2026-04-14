package com.shop.service;

import com.shop.dao.CategoryDao;
import com.shop.dao.ProductDao;
import com.shop.model.Category;
import com.shop.model.Product;

import java.sql.SQLException;
import java.util.List;

public class ProductService {

    private final ProductDao productDao = new ProductDao();
    private final CategoryDao categoryDao = new CategoryDao();

    public List<Product> getActiveProducts() throws SQLException {
        return productDao.findActive();
    }

    public List<Product> getAllProducts() throws SQLException {
        return productDao.findAll();
    }

    public List<Product> getByCategory(long categoryId) throws SQLException {
        return productDao.findByCategory(categoryId);
    }

    public List<Product> search(String keyword) throws SQLException {
        return productDao.search(keyword);
    }

    public Product getById(long id) throws SQLException {
        return productDao.findById(id);
    }

    public void create(Product product) throws SQLException {
        productDao.insert(product);
    }

    public void update(Product product) throws SQLException {
        productDao.update(product);
    }

    public void delete(long id) throws SQLException {
        productDao.delete(id);
    }

    public List<Category> getAllCategories() throws SQLException {
        return categoryDao.findAll();
    }

    public void createCategory(Category category) throws SQLException {
        categoryDao.insert(category);
    }

    public void deleteCategory(long id) throws SQLException {
        categoryDao.delete(id);
    }
}
