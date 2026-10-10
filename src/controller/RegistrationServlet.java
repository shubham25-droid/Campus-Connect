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
import java.util.List;

/**
 * RegistrationServlet manages student registrations, cancellations, and saved events.
 */
@WebServlet(urlPatterns = {"/register-event", "/cancel-registration", "/my-registrations", "/saved-events", "/toggle-save"})
public class RegistrationServlet extends HttpServlet {

    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getRequestURI());
            return;
        }

        String servletPath = req.getServletPath();

        if ("/my-registrations".equals(servletPath)) {
            List<Registration> list = registrationDAO.getRegistrationsByUser(currentUser.getId());
            req.setAttribute("registrations", list);
            req.getRequestDispatcher("/my-registrations.jsp").forward(req, resp);
        } else if ("/saved-events".equals(servletPath)) {
            List<Event> savedList = eventDAO.getSavedEventsByUser(currentUser.getId());
            req.setAttribute("savedEvents", savedList);
            req.getRequestDispatcher("/saved-events.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String servletPath = req.getServletPath();
        String eventIdParam = req.getParameter("eventId");

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login" + (eventIdParam != null ? "?redirect=" + req.getContextPath() + "/event-details?id=" + eventIdParam : ""));
            return;
        }

        if (eventIdParam == null || eventIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        int eventId;
        try {
            eventId = Integer.parseInt(eventIdParam.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        if ("/register-event".equals(servletPath)) {
            int result = registrationDAO.registerUser(currentUser.getId(), eventId);
            if (result == 1) {
                resp.sendRedirect(req.getContextPath() + "/event-details?id=" + eventId + "&status=registered_success");
            } else if (result == 0) {
                resp.sendRedirect(req.getContextPath() + "/event-details?id=" + eventId + "&status=already_registered");
            } else if (result == -1) {
                resp.sendRedirect(req.getContextPath() + "/event-details?id=" + eventId + "&status=event_full");
            } else {
                resp.sendRedirect(req.getContextPath() + "/event-details?id=" + eventId + "&status=error");
            }
        } else if ("/cancel-registration".equals(servletPath)) {
            registrationDAO.cancelRegistration(currentUser.getId(), eventId);
            String referer = req.getHeader("referer");
            if (referer != null && referer.contains("my-registrations")) {
                resp.sendRedirect(req.getContextPath() + "/my-registrations?status=cancelled");
            } else {
                resp.sendRedirect(req.getContextPath() + "/event-details?id=" + eventId + "&status=cancelled");
            }
        } else if ("/toggle-save".equals(servletPath)) {
            boolean isSavedNow = eventDAO.toggleSaveEvent(currentUser.getId(), eventId);
            String ajax = req.getParameter("ajax");
            if ("true".equalsIgnoreCase(ajax)) {
                resp.setContentType("application/json");
                resp.getWriter().write("{\"saved\":" + isSavedNow + "}");
                return;
            }
            String returnUrl = req.getParameter("returnUrl");
            if (util.SecurityUtil.isSafeRedirect(returnUrl, req.getContextPath())) {
                resp.sendRedirect(returnUrl);
            } else {
                resp.sendRedirect(req.getContextPath() + "/event-details?id=" + eventId);
            }
        }
    }
}
