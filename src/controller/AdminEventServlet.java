package controller;

import dao.EventDAO;
import dao.RegistrationDAO;
import model.Event;
import model.Registration;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

/**
 * AdminEventServlet provides full event lifecycle administration,
 * attendee tracking, and analytics for college organizers.
 */
@WebServlet(urlPatterns = {
        "/admin/dashboard",
        "/admin/create-event",
        "/admin/edit-event",
        "/admin/delete-event",
        "/admin/registrations"
})
public class AdminEventServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();

    private boolean checkAdminAuth(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getRequestURI());
            return false;
        }
        User user = (User) session.getAttribute("currentUser");
        if (!user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=unauthorized");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdminAuth(req, resp)) return;

        String path = req.getServletPath();

        if ("/admin/dashboard".equals(path)) {
            Map<String, Integer> stats = eventDAO.getDashboardStats();
            List<Event> allEvents = eventDAO.getAllEventsForAdmin();
            List<Registration> recentRegistrations = registrationDAO.getAllRecentRegistrations(8);

            req.setAttribute("stats", stats);
            req.setAttribute("events", allEvents);
            req.setAttribute("recentRegistrations", recentRegistrations);
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);

        } else if ("/admin/create-event".equals(path)) {
            req.getRequestDispatcher("/admin/create-event.jsp").forward(req, resp);

        } else if ("/admin/edit-event".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                return;
            }
            try {
                int eventId = Integer.parseInt(idStr.trim());
                Event event = eventDAO.getEventById(eventId, null);
                if (event == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=event_not_found");
                    return;
                }
                req.setAttribute("event", event);
                req.getRequestDispatcher("/admin/edit-event.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }

        } else if ("/admin/registrations".equals(path)) {
            String eventIdStr = req.getParameter("eventId");
            if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
                try {
                    int eventId = Integer.parseInt(eventIdStr.trim());
                    Event event = eventDAO.getEventById(eventId, null);
                    List<Registration> attendees = registrationDAO.getRegistrationsByEvent(eventId);
                    req.setAttribute("event", event);
                    req.setAttribute("attendees", attendees);
                } catch (NumberFormatException ignored) {}
            } else {
                List<Registration> attendees = registrationDAO.getAllRecentRegistrations(50);
                req.setAttribute("attendees", attendees);
            }
            req.getRequestDispatcher("/admin/registrations.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdminAuth(req, resp)) return;

        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        if ("/admin/delete-event".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int eventId = Integer.parseInt(idStr.trim());
                    eventDAO.deleteEvent(eventId);
                } catch (NumberFormatException ignored) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=deleted");
            return;
        }

        // Form submission for Create or Edit
        String title = req.getParameter("title");
        String shortDesc = req.getParameter("shortDescription");
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        String department = req.getParameter("department");
        String eligibleYear = req.getParameter("eligibleYear");
        String eventDateStr = req.getParameter("eventDate");
        String startTime = req.getParameter("startTime");
        String endTime = req.getParameter("endTime");
        String venue = req.getParameter("venue");
        String organizerName = req.getParameter("organizerName");
        String organizerContact = req.getParameter("organizerContact");
        String deadlineStr = req.getParameter("registrationDeadline");
        String maxParticipantsStr = req.getParameter("maxParticipants");
        String eligibility = req.getParameter("eligibility");
        String image = req.getParameter("image");
        String status = req.getParameter("status");

        // Validate essentials
        if (title == null || title.trim().isEmpty() ||
            eventDateStr == null || eventDateStr.trim().isEmpty() ||
            venue == null || venue.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Event Title, Date, and Venue are mandatory fields.");
            if ("/admin/create-event".equals(path)) {
                req.getRequestDispatcher("/admin/create-event.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/admin/edit-event.jsp").forward(req, resp);
            }
            return;
        }

        Event event = new Event();
        event.setTitle(title.trim());
        event.setShortDescription(shortDesc != null ? shortDesc.trim() : "");
        event.setDescription(description != null ? description.trim() : "");
        event.setCategory(category != null ? category.trim() : "General");
        event.setDepartment(department != null ? department.trim() : "All Departments");
        event.setEligibleYear(eligibleYear != null ? eligibleYear.trim() : "All Years");

        try {
            event.setEventDate(Date.valueOf(eventDateStr.trim()));
        } catch (Exception e) {
            event.setEventDate(new Date(System.currentTimeMillis()));
        }

        event.setStartTime(startTime != null ? startTime.trim() : "10:00 AM");
        event.setEndTime(endTime != null ? endTime.trim() : "12:00 PM");
        event.setVenue(venue.trim());
        event.setOrganizerName(organizerName != null ? organizerName.trim() : "College Committee");
        event.setOrganizerContact(organizerContact != null ? organizerContact.trim() : "");

        try {
            if (deadlineStr != null && !deadlineStr.trim().isEmpty()) {
                event.setRegistrationDeadline(Date.valueOf(deadlineStr.trim()));
            } else {
                event.setRegistrationDeadline(event.getEventDate());
            }
        } catch (Exception e) {
            event.setRegistrationDeadline(event.getEventDate());
        }

        try {
            event.setMaxParticipants(maxParticipantsStr != null ? Integer.parseInt(maxParticipantsStr.trim()) : 100);
        } catch (NumberFormatException e) {
            event.setMaxParticipants(100);
        }

        event.setEligibility(eligibility != null ? eligibility.trim() : "Open to all students");
        event.setImage(image != null && !image.trim().isEmpty() ? image.trim() : "gdg_hacktoberfest.jpg");
        event.setStatus(status != null ? status.trim() : "Published");

        if ("/admin/create-event".equals(path)) {
            event.setCreatedBy(currentUser.getId());
            boolean ok = eventDAO.createEvent(event);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=created");
            } else {
                req.setAttribute("errorMessage", "Failed to save event to database.");
                req.getRequestDispatcher("/admin/create-event.jsp").forward(req, resp);
            }
        } else if ("/admin/edit-event".equals(path)) {
            String idStr = req.getParameter("id");
            try {
                event.setId(Integer.parseInt(idStr.trim()));
                boolean ok = eventDAO.updateEvent(event);
                if (ok) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=updated");
                } else {
                    req.setAttribute("errorMessage", "Failed to update event.");
                    req.setAttribute("event", event);
                    req.getRequestDispatcher("/admin/edit-event.jsp").forward(req, resp);
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        }
    }
}
