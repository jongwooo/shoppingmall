package com.shop.service;

import at.favre.lib.crypto.bcrypt.BCrypt;
import com.shop.dao.UserDao;
import com.shop.model.User;

import java.sql.SQLException;

public class UserService {

    private final UserDao userDao = new UserDao();

    public User login(String email, String password) throws SQLException {
        User user = userDao.findByEmail(email);
        if (user == null) return null;

        BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), user.getPassword());
        return result.verified ? user : null;
    }

    public boolean register(User user) throws SQLException {
        if (userDao.findByEmail(user.getEmail()) != null) {
            return false;
        }
        String hashed = BCrypt.withDefaults().hashToString(12, user.getPassword().toCharArray());
        user.setPassword(hashed);
        if (user.getRole() == null) user.setRole("CUSTOMER");
        userDao.insert(user);
        return true;
    }

    public User findById(long id) throws SQLException {
        return userDao.findById(id);
    }

    public void update(User user) throws SQLException {
        userDao.update(user);
    }
}
