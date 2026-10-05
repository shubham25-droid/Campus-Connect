<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Event" %>
<%@ page import="model.Registration" %>
<%@ page import="dao.EventDAO" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Attendee Roster");
    Event event = (Event) request.getAttribute("event");
    List<Registration> attendees = (List<Registration>) request.getAttribute("attendees");

    EventDAO eventDAO = new EventDAO();
    List<Event> allEvents = eventDAO.getAllEventsForAdmin();
%>
<jsp:include page="../includes/header.jsp" />

<div class="container">

    <div style="margin-bottom: 1.5rem; display: flex; align-items: center; justify-content: space-between; flex-wrap:wrap; gap:1rem;">
        <div>
            <a href="<%= request.getContextPath() %>/admin/dashboard" style="display:inline-flex; align-items:center; gap:6px; font-weight:600; font-size:0.9rem;">
                &larr; Back to Admin Dashboard
            </a>
            <h1 class="page-title" style="margin-top:4px;">
                <%= event != null ? "Attendees: " + event.getTitle() : "All Event Registrations" %>
            </h1>
            <p class="page-subtitle">
                Official registration roster for faculty coordinators and HOD verification.
            </p>
        </div>

        <div style="display:flex; gap:10px;">
            <button type="button" class="btn btn-outline" onclick="exportTableToCSV('campusconnect_attendees.csv')">
                &#128190; Export to CSV
            </button>
            <button type="button" class="btn btn-secondary" onclick="window.print()">
                &#128424; Print Roster
            </button>
        </div>
    </div>

    <!-- Event Filter Dropdown -->
    <div class="card" style="padding: 1rem 1.25rem; margin-bottom: 1.5rem;">
        <form action="<%= request.getContextPath() %>/admin/registrations" method="GET" style="display:flex; gap:1rem; align-items:center; flex-wrap:wrap;">
            <label style="font-weight:600; font-size:0.875rem;">Filter by Event:</label>
            <select name="eventId" class="form-select" style="max-width:400px;" onchange="this.form.submit()">
                <option value="">-- All Recent Registrations --</option>
                <% for (Event e : allEvents) { %>
                    <option value="<%= e.getId() %>" <%= (event != null && event.getId() == e.getId()) ? "selected" : "" %>>
                        <%= e.getTitle() %> (<%= e.getFormattedDate() %>)
                    </option>
                <% } %>
            </select>
            <span style="font-size:0.85rem; color:var(--text-muted); margin-left:auto;">
                Total Registered: <strong><%= attendees != null ? attendees.size() : 0 %></strong> students
            </span>
        </form>
    </div>

    <!-- Attendees Table -->
    <div class="card" style="overflow:hidden;">
        <div class="table-responsive">
            <table class="admin-table" id="attendeesTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student Name</th>
                        <th>College Email</th>
                        <th>Department</th>
                        <th>Academic Year</th>
                        <th>Event</th>
                        <th>Registered At</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (attendees != null && !attendees.isEmpty()) { 
                        int idx = 1;
                        for (Registration reg : attendees) { 
                    %>
                        <tr>
                            <td><%= idx++ %></td>
                            <td><strong style="color:var(--secondary);"><%= reg.getUserName() %></strong></td>
                            <td><%= reg.getUserEmail() %></td>
                            <td><%= reg.getUserDepartment() %></td>
                            <td><%= reg.getUserYear() %></td>
                            <td><%= reg.getEventTitle() %></td>
                            <td style="font-size:0.8rem; color:var(--text-muted);"><%= reg.getFormattedRegisteredAt() %></td>
                            <td>
                                <span class="seat-status-pill open" style="font-size:0.75rem;">
                                    &#10003; <%= reg.getStatus() %>
                                </span>
                            </td>
                        </tr>
                    <%  } 
                       } else { %>
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 2.5rem; color: var(--text-muted);">
                                No students have registered for this event yet.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- CSV Export Script -->
<script>
function exportTableToCSV(filename) {
    var csv = [];
    var rows = document.querySelectorAll("#attendeesTable tr");
    
    for (var i = 0; i < rows.length; i++) {
        var row = [], cols = rows[i].querySelectorAll("td, th");
        for (var j = 0; j < cols.length; j++) {
            var text = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, "").replace(/"/g, '""');
            row.push('"' + text.trim() + '"');
        }
        csv.push(row.join(","));
    }

    var csvFile = new Blob([csv.join("\n")], { type: "text/csv" });
    var downloadLink = document.createElement("a");
    downloadLink.download = filename;
    downloadLink.href = window.URL.createObjectURL(csvFile);
    downloadLink.style.display = "none";
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
}
</script>

<jsp:include page="../includes/footer.jsp" />
