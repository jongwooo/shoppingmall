package com.shop.controller;

import com.shop.model.Category;
import com.shop.model.Product;
import com.shop.service.OrderService;
import com.shop.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class AdminServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = getAction(req);
        try {
            switch (action) {
                case "products":
                    req.setAttribute("products", productService.getAllProducts());
                    req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
                    break;
                case "product-form":
                    req.setAttribute("categories", productService.getAllCategories());
                    String idStr = req.getParameter("id");
                    if (idStr != null) {
                        req.setAttribute("product", productService.getById(Long.parseLong(idStr)));
                    }
                    req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
                    break;
                case "orders":
                    req.setAttribute("orders", orderService.getAllOrders());
                    req.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(req, resp);
                    break;
                case "order-detail":
                    long orderId = Long.parseLong(req.getParameter("id"));
                    req.setAttribute("order", orderService.getOrderDetail(orderId));
                    req.getRequestDispatcher("/WEB-INF/views/admin/order-detail.jsp").forward(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/products");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = getAction(req);
        try {
            switch (action) {
                case "product-save":
                    handleProductSave(req, resp);
                    break;
                case "product-delete":
                    productService.delete(Long.parseLong(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/admin/products");
                    break;
                case "order-status":
                    orderService.updateStatus(
                            Long.parseLong(req.getParameter("orderId")),
                            req.getParameter("status"));
                    resp.sendRedirect(req.getContextPath() + "/admin/order-detail?id=" + req.getParameter("orderId"));
                    break;
                case "category-save":
                    Category cat = new Category();
                    cat.setName(req.getParameter("name"));
                    productService.createCategory(cat);
                    resp.sendRedirect(req.getContextPath() + "/admin/product-form");
                    break;
                case "category-delete":
                    productService.deleteCategory(Long.parseLong(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/admin/product-form");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/products");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleProductSave(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Product p = new Product();
        p.setName(req.getParameter("name"));
        p.setDescription(req.getParameter("description"));
        p.setPrice(new BigDecimal(req.getParameter("price")));
        p.setStock(Integer.parseInt(req.getParameter("stock")));
        p.setImageUrl(req.getParameter("imageUrl"));
        String catId = req.getParameter("categoryId");
        p.setCategoryId(catId != null && !catId.isEmpty() ? Long.parseLong(catId) : null);
        p.setActive(req.getParameter("active") != null);

        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            p.setId(Long.parseLong(idStr));
            productService.update(p);
        } else {
            productService.create(p);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) return "";
        return pathInfo.substring(1);
    }
}
