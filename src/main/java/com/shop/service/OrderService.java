package com.shop.service;

import com.shop.dao.OrderDao;
import com.shop.dao.ProductDao;
import com.shop.model.*;
import com.shop.util.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderService {

    private final OrderDao orderDao = new OrderDao();
    private final ProductDao productDao = new ProductDao();

    public long placeOrder(long userId, String address, String idempotencyKey, List<CartItem> cartItems) throws SQLException {
        if (cartItems == null || cartItems.isEmpty()) {
            throw new SQLException("Cart is empty");
        }

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            if (idempotencyKey != null && !idempotencyKey.isEmpty()) {
                Long existingId = orderDao.findIdByIdempotencyKey(userId, idempotencyKey, conn);
                if (existingId != null) {
                    conn.commit();
                    return existingId;
                }
            }

            BigDecimal totalPrice = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();

            for (CartItem ci : cartItems) {
                productDao.updateStock(ci.getProductId(), ci.getQuantity(), conn);

                OrderItem oi = new OrderItem();
                oi.setProductId(ci.getProductId());
                oi.setQuantity(ci.getQuantity());
                oi.setPrice(ci.getProductPrice());
                orderItems.add(oi);

                totalPrice = totalPrice.add(ci.getSubtotal());
            }

            Order order = new Order();
            order.setUserId(userId);
            order.setTotalPrice(totalPrice);
            order.setStatus("PENDING");
            order.setAddress(address);
            order.setIdempotencyKey(idempotencyKey);

            long orderId = orderDao.insert(order, conn);
            orderDao.insertItems(orderId, orderItems, conn);

            conn.commit();
            return orderId;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public List<Order> getOrdersByUser(long userId) throws SQLException {
        return orderDao.findByUserId(userId);
    }

    public List<Order> getAllOrders() throws SQLException {
        return orderDao.findAll();
    }

    public Order getOrderDetail(long orderId) throws SQLException {
        Order order = orderDao.findById(orderId);
        if (order != null) {
            order.setItems(orderDao.findItemsByOrderId(orderId));
        }
        return order;
    }

    public void updateStatus(long orderId, String status) throws SQLException {
        orderDao.updateStatus(orderId, status);
    }
}
