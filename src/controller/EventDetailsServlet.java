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

/**
 * EventDetailsServlet loads the dedicated event view with all structured details.
 */
@WebServlet("/event-details")
public class EventDetailsServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        try {
            int eventId = Integer.parseInt(idParam.trim());
            HttpSession session = req.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
            Integer currentUserId = (currentUser != null) ? currentUser.getId() : null;

            Event event = eventDAO.getEventById(eventId, currentUserId);
            if (event == null) {
                resp.sendRedirect(req.getContextPath() + "/dashboard?error=not_found");
                return;
            }

            req.setAttribute("event", event);
            req.getRequestDispatcher("/event-details.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }
}
