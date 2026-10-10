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

    // Dual-bucket rate limiting against brute-force attacks: key (IP or email) -> [failedCount, timestampMs]
    private static final java.util.concurrent.ConcurrentHashMap<String, long[]> ipAttempts = new java.util.concurrent.ConcurrentHashMap<>();
    private static final java.util.concurrent.ConcurrentHashMap<String, long[]> emailAttempts = new java.util.concurrent.ConcurrentHashMap<>();
    private static final int MAX_IP_ATTEMPTS = 5;
    private static final int MAX_EMAIL_ATTEMPTS = 8;
    private static final long LOCK_WINDOW_MS = 3 * 60 * 1000; // 3 minutes

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String clientIp = util.SecurityUtil.getClientIp(req);
        long now = System.currentTimeMillis();

        // 1. Check IP rate limit
        long[] ipData = ipAttempts.get(clientIp);
        if (ipData != null) {
            if (now - ipData[1] < LOCK_WINDOW_MS && ipData[0] >= MAX_IP_ATTEMPTS) {
                long remainingSec = Math.max(1, (LOCK_WINDOW_MS - (now - ipData[1])) / 1000);
                req.setAttribute("errorMessage", "Too many failed login attempts from this network. Please wait " + remainingSec + " seconds before trying again.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            } else if (now - ipData[1] >= LOCK_WINDOW_MS) {
                ipAttempts.remove(clientIp);
            }
        }

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String redirectUrl = req.getParameter("redirect");
        String normalizedEmail = email != null ? email.trim().toLowerCase() : "";

        // 2. Check Targeted Email rate limit (Distributed brute-force defense)
        if (!normalizedEmail.isEmpty()) {
            long[] emailData = emailAttempts.get(normalizedEmail);
            if (emailData != null) {
                if (now - emailData[1] < LOCK_WINDOW_MS && emailData[0] >= MAX_EMAIL_ATTEMPTS) {
                    long remainingSec = Math.max(1, (LOCK_WINDOW_MS - (now - emailData[1])) / 1000);
                    req.setAttribute("errorMessage", "This account is temporarily locked due to multiple failed login attempts. Please wait " + remainingSec + " seconds.");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                    return;
                } else if (now - emailData[1] >= LOCK_WINDOW_MS) {
                    emailAttempts.remove(normalizedEmail);
                }
            }
        }

        // Validate essentials
        if (normalizedEmail.isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please provide both email address and password.");
            req.setAttribute("enteredEmail", util.SecurityUtil.escapeHtml(normalizedEmail));
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(normalizedEmail, password);

        if (user != null) {
            // Reset failed counters on successful login
            ipAttempts.remove(clientIp);
            if (!normalizedEmail.isEmpty()) {
                emailAttempts.remove(normalizedEmail);
            }

            // Session Fixation Defense: Invalidate previous session and generate fresh ID
            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);

            // Safe Open-Redirect Defense
            if (util.SecurityUtil.isSafeRedirect(redirectUrl, req.getContextPath())) {
                resp.sendRedirect(redirectUrl);
                return;
            }

            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } else {
            // Track failed attempt on IP
            ipAttempts.compute(clientIp, (k, v) -> {
                if (v == null || (now - v[1] >= LOCK_WINDOW_MS)) {
                    return new long[]{1, now};
                } else {
                    return new long[]{v[0] + 1, now};
                }
            });

            // Track failed attempt on Targeted Email
            if (!normalizedEmail.isEmpty()) {
                emailAttempts.compute(normalizedEmail, (k, v) -> {
                    if (v == null || (now - v[1] >= LOCK_WINDOW_MS)) {
                        return new long[]{1, now};
                    } else {
                        return new long[]{v[0] + 1, now};
                    }
                });
            }

            req.setAttribute("errorMessage", "Invalid email or password. Please verify your credentials.");
            req.setAttribute("enteredEmail", util.SecurityUtil.escapeHtml(normalizedEmail));
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
