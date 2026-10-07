<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.EventDAO" %>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Official Campus Events Hub");
    EventDAO eventDAO = new EventDAO();
    User auth = (session != null) ? (User) session.getAttribute("currentUser") : null;
    Integer authId = (auth != null) ? auth.getId() : null;
    
    // Fetch upcoming published events for the live preview
    List<Event> upcomingEvents = eventDAO.getDiscoveredEvents("", "All", "All", "All", "upcoming", authId);
    Event featuredLead = null;
    if (upcomingEvents != null && !upcomingEvents.isEmpty()) {
        for (Event e : upcomingEvents) {
            if (!e.isPastEvent()) {
                featuredLead = e;
                break;
            }
        }
        if (featuredLead == null) {
            featuredLead = upcomingEvents.get(0);
        }
    }
    String cp = request.getContextPath();
%>
<jsp:include page="includes/header.jsp" />

<!-- ==============================================
     1. Modern Collegiate Split Hero Section
     ============================================== -->
<section class="collegiate-hero">
    <div class="hero-container">
        <div class="hero-split-grid">
            
            <!-- Left Column: Primary Pitch, Search & CTAs -->
            <div class="hero-left-content">
                <!-- Live Academic Announcement Pill -->
                <div class="hero-live-pill">
                    <span class="pulse-indicator"></span>
                    <span class="live-pill-text">Official Campus Board &bull; <strong>LTCE Navi Mumbai</strong></span>
                </div>

                <!-- High-Impact Typography -->
                <h1 class="hero-heading">
                    Campus Events &amp; Opportunities<br>
                    <span class="hero-gradient-text">LTCE Student Hub</span>
                </h1>

                <!-- Clear Value Proposition -->
                <p class="hero-lead">
                    Discover hackathons, workshops, and student club events at Lokmanya Tilak College of Engineering.
                </p>

                <!-- Search Form -->
                <form action="<%= cp %>/dashboard" method="GET" class="hero-search-box">
                    <div class="hero-search-inner">
                        <span class="hero-search-icon">&#128269;</span>
                        <input type="text" name="search" class="hero-search-input" 
                               placeholder="Search hackathons, bootcamps, CESA, GDG..." 
                               autocomplete="off">
                        <button type="submit" class="hero-search-submit">Search</button>
                    </div>
                </form>

                <!-- Action CTAs -->
                <div class="hero-action-buttons">
                    <a href="<%= cp %>/dashboard" class="btn-hero-primary">
                        Browse Events <span>&rarr;</span>
                    </a>
                    <a href="<%= cp %>/clubs.jsp" class="btn-hero-secondary">
                        <span>&#127891;</span> Clubs Guide
                    </a>
                </div>
            </div>

            <!-- Right Column: Interactive Featured Pass / Opportunity Showcase -->
            <div class="hero-right-visual">
                <% if (featuredLead != null) { %>
                    <div class="hero-ticket-card">
                        <div class="ticket-top-tag">
                            <span class="ticket-live-dot <%= featuredLead.isPastEvent() ? "concluded" : "" %>"></span>
                            <span><%= featuredLead.isPastEvent() ? "PAST EVENT" : "FEATURED CAMPUS EVENT &bull; REGISTRATION OPEN" %></span>
                        </div>

                        <div class="ticket-banner-wrap">
                            <img src="<%= cp %>/images/<%= featuredLead.getImage() %>" alt="<%= featuredLead.getTitle() %>" 
                                 class="ticket-banner-img" onerror="this.src='<%= cp %>/images/default_event.jpg'">
                            <span class="ticket-badge-cat"><%= featuredLead.getCategory() %></span>
                        </div>

                        <div class="ticket-body">
                            <div class="ticket-club-row">
                                <img src="<%= cp %>/images/clubs/<%= featuredLead.getClubLogo() %>?v=3.0" alt="<%= featuredLead.getOrganizerName() %>" 
                                     class="ticket-club-mini-logo" onerror="this.src='<%= cp %>/images/campusconnect-mark.svg'">
                                <span class="ticket-club-name"><%= featuredLead.getOrganizerName() %></span>
                            </div>

                            <h3 class="ticket-title"><%= featuredLead.getTitle() %></h3>

                            <div class="ticket-meta-grid">
                                <div class="ticket-meta-cell">
                                    <span class="ticket-meta-label">Date &amp; Time</span>
                                    <span class="ticket-meta-val">&#128197; <%= featuredLead.getFormattedDate() %></span>
                                </div>
                                <div class="ticket-meta-cell">
                                    <span class="ticket-meta-label">Campus Venue</span>
                                    <span class="ticket-meta-val">&#128205; <%= featuredLead.getVenue() %></span>
                                </div>
                            </div>

                            <div class="ticket-seats-bar">
                                <div class="seats-label-row">
                                    <span>Seat Availability</span>
                                    <strong><%= featuredLead.getRemainingSeats() %> / <%= featuredLead.getMaxParticipants() %> Left</strong>
                                </div>
                                <div class="seats-progress-track">
                                    <div class="seats-progress-fill" style="width: <%= Math.min(100, (featuredLead.getRemainingSeats() * 100) / Math.max(1, featuredLead.getMaxParticipants())) %>%;"></div>
                                </div>
                            </div>

                            <a href="<%= cp %>/event-details?id=<%= featuredLead.getId() %>" class="btn-ticket-action">
                                View Event Details &amp; Register &rarr;
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="hero-ticket-card">
                        <div class="ticket-top-tag">
                            <span>CAMPUS OPPORTUNITY HUB</span>
                        </div>
                        <div class="ticket-body" style="padding:2.5rem 2rem; text-align:center;">
                            <div style="font-size:3rem; margin-bottom:1rem;">&#127891;</div>
                            <h3 class="ticket-title">Explore 10+ Student Chapters</h3>
                            <p style="color:#cbd5e1; font-size:0.9rem; margin-bottom:1.5rem;">Discover CESA, AIMSA, GDG, E-Cell &amp; GFG opportunities directly.</p>
                            <a href="<%= cp %>/dashboard" class="btn-ticket-action">Browse Events Directory &rarr;</a>
                        </div>
                    </div>
                <% } %>

                <!-- Floating Quick Chapter Chips -->
                <div class="hero-quick-chapters">
                    <span class="quick-chapters-label">Quick Filter by Club:</span>
                    <div class="quick-chips-wrap">
                        <a href="<%= cp %>/dashboard?search=CESA" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/cesa.png" alt="CESA">
                            <span>CESA</span>
                        </a>
                        <a href="<%= cp %>/dashboard?search=AIMSA" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/aimsa.png" alt="AIMSA">
                            <span>AIMSA</span>
                        </a>
                        <a href="<%= cp %>/dashboard?search=Data+Science" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/dssa.png" alt="DSSA">
                            <span>DSSA</span>
                        </a>
                        <a href="<%= cp %>/dashboard?search=GDG" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/gdg.png?v=3.0" alt="GDG">
                            <span>GDG</span>
                        </a>
                        <a href="<%= cp %>/dashboard?search=GFG" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/gfg.png?v=3.0" alt="GFG">
                            <span>GFG</span>
                        </a>
                        <a href="<%= cp %>/dashboard?search=E-CELL" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/ecell.png" alt="E-CELL">
                            <span>E-CELL</span>
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- ==============================================
     2. Campus Clubs & Student Bodies Strip (High Touch)
     ============================================== -->
