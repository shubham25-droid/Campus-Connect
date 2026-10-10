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

    // Simple in-memory rate limiting against brute-force attacks: IP -> [failedCount, timestampMs]
    private static final java.util.concurrent.ConcurrentHashMap<String, long[]> loginAttempts = new java.util.concurrent.ConcurrentHashMap<>();
    private static final int MAX_ATTEMPTS = 5;
    private static final long LOCK_WINDOW_MS = 3 * 60 * 1000; // 3 minutes

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String clientIp = req.getRemoteAddr();
        long now = System.currentTimeMillis();

        // Check rate limiting
        long[] attemptData = loginAttempts.get(clientIp);
        if (attemptData != null) {
            if (now - attemptData[1] < LOCK_WINDOW_MS && attemptData[0] >= MAX_ATTEMPTS) {
                long remainingSec = (LOCK_WINDOW_MS - (now - attemptData[1])) / 1000;
                req.setAttribute("errorMessage", "Too many failed login attempts. Please wait " + remainingSec + " seconds before trying again.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            } else if (now - attemptData[1] >= LOCK_WINDOW_MS) {
                loginAttempts.remove(clientIp);
            }
        }

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String redirectUrl = req.getParameter("redirect");

        // Validate
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please provide both email address and password.");
            req.setAttribute("enteredEmail", email != null ? email.trim() : "");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(email, password);

        if (user != null) {
            // Reset failed attempts on success
            loginAttempts.remove(clientIp);

            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);

            // Safe Open-Redirect check: ensure redirect stays within the application
            if (redirectUrl != null && !redirectUrl.trim().isEmpty() && !redirectUrl.contains("login") && !redirectUrl.contains("logout")) {
                redirectUrl = redirectUrl.trim();
                if ((redirectUrl.startsWith("/") && !redirectUrl.startsWith("//")) || redirectUrl.startsWith(req.getContextPath())) {
                    resp.sendRedirect(redirectUrl);
                    return;
                }
            }

            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } else {
            // Track failed attempt
            loginAttempts.compute(clientIp, (k, v) -> {
                if (v == null || (now - v[1] >= LOCK_WINDOW_MS)) {
                    return new long[]{1, now};
                } else {
                    return new long[]{v[0] + 1, now};
                }
            });

            req.setAttribute("errorMessage", "Invalid email or password. Please verify your credentials.");
            req.setAttribute("enteredEmail", email != null ? email.trim() : "");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
