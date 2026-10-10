package dao;

import model.User;
import util.DBConnection;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * UserDAO handles authentication and profile persistence.
 */
public class UserDAO {

    /**
     * Authenticates a user by email and password.
     * Supports both SHA-256 hashed passwords and fallback plain-text demo passwords.
     */
    public User authenticate(String email, String password) {
        if (email == null || password == null) return null;

        String sql = "SELECT id, name, email, password, role, department, academic_year, created_at FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    String inputHash = hashPassword(password);

                    // Allow direct match or SHA-256 hash match
                    if (storedHash.equalsIgnoreCase(inputHash) || storedHash.equals(password)) {
                        // If password was stored in plain text, upgrade it to SHA-256 hash immediately
                        if (storedHash.equals(password) && !storedHash.equalsIgnoreCase(inputHash)) {
                            upgradePassword(rs.getInt("id"), inputHash);
                        }

                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setName(rs.getString("name"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        user.setDepartment(rs.getString("department"));
                        user.setYear(rs.getString("academic_year"));
                        try {
                            user.setCreatedAt(rs.getTimestamp("created_at"));
                        } catch (Exception ignored) {}
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO.authenticate] " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private void upgradePassword(int userId, String sha256Hash) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sha256Hash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[UserDAO.upgradePassword] " + e.getMessage());
        }
    }

    /**
     * Checks if an email is already registered.
     */
    public boolean emailExists(String email) {
        if (email == null) return false;
        String sql = "SELECT 1 FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO.emailExists] " + e.getMessage());
        }
        return false;
    }

    /**
     * Registers a new student or admin.
     */
    public boolean register(User user) {
        String sql = "INSERT INTO users (name, email, password, role, department, academic_year) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail().trim().toLowerCase());
            // Store password hash (or fallback plaintext)
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole() != null ? user.getRole() : "STUDENT");
            ps.setString(5, user.getDepartment());
            ps.setString(6, user.getYear());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO.register] " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves user details by ID.
     */
    public User getUserById(int userId) {
        String sql = "SELECT id, name, email, role, department, academic_year, created_at FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setName(rs.getString("name"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setDepartment(rs.getString("department"));
                    u.setYear(rs.getString("academic_year"));
                    try {
                        u.setCreatedAt(rs.getTimestamp("created_at"));
                    } catch (Exception ignored) {}
                    return u;
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO.getUserById] " + e.getMessage());
        }
        return null;
    }

    public static String hashPassword(String password) {
        if (password == null) return "";
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return password;
        }
    }
}
