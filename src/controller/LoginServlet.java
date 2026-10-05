package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet handles student and admin login/logout operations.
 */
@WebServlet(urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if ("/logout".equals(servletPath)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login?msg=logged_out");
            return;
        }

        // If already logged in, redirect to appropriate home
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
            return;
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String redirectUrl = req.getParameter("redirect");

        // Validate
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please provide both email address and password.");
            req.setAttribute("enteredEmail", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(email, password);

        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);

            if (redirectUrl != null && !redirectUrl.trim().isEmpty() && !redirectUrl.contains("login") && !redirectUrl.contains("logout")) {
                resp.sendRedirect(redirectUrl);
                return;
            }

            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } else {
            req.setAttribute("errorMessage", "Invalid email or password. Please verify your credentials.");
            req.setAttribute("enteredEmail", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
