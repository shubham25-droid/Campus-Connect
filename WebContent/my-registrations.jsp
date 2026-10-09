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
            Registration has been successfully cancelled.
        </div>
    <% } %>

    <% if (registrations != null && !registrations.isEmpty()) { %>
        <div class="pass-tickets-list">
            <% for (Registration r : registrations) { %>
                <div class="pass-ticket-card">
                    <div class="pass-ticket-main">
                        <div class="pass-ticket-img-wrap">
                            <img src="<%= request.getContextPath() %>/images/<%= r.getEventImage() %>" alt="<%= r.getEventTitle() %>" 
                                 class="pass-ticket-img"
                                 onerror="this.src='<%= request.getContextPath() %>/images/gdg_hacktoberfest.jpg'">
                        </div>
                        <div class="pass-ticket-details">
                            <div class="pass-ticket-tag-row">
                                <span class="cat-pill active" style="font-size: 0.72rem; padding: 2px 8px;"><%= r.getEventCategory() %></span>
                                <span class="seat-status-pill open" style="padding: 3px 8px; font-size: 0.75rem;">
                                    &#10003; <%= r.getStatus() %>
                                </span>
                            </div>
                            <h3 class="pass-ticket-title">
                                <a href="<%= request.getContextPath() %>/event-details?id=<%= r.getEventId() %>"><%= r.getEventTitle() %></a>
                            </h3>
                            <div class="pass-ticket-meta">
                                <div>&#128197; <strong><%= r.getFormattedEventDate() %></strong> &bull; <%= r.getEventStartTime() %></div>
                                <div>&#128205; <%= r.getEventVenue() %> &bull; <%= r.getEventOrganizer() %></div>
                                <div style="color: var(--text-muted); font-size: 0.75rem; margin-top: 2px;">Registered on <%= r.getFormattedRegisteredAt() %></div>
                            </div>
                        </div>
                    </div>

                    <div class="pass-ticket-actions">
                        <div class="action-btn-group pass-btn-group">
                            <a href="<%= request.getContextPath() %>/event-details?id=<%= r.getEventId() %>" class="btn btn-secondary btn-sm">
                                View Details
                            </a>
                            <button type="button" class="btn btn-outline btn-sm btn-print-pass" onclick="printPass('<%= r.getEventTitle() %>', '<%= r.getFormattedEventDate() %>', '<%= r.getEventStartTime() %>', '<%= r.getEventVenue() %>', '<%= authUser.getName() %>', '<%= authUser.getEmail() %>')">
                                &#127915; Print Pass
                            </button>
                            <form action="<%= request.getContextPath() %>/cancel-registration" method="POST" onsubmit="return confirm('Cancel this registration?');" style="display:inline; margin:0;">
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
                body { font-family: 'Roboto', 'Segoe UI', Tahoma, sans-serif; padding: 30px; background: #f8fafc; color: #0f172a; }
                .ticket { border: 2.5px dashed #0d4379; background: #fff; padding: 25px; border-radius: 10px; max-width: 600px; margin: 0 auto; box-shadow: 0 4px 12px rgba(8,44,80,0.1); border-top: 6px solid #ff9600; }
                .header { border-bottom: 2px solid #eff6ff; padding-bottom: 12px; margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center; }
                .title { font-size: 20px; font-weight: 800; color: #0d4379; margin-top: 10px; }
                .meta { font-size: 14px; margin: 6px 0; color: #334155; }
                .badge { background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 4px; font-weight: bold; font-size: 12px; border: 1px solid #bbf7d0; }
            </style>
        </head>
        <body>
            <div class="ticket">
                <div class="header">
                    <div>
                        <div style="font-size: 11px; text-transform: uppercase; color: #64748b; font-weight: bold; letter-spacing:0.5px;">Lokmanya Tilak College of Engineering</div>
                        <div style="font-size: 20px; font-weight: 900; color: #0d4379;">CAMPUS<span style="color:#ff9600;">CONNECT</span> ENTRY PASS</div>
                    </div>
                    <span class="badge">&#10003; VERIFIED PASS</span>
                </div>
                <div class="title">\${title}</div>
                <div class="meta"><strong>Date & Time:</strong> \${date} at \${time}</div>
                <div class="meta"><strong>Venue:</strong> \${venue}</div>
                <hr style="border:none; border-top: 1px solid #e2e8f0; margin: 16px 0;">
                <div class="meta"><strong>Student Name:</strong> \${student}</div>
                <div class="meta"><strong>Email ID:</strong> \${email}</div>
                <div style="font-size: 11px; color: #94a3b8; margin-top: 20px; text-align: center; border-top: 1px dashed #e2e8f0; padding-top: 12px;">
                    Present this verified pass along with your LTCE College ID card at the entry gate.
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
