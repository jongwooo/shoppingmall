package com.shop.controller;

import com.shop.model.Product;
import com.shop.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ProductServlet extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = getAction(req);
        try {
            switch (action) {
                case "list":
                    handleList(req, resp);
                    break;
                case "detail":
                    handleDetail(req, resp);
                    break;
                case "search":
                    handleSearch(req, resp);
                    break;
                default:
                    handleList(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String categoryIdStr = req.getParameter("categoryId");
        List<Product> products;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            products = productService.getByCategory(Long.parseLong(categoryIdStr));
            req.setAttribute("selectedCategoryId", Long.parseLong(categoryIdStr));
        } else {
            products = productService.getActiveProducts();
        }
        req.setAttribute("products", products);
        req.setAttribute("categories", productService.getAllCategories());
        req.getRequestDispatcher("/WEB-INF/views/product/list.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        long id = Long.parseLong(req.getParameter("id"));
        Product product = productService.getById(id);
        if (product == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        req.setAttribute("product", product);
        req.getRequestDispatcher("/WEB-INF/views/product/detail.jsp").forward(req, resp);
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";
        req.setAttribute("products", productService.search(keyword));
        req.setAttribute("categories", productService.getAllCategories());
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("/WEB-INF/views/product/list.jsp").forward(req, resp);
    }

    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) return "list";
        return pathInfo.substring(1);
    }
}