<section class="clubs-strip-section">
    <div class="section-container">
        <div class="section-title-bar">
            <div>
                <span class="sub-header-pill">STUDENT CLUBS</span>
                <h2 class="sub-header-title">Student Chapters &amp; Bodies</h2>
            </div>
            <a href="<%= cp %>/clubs.jsp" class="view-all-link">
                Explore All Clubs &rarr;
            </a>
        </div>

        <!-- Touch-Friendly Club Cards Grid / Reel (Sequence: CESA, AIMSA, DSSA, GDG, GFG, E-CELL, Technical Vidya, English Club) -->
        <div class="clubs-reel">
            <!-- 1. CESA -->
            <a href="<%= cp %>/dashboard?search=CESA" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/cesa.png" alt="CESA" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">CESA</span>
                    <span class="club-reel-tag dept">Computer Engg</span>
                    <span class="club-reel-desc">CodeSprint &amp; Dev</span>
                </div>
            </a>

            <!-- 2. AIMSA -->
            <a href="<%= cp %>/dashboard?search=AIMSA" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/aimsa.png" alt="AIMSA" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">AIMSA</span>
                    <span class="club-reel-tag dept">CSE (AI &amp; ML)</span>
                    <span class="club-reel-desc">AI Hackathons &amp; Models</span>
                </div>
            </a>

            <!-- 3. DSSA -->
            <a href="<%= cp %>/dashboard?search=Data+Science" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/dssa.png" alt="DSSA" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">DSSA</span>
                    <span class="club-reel-tag dept">Data Science Dept</span>
                    <span class="club-reel-desc">Analytics &amp; Big Data</span>
                </div>
            </a>

            <!-- 4. GDG -->
            <a href="<%= cp %>/dashboard?search=GDG" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/gdg.png?v=3.0" alt="GDG" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">GDG on Campus</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">Google Tech &amp; GSoC</span>
                </div>
            </a>

            <!-- 5. GFG -->
            <a href="<%= cp %>/dashboard?search=GFG" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/gfg.png?v=3.0" alt="GFG" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">GFG Chapter</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">DSA &amp; Placement Prep</span>
                </div>
            </a>

            <!-- 6. E-CELL -->
            <a href="<%= cp %>/dashboard?search=E-CELL" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/ecell.png" alt="E-CELL" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">E-CELL LTCE</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">IIT Bombay E-Summit</span>
                </div>
            </a>

            <!-- 7. Technical Vidya -->
            <a href="<%= cp %>/dashboard?search=Technical+Vidya" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/technical_vidya.png" alt="Technical Vidya" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">Technical Vidya</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">Startup Incubator &amp; Talks</span>
                </div>
            </a>

            <!-- 8. The English Club -->
            <a href="<%= cp %>/dashboard?search=English" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/english_club.png" alt="The English Club" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">The English Club</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">Debates &amp; Public Speaking</span>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- ==============================================
     3. Happening Soon: Live Events Grid
     ============================================== -->
