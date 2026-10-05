<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Registration" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "My Registrations");
    List<Registration> registrations = (List<Registration>) request.getAttribute("registrations");
    User authUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
    String status = request.getParameter("status");
%>
<jsp:include page="includes/header.jsp" />

<div class="container">

    <div class="page-header" style="display:flex; justify-content:space-between; align-items:flex-end; flex-wrap:wrap; gap:1rem;">
        <div>
            <h1 class="page-title">My Registered Events</h1>
            <p class="page-subtitle">Manage your event attendance passes and upcoming schedules</p>
        </div>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline btn-sm">Explore More Opportunities &rarr;</a>
    </div>

    <% if ("cancelled".equals(status)) { %>
        <div class="alert alert-info">
            Registration has been successfully cancelled. Your seat has been released for other students.
        </div>
    <% } %>

    <% if (registrations != null && !registrations.isEmpty()) { %>
        <div style="display: flex; flex-direction: column; gap: 1.25rem;">
            <% for (Registration r : registrations) { %>
                <div class="card" style="padding: 1.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1.5rem;">
                    
                    <div style="display: flex; gap: 1.25rem; align-items: center; min-width: 300px; flex: 1;">
                        <img src="<%= request.getContextPath() %>/images/<%= r.getEventImage() %>" alt="<%= r.getEventTitle() %>" 
                             style="width: 100px; height: 100px; object-fit: cover; border-radius: var(--radius-sm); border: 1px solid var(--border-color);"
                             onerror="this.src='<%= request.getContextPath() %>/images/gdg_hacktoberfest.jpg'">
                        <div>
                            <span class="cat-pill active" style="font-size: 0.72rem; padding: 2px 8px;"><%= r.getEventCategory() %></span>
                            <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--secondary); margin: 4px 0 6px;">
                                <a href="<%= request.getContextPath() %>/event-details?id=<%= r.getEventId() %>"><%= r.getEventTitle() %></a>
                            </h3>
                            <div style="font-size: 0.825rem; color: var(--text-muted); display: flex; flex-direction: column; gap: 2px;">
                                <span>&#128197; <%= r.getFormattedEventDate() %> &bull; <%= r.getEventStartTime() %></span>
                                <span>&#128205; <%= r.getEventVenue() %> &bull; <%= r.getEventOrganizer() %></span>
                                <span style="color: var(--text-subtle); margin-top: 2px;">Registered on: <%= r.getFormattedRegisteredAt() %></span>
                            </div>
                        </div>
                    </div>

                    <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 0.75rem;">
                        <span class="seat-status-pill open" style="padding: 4px 10px; font-size: 0.8125rem;">
                            &#10003; <%= r.getStatus() %>
                        </span>

                        <div class="action-btn-group">
                            <a href="<%= request.getContextPath() %>/event-details?id=<%= r.getEventId() %>" class="btn btn-secondary btn-sm">
                                View Details
                            </a>
                            <button type="button" class="btn btn-outline btn-sm" onclick="printPass('<%= r.getEventTitle() %>', '<%= r.getFormattedEventDate() %>', '<%= r.getEventStartTime() %>', '<%= r.getEventVenue() %>', '<%= authUser.getName() %>', '<%= authUser.getEmail() %>')">
                                Print Pass
                            </button>
                            <form action="<%= request.getContextPath() %>/cancel-registration" method="POST" onsubmit="return confirm('Cancel this registration?');" style="display:inline;">
                                <input type="hidden" name="eventId" value="<%= r.getEventId() %>">
                                <button type="submit" class="btn btn-danger btn-sm" style="background:#fee2e2; color:#b91c1c; border-color:#fecaca;">
                                    Cancel
                                </button>
                            </form>
                        </div>
                    </div>

                </div>
            <% } %>
        </div>
    <% } else { %>
        <div style="text-align: center; padding: 4.5rem 1.5rem; background: var(--bg-surface); border: 1px dashed var(--border-color); border-radius: var(--radius-md);">
            <div style="font-size: 3rem; margin-bottom: 0.75rem;">&#128197;</div>
            <h3 style="font-size: 1.35rem; font-weight: 700; color: var(--secondary);">No Active Registrations</h3>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 6px; max-width: 480px; margin-left: auto; margin-right: auto;">
                You haven't signed up for any events yet. Check out upcoming workshops, hackathons, and technical sessions happening across the campus.
            </p>
            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-primary" style="margin-top: 1.25rem;">
                Explore Campus Events
            </a>
        </div>
    <% } %>

</div>

<!-- Event Pass Print Modal Script -->
<script>
function printPass(title, date, time, venue, student, email) {
    const printWindow = window.open('', '_blank', 'width=700,height=550');
    printWindow.document.write(`
        <html>
        <head>
            <title>CampusConnect Official Event Pass</title>
            <style>
                body { font-family: 'Segoe UI', Tahoma, sans-serif; padding: 30px; background: #f8fafc; color: #0f172a; }
                .ticket { border: 2px dashed #1e3a8a; background: #fff; padding: 25px; border-radius: 8px; max-width: 580px; margin: 0 auto; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
                .header { border-bottom: 2px solid #eff6ff; padding-bottom: 12px; margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center; }
                .title { font-size: 18px; font-weight: bold; color: #1e3a8a; margin-top: 10px; }
                .meta { font-size: 14px; margin: 6px 0; color: #475569; }
                .badge { background: #dcfce7; color: #166534; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="ticket">
                <div class="header">
                    <div>
                        <div style="font-size: 11px; text-transform: uppercase; color: #64748b; font-weight: bold;">Lokmanya Tilak College of Engineering</div>
                        <div style="font-size: 18px; font-weight: bold; color: #1e3a8a;">CampusConnect Entry Pass</div>
                    </div>
                    <span class="badge">CONFIRMED ATTENDEE</span>
                </div>
                <div class="title">\${title}</div>
                <div class="meta"><strong>Date & Time:</strong> \${date} at \${time}</div>
                <div class="meta"><strong>Venue:</strong> \${venue}</div>
                <hr style="border:none; border-top: 1px solid #e2e8f0; margin: 16px 0;">
                <div class="meta"><strong>Attendee Name:</strong> \${student}</div>
                <div class="meta"><strong>Registered Email:</strong> \${email}</div>
                <div style="font-size: 11px; color: #94a3b8; margin-top: 20px; text-align: center;">
                    Please present this digital pass or your college ID card at the entry gate.
                </div>
            </div>
            <script>window.onload = function() { window.print(); };<\/script>
        </body>
        </html>
    `);
    printWindow.document.close();
}
</script>

<jsp:include page="includes/footer.jsp" />
