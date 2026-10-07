<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Event" %>
<%@ page import="model.Registration" %>
<%@ page import="model.User" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Admin Dashboard");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    List<Event> events = (List<Event>) request.getAttribute("events");
    List<Registration> recentRegs = (List<Registration>) request.getAttribute("recentRegistrations");
    User adminUser = (User) session.getAttribute("currentUser");

    String msg = request.getParameter("msg");
%>
<jsp:include page="../includes/header.jsp" />

<div class="container">

    <!-- Admin Top Banner -->
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1.25rem; margin-bottom: 2rem;">
        <div>
            <div style="display:flex; align-items:center; gap:8px;">
                <span class="role-tag admin">Administrative Portal</span>
                <span style="font-size:0.8rem; color:var(--text-muted);">&bull; <%= DBConnection.getDatabaseType() %></span>
            </div>
            <h1 class="page-title" style="margin-top:4px;">Campus Event Management</h1>
            <p class="page-subtitle">Centralized governance for college events, departments, and registrations</p>
        </div>

        <div style="display:flex; gap:10px;">
            <a href="<%= request.getContextPath() %>/admin/registrations" class="btn btn-secondary">
                &#128101; View All Attendees
            </a>
            <a href="<%= request.getContextPath() %>/admin/create-event" class="btn btn-primary">
                + Create New Event
            </a>
        </div>
    </div>

    <!-- Feedback messages -->
    <% if ("created".equals(msg)) { %>
        <div class="alert alert-success">
            &#10003; <strong>Success:</strong> Event has been published and is now live across student dashboards!
        </div>
    <% } else if ("updated".equals(msg)) { %>
        <div class="alert alert-success">
            &#10003; <strong>Success:</strong> Event details were updated successfully.
        </div>
    <% } else if ("deleted".equals(msg)) { %>
        <div class="alert alert-info">
            Event has been removed from the directory.
        </div>
    <% } %>

    <!-- 4 Overview Metric Cards -->
    <div class="admin-metrics-grid">
        <div class="metric-card">
            <div class="metric-icon-box blue">&#128197;</div>
            <div>
                <div class="metric-label">Total Events</div>
                <div class="metric-number"><%= stats != null ? stats.get("totalEvents") : 0 %></div>
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-icon-box green">&#9200;</div>
            <div>
                <div class="metric-label">Upcoming Events</div>
                <div class="metric-number"><%= stats != null ? stats.get("upcomingEvents") : 0 %></div>
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-icon-box amber">&#128101;</div>
            <div>
                <div class="metric-label">Total Registrations</div>
                <div class="metric-number"><%= stats != null ? stats.get("totalRegistrations") : 0 %></div>
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-icon-box purple">&#9881;</div>
            <div>
                <div class="metric-label">Active / Published</div>
                <div class="metric-number"><%= stats != null ? stats.get("activeEvents") : 0 %></div>
            </div>
        </div>
    </div>

    <!-- Event Management Table -->
    <div class="card" style="margin-bottom: 2.5rem; overflow:hidden;">
        <div style="padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border-color); display:flex; justify-content:space-between; align-items:center;">
            <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--secondary);">Event Management</h3>
            <span style="font-size:0.85rem; color:var(--text-muted);"><%= events != null ? events.size() : 0 %> total published & draft events</span>
        </div>

        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="min-width: 220px;">Event</th>
                        <th style="min-width: 130px;">Date &amp; Time</th>
                        <th>Category</th>
                        <th>Department</th>
                        <th>Status</th>
                        <th>Registered</th>
                        <th style="text-align: right; min-width: 140px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (events != null && !events.isEmpty()) { 
                        for (Event e : events) { 
                    %>
                        <tr>
                            <td>
                                <div>
                                    <a href="<%= request.getContextPath() %>/event-details?id=<%= e.getId() %>" style="font-weight:700; color:var(--ltce-navy); font-size:0.92rem;">
                                        <%= e.getTitle() %>
                                    </a>
                                </div>
                                <div style="font-size:0.775rem; color:var(--text-muted); margin-top:2px;">
                                    <%= e.getOrganizerName() %>
                                </div>
                            </td>
                            <td>
                                <div style="font-weight:600; font-size:0.85rem;"><%= e.getFormattedDate() %></div>
                                <div style="font-size:0.75rem; color:var(--text-muted); margin-top:1px;"><%= e.getStartTime() %></div>
                            </td>
                            <td>
                                <span class="cat-pill" style="font-size:0.75rem;"><%= e.getCategory() %></span>
                            </td>
                            <td>
                                <span style="font-size:0.825rem; color:#475569;"><%= e.getDepartment() %></span>
                            </td>
                            <td>
                                <span class="role-tag <%= "Published".equalsIgnoreCase(e.getStatus()) ? "student" : "admin" %>" style="font-size:0.725rem;">
                                    <%= e.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <a href="<%= request.getContextPath() %>/admin/registrations?eventId=<%= e.getId() %>" style="font-weight:700; color:var(--primary); font-size:0.9rem;">
                                    <%= e.getRegisteredCount() %> / <%= e.getMaxParticipants() %>
                                </a>
                            </td>
                            <td style="text-align: right;">
                                <div class="action-btn-group" style="justify-content: flex-end;">
                                    <a href="<%= request.getContextPath() %>/admin/registrations?eventId=<%= e.getId() %>" class="btn btn-outline btn-xs" title="Attendee List">
                                        Attendees
                                    </a>
                                    <a href="<%= request.getContextPath() %>/admin/edit-event?id=<%= e.getId() %>" class="btn btn-secondary btn-xs" title="Edit Event">
                                        Edit
                                    </a>
                                    <form action="<%= request.getContextPath() %>/admin/delete-event" method="POST" onsubmit="return confirm('Are you sure you want to delete this event?');" style="display:inline; margin:0;">
                                        <input type="hidden" name="id" value="<%= e.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-xs" style="background:#fee2e2; color:#b91c1c; border-color:#fecaca;" title="Delete">
                                            &times;
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <%  } 
                       } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 2.5rem; color: var(--text-muted);">
                                No events found. Create your first event!
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Recent Student Registrations Feed -->
    <div class="card" style="overflow:hidden;">
        <div style="padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border-color); display:flex; justify-content:space-between; align-items:center;">
            <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--secondary);">Recent Registrations</h3>
            <a href="<%= request.getContextPath() %>/admin/registrations" style="font-size:0.85rem; font-weight:600;">View Attendee Directory &rarr;</a>
        </div>

        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="min-width: 150px;">Student Name</th>
                        <th style="min-width: 180px;">College Email</th>
                        <th style="min-width: 180px;">Department &amp; Year</th>
                        <th style="min-width: 200px;">Event</th>
                        <th style="min-width: 140px;">Registered At</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (recentRegs != null && !recentRegs.isEmpty()) { 
                        for (Registration reg : recentRegs) { 
                    %>
                        <tr>
                            <td><strong style="color:var(--ltce-navy);"><%= reg.getUserName() %></strong></td>
                            <td style="color:#64748b; font-size:0.825rem;"><%= reg.getUserEmail() %></td>
                            <td style="color:#475569; font-size:0.825rem;"><%= reg.getUserDepartment() %> (<%= reg.getUserYear() %>)</td>
                            <td>
                                <a href="<%= request.getContextPath() %>/event-details?id=<%= reg.getEventId() %>" style="font-weight:600; color:var(--primary); font-size:0.875rem;">
                                    <%= reg.getEventTitle() %>
                                </a>
                            </td>
                            <td style="font-size:0.8rem; color:#64748b;"><%= reg.getFormattedRegisteredAt() %></td>
                            <td>
                                <span class="seat-status-pill open" style="font-size:0.725rem;">&#10003; <%= reg.getStatus() %></span>
                            </td>
                        </tr>
                    <%  } 
                       } else { %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 2.5rem; color: var(--text-muted);">
                                No student registrations recorded yet.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<jsp:include page="../includes/footer.jsp" />