<section class="live-events-section">
    <div class="section-container">
        <div class="section-title-bar">
            <div>
                <span class="sub-header-pill">CAMPUS EVENTS</span>
                <h2 class="sub-header-title">Featured &amp; Upcoming Events</h2>
            </div>
            <a href="<%= cp %>/dashboard" class="btn btn-clean-ghost btn-sm">
                View All Events &rarr;
            </a>
        </div>

        <div class="events-cards-grid">
            <% if (upcomingEvents != null && !upcomingEvents.isEmpty()) { %>
                <% int count = 0;
                   for (Event ev : upcomingEvents) { 
                       if (count++ >= 6) break; // Display top events
                %>
                    <div class="event-modern-card">
                        <!-- Card Banner / Image -->
                        <div class="card-media-wrap">
                            <img src="<%= cp %>/images/<%= ev.getImage() %>" alt="<%= ev.getTitle() %>" 
                                 class="card-event-img" onerror="this.src='<%= cp %>/images/default_event.jpg'">
                            <span class="card-category-badge <%= ev.getCategory().toLowerCase() %>">
                                <%= ev.getCategory() %>
                            </span>
                            <% if (ev.isPastEvent()) { %>
                                <span class="card-concluded-badge">Past Event</span>
                            <% } %>
                            <div class="card-date-stamp <%= ev.isPastEvent() ? "is-concluded" : (ev.isToday() ? "is-today" : "") %>">
                                <span class="date-month"><%= ev.getShortMonth() %></span>
                                <span class="date-day"><%= ev.getDayString() %></span>
                                <% if (ev.isPastEvent()) { %>
                                    <span class="date-tag-status ended">PAST</span>
                                <% } else if (ev.isToday()) { %>
                                    <span class="date-tag-status today">TODAY</span>
                                <% } %>
                            </div>
                        </div>

                        <!-- Card Body -->
                        <div class="card-details-wrap">
                            <!-- Organizer Pill with Club Logo -->
                            <div class="card-club-author">
                                <img src="<%= cp %>/images/clubs/<%= ev.getClubLogo() %>?v=3.0" alt="<%= ev.getOrganizerName() %>" 
                                     class="card-club-mini-logo" onerror="this.src='<%= cp %>/images/campusconnect-mark.svg'">
                                <span class="card-club-name"><%= ev.getOrganizerName() %></span>
                            </div>

                            <h3 class="card-event-title">
                                <a href="<%= cp %>/event-details?id=<%= ev.getId() %>"><%= ev.getTitle() %></a>
                            </h3>

                            <p class="card-event-snippet"><%= ev.getShortDescription() %></p>

                            <!-- Meta Details (Venue & Time) -->
                            <div class="card-meta-list">
                                <span class="card-meta-pill">&#128205; <%= ev.getVenue() %></span>
                                <span class="card-meta-pill">&#128337; <%= ev.getStartTime() %></span>
                            </div>

                            <!-- Footer Actions -->
                            <div class="card-footer-actions">
                                <% if (ev.isPastEvent()) { %>
                                    <a href="<%= cp %>/event-details?id=<%= ev.getId() %>" class="btn-card-register concluded">
                                        Event Ended &bull; Details &rarr;
                                    </a>
                                <% } else { %>
                                    <a href="<%= cp %>/event-details?id=<%= ev.getId() %>" class="btn-card-register">
                                        View &amp; Register &rarr;
                                    </a>
                                <% } %>
                                <% if (auth != null) { %>
                                    <button type="button" class="btn-card-save btn-save-toggle <%= ev.isUserSaved() ? "saved" : "" %>" 
                                            data-event-id="<%= ev.getId() %>" title="Save Event">
                                        <span class="save-icon"><%= ev.isUserSaved() ? "&#9829;" : "&#9825;" %></span>
                                    </button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-state-box">
                    <p>No upcoming events currently scheduled. Check back soon!</p>
                </div>
            <% } %>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />
