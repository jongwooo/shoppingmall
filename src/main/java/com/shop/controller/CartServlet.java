package com.shop.controller;

import com.shop.model.User;
import com.shop.service.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CartServlet extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("user");
            req.setAttribute("cartItems", cartService.getCartItems(session, user));
        } catch (Exception e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String action = getAction(req);

        try {
            switch (action) {
                case "add":
                    long productId = Long.parseLong(req.getParameter("productId"));
                    int qty = Integer.parseInt(req.getParameter("quantity"));
                    cartService.addToCart(session, user, productId, qty);
                    break;
                case "update":
                    long updateProductId = Long.parseLong(req.getParameter("productId"));
                    int newQty = Integer.parseInt(req.getParameter("quantity"));
                    cartService.updateQuantity(session, user, updateProductId, newQty);
                    break;
                case "remove":
                    long removeProductId = Long.parseLong(req.getParameter("productId"));
                    cartService.removeItem(session, user, removeProductId);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/cart/");
    }

    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) return "";
        return pathInfo.substring(1);
    }
}
