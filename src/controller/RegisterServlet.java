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
 * RegisterServlet handles new student account registrations.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String department = req.getParameter("department");
        String year = req.getParameter("year");

        // Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            department == null || department.trim().isEmpty() ||
            year == null || year.trim().isEmpty()) {
            
            req.setAttribute("errorMessage", "All fields are required. Please fill in all information.");
            setFormAttributes(req, name, email, department, year);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            setFormAttributes(req, name, email, department, year);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Passwords do not match. Please try again.");
            setFormAttributes(req, name, email, department, year);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.emailExists(email)) {
            req.setAttribute("errorMessage", "An account with this email already exists. Please login instead.");
            setFormAttributes(req, name, email, department, year);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User newUser = new User();
        newUser.setName(sanitize(name.trim()));
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPassword(UserDAO.hashPassword(password.trim()));
        newUser.setRole("STUDENT");
        newUser.setDepartment(sanitize(department.trim()));
        newUser.setYear(sanitize(year.trim()));

        boolean success = userDAO.register(newUser);

        if (success) {
            // Auto login on successful registration
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", newUser);
            resp.sendRedirect(req.getContextPath() + "/dashboard?registered=true");
        } else {
            req.setAttribute("errorMessage", "Failed to create account due to a database error. Please try again.");
            setFormAttributes(req, name, email, department, year);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }

    private String sanitize(String input) {
        if (input == null) return "";
        return input.replaceAll("<[^>]*>", "").trim();
    }

    private void setFormAttributes(HttpServletRequest req, String name, String email, String department, String year) {
        req.setAttribute("enteredName", name);
        req.setAttribute("enteredEmail", email);
        req.setAttribute("enteredDepartment", department);
        req.setAttribute("enteredYear", year);
    }
}
