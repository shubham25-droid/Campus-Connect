package dao;

import model.Event;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * EventDAO handles event querying, creation, updating, deletion,
 * bookmarking, and aggregation metrics for dashboards.
 */
public class EventDAO {

    /**
     * Map ResultSet row to Event object.
     */
    private Event mapResultSetToEvent(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setId(rs.getInt("id"));
        e.setTitle(rs.getString("title"));
        e.setShortDescription(rs.getString("short_description"));
        e.setDescription(rs.getString("description"));
        e.setCategory(rs.getString("category"));
        e.setDepartment(rs.getString("department"));
        e.setEligibleYear(rs.getString("eligible_year"));

        // Date parsing compatible with both MySQL and SQLite
        try {
            e.setEventDate(rs.getDate("event_date"));
        } catch (Exception ex) {
            String dStr = rs.getString("event_date");
            if (dStr != null) {
                try { e.setEventDate(Date.valueOf(dStr.trim().substring(0, 10))); } catch (Exception ignored) {}
            }
        }

        e.setStartTime(rs.getString("start_time"));
        e.setEndTime(rs.getString("end_time"));
        e.setVenue(rs.getString("venue"));
        e.setOrganizerName(rs.getString("organizer_name"));
        e.setOrganizerContact(rs.getString("organizer_contact"));

        try {
            e.setRegistrationDeadline(rs.getDate("registration_deadline"));
        } catch (Exception ex) {
            String dStr = rs.getString("registration_deadline");
            if (dStr != null) {
                try { e.setRegistrationDeadline(Date.valueOf(dStr.trim().substring(0, 10))); } catch (Exception ignored) {}
            }
        }

        e.setMaxParticipants(rs.getInt("max_participants"));
        e.setEligibility(rs.getString("eligibility"));
        e.setImage(rs.getString("image"));
        e.setStatus(rs.getString("status"));
        e.setCreatedBy(rs.getInt("created_by"));

        try {
            e.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (Exception ignored) {}
        try {
            e.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (Exception ignored) {}

        return e;
    }

    /**
     * Get published events with search, filters, and sorting.
     */
    public List<Event> getDiscoveredEvents(String search, String category, String department, String year, String sort, Integer currentUserId) {
        List<Event> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT e.*, ");
        sql.append("(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count ");
        if (currentUserId != null) {
            sql.append(", (SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.user_id = ? AND r.status != 'CANCELLED') AS is_registered ");
            sql.append(", (SELECT COUNT(*) FROM saved_events s WHERE s.event_id = e.id AND s.user_id = ?) AS is_saved ");
        }
        sql.append("FROM events e WHERE e.status = 'Published' ");

        List<Object> params = new ArrayList<>();
        if (currentUserId != null) {
            params.add(currentUserId);
            params.add(currentUserId);
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(e.title) LIKE ? OR LOWER(e.organizer_name) LIKE ? OR LOWER(e.category) LIKE ? OR LOWER(e.short_description) LIKE ?) ");
            String term = "%" + search.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (category != null && !category.trim().isEmpty() && !"All".equalsIgnoreCase(category)) {
            sql.append("AND LOWER(e.category) = LOWER(?) ");
            params.add(category.trim());
        }

        if (department != null && !department.trim().isEmpty() && !"All".equalsIgnoreCase(department)) {
            sql.append("AND (LOWER(e.department) = LOWER(?) OR LOWER(e.department) LIKE '%all%') ");
            params.add(department.trim());
        }

        if (year != null && !year.trim().isEmpty() && !"All".equalsIgnoreCase(year)) {
            sql.append("AND (LOWER(e.eligible_year) LIKE ? OR LOWER(e.eligible_year) LIKE '%all%') ");
            params.add("%" + year.trim().toLowerCase() + "%");
        }

        // Sorting
        if ("latest".equalsIgnoreCase(sort)) {
            sql.append("ORDER BY e.created_at DESC, e.id DESC");
        } else if ("deadline".equalsIgnoreCase(sort)) {
            sql.append("ORDER BY e.registration_deadline ASC, e.event_date ASC");
        } else {
            // Default: Upcoming first (Today and future events first, past events at the end)
            sql.append("ORDER BY CASE WHEN e.event_date >= CURRENT_DATE THEN 0 ELSE 1 END ASC, e.event_date ASC, e.start_time ASC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Event event = mapResultSetToEvent(rs);
                    event.setRegisteredCount(rs.getInt("reg_count"));
                    if (currentUserId != null) {
                        event.setUserRegistered(rs.getInt("is_registered") > 0);
                        event.setUserSaved(rs.getInt("is_saved") > 0);
                    }
                    list.add(event);
                }
            }
        } catch (SQLException e) {
            System.err.println("[EventDAO.getDiscoveredEvents] " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get single event by ID with registration count and user status.
     */
    public Event getEventById(int eventId, Integer currentUserId) {
        StringBuilder sql = new StringBuilder("SELECT e.*, ");
        sql.append("(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count ");
        if (currentUserId != null) {
            sql.append(", (SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.user_id = ? AND r.status != 'CANCELLED') AS is_registered ");
            sql.append(", (SELECT COUNT(*) FROM saved_events s WHERE s.event_id = e.id AND s.user_id = ?) AS is_saved ");
        }
        sql.append("FROM events e WHERE e.id = ?");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int pIdx = 1;
            if (currentUserId != null) {
                ps.setInt(pIdx++, currentUserId);
                ps.setInt(pIdx++, currentUserId);
            }
            ps.setInt(pIdx, eventId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Event event = mapResultSetToEvent(rs);
                    event.setRegisteredCount(rs.getInt("reg_count"));
                    if (currentUserId != null) {
                        event.setUserRegistered(rs.getInt("is_registered") > 0);
                        event.setUserSaved(rs.getInt("is_saved") > 0);
                    }
                    return event;
                }
            }
        } catch (SQLException e) {
            System.err.println("[EventDAO.getEventById] " + e.getMessage());
        }
        return null;
    }

    /**
     * Get all events for Admin management view.
     */
    public List<Event> getAllEventsForAdmin() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, "
                + "(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count "
                + "FROM events e ORDER BY e.event_date DESC, e.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Event event = mapResultSetToEvent(rs);
                event.setRegisteredCount(rs.getInt("reg_count"));
                list.add(event);
            }
        } catch (SQLException e) {
            System.err.println("[EventDAO.getAllEventsForAdmin] " + e.getMessage());
        }
        return list;
    }

    /**
     * Create a new event.
     */
    public boolean createEvent(Event event) {
        String sql = "INSERT INTO events (title, short_description, description, category, department, eligible_year, "
                + "event_date, start_time, end_time, venue, organizer_name, organizer_contact, registration_deadline, "
                + "max_participants, eligibility, image, status, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, event.getTitle());
            ps.setString(2, event.getShortDescription());
            ps.setString(3, event.getDescription());
            ps.setString(4, event.getCategory());
            ps.setString(5, event.getDepartment());
            ps.setString(6, event.getEligibleYear());
            ps.setString(7, event.getEventDate() != null ? event.getEventDate().toString() : "");
            ps.setString(8, event.getStartTime());
            ps.setString(9, event.getEndTime());
            ps.setString(10, event.getVenue());
            ps.setString(11, event.getOrganizerName());
            ps.setString(12, event.getOrganizerContact());
            ps.setString(13, event.getRegistrationDeadline() != null ? event.getRegistrationDeadline().toString() : "");
            ps.setInt(14, event.getMaxParticipants());
            ps.setString(15, event.getEligibility());
            ps.setString(16, event.getImage());
            ps.setString(17, event.getStatus() != null ? event.getStatus() : "Published");
            ps.setInt(18, event.getCreatedBy());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet gk = ps.getGeneratedKeys()) {
                    if (gk.next()) {
                        event.setId(gk.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[EventDAO.createEvent] " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update an existing event.
     */
    public boolean updateEvent(Event event) {
        String sql = "UPDATE events SET title = ?, short_description = ?, description = ?, category = ?, department = ?, "
                + "eligible_year = ?, event_date = ?, start_time = ?, end_time = ?, venue = ?, organizer_name = ?, "
                + "organizer_contact = ?, registration_deadline = ?, max_participants = ?, eligibility = ?, "
                + "image = ?, status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, event.getTitle());
            ps.setString(2, event.getShortDescription());
            ps.setString(3, event.getDescription());
            ps.setString(4, event.getCategory());
            ps.setString(5, event.getDepartment());
            ps.setString(6, event.getEligibleYear());
            ps.setString(7, event.getEventDate() != null ? event.getEventDate().toString() : "");
            ps.setString(8, event.getStartTime());
            ps.setString(9, event.getEndTime());
            ps.setString(10, event.getVenue());
            ps.setString(11, event.getOrganizerName());
            ps.setString(12, event.getOrganizerContact());
            ps.setString(13, event.getRegistrationDeadline() != null ? event.getRegistrationDeadline().toString() : "");
            ps.setInt(14, event.getMaxParticipants());
            ps.setString(15, event.getEligibility());
            ps.setString(16, event.getImage());
            ps.setString(17, event.getStatus());
            ps.setInt(18, event.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[EventDAO.updateEvent] " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete an event by ID.
     */
    public boolean deleteEvent(int eventId) {
        String sql = "DELETE FROM events WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[EventDAO.deleteEvent] " + e.getMessage());
        }
        return false;
    }

    /**
     * Retrieve bookmarked events for a user.
     */
    public List<Event> getSavedEventsByUser(int userId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, "
                + "(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.status != 'CANCELLED') AS reg_count, "
                + "(SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.id AND r.user_id = ? AND r.status != 'CANCELLED') AS is_registered "
                + "FROM events e "
                + "INNER JOIN saved_events s ON e.id = s.event_id "
                + "WHERE s.user_id = ? ORDER BY s.saved_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Event event = mapResultSetToEvent(rs);
                    event.setRegisteredCount(rs.getInt("reg_count"));
                    event.setUserRegistered(rs.getInt("is_registered") > 0);
                    event.setUserSaved(true);
                    list.add(event);
                }
            }
        } catch (SQLException e) {
            System.err.println("[EventDAO.getSavedEventsByUser] " + e.getMessage());
        }
        return list;
    }

    /**
     * Toggle bookmark/saved status.
     */
    public boolean toggleSaveEvent(int userId, int eventId) {
        String checkSql = "SELECT 1 FROM saved_events WHERE user_id = ? AND event_id = ?";
        String insertSql = "INSERT INTO saved_events (user_id, event_id) VALUES (?, ?)";
        String deleteSql = "DELETE FROM saved_events WHERE user_id = ? AND event_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            boolean isSaved = false;
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, eventId);
                try (ResultSet rs = ps.executeQuery()) {
                    isSaved = rs.next();
                }
            }

            if (isSaved) {
                try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, eventId);
                    ps.executeUpdate();
                    return false; // Now unsaved
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, eventId);
                    ps.executeUpdate();
                    return true; // Now saved
                }
            }
        } catch (SQLException e) {
            System.err.println("[EventDAO.toggleSaveEvent] " + e.getMessage());
        }
        return false;
    }

    /**
     * Get aggregate statistics for Admin Dashboard.
     */
    public Map<String, Integer> getDashboardStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalEvents", 0);
        stats.put("upcomingEvents", 0);
        stats.put("totalRegistrations", 0);
        stats.put("activeEvents", 0);

        try (Connection conn = DBConnection.getConnection()) {
            // Total Events
            try (Statement s = conn.createStatement();
                 ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM events")) {
                if (rs.next()) stats.put("totalEvents", rs.getInt(1));
            }

            // Total Registrations
            try (Statement s = conn.createStatement();
                 ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM registrations WHERE status != 'CANCELLED'")) {
                if (rs.next()) stats.put("totalRegistrations", rs.getInt(1));
            }

            // Active / Published Events
            try (Statement s = conn.createStatement();
                 ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM events WHERE status = 'Published'")) {
                if (rs.next()) stats.put("activeEvents", rs.getInt(1));
            }

            // Upcoming Events (based on current date or published)
            String upcomingSql = DBConnection.isFallbackActive()
                    ? "SELECT COUNT(*) FROM events WHERE status = 'Published' AND date(event_date) >= date('now')"
                    : "SELECT COUNT(*) FROM events WHERE status = 'Published' AND event_date >= CURRENT_DATE()";
            try (Statement s = conn.createStatement();
                 ResultSet rs = s.executeQuery(upcomingSql)) {
                if (rs.next()) stats.put("upcomingEvents", rs.getInt(1));
            } catch (Exception e) {
                // If date comparison differs, fallback to active events
                stats.put("upcomingEvents", stats.get("activeEvents"));
            }
        } catch (SQLException e) {
            System.err.println("[EventDAO.getDashboardStats] " + e.getMessage());
        }
        return stats;
    }
}
