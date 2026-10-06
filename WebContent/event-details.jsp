<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%
    Event event = (Event) request.getAttribute("event");
    User authUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
    request.setAttribute("pageTitle", event != null ? event.getTitle() : "Event Details");

    String status = request.getParameter("status");
%>
<jsp:include page="includes/header.jsp" />

<div class="container">

    <!-- Breadcrumb & Back Link -->
    <div style="margin-bottom: 1.5rem; display: flex; align-items: center; justify-content: space-between;">
        <a href="<%= request.getContextPath() %>/dashboard" style="display:inline-flex; align-items:center; gap:6px; font-weight:600; font-size:0.9rem;">
            &larr; Back to Events Discovery
        </a>
        <div style="font-size:0.85rem; color:var(--text-muted);">
            CampusConnect &bull; <%= event.getDepartment() %>
        </div>
    </div>

    <!-- Notification Feedback Alerts -->
    <% if ("registered_success".equals(status)) { %>
        <div class="alert alert-success">
            <span>&#10003;</span>
            <div>
                <strong>Registration Confirmed!</strong> You have successfully registered for <%= event.getTitle() %>. You can view your confirmation under <a href="<%= request.getContextPath() %>/my-registrations" style="text-decoration:underline; font-weight:700;">My Registrations</a>.
            </div>
        </div>
    <% } else if ("already_registered".equals(status)) { %>
        <div class="alert alert-info">
            <span>&#8505;</span>
            <div>You are already registered for this event. Your seat is confirmed!</div>
        </div>
    <% } else if ("event_full".equals(status)) { %>
        <div class="alert alert-warning">
            <span>&#9888;</span>
            <div>Registration is currently full or closed for this opportunity.</div>
        </div>
    <% } else if ("cancelled".equals(status)) { %>
        <div class="alert alert-info">
            <span>&#8505;</span>
            <div>Your registration has been cancelled.</div>
        </div>
    <% } %>

    <!-- Main Two-Column Layout -->
    <div class="details-layout">

        <!-- Left Column: Content, Banner, Agenda -->
        <div class="details-main">
            <!-- Event Banner -->
            <img class="details-banner" src="<%= request.getContextPath() %>/images/<%= event.getImage() %>" alt="<%= event.getTitle() %>" onerror="this.src='<%= request.getContextPath() %>/images/gdg_hacktoberfest.jpg'">

            <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="cat-pill active"><%= event.getCategory() %></span>
                <span class="cat-pill" style="cursor:default;"><%= event.getDepartment() %></span>
                <span class="cat-pill" style="cursor:default;">Eligible: <%= event.getEligibleYear() %></span>
            </div>

            <h1 class="details-title"><%= event.getTitle() %></h1>

            <!-- Quick Info Strip -->
            <div class="details-quick-strip">
                <div class="strip-item">
                    <div class="strip-label">&#128197; Date</div>
                    <div class="strip-val"><%= event.getFormattedDate() %></div>
                </div>
                <div class="strip-item">
                    <div class="strip-label">&#9200; Time</div>
                    <div class="strip-val"><%= event.getStartTime() %> - <%= event.getEndTime() %></div>
                </div>
                <div class="strip-item">
                    <div class="strip-label">&#128205; Venue</div>
                    <div class="strip-val"><%= event.getVenue() %></div>
                </div>
                <div class="strip-item">
                    <div class="strip-label">&#128101; Seats Remaining</div>
                    <div class="strip-val" style="color: <%= event.isRegistrationOpen() ? "var(--success)" : "var(--danger)" %>">
                        <%= event.getRemainingSeats() %> / <%= event.getMaxParticipants() %>
                    </div>
                </div>
            </div>

            <!-- About Event Section -->
            <div class="details-section">
                <h3>About This Opportunity</h3>
                <p><%= event.getDescription() %></p>
            </div>

            <!-- Eligibility & Rules -->
            <div class="details-section">
                <h3>Eligibility & Guidelines</h3>
                <p>
                    <strong>Who can participate:</strong> <%= event.getEligibility() != null ? event.getEligibility() : "Open to all students" %><br>
                    <strong>Eligible Branches:</strong> <%= event.getDepartment() %><br>
                    <strong>Eligible Academic Years:</strong> <%= event.getEligibleYear() %><br>
                    <strong>Last Date to Register:</strong> <%= event.getFormattedDeadline() %>
                </p>
            </div>

            <!-- Share with Classmates -->
            <div style="background:var(--bg-alt); border:1px solid var(--border-color); border-radius:var(--radius-sm); padding:1.25rem; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem;">
                <div>
                    <h4 style="font-size:0.95rem; font-weight:700;">Share with Classmates</h4>
                    <p style="font-size:0.8125rem; color:var(--text-muted); margin-top:2px;">
                        Forward verified event details directly into your branch or batch WhatsApp groups.
                    </p>
                </div>
                <div style="display:flex; gap:8px;">
                    <button type="button" id="btnShareWhatsApp" class="btn btn-sm" style="background:#25D366; color:#fff;"
                            data-title="<%= event.getTitle() %>" 
                            data-date="<%= event.getFormattedDate() %>" 
                            data-venue="<%= event.getVenue() %>">
                        Share on WhatsApp
                    </button>
                    <button type="button" id="btnCopyLink" class="btn btn-secondary btn-sm">Copy Link</button>
                </div>
            </div>
        </div>

        <!-- Right Column: Registration Card & Organizer Details -->
        <div class="registration-sidebar-card">
            <h3 style="font-size:1.2rem; font-weight:700; margin-bottom:1rem;">Event Registration</h3>

            <div style="margin-bottom:1.25rem;">
                <div style="font-size:0.8125rem; color:var(--text-muted);">Registration Status</div>
                <div style="margin-top:4px;">
                    <% if (event.isUserRegistered()) { %>
                        <span class="seat-status-pill registered" style="font-size:0.9rem; padding:6px 12px; display:inline-block;">
                            &#10003; You Are Registered
                        </span>
                    <% } else if (event.isRegistrationOpen()) { %>
                        <span class="seat-status-pill open" style="font-size:0.9rem; padding:6px 12px; display:inline-block;">
                            &#10004; Open for Registration
                        </span>
                    <% } else { %>
                        <span class="seat-status-pill full" style="font-size:0.9rem; padding:6px 12px; display:inline-block;">
                            Registration Closed
                        </span>
                    <% } %>
                </div>
            </div>

            <div style="font-size:0.85rem; color:var(--text-muted); margin-bottom:1.5rem; line-height:1.4;">
                <div><strong>Deadline:</strong> <%= event.getFormattedDeadline() %></div>
                <div><strong>Available Slots:</strong> <%= event.getRemainingSeats() %> remaining</div>
                <div><strong>Registration Fee:</strong> <span style="color:var(--success); font-weight:700;">FREE (Sponsored)</span></div>
            </div>

            <!-- Action Buttons -->
            <% if (authUser == null) { %>
                <a href="<%= request.getContextPath() %>/login?redirect=<%= request.getContextPath() %>/event-details?id=<%= event.getId() %>" class="btn btn-primary btn-full">
                    Login to Register
                </a>
                <div style="font-size:0.775rem; color:var(--text-muted); text-align:center; margin-top:8px;">
                    Student account required to secure a seat.
                </div>
            <% } else if (event.isUserRegistered()) { %>
                <div style="background:var(--success-bg); border:1px solid var(--success-border); border-radius:var(--radius-sm); padding:1rem; text-align:center; margin-bottom:1rem;">
                    <div style="color:var(--success); font-weight:700; font-size:0.95rem;">Seat Confirmed!</div>
                    <div style="font-size:0.8rem; color:var(--text-muted); margin-top:2px;">Your pass is ready in My Registrations.</div>
                </div>

                <form action="<%= request.getContextPath() %>/cancel-registration" method="POST" onsubmit="return confirm('Are you sure you want to cancel your registration?');">
                    <input type="hidden" name="eventId" value="<%= event.getId() %>">
                    <button type="submit" class="btn btn-outline btn-full btn-sm" style="color:var(--danger); border-color:var(--danger-border);">
                        Cancel Registration
                    </button>
                </form>
            <% } else if (event.isRegistrationOpen()) { %>
                <form action="<%= request.getContextPath() %>/register-event" method="POST">
                    <input type="hidden" name="eventId" value="<%= event.getId() %>">
                    <button type="submit" class="btn btn-primary btn-full btn-lg">
                        Register Now
                    </button>
                </form>
            <% } else { %>
                <button type="button" class="btn btn-secondary btn-full btn-lg" disabled style="opacity:0.6; cursor:not-allowed;">
                    Registration Closed
                </button>
            <% } %>

            <!-- Save / Bookmark Button -->
            <% if (authUser != null) { %>
                <div style="margin-top: 0.75rem;">
                    <button type="button" class="btn btn-secondary btn-full btn-sm btn-save-toggle <%= event.isUserSaved() ? "saved" : "" %>" data-event-id="<%= event.getId() %>">
                        <span class="save-icon"><%= event.isUserSaved() ? "&#9829;" : "&#9825;" %></span>
                        <span class="save-label"><%= event.isUserSaved() ? "Saved in Bookmarks" : "Save Event for Later" %></span>
                    </button>
                </div>
            <% } %>

            <!-- Organizer Contact Box -->
            <div class="sidebar-organizer-box">
                <div class="organizer-avatar-title" style="display:flex; align-items:center; gap:12px;">
                    <img src="<%= request.getContextPath() %>/images/clubs/<%= event.getClubLogo() %>" alt="<%= event.getOrganizerName() %> logo" style="width:42px; height:42px; border-radius:8px; object-fit:contain; background:#ffffff; box-shadow:0 1px 3px rgba(0,0,0,0.1); padding:2px;" onerror="this.src='<%= request.getContextPath() %>/images/clubs/ltce.svg'">
                    <div>
                        <div style="font-size:0.75rem; text-transform:uppercase; color:var(--text-muted); font-weight:600;">Organized By</div>
                        <div style="font-size:0.95rem; font-weight:700; color:var(--secondary);"><%= event.getOrganizerName() %></div>
                    </div>
                </div>
                <div style="font-size:0.825rem; color:var(--text-muted); margin-top:8px; line-height:1.4;">
                    <div><strong>Department:</strong> <%= event.getDepartment() %></div>
                    <div><strong>Contact:</strong> <%= event.getOrganizerContact() %></div>
                </div>
            </div>

            <!-- College Trust Badge -->
            <div style="margin-top: 1.5rem; padding-top: 1rem; border-top: 1px dashed var(--border-color); font-size: 0.75rem; color: var(--text-muted); display:flex; align-items:center; gap:6px;">
                <span>&#128737;</span>
                <span>Verified academic event at Lokmanya Tilak College of Engineering</span>
            </div>
        </div>

    </div>

</div>

<jsp:include page="includes/footer.jsp" />
