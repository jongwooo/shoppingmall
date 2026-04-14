package com.shop.filter;

import com.shop.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String requestUri = req.getRequestURI();
            String query = req.getQueryString();
            if (query != null) requestUri += "?" + query;
            req.getSession().setAttribute("redirectAfterLogin", requestUri);
            res.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        // Only allow ADMIN role for admin paths
        if (req.getRequestURI().startsWith(req.getContextPath() + "/admin") && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }
}
