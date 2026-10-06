<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.EventDAO" %>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Home");
    EventDAO eventDAO = new EventDAO();
    User auth = (session != null) ? (User) session.getAttribute("currentUser") : null;
    Integer authId = (auth != null) ? auth.getId() : null;
    List<Event> upcomingEvents = eventDAO.getDiscoveredEvents("", "All", "All", "All", "upcoming", authId);
%>
<jsp:include page="includes/header.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-pill">
        <span>&#9733; Official LTCE Opportunity Hub &bull; Autonomous Institute</span>
    </div>
    <h1 class="hero-title">
        One place for <span>every campus event</span>.
    </h1>
    <p class="hero-subtitle">
        Discover, manage, and participate in official college events, hackathons, and technical bootcamps without searching through endless chaotic WhatsApp groups.
    </p>
    <div class="hero-cta">
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-cta-gold btn-lg">Explore Events &rarr;</a>
        <% if (auth != null && auth.isAdmin()) { %>
            <a href="<%= request.getContextPath() %>/admin/create-event" class="btn btn-secondary btn-lg" style="background:rgba(255,255,255,0.15); color:#ffffff; border-color:rgba(255,255,255,0.35);">+ Post an Event</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary btn-lg" style="background:rgba(255,255,255,0.15); color:#ffffff; border-color:rgba(255,255,255,0.35);">Organizer Sign In</a>
        <% } %>
    </div>
</section>

<!-- Participating Student Bodies & Chapters Strip -->
<section id="clubs" style="background:var(--bg-surface); border-bottom:1px solid var(--border-color); padding: 1.75rem 1.5rem;">
    <div class="container" style="padding-top:0; padding-bottom:0; max-width:var(--container-max);">
        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:0.5rem; margin-bottom:1rem;">
            <div style="font-size:0.75rem; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:1px;">
                Official LTCE Student Bodies &amp; Technical Chapters
            </div>
            <a href="<%= request.getContextPath() %>/clubs.jsp" style="font-size:0.825rem; font-weight:700; color:var(--ltce-blue-mid); text-decoration:underline;">
                &#127891; View All Clubs &amp; Student Guidance Guide &rarr;
            </a>
        </div>
        <div style="display:flex; justify-content:center; align-items:center; flex-wrap:wrap; gap:0.75rem;">
            <a href="<%= request.getContextPath() %>/dashboard?search=AIMSA" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/aimsa.png" alt="AIMSA">
                <span>AIMSA (AI &amp; ML)</span>
            </a>
            <a href="<%= request.getContextPath() %>/dashboard?search=CESA" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/cesa.png" alt="CESA">
                <span>CESA (Computer)</span>
            </a>
            <a href="<%= request.getContextPath() %>/dashboard?search=GDG" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/gdg.svg" alt="GDG">
                <span>GDG on Campus</span>
            </a>
            <a href="<%= request.getContextPath() %>/dashboard?search=GFG" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/gfg.svg" alt="GFG">
                <span>GFG Student Chapter</span>
            </a>
            <a href="<%= request.getContextPath() %>/dashboard?search=E-CELL" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/ecell.png" alt="E-CELL">
                <span>E-CELL LTCE (IITB)</span>
            </a>
            <a href="<%= request.getContextPath() %>/dashboard?search=Technical+Vidya" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/technical_vidya.png" alt="Technical Vidya">
                <span>Technical Vidya</span>
            </a>
            <a href="<%= request.getContextPath() %>/dashboard?search=English" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/english_club.png" alt="The English Club">
                <span>The English Club</span>
            </a>
            <a href="<%= request.getContextPath() %>/dashboard?search=Data+Science" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/dssa.svg" alt="DSSA">
                <span>DSSA (Data Science)</span>
            </a>
            <a href="<%= request.getContextPath() %>/dashboard?search=IIC" class="club-badge-pill">
                <img src="<%= request.getContextPath() %>/images/clubs/iic.svg" alt="IIC">
                <span>IIC LTCE</span>
            </a>
        </div>
    </div>
</section>

<!-- Core Workflow: How CampusConnect Works -->
<section class="workflow-section" id="how-it-works">
    <div class="section-head">
        <h2>How CampusConnect Works</h2>
        <p>A streamlined workflow designed to eliminate WhatsApp announcement fatigue for both organizers and students.</p>
    </div>

    <div class="workflow-grid">
        <div class="step-card">
            <div class="step-number">1</div>
            <h3>Organizers Post Once</h3>
            <p>Clubs, faculty, and departments publish event details, rules, deadlines, and seat limits in a single structured form.</p>
        </div>

        <div class="step-card">
            <div class="step-number">2</div>
            <h3>Central Discovery</h3>
            <p>Students browse upcoming events filtered by branch, academic year, and category without missing buried chat announcements.</p>
        </div>

        <div class="step-card">
            <div class="step-number">3</div>
            <h3>Direct Registration</h3>
            <p>Students register with a single click. Duplicate registrations are prevented, and organizers receive verified attendee rosters instantly.</p>
        </div>
    </div>
</section>

<!-- Problem vs Solution: Why CampusConnect? -->
<section class="comparison-section">
    <div class="section-head">
        <h2>Why CampusConnect?</h2>
        <p>Solving the real fragmentation issue on college campuses.</p>
    </div>

    <div class="comparison-grid">
        <div class="comparison-card old-way">
            <h3 style="color:#b91c1c;">
                <span style="font-size:1.4rem;">&times;</span> The WhatsApp Group Problem
            </h3>
            <ul>
                <li><strong>Scattered Across 10+ Groups:</strong> Class groups, branch groups, unofficial club groups, council chats.</li>
                <li><strong>Buried Messages:</strong> Important registration links and rules get lost in casual chat chatter.</li>
                <li><strong>No Searchability:</strong> Inability to filter by eligible academic year or technical category.</li>
                <li><strong>Duplicate Effort for Organizers:</strong> Organizers paste identical messages across 15 different groups repeatedly.</li>
                <li><strong>Registration Chaos:</strong> Disconnected Google Forms with duplicate entries and manual tracking.</li>
            </ul>
        </div>

        <div class="comparison-card new-way">
            <h3 style="color:#059669;">
                <span style="font-size:1.4rem;">&#10003;</span> The CampusConnect Solution
            </h3>
            <ul>
                <li><strong>Single Source of Truth:</strong> One centralized URL containing complete, verified event parameters.</li>
                <li><strong>Structured Information:</strong> Timings, speakers, venues, eligibility, and perks clearly formatted.</li>
                <li><strong>Instant Discovery:</strong> Fast search by branch (CSE, AI/ML, IT), eligibility, or event type.</li>
                <li><strong>WhatsApp Friendly:</strong> Organizers share a single clean CampusConnect event link with preview.</li>
                <li><strong>Built-in Attendance Roster:</strong> Auto-managed registration caps and instant attendee reports for HODs.</li>
            </ul>
        </div>
    </div>
</section>

<!-- Upcoming Highlights Preview -->
<section class="container" style="padding-top: 3.5rem;">
    <div style="display:flex; justify-content:space-between; align-items:flex-end; margin-bottom: 2rem;">
        <div>
            <h2 style="font-size:1.85rem; font-weight:800; color:var(--secondary);">Upcoming Campus Highlights</h2>
            <p style="color:var(--text-muted); font-size:0.95rem; margin-top:4px;">Real upcoming opportunities at Lokmanya Tilak College of Engineering</p>
        </div>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline btn-sm">View All Events &rarr;</a>
    </div>

    <div class="events-grid">
        <% 
            int count = 0;
            for (Event e : upcomingEvents) { 
                if (count++ >= 3) break;
        %>
            <div class="event-card">
                <div class="event-card-media">
                    <img src="<%= request.getContextPath() %>/images/<%= e.getImage() %>" alt="<%= e.getTitle() %>" onerror="this.src='<%= request.getContextPath() %>/images/gdg_hacktoberfest.jpg'">
                    <span class="event-type-badge"><%= e.getCategory() %></span>
                </div>
                <div class="event-card-body">
                    <div class="event-dept-tag"><%= e.getDepartment() %> &bull; <%= e.getEligibleYear() %></div>
                    <h3 class="event-card-title"><%= e.getTitle() %></h3>
                    <p class="event-card-desc"><%= e.getShortDescription() %></p>

                    <div class="event-meta-list">
                        <div class="event-meta-item">
                            <span>&#128197;</span>
                            <span><%= e.getFormattedDate() %> &bull; <%= e.getStartTime() %></span>
                        </div>
                        <div class="event-meta-item">
                            <span>&#128205;</span>
                            <span><%= e.getVenue() %></span>
                        </div>
                        <div class="event-meta-item event-organizer-row">
                            <img src="<%= request.getContextPath() %>/images/clubs/<%= e.getClubLogo() %>" alt="<%= e.getOrganizerName() %>" class="club-logo-mini" onerror="this.src='<%= request.getContextPath() %>/images/clubs/ltce.svg'">
                            <span><%= e.getOrganizerName() %></span>
                        </div>
                    </div>

                    <div class="event-card-footer">
                        <span class="seat-status-pill <%= e.isRegistrationOpen() ? "open" : "full" %>">
                            <%= e.isRegistrationOpen() ? e.getRemainingSeats() + " seats left" : "Registration Closed" %>
                        </span>
                        <a href="<%= request.getContextPath() %>/event-details?id=<%= e.getId() %>" class="btn btn-primary btn-sm">View Details</a>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
</section>

<!-- College Institutional Adoption Callout -->
<section style="background:var(--bg-surface); border-top:1px solid var(--border-color); padding: 4rem 1.5rem; text-align:center; margin-top: 3rem;">
    <div style="max-width: 650px; margin: 0 auto;">
        <h3 style="font-size:1.75rem; font-weight:800; color:var(--secondary); margin-bottom:0.75rem;">Ready to streamline campus events?</h3>
        <p style="color:var(--text-muted); font-size:1rem; margin-bottom:1.75rem;">
            Experience how easy it is for student bodies, faculty coordinators, and HODs to publish once and engage the entire student body seamlessly.
        </p>
        <div style="display:flex; justify-content:center; gap:1rem;">
            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-primary btn-lg">Browse All Events</a>
            <a href="<%= request.getContextPath() %>/register" class="btn btn-secondary btn-lg">Create Student Account</a>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />
