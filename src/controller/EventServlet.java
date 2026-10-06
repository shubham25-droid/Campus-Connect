package controller;

import dao.EventDAO;
import dao.RegistrationDAO;
import model.Event;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * EventServlet handles both the Student Dashboard and Event Discovery views.
 */
@WebServlet(urlPatterns = {"/dashboard", "/events"})
public class EventServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final RegistrationDAO registrationDAO = new RegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : null;

        // Parse search, filter, and sorting parameters
        String search = req.getParameter("search");
        String category = req.getParameter("category");
        String department = req.getParameter("department");
        String year = req.getParameter("year");
        String sort = req.getParameter("sort");

        if (sort == null || sort.trim().isEmpty()) {
            sort = "upcoming";
        }

        // Retrieve filtered events
        List<Event> events = eventDAO.getDiscoveredEvents(search, category, department, year, sort, currentUserId);

        // Featured event: prioritize active upcoming events
        Event featuredEvent = null;
        if (!events.isEmpty()) {
            for (Event e : events) {
                if ((e.getTitle().contains("GDG") || e.getTitle().contains("Hacktoberfest")) && !e.isPastEvent()) {
                    featuredEvent = e;
                    break;
                }
            }
            if (featuredEvent == null) {
                for (Event e : events) {
                    if (!e.isPastEvent()) {
                        featuredEvent = e;
                        break;
                    }
                }
            }
            if (featuredEvent == null) {
                featuredEvent = events.get(0);
            }
        }

        // Quick user counts if logged in
        int myRegistrationsCount = 0;
        int savedEventsCount = 0;
        if (currentUserId != null) {
            myRegistrationsCount = registrationDAO.getRegistrationsByUser(currentUserId).size();
            savedEventsCount = eventDAO.getSavedEventsByUser(currentUserId).size();
        }

        req.setAttribute("events", events);
        req.setAttribute("featuredEvent", featuredEvent);
        req.setAttribute("totalFound", events.size());
        req.setAttribute("paramSearch", search);
        req.setAttribute("paramCategory", category);
        req.setAttribute("paramDepartment", department);
        req.setAttribute("paramYear", year);
        req.setAttribute("paramSort", sort);
        req.setAttribute("myRegistrationsCount", myRegistrationsCount);
        req.setAttribute("savedEventsCount", savedEventsCount);

        String path = req.getServletPath();
        if ("/events".equals(path)) {
            // Forward to dedicated discovery view or dashboard
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        }
    }
}
