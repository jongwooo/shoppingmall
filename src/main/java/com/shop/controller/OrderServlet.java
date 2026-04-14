package com.shop.controller;

import com.shop.model.CartItem;
import com.shop.model.Order;
import com.shop.model.User;
import com.shop.service.CartService;
import com.shop.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class OrderServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        String action = getAction(req);

        try {
            switch (action) {
                case "checkout":
                    req.setAttribute("cartItems", cartService.getCartItems(req.getSession(), user));
                    req.setAttribute("user", user);
                    req.getRequestDispatcher("/WEB-INF/views/order/checkout.jsp").forward(req, resp);
                    break;
                case "detail":
                    long orderId = Long.parseLong(req.getParameter("id"));
                    Order order = orderService.getOrderDetail(orderId);
                    if (order == null || (!user.isAdmin() && order.getUserId() != user.getId())) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                        return;
                    }
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/WEB-INF/views/order/detail.jsp").forward(req, resp);
                    break;
                default:
                    req.setAttribute("orders", orderService.getOrdersByUser(user.getId()));
                    req.getRequestDispatcher("/WEB-INF/views/order/list.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String action = getAction(req);

        try {
            if ("place".equals(action)) {
                String address = req.getParameter("address");
                String idempotencyKey = req.getParameter("idempotencyKey");
                List<CartItem> cartItems = cartService.getCartItems(session, user);
                long orderId = orderService.placeOrder(user.getId(), address, idempotencyKey, cartItems);
                cartService.clearCart(session, user);
                resp.sendRedirect(req.getContextPath() + "/order/detail?id=" + orderId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/order/");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            try {
                req.setAttribute("cartItems", cartService.getCartItems(session, user));
            } catch (Exception ignored) {}
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/order/checkout.jsp").forward(req, resp);
        }
    }

    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) return "list";
        return pathInfo.substring(1);
    }
}
