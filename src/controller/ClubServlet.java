package controller;

import dao.EventDAO;
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
 * ClubServlet provides a comprehensive directory of all campus clubs,
 * technical chapters, and department associations at LTCE.
 */
@WebServlet("/clubs")
public class ClubServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : null;

        // Fetch all published events to show counts per club
        List<Event> allEvents = eventDAO.getDiscoveredEvents("", "All", "All", "All", "upcoming", currentUserId);
        req.setAttribute("allEvents", allEvents);

        req.getRequestDispatcher("/clubs.jsp").forward(req, resp);
    }
}
