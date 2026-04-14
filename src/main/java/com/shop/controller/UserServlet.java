package com.shop.controller;

import com.shop.model.User;
import com.shop.service.CartService;
import com.shop.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class UserServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = getAction(req);
        switch (action) {
            case "login":
                req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, resp);
                break;
            case "register":
                req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, resp);
                break;
            case "mypage":
                HttpSession session = req.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    resp.sendRedirect(req.getContextPath() + "/user/login");
                    return;
                }
                try {
                    User user = userService.findById(((User) session.getAttribute("user")).getId());
                    req.setAttribute("user", user);
                } catch (Exception e) {
                    throw new ServletException(e);
                }
                req.getRequestDispatcher("/WEB-INF/views/user/mypage.jsp").forward(req, resp);
                break;
            case "logout":
                HttpSession s = req.getSession(false);
                if (s != null) s.invalidate();
                resp.sendRedirect(req.getContextPath() + "/home");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = getAction(req);
        try {
            switch (action) {
                case "login":
                    handleLogin(req, resp);
                    break;
                case "register":
                    handleRegister(req, resp);
                    break;
                case "mypage":
                    handleUpdateProfile(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/home");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userService.login(email, password);
        if (user == null) {
            req.setAttribute("error", "이메일 또는 비밀번호가 올바르지 않습니다.");
            req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("user", user);
        cartService.mergeSessionCartToDb(session, user);

        String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
        session.removeAttribute("redirectAfterLogin");
        if (redirectUrl != null) {
            resp.sendRedirect(req.getContextPath() + "/cart/");
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = new User();
        user.setEmail(req.getParameter("email"));
        user.setPassword(req.getParameter("password"));
        user.setName(req.getParameter("name"));
        user.setPhone(req.getParameter("phone"));
        user.setAddress(req.getParameter("address"));

        if (!userService.register(user)) {
            req.setAttribute("error", "이미 등록된 이메일입니다.");
            req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/user/login");
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User sessionUser = (User) req.getSession().getAttribute("user");
        sessionUser.setName(req.getParameter("name"));
        sessionUser.setPhone(req.getParameter("phone"));
        sessionUser.setAddress(req.getParameter("address"));

        userService.update(sessionUser);
        req.getSession().setAttribute("user", sessionUser);
        resp.sendRedirect(req.getContextPath() + "/user/mypage");
    }

    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) return "";
        return pathInfo.substring(1);
    }
}
