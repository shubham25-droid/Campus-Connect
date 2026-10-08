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

                <!-- Search Form with Suggestions -->
                <div class="hero-search-wrapper">
                    <form action="<%= cp %>/dashboard" method="GET" class="hero-search-box" id="heroSearchForm">
                        <div class="hero-search-inner">
                            <span class="hero-search-icon">&#128269;</span>
                            <input type="text" id="heroSearchInput" name="search" class="hero-search-input" 
                                   placeholder="Search hackathons, workshops, GDG, CESA..." 
                                   autocomplete="off">
                            <button type="submit" class="hero-search-submit">Search</button>
                        </div>
                    </form>
                    <!-- Instant Search Suggestions Dropdown -->
                    <div class="hero-search-suggestions" id="heroSuggestionsBox"></div>
                </div>

                <!-- Interactive Quick Trending Topics -->
                <div class="hero-quick-topics">
                    <span class="quick-topics-label">Trending:</span>
                    <button type="button" class="topic-chip" onclick="quickHeroFilter('Hackathon')">&#9889; Hackathons</button>
                    <button type="button" class="topic-chip" onclick="quickHeroFilter('Workshop')">&#128218; Workshops</button>
                    <button type="button" class="topic-chip" onclick="quickHeroFilter('Technical')">&#128187; Tech Talks</button>
                    <button type="button" class="topic-chip" onclick="quickHeroFilter('Competition')">&#127942; Competitions</button>
                </div>

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

            <!-- Right Column: Interactive Featured Pass / Opportunity Showcase Carousel -->
            <div class="hero-right-visual">
                <% if (upcomingEvents != null && !upcomingEvents.isEmpty()) { %>
                    <div class="hero-ticket-card" id="heroTicketCard">
                        <!-- Interactive Top Control Bar -->
                        <div class="ticket-top-tag">
                            <div style="display:flex; align-items:center; gap:8px;">
                                <span class="ticket-live-dot" id="ticketLiveDot"></span>
                                <span id="ticketStatusText">FEATURED CAMPUS PASS</span>
                            </div>
                            <div class="ticket-nav-controls">
                                <button type="button" class="ticket-nav-btn prev" onclick="changeHeroSlide(-1)" aria-label="Previous Event">&#8249;</button>
                                <span class="ticket-counter" id="ticketCounter">1 / <%= upcomingEvents.size() %></span>
                                <button type="button" class="ticket-nav-btn next" onclick="changeHeroSlide(1)" aria-label="Next Event">&#8250;</button>
                            </div>
                        </div>

                        <!-- Ticket Slides Viewport -->
                        <div class="ticket-slides-viewport">
                            <% 
                               int slideIdx = 0;
                               for (Event ev : upcomingEvents) { 
                                   int seatPct = Math.min(100, (ev.getRemainingSeats() * 100) / Math.max(1, ev.getMaxParticipants()));
                            %>
                                <div class="ticket-slide <%= slideIdx == 0 ? "active" : "" %>" 
                                     data-slide-index="<%= slideIdx %>" 
                                     data-past="<%= ev.isPastEvent() %>">
                                    <div class="ticket-banner-wrap">
                                        <img src="<%= cp %>/images/<%= ev.getImage() %>" alt="<%= ev.getTitle() %>" 
                                             class="ticket-banner-img" onerror="this.src='<%= cp %>/images/default_event.jpg'">
                                        <span class="ticket-badge-cat"><%= ev.getCategory() %></span>
                                        <% if (ev.isPastEvent()) { %>
                                            <span class="ticket-badge-concluded">&#9679; Past Event</span>
                                        <% } %>
                                    </div>

                                    <div class="ticket-body">
                                        <div class="ticket-club-row">
                                            <img src="<%= cp %>/images/clubs/<%= ev.getClubLogo() %>?v=3.0" alt="<%= ev.getOrganizerName() %>" 
                                                 class="ticket-club-mini-logo" onerror="this.src='<%= cp %>/images/campusconnect-mark.svg'">
                                            <span class="ticket-club-name"><%= ev.getOrganizerName() %></span>
                                        </div>

                                        <h3 class="ticket-title"><%= ev.getTitle() %></h3>

                                        <div class="ticket-meta-grid">
                                            <div class="ticket-meta-cell">
                                                <span class="ticket-meta-label">Date &amp; Time</span>
                                                <span class="ticket-meta-val">&#128197; <%= ev.getFormattedDate() %></span>
                                            </div>
                                            <div class="ticket-meta-cell">
                                                <span class="ticket-meta-label">Campus Venue</span>
                                                <span class="ticket-meta-val">&#128205; <%= ev.getVenue() %></span>
                                            </div>
                                        </div>

                                        <div class="ticket-seats-bar">
                                            <div class="seats-label-row">
                                                <span>Seat Availability</span>
                                                <strong><%= ev.getRemainingSeats() %> / <%= ev.getMaxParticipants() %> Left</strong>
                                            </div>
                                            <div class="seats-progress-track">
                                                <div class="seats-progress-fill" style="width: <%= seatPct %>%;"></div>
                                            </div>
                                        </div>

                                        <a href="<%= cp %>/event-details?id=<%= ev.getId() %>" class="btn-ticket-action <%= ev.isPastEvent() ? "concluded" : "" %>">
                                            <%= ev.isPastEvent() ? "View Past Event Details &rarr;" : "View Event &amp; Register &rarr;" %>
                                        </a>
                                    </div>
                                </div>
                            <%  slideIdx++; 
                               } %>
                        </div>

                        <!-- Indicator Dots -->
                        <div class="ticket-dots-strip">
                            <% for (int d = 0; d < upcomingEvents.size(); d++) { %>
                                <button type="button" class="ticket-dot <%= d == 0 ? "active" : "" %>" 
                                        onclick="goToHeroSlide(<%= d %>)" 
                                        aria-label="Go to slide <%= d + 1 %>"></button>
                            <% } %>
                        </div>
                    </div>
                <% } else { %>
                    <div class="hero-ticket-card">
                        <div class="ticket-top-tag">
                            <span>CAMPUS OPPORTUNITY HUB</span>
                        </div>
                        <div class="ticket-body" style="padding:2.5rem 2rem; text-align:center;">
                            <div style="font-size:3rem; margin-bottom:1rem;">&#127891;</div>
                            <h3 class="ticket-title">Explore Campus Events</h3>
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

<%
    StringBuilder jsEventsJson = new StringBuilder("[");
    if (upcomingEvents != null) {
        for (int i = 0; i < upcomingEvents.size(); i++) {
            Event ev = upcomingEvents.get(i);
            String titleSafe = ev.getTitle() != null ? ev.getTitle().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ") : "";
            String orgSafe = ev.getOrganizerName() != null ? ev.getOrganizerName().replace("\\", "\\\\").replace("\"", "\\\"") : "";
            String catSafe = ev.getCategory() != null ? ev.getCategory().replace("\\", "\\\\").replace("\"", "\\\"") : "";
            String venueSafe = ev.getVenue() != null ? ev.getVenue().replace("\\", "\\\\").replace("\"", "\\\"") : "";
            jsEventsJson.append("{");
            jsEventsJson.append("\"id\":").append(ev.getId()).append(",");
            jsEventsJson.append("\"title\":\"").append(titleSafe).append("\",");
            jsEventsJson.append("\"organizer\":\"").append(orgSafe).append("\",");
            jsEventsJson.append("\"category\":\"").append(catSafe).append("\",");
            jsEventsJson.append("\"venue\":\"").append(venueSafe).append("\",");
            jsEventsJson.append("\"isPast\":").append(ev.isPastEvent());
            jsEventsJson.append("}");
            if (i < upcomingEvents.size() - 1) {
                jsEventsJson.append(",");
            }
        }
    }
    jsEventsJson.append("]");
%>

<script>
(function() {
    // 1. Hero Ticket Carousel Logic
    let currentHeroSlide = 0;
    const slides = document.querySelectorAll('#heroTicketCard .ticket-slide');
    const dots = document.querySelectorAll('#heroTicketCard .ticket-dot');
    const counter = document.getElementById('ticketCounter');
    const statusText = document.getElementById('ticketStatusText');
    const liveDot = document.getElementById('ticketLiveDot');
    const totalSlides = slides.length;
    let autoSlideInterval = null;

    function updateHeroSlideUI() {
        if (!slides.length) return;
        slides.forEach((slide, idx) => {
            if (idx === currentHeroSlide) {
                slide.classList.add('active');
                const isPast = slide.getAttribute('data-past') === 'true';
                if (statusText) {
                    statusText.textContent = isPast ? 'PAST EVENT ARCHIVE' : 'FEATURED CAMPUS PASS';
                }
                if (liveDot) {
                    liveDot.style.backgroundColor = isPast ? '#94a3b8' : 'var(--ltce-gold)';
                }
            } else {
                slide.classList.remove('active');
            }
        });

        dots.forEach((dot, idx) => {
            if (idx === currentHeroSlide) {
                dot.classList.add('active');
            } else {
                dot.classList.remove('active');
            }
        });

        if (counter) {
            counter.textContent = (currentHeroSlide + 1) + ' / ' + totalSlides;
        }
    }

    window.changeHeroSlide = function(dir) {
        if (totalSlides <= 1) return;
        currentHeroSlide = (currentHeroSlide + dir + totalSlides) % totalSlides;
        updateHeroSlideUI();
        restartSlideTimer();
    };

    window.goToHeroSlide = function(idx) {
        if (idx >= 0 && idx < totalSlides) {
            currentHeroSlide = idx;
            updateHeroSlideUI();
            restartSlideTimer();
        }
    };

    function startSlideTimer() {
        if (totalSlides > 1) {
            clearInterval(autoSlideInterval);
            autoSlideInterval = setInterval(function() {
                currentHeroSlide = (currentHeroSlide + 1) % totalSlides;
                updateHeroSlideUI();
            }, 5500);
        }
    }

    function restartSlideTimer() {
        clearInterval(autoSlideInterval);
        startSlideTimer();
    }

    const ticketCard = document.getElementById('heroTicketCard');
    if (ticketCard) {
        ticketCard.addEventListener('mouseenter', function() {
            clearInterval(autoSlideInterval);
        });
        ticketCard.addEventListener('mouseleave', function() {
            startSlideTimer();
        });

        // Touch swipe support for mobile
        let touchStartX = 0;
        let touchEndX = 0;
        ticketCard.addEventListener('touchstart', function(e) {
            touchStartX = e.changedTouches[0].screenX;
        }, { passive: true });
        ticketCard.addEventListener('touchend', function(e) {
            touchEndX = e.changedTouches[0].screenX;
            if (touchEndX < touchStartX - 45) {
                window.changeHeroSlide(1);
            } else if (touchEndX > touchStartX + 45) {
                window.changeHeroSlide(-1);
            }
        }, { passive: true });
    }

    startSlideTimer();

    // 2. Quick Trending Topics Filter
    window.quickHeroFilter = function(query) {
        const input = document.getElementById('heroSearchInput');
        const form = document.getElementById('heroSearchForm');
        if (input && form) {
            input.value = query;
            form.submit();
        }
    };

    // 3. Instant Search Autocomplete
    const heroEvents = <%= jsEventsJson.toString() %>;
    const heroClubs = [
        { name: "CESA - Computer Engg Association", query: "CESA" },
        { name: "AIMSA - AI & Machine Learning", query: "AIMSA" },
        { name: "DSSA - Data Science Association", query: "Data Science" },
        { name: "GDG On Campus LTCE", query: "GDG" },
        { name: "GFG Student Chapter", query: "GFG" },
        { name: "E-CELL Entrepreneurship Club", query: "E-CELL" },
        { name: "Technical Vidya Club", query: "Technical Vidya" },
        { name: "English Literary Club", query: "English Club" }
    ];

    const searchInput = document.getElementById('heroSearchInput');
    const suggestionsBox = document.getElementById('heroSuggestionsBox');

    if (searchInput && suggestionsBox) {
        searchInput.addEventListener('input', function() {
            const query = this.value.trim().toLowerCase();
            if (query.length < 2) {
                suggestionsBox.innerHTML = '';
                suggestionsBox.classList.remove('show');
                return;
            }

            const matchedEvents = heroEvents.filter(function(e) {
                return (e.title && e.title.toLowerCase().includes(query)) ||
                       (e.organizer && e.organizer.toLowerCase().includes(query)) ||
                       (e.category && e.category.toLowerCase().includes(query)) ||
                       (e.venue && e.venue.toLowerCase().includes(query));
            }).slice(0, 4);

            const matchedClubs = heroClubs.filter(function(c) {
                return c.name.toLowerCase().includes(query) ||
                       c.query.toLowerCase().includes(query);
            }).slice(0, 2);

            if (matchedEvents.length === 0 && matchedClubs.length === 0) {
                suggestionsBox.innerHTML = '<div style="padding:12px; color:#64748b; font-size:0.85rem; text-align:center;">No direct match. Press Enter to search all events.</div>';
                suggestionsBox.classList.add('show');
                return;
            }

            let html = '';
            matchedEvents.forEach(function(ev) {
                html += '<a href="<%= cp %>/event-details?id=' + ev.id + '" class="hero-suggest-item">' +
                            '<div>' +
                                '<div class="hero-suggest-title">' + ev.title + '</div>' +
                                '<div class="hero-suggest-meta">' + ev.organizer + ' &bull; ' + ev.category + (ev.isPast ? ' &bull; <span style=\"color:#ef4444;\">Past Event</span>' : '') + '</div>' +
                            '</div>' +
                            '<span class="hero-suggest-badge">Event</span>' +
                        '</a>';
            });

            matchedClubs.forEach(function(cl) {
                html += '<a href="<%= cp %>/dashboard?search=' + encodeURIComponent(cl.query) + '" class="hero-suggest-item">' +
                            '<div>' +
                                '<div class="hero-suggest-title">' + cl.name + '</div>' +
                                '<div class="hero-suggest-meta">Student Chapter &bull; View club events</div>' +
                            '</div>' +
                            '<span class="hero-suggest-badge" style="background:#e0f2fe; color:#0369a1;">Club</span>' +
                        '</a>';
            });

            suggestionsBox.innerHTML = html;
            suggestionsBox.classList.add('show');
        });

        document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !suggestionsBox.contains(e.target)) {
                suggestionsBox.classList.remove('show');
            }
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                suggestionsBox.classList.remove('show');
            }
        });

        searchInput.addEventListener('focus', function() {
            if (this.value.trim().length >= 2 && suggestionsBox.innerHTML.trim() !== '') {
                suggestionsBox.classList.add('show');
            }
        });
    }
})();
</script>

<jsp:include page="includes/footer.jsp" />
