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
    Event featuredLead = (upcomingEvents != null && !upcomingEvents.isEmpty()) ? upcomingEvents.get(0) : null;
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
                    <span class="live-pill-text">Spring 2026 Academic Season &bull; <strong>12+ Events Live</strong></span>
                </div>

                <!-- High-Impact Bold Typography -->
                <h1 class="hero-heading">
                    Connecting Students with <br>
                    <span class="hero-gradient-text">Every Campus Opportunity.</span>
                </h1>

                <!-- Clear, Realistic Value Proposition -->
                <p class="hero-lead">
                    The official central opportunity board for <strong>Lokmanya Tilak College of Engineering</strong>. 
                    Discover hackathons, technical bootcamps, and cultural fests from AIMSA, CESA, GDG, E-Cell &amp; more&mdash;without digging through endless noisy WhatsApp groups.
                </p>

                <!-- Instant In-Hero Search Form (Maximum Utility for Students) -->
                <form action="<%= cp %>/dashboard" method="GET" class="hero-search-box">
                    <div class="hero-search-inner">
                        <span class="hero-search-icon">&#128269;</span>
                        <input type="text" name="search" class="hero-search-input" 
                               placeholder="Search hackathons, bootcamps, CESA, GDG, DSA..." 
                               autocomplete="off">
                        <button type="submit" class="hero-search-submit">Search Events</button>
                    </div>
                </form>

                <!-- Action CTAs -->
                <div class="hero-action-buttons">
                    <a href="<%= cp %>/dashboard" class="btn-hero-primary">
                        Explore All Events <span>&rarr;</span>
                    </a>
                    <a href="<%= cp %>/clubs.jsp" class="btn-hero-secondary">
                        <span>&#127891;</span> Campus Clubs Guide (10)
                    </a>
                </div>

                <!-- Trust & Social Proof Metrics Strip -->
                <div class="hero-metrics-strip">
                    <div class="metric-block">
                        <div class="metric-number">10+</div>
                        <div class="metric-label">Active Campus Clubs</div>
                    </div>
                    <div class="metric-divider"></div>
                    <div class="metric-block">
                        <div class="metric-number">100%</div>
                        <div class="metric-label">Free For Students</div>
                    </div>
                    <div class="metric-divider"></div>
                    <div class="metric-block">
                        <div class="metric-number">1-Click</div>
                        <div class="metric-label">Instant Pass Roster</div>
                    </div>
                    <div class="metric-divider"></div>
                    <div class="metric-block">
                        <div class="metric-number">Official</div>
                        <div class="metric-label">Autonomous Board</div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Interactive Featured Pass / Opportunity Showcase -->
            <div class="hero-right-visual">
                <% if (featuredLead != null) { %>
                    <div class="hero-ticket-card">
                        <div class="ticket-top-tag">
                            <span class="ticket-live-dot"></span>
                            <span>FEATURED CAMPUS EVENT &bull; REGISTRATION OPEN</span>
                        </div>

                        <div class="ticket-banner-wrap">
                            <img src="<%= cp %>/images/<%= featuredLead.getImage() %>" alt="<%= featuredLead.getTitle() %>" 
                                 class="ticket-banner-img" onerror="this.src='<%= cp %>/images/gdg_hacktoberfest.jpg'">
                            <span class="ticket-badge-cat"><%= featuredLead.getCategory() %></span>
                        </div>

                        <div class="ticket-body">
                            <div class="ticket-club-row">
                                <img src="<%= cp %>/images/clubs/<%= featuredLead.getClubLogo() %>" alt="<%= featuredLead.getOrganizerName() %>" 
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
                        <a href="<%= cp %>/dashboard?search=AIMSA" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/aimsa.png" alt="AIMSA">
                            <span>AIMSA</span>
                        </a>
                        <a href="<%= cp %>/dashboard?search=CESA" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/cesa.png" alt="CESA">
                            <span>CESA</span>
                        </a>
                        <a href="<%= cp %>/dashboard?search=GDG" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/gdg.svg" alt="GDG">
                            <span>GDG</span>
                        </a>
                        <a href="<%= cp %>/dashboard?search=GFG" class="hero-quick-chip">
                            <img src="<%= cp %>/images/clubs/gfg.svg" alt="GFG">
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
                <span class="sub-header-pill">CAMPUS BODIES</span>
                <h2 class="sub-header-title">Official LTCE Student Chapters &amp; Clubs</h2>
            </div>
            <a href="<%= cp %>/clubs.jsp" class="view-all-link">
                Compare All Clubs &amp; "Kisme Jaana Chahiye" Guide &rarr;
            </a>
        </div>

        <!-- Touch-Friendly Club Cards Grid / Reel -->
        <div class="clubs-reel">
            <!-- 1. AIMSA -->
            <a href="<%= cp %>/dashboard?search=AIMSA" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/aimsa.png" alt="AIMSA" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">AIMSA</span>
                    <span class="club-reel-tag dept">CSE (AI &amp; ML)</span>
                    <span class="club-reel-desc">AI Hackathons &amp; Models</span>
                </div>
            </a>

            <!-- 2. CESA -->
            <a href="<%= cp %>/dashboard?search=CESA" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/cesa.png" alt="CESA" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">CESA</span>
                    <span class="club-reel-tag dept">Computer Engg</span>
                    <span class="club-reel-desc">CodeSprint &amp; Dev</span>
                </div>
            </a>

            <!-- 3. GDG -->
            <a href="<%= cp %>/dashboard?search=GDG" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/gdg.svg" alt="GDG" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">GDG on Campus</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">Google Tech &amp; GSoC</span>
                </div>
            </a>

            <!-- 4. GFG -->
            <a href="<%= cp %>/dashboard?search=GFG" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/gfg.svg" alt="GFG" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">GFG Chapter</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">DSA &amp; Placement Prep</span>
                </div>
            </a>

            <!-- 5. E-CELL -->
            <a href="<%= cp %>/dashboard?search=E-CELL" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/ecell.png" alt="E-CELL" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">E-CELL LTCE</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">IIT Bombay E-Summit</span>
                </div>
            </a>

            <!-- 6. Technical Vidya -->
            <a href="<%= cp %>/dashboard?search=Technical+Vidya" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/technical_vidya.png" alt="Technical Vidya" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">Technical Vidya</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">Startup Incubator &amp; Talks</span>
                </div>
            </a>

            <!-- 7. The English Club -->
            <a href="<%= cp %>/dashboard?search=English" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/english_club.png" alt="The English Club" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">The English Club</span>
                    <span class="club-reel-tag open">Open For All</span>
                    <span class="club-reel-desc">Debates &amp; Public Speaking</span>
                </div>
            </a>

            <!-- 8. DSSA -->
            <a href="<%= cp %>/dashboard?search=Data+Science" class="club-reel-card">
                <img src="<%= cp %>/images/clubs/dssa.svg" alt="DSSA" class="club-reel-img">
                <div class="club-reel-info">
                    <span class="club-reel-name">DSSA</span>
                    <span class="club-reel-tag dept">Data Science Dept</span>
                    <span class="club-reel-desc">Analytics &amp; Big Data</span>
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
                <span class="sub-header-pill">HAPPENING SOON</span>
                <h2 class="sub-header-title">Upcoming Campus Opportunities</h2>
            </div>
            <a href="<%= cp %>/dashboard" class="btn btn-clean-ghost btn-sm">
                View All Events Directory &rarr;
            </a>
        </div>

        <div class="events-cards-grid">
            <% if (upcomingEvents != null && !upcomingEvents.isEmpty()) { %>
                <% int count = 0;
                   for (Event ev : upcomingEvents) { 
                       if (count++ >= 4) break; // Display top 4 on landing
                %>
                    <div class="event-modern-card">
                        <!-- Card Banner / Image -->
                        <div class="card-media-wrap">
                            <img src="<%= cp %>/images/<%= ev.getImage() %>" alt="<%= ev.getTitle() %>" 
                                 class="card-event-img" onerror="this.src='<%= cp %>/images/gdg_hacktoberfest.jpg'">
                            <span class="card-category-badge <%= ev.getCategory().toLowerCase() %>">
                                <%= ev.getCategory() %>
                            </span>
                            <div class="card-date-stamp">
                                <span class="date-month"><%= ev.getEventDate() != null ? ev.getEventDate().toString().substring(5, 7) : "UP" %></span>
                                <span class="date-day"><%= ev.getEventDate() != null ? ev.getEventDate().toString().substring(8) : "--" %></span>
                            </div>
                        </div>

                        <!-- Card Body -->
                        <div class="card-details-wrap">
                            <!-- Organizer Pill with Club Logo -->
                            <div class="card-club-author">
                                <img src="<%= cp %>/images/clubs/<%= ev.getClubLogo() %>" alt="<%= ev.getOrganizerName() %>" 
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
                                <a href="<%= cp %>/event-details?id=<%= ev.getId() %>" class="btn-card-register">
                                    View &amp; Register &rarr;
                                </a>
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

<!-- ==============================================
     4. The WhatsApp Problem vs CampusConnect Solution
     ============================================== -->
<section class="reality-comparison-section">
    <div class="section-container">
        <div class="text-center" style="max-width: 680px; margin: 0 auto 2.5rem;">
            <span class="sub-header-pill">WHY WE BUILT THIS</span>
            <h2 class="sub-header-title">The College Event Problem We Solved</h2>
            <p style="color: var(--text-muted); font-size: 1rem; margin-top: 0.5rem;">
                WhatsApp is built for personal messaging&mdash;not managing 4,000 engineering students across 6 departments.
            </p>
        </div>

        <div class="comparison-dual-cards">
            <!-- Left: The Chaotic Reality -->
            <div class="comparison-card reality-card">
                <div class="comparison-head">
                    <span class="status-indicator bad">&#10006;</span>
                    <div>
                        <h3 class="comparison-title">The WhatsApp Chaos</h3>
                        <span class="comparison-sub">How college announcements were managed</span>
                    </div>
                </div>
                <ul class="comparison-points">
                    <li><span>&#10060;</span> 15+ WhatsApp groups (class, dept, club, batch, electives)</li>
                    <li><span>&#10060;</span> Crucial event posters get buried inside 200 daily chatter messages</li>
                    <li><span>&#10060;</span> Organizers waste hours repeatedly forwarding identical texts</li>
                    <li><span>&#10060;</span> Duplicate Google Form registrations, expired links, and zero attendance tracking</li>
                    <li><span>&#10060;</span> Cross-department students miss out entirely because they aren't in the group</li>
                </ul>
            </div>

            <!-- Right: CampusConnect Solution -->
            <div class="comparison-card solution-card">
                <div class="comparison-head">
                    <span class="status-indicator good">&#10004;</span>
                    <div>
                        <h3 class="comparison-title">The CampusConnect Way</h3>
                        <span class="comparison-sub">A verified, centralized institution portal</span>
                    </div>
                </div>
                <ul class="comparison-points">
                    <li><span>&#9989;</span> <strong>Post Once, Reach Everyone:</strong> Clubs publish once and reach the whole college</li>
                    <li><span>&#9989;</span> <strong>1-Click Student Registration:</strong> Zero duplicate entries, instant digital passes</li>
                    <li><span>&#9989;</span> <strong>Filter by Branch &amp; Year:</strong> Find relevant hackathons without chat clutter</li>
                    <li><span>&#9989;</span> <strong>Single Source of Truth:</strong> Always see confirmed venue, time, rules &amp; deadlines</li>
                    <li><span>&#9989;</span> <strong>Seamless Sharing:</strong> Generate clean WhatsApp links that lead right to the event pass</li>
                </ul>
            </div>
        </div>
    </div>
</section>

<!-- ==============================================
     5. How It Works Workflow (Simple 3 Steps)
     ============================================== -->
<section class="how-it-works-section" id="how-it-works">
    <div class="section-container">
        <div class="text-center" style="max-width: 600px; margin: 0 auto 2.5rem;">
            <span class="sub-header-pill">SIMPLE WORKFLOW</span>
            <h2 class="sub-header-title">How CampusConnect Works</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.5rem;">Designed for minimal friction for both organizers and students.</p>
        </div>

        <div class="workflow-three-grid">
            <div class="workflow-card">
                <div class="workflow-num">01</div>
                <h3>Organizer Posts Once</h3>
                <p>Clubs or faculty fill a clean form with dates, venue, eligibility rules, and registration deadlines. No spamming chat groups.</p>
            </div>
            <div class="workflow-card">
                <div class="workflow-num">02</div>
                <h3>Students Discover Centrally</h3>
                <p>Browse events filtered by department (AI/ML, Computer, Data Science) or open-for-all clubs (GDG, GFG, E-Cell).</p>
            </div>
            <div class="workflow-card">
                <div class="workflow-num">03</div>
                <h3>Instant Registration &amp; Pass</h3>
                <p>One click to register. Students get confirmed access under "My Registrations", and organizers download clean participant rosters.</p>
            </div>
        </div>
    </div>
</section>

<!-- ==============================================
     6. Institutional Call to Action
     ============================================== -->
<section class="banner-cta-section">
    <div class="banner-cta-inner">
        <h2>Ready to Experience Seamless Campus Life?</h2>
        <p>Join fellow students and organizers at Lokmanya Tilak College of Engineering.</p>
        <div class="banner-cta-actions">
            <a href="<%= cp %>/dashboard" class="btn-hero-primary">Explore All Events</a>
            <a href="<%= cp %>/register" class="btn-hero-secondary">Create Student Account</a>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />
