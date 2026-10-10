package dao;

import model.Registration;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * RegistrationDAO manages student event registrations and attendee queries.
 */
public class RegistrationDAO {

    /**
     * Checks if a user is already registered for an event.
     */
    public boolean isUserRegistered(int userId, int eventId) {
        String sql = "SELECT 1 FROM registrations WHERE user_id = ? AND event_id = ? AND status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("[RegistrationDAO.isUserRegistered] " + e.getMessage());
        }
        return false;
    }

    /**
     * Registers a student for an event with capacity and duplicate check.
     * Returns:
     *  1 = Success
     *  0 = Already registered
     * -1 = Event is full or closed
     * -2 = Database error
     */
    public synchronized int registerUser(int userId, int eventId) {
        if (isUserRegistered(userId, eventId)) {
            return 0; // Already registered
        }

        // Check event status and remaining seats
        EventDAO eventDAO = new EventDAO();
        model.Event event = eventDAO.getEventById(eventId, userId);
        if (event == null || !event.isRegistrationOpen()) {
            return -1; // Event full or registration closed
        }

        // If previously cancelled, re-activate or insert new
        String checkExisting = "SELECT id, status FROM registrations WHERE user_id = ? AND event_id = ?";
        String updateReactivate = "UPDATE registrations SET status = 'CONFIRMED', registered_at = CURRENT_TIMESTAMP WHERE id = ?";
        String insertSql = "INSERT INTO registrations (user_id, event_id, status) VALUES (?, ?, 'CONFIRMED')";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement checkPs = conn.prepareStatement(checkExisting)) {
                checkPs.setInt(1, userId);
                checkPs.setInt(2, eventId);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        int regId = rs.getInt("id");
                        try (PreparedStatement updatePs = conn.prepareStatement(updateReactivate)) {
                            updatePs.setInt(1, regId);
                            updatePs.executeUpdate();
                            return 1;
                        }
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, eventId);
                int affected = ps.executeUpdate();
                return affected > 0 ? 1 : -2;
            }
        } catch (SQLException e) {
            System.err.println("[RegistrationDAO.registerUser] " + e.getMessage());
            e.printStackTrace();
            return -2;
        }
    }

    /**
     * Cancels an active registration for a user.
     */
    public boolean cancelRegistration(int userId, int eventId) {
        String sql = "UPDATE registrations SET status = 'CANCELLED' WHERE user_id = ? AND event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[RegistrationDAO.cancelRegistration] " + e.getMessage());
        }
        return false;
    }

    /**
     * Retrieves all registrations made by a particular student (My Registrations).
     */
    public List<Registration> getRegistrationsByUser(int userId) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.id, r.user_id, r.event_id, r.registered_at, r.status, "
                + "e.title AS event_title, e.event_date, e.start_time, e.venue, e.category, e.organizer_name, e.image "
                + "FROM registrations r "
                + "INNER JOIN events e ON r.event_id = e.id "
                + "WHERE r.user_id = ? AND r.status != 'CANCELLED' "
                + "ORDER BY e.event_date ASC, r.registered_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Registration reg = new Registration();
                    reg.setId(rs.getInt("id"));
                    reg.setUserId(rs.getInt("user_id"));
                    reg.setEventId(rs.getInt("event_id"));
                    try { reg.setRegisteredAt(rs.getTimestamp("registered_at")); } catch (Exception ignored) {}
                    reg.setStatus(rs.getString("status"));

                    reg.setEventTitle(rs.getString("event_title"));
                    try {
                        reg.setEventDate(rs.getDate("event_date"));
                    } catch (Exception ex) {
                        String d = rs.getString("event_date");
                        if (d != null) {
                            try { reg.setEventDate(Date.valueOf(d.trim().substring(0, 10))); } catch (Exception ignored) {}
                        }
                    }
                    reg.setEventStartTime(rs.getString("start_time"));
                    reg.setEventVenue(rs.getString("venue"));
                    reg.setEventCategory(rs.getString("category"));
                    reg.setEventOrganizer(rs.getString("organizer_name"));
                    reg.setEventImage(rs.getString("image"));

                    list.add(reg);
                }
            }
        } catch (SQLException e) {
            System.err.println("[RegistrationDAO.getRegistrationsByUser] " + e.getMessage());
        }
        return list;
    }

    /**
     * Retrieves all registered students for a specific event (Admin view).
     */
    public List<Registration> getRegistrationsByEvent(int eventId) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.id, r.user_id, r.event_id, r.registered_at, r.status, "
                + "u.name AS user_name, u.email AS user_email, u.department AS user_department, u.academic_year AS user_year, "
                + "e.title AS event_title "
                + "FROM registrations r "
                + "INNER JOIN users u ON r.user_id = u.id "
                + "INNER JOIN events e ON r.event_id = e.id "
                + "WHERE r.event_id = ? AND r.status != 'CANCELLED' "
                + "ORDER BY r.registered_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Registration reg = new Registration();
                    reg.setId(rs.getInt("id"));
                    reg.setUserId(rs.getInt("user_id"));
                    reg.setEventId(rs.getInt("event_id"));
                    try { reg.setRegisteredAt(rs.getTimestamp("registered_at")); } catch (Exception ignored) {}
                    reg.setStatus(rs.getString("status"));

                    reg.setUserName(rs.getString("user_name"));
                    reg.setUserEmail(rs.getString("user_email"));
                    reg.setUserDepartment(rs.getString("user_department"));
                    reg.setUserYear(rs.getString("user_year"));
                    reg.setEventTitle(rs.getString("event_title"));

                    list.add(reg);
                }
            }
        } catch (SQLException e) {
            System.err.println("[RegistrationDAO.getRegistrationsByEvent] " + e.getMessage());
        }
        return list;
    }

    /**
     * Retrieves all registrations across all events for the main Admin dashboard.
     */
    public List<Registration> getAllRecentRegistrations(int limit) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.id, r.user_id, r.event_id, r.registered_at, r.status, "
                + "u.name AS user_name, u.email AS user_email, u.department AS user_department, u.academic_year AS user_year, "
                + "e.title AS event_title, e.category AS event_category "
                + "FROM registrations r "
                + "INNER JOIN users u ON r.user_id = u.id "
                + "INNER JOIN events e ON r.event_id = e.id "
                + "WHERE r.status != 'CANCELLED' "
                + "ORDER BY r.registered_at DESC, r.id DESC "
                + "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit > 0 ? limit : 20);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Registration reg = new Registration();
                    reg.setId(rs.getInt("id"));
                    reg.setUserId(rs.getInt("user_id"));
                    reg.setEventId(rs.getInt("event_id"));
                    try { reg.setRegisteredAt(rs.getTimestamp("registered_at")); } catch (Exception ignored) {}
                    reg.setStatus(rs.getString("status"));

                    reg.setUserName(rs.getString("user_name"));
                    reg.setUserEmail(rs.getString("user_email"));
                    reg.setUserDepartment(rs.getString("user_department"));
                    reg.setUserYear(rs.getString("user_year"));
                    reg.setEventTitle(rs.getString("event_title"));
                    reg.setEventCategory(rs.getString("event_category"));

                    list.add(reg);
                }
            }
        } catch (SQLException e) {
            System.err.println("[RegistrationDAO.getAllRecentRegistrations] " + e.getMessage());
        }
        return list;
    }
}
