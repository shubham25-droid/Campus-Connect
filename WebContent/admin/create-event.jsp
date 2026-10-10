<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    request.setAttribute("pageTitle", "Create New Campus Event");
    String error = (String) request.getAttribute("errorMessage");
%>
<jsp:include page="../includes/header.jsp" />

<div class="container" style="max-width: 820px;">

    <div style="margin-bottom: 1.5rem; display: flex; align-items: center; justify-content: space-between;">
        <a href="<%= request.getContextPath() %>/admin/dashboard" style="display:inline-flex; align-items:center; gap:6px; font-weight:600; font-size:0.9rem;">
            &larr; Back to Admin Dashboard
        </a>
        <span class="role-tag admin">Organizer Portal</span>
    </div>

    <div class="card" style="padding: 2.25rem;">
        <div style="margin-bottom: 2rem; border-bottom: 1px solid var(--border-color); padding-bottom: 1rem;">
            <h1 class="page-title" style="font-size: 1.6rem;">Publish New Campus Opportunity</h1>
            <p class="page-subtitle">Post once to distribute complete structured event details across the college.</p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form id="createEventForm" action="<%= request.getContextPath() %>/admin/create-event" method="POST">
            
            <!-- Basic Details -->
            <div class="form-group">
                <label class="form-label" for="eventTitle">Event Title *</label>
                <input type="text" id="eventTitle" name="title" class="form-control" placeholder="e.g. Orientation + GDG x Hacktoberfest HF 2026" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="eventCategory">Event Category *</label>
                    <select id="eventCategory" name="category" class="form-select" required>
                        <option value="Technical">Technical Session</option>
                        <option value="Competition">Competition</option>
                        <option value="Hackathon">Hackathon</option>
                        <option value="Workshop">Hands-on Workshop</option>
                        <option value="Seminar">Seminar & Guest Lecture</option>
                        <option value="Cultural">Cultural & Extracurricular</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="eventDept">Organizing Department *</label>
                    <select id="eventDept" name="department" class="form-select" required>
                        <option value="All Departments">All Departments (College-Wide)</option>
                        <option value="Computer Engineering">Computer Engineering</option>
                        <option value="CSE (AI & ML)">CSE (AI & ML)</option>
                        <option value="Information Technology">Information Technology</option>
                        <option value="Mechanical Engineering">Mechanical Engineering</option>
                        <option value="Electronics & Telecom">Electronics & Telecom</option>
                        <option value="Electrical Engineering">Electrical Engineering</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="shortDescription">Short Summary (Shown on Event Cards) *</label>
                <input type="text" id="shortDescription" name="shortDescription" class="form-control" 
                       placeholder="Brief 1-2 sentence overview for rapid discovery" maxlength="280" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="fullDescription">Full Description & Agenda *</label>
                <textarea id="fullDescription" name="description" class="form-control" rows="5" 
                          placeholder="Detailed overview, guest speakers, topic outline, takeaways, perks and prerequisites..." required></textarea>
            </div>

            <!-- Schedule & Location -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="eventDate">Event Date *</label>
                    <input type="date" id="eventDate" name="eventDate" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="startTime">Start Time *</label>
                    <input type="text" id="startTime" name="startTime" class="form-control" placeholder="e.g. 2:00 PM" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="endTime">End Time *</label>
                    <input type="text" id="endTime" name="endTime" class="form-control" placeholder="e.g. 4:30 PM" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="eventVenue">Campus Venue *</label>
                <input type="text" id="eventVenue" name="venue" class="form-control" placeholder="e.g. A510 Auditorium, LTCE Campus or C Building 4th Floor" required>
            </div>

            <!-- Organizer Info -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="organizerName">Organizer Body / Club Name *</label>
                    <input type="text" id="organizerName" name="organizerName" class="form-control" placeholder="e.g. GDG on Campus LTCE or IIC x AIMSA" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="organizerContact">Organizer Contact (Email / Phone) *</label>
                    <input type="text" id="organizerContact" name="organizerContact" class="form-control" placeholder="e.g. gdg@ltce.in | +91 98765 43210" required>
                </div>
            </div>

            <!-- Registration Parameters -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="regDeadline">Registration Deadline *</label>
                    <input type="date" id="regDeadline" name="registrationDeadline" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="maxSeats">Maximum Capacity (Seats) *</label>
                    <input type="number" id="maxSeats" name="maxParticipants" class="form-control" value="150" min="1" max="2000" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="eligibleYear">Eligible Years</label>
                    <select id="eligibleYear" name="eligibleYear" class="form-select">
                        <option value="All Years (FE, SE, TE, BE)">All Years (FE, SE, TE, BE)</option>
                        <option value="SE, TE, BE">SE, TE, BE</option>
                        <option value="TE, BE">TE, BE (3rd & Final Year)</option>
                        <option value="FE, SE">FE, SE (1st & 2nd Year)</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="eligibility">Eligibility / Prerequisites</label>
                <input type="text" id="eligibility" name="eligibility" class="form-control" placeholder="e.g. Open to all students. Laptops required for coding session.">
            </div>

            <!-- Visual & Status -->
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="eventImage">Banner Poster</label>
                    <select id="eventImage" name="image" class="form-select">
                        <option value="gdg_hacktoberfest.jpg">GDG x Hacktoberfest Orientation Poster</option>
                        <option value="iic_aimsa_poster.jpg">IIC x AIMSA Emerging Tech Poster</option>
                        <option value="sih_hackathon.png">Smart India Hackathon Poster</option>
                        <option value="web_bootcamp.png">Web Development Bootcamp Poster</option>
                        <option value="resume_seminar.png">Training & Placement Seminar Poster</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="eventStatus">Publication Status</label>
                    <select id="eventStatus" name="status" class="form-select">
                        <option value="Published">Published (Live to Students)</option>
                        <option value="Draft">Draft (Save Internally)</option>
                    </select>
                </div>
            </div>

            <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                <button type="submit" class="btn btn-primary btn-lg" style="flex:1;">
                    Publish Event to CampusConnect
                </button>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-secondary btn-lg">
                    Cancel
                </a>
            </div>

        </form>
    </div>

</div>

<jsp:include page="../includes/footer.jsp" />
