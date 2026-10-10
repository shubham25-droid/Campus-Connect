<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%
    User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Event event = (Event) request.getAttribute("event");
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
    request.setAttribute("pageTitle", "Edit Campus Event");
    String error = (String) request.getAttribute("errorMessage");
%>
<jsp:include page="../includes/header.jsp" />

<div class="container" style="max-width: 820px;">

    <div style="margin-bottom: 1.5rem; display: flex; align-items: center; justify-content: space-between;">
        <a href="<%= request.getContextPath() %>/admin/dashboard" style="display:inline-flex; align-items:center; gap:6px; font-weight:600; font-size:0.9rem;">
            &larr; Back to Admin Dashboard
        </a>
        <span class="role-tag admin">Editing Event #<%= event.getId() %></span>
    </div>

    <div class="card" style="padding: 2.25rem;">
        <div style="margin-bottom: 2rem; border-bottom: 1px solid var(--border-color); padding-bottom: 1rem;">
            <h1 class="page-title" style="font-size: 1.6rem;">Modify Event Details</h1>
            <p class="page-subtitle">Update venue, schedules, capacity, or change publication status.</p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin/edit-event" method="POST">
            <input type="hidden" name="id" value="<%= event.getId() %>">

            <div class="form-group">
                <label class="form-label" for="eventTitle">Event Title *</label>
                <input type="text" id="eventTitle" name="title" class="form-control" value="<%= event.getTitle() %>" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="eventCategory">Event Category *</label>
                    <select id="eventCategory" name="category" class="form-select" required>
                        <option value="Technical" <%= "Technical".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>Technical Session</option>
                        <option value="Competition" <%= "Competition".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>Competition</option>
                        <option value="Hackathon" <%= "Hackathon".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>Hackathon</option>
                        <option value="Workshop" <%= "Workshop".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>Hands-on Workshop</option>
                        <option value="Seminar" <%= "Seminar".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>Seminar & Guest Lecture</option>
                        <option value="Cultural" <%= "Cultural".equalsIgnoreCase(event.getCategory()) ? "selected" : "" %>>Cultural & Extracurricular</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="eventDept">Organizing Department *</label>
                    <select id="eventDept" name="department" class="form-select" required>
                        <option value="All Departments" <%= "All Departments".equalsIgnoreCase(event.getDepartment()) ? "selected" : "" %>>All Departments (College-Wide)</option>
                        <option value="Computer Engineering" <%= "Computer Engineering".equalsIgnoreCase(event.getDepartment()) ? "selected" : "" %>>Computer Engineering</option>
                        <option value="CSE (AI & ML)" <%= "CSE (AI & ML)".equalsIgnoreCase(event.getDepartment()) ? "selected" : "" %>>CSE (AI & ML)</option>
                        <option value="Information Technology" <%= "Information Technology".equalsIgnoreCase(event.getDepartment()) ? "selected" : "" %>>Information Technology</option>
                        <option value="Mechanical Engineering" <%= "Mechanical Engineering".equalsIgnoreCase(event.getDepartment()) ? "selected" : "" %>>Mechanical Engineering</option>
                        <option value="Electronics & Telecom" <%= "Electronics & Telecom".equalsIgnoreCase(event.getDepartment()) ? "selected" : "" %>>Electronics & Telecom</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="shortDescription">Short Summary *</label>
                <input type="text" id="shortDescription" name="shortDescription" class="form-control" value="<%= event.getShortDescription() %>" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="fullDescription">Full Description & Agenda *</label>
                <textarea id="fullDescription" name="description" class="form-control" rows="5" required><%= event.getDescription() %></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="eventDate">Event Date *</label>
                    <input type="date" id="eventDate" name="eventDate" class="form-control" value="<%= event.getEventDate() != null ? event.getEventDate().toString() : "" %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="startTime">Start Time *</label>
                    <input type="text" id="startTime" name="startTime" class="form-control" value="<%= event.getStartTime() %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="endTime">End Time *</label>
                    <input type="text" id="endTime" name="endTime" class="form-control" value="<%= event.getEndTime() %>" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="eventVenue">Campus Venue *</label>
                <input type="text" id="eventVenue" name="venue" class="form-control" value="<%= event.getVenue() %>" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="organizerName">Organizer Body / Club Name *</label>
                    <input type="text" id="organizerName" name="organizerName" class="form-control" value="<%= event.getOrganizerName() %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="organizerContact">Organizer Contact *</label>
                    <input type="text" id="organizerContact" name="organizerContact" class="form-control" value="<%= event.getOrganizerContact() %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="regDeadline">Registration Deadline *</label>
                    <input type="date" id="regDeadline" name="registrationDeadline" class="form-control" value="<%= event.getRegistrationDeadline() != null ? event.getRegistrationDeadline().toString() : "" %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="maxSeats">Maximum Capacity *</label>
                    <input type="number" id="maxSeats" name="maxParticipants" class="form-control" value="<%= event.getMaxParticipants() %>" min="1" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="eligibleYear">Eligible Years</label>
                    <input type="text" id="eligibleYear" name="eligibleYear" class="form-control" value="<%= event.getEligibleYear() %>">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="eligibility">Eligibility / Prerequisites</label>
                <input type="text" id="eligibility" name="eligibility" class="form-control" value="<%= event.getEligibility() != null ? event.getEligibility() : "" %>">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="eventImage">Banner Poster</label>
                    <select id="eventImage" name="image" class="form-select">
                        <option value="gdg_hacktoberfest.jpg" <%= "gdg_hacktoberfest.jpg".equals(event.getImage()) ? "selected" : "" %>>GDG x Hacktoberfest Orientation Poster</option>
                        <option value="iic_aimsa_poster.jpg" <%= "iic_aimsa_poster.jpg".equals(event.getImage()) ? "selected" : "" %>>IIC x AIMSA Emerging Tech Poster</option>
                        <option value="sih_hackathon.png" <%= "sih_hackathon.png".equals(event.getImage()) ? "selected" : "" %>>Smart India Hackathon Poster</option>
                        <option value="web_bootcamp.png" <%= "web_bootcamp.png".equals(event.getImage()) ? "selected" : "" %>>Web Development Bootcamp Poster</option>
                        <option value="resume_seminar.png" <%= "resume_seminar.png".equals(event.getImage()) ? "selected" : "" %>>Training & Placement Seminar Poster</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="eventStatus">Status</label>
                    <select id="eventStatus" name="status" class="form-select">
                        <option value="Published" <%= "Published".equalsIgnoreCase(event.getStatus()) ? "selected" : "" %>>Published</option>
                        <option value="Draft" <%= "Draft".equalsIgnoreCase(event.getStatus()) ? "selected" : "" %>>Draft</option>
                        <option value="Completed" <%= "Completed".equalsIgnoreCase(event.getStatus()) ? "selected" : "" %>>Completed</option>
                        <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(event.getStatus()) ? "selected" : "" %>>Cancelled</option>
                    </select>
                </div>
            </div>

            <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                <button type="submit" class="btn btn-primary btn-lg" style="flex:1;">
                    Save Changes
                </button>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-secondary btn-lg">
                    Cancel
                </a>
            </div>

        </form>
    </div>

</div>

<jsp:include page="../includes/footer.jsp" />
