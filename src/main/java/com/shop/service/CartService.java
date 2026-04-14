package com.shop.service;

import com.shop.dao.CartDao;
import com.shop.dao.ProductDao;
import com.shop.model.CartItem;
import com.shop.model.Product;
import com.shop.model.User;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CartService {

    private final CartDao cartDao = new CartDao();
    private final ProductDao productDao = new ProductDao();

    // --- public API: caller passes session + user ---

    public List<CartItem> getCartItems(jakarta.servlet.http.HttpSession session, User user) throws SQLException {
        if (user != null) {
            return cartDao.findByUserId(user.getId());
        }
        return new ArrayList<>(getSessionCart(session).values());
    }

    public void addToCart(jakarta.servlet.http.HttpSession session, User user, long productId, int quantity) throws SQLException {
        if (user != null) {
            cartDao.upsert(user.getId(), productId, quantity);
        } else {
            addToSessionCart(session, productId, quantity);
        }
    }

    public void updateQuantity(jakarta.servlet.http.HttpSession session, User user, long productId, int quantity) throws SQLException {
        if (user != null) {
            cartDao.updateQuantity(user.getId(), productId, quantity);
        } else {
            Map<Long, CartItem> cart = getSessionCart(session);
            if (quantity <= 0) {
                cart.remove(productId);
            } else {
                CartItem item = cart.get(productId);
                if (item != null) item.setQuantity(quantity);
            }
            saveSessionCart(session, cart);
        }
    }

    public void removeItem(jakarta.servlet.http.HttpSession session, User user, long productId) throws SQLException {
        if (user != null) {
            cartDao.remove(user.getId(), productId);
        } else {
            Map<Long, CartItem> cart = getSessionCart(session);
            cart.remove(productId);
            saveSessionCart(session, cart);
        }
    }

    public void clearCart(jakarta.servlet.http.HttpSession session, User user) throws SQLException {
        if (user != null) {
            cartDao.clearByUserId(user.getId());
        } else {
            session.removeAttribute("cart");
        }
    }

    /**
     * Merge session cart into DB cart on login, then clear session cart.
     */
    public void mergeSessionCartToDb(jakarta.servlet.http.HttpSession session, User user) throws SQLException {
        Map<Long, CartItem> sessionCart = getSessionCart(session);
        if (sessionCart.isEmpty()) return;

        for (CartItem item : sessionCart.values()) {
            cartDao.upsert(user.getId(), item.getProductId(), item.getQuantity());
        }
        session.removeAttribute("cart");
    }

    // --- session cart helpers (guest) ---

    @SuppressWarnings("unchecked")
    private Map<Long, CartItem> getSessionCart(jakarta.servlet.http.HttpSession session) {
        Map<Long, CartItem> cart = (Map<Long, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
        }
        return cart;
    }

    private void saveSessionCart(jakarta.servlet.http.HttpSession session, Map<Long, CartItem> cart) {
        session.setAttribute("cart", new LinkedHashMap<>(cart));
    }

    private void addToSessionCart(jakarta.servlet.http.HttpSession session, long productId, int quantity) throws SQLException {
        Map<Long, CartItem> cart = getSessionCart(session);
        CartItem existing = cart.get(productId);
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            Product product = productDao.findById(productId);
            if (product == null) return;
            CartItem item = new CartItem();
            item.setProductId(productId);
            item.setQuantity(quantity);
            item.setProductName(product.getName());
            item.setProductPrice(product.getPrice());
            item.setProductImageUrl(product.getImageUrl());
            item.setProductStock(product.getStock());
            cart.put(productId, item);
        }
        saveSessionCart(session, cart);
    }
}
