<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Event" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Campus Events Discovery");
    User authUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
    List<Event> events = (List<Event>) request.getAttribute("events");
    Event featured = (Event) request.getAttribute("featuredEvent");

    String curSearch = (String) request.getAttribute("paramSearch");
    String curCat = (String) request.getAttribute("paramCategory");
    String curDept = (String) request.getAttribute("paramDepartment");
    String curYear = (String) request.getAttribute("paramYear");
    String curSort = (String) request.getAttribute("paramSort");

    Integer regCount = (Integer) request.getAttribute("myRegistrationsCount");
    Integer saveCount = (Integer) request.getAttribute("savedEventsCount");
%>
<jsp:include page="includes/header.jsp" />

<div class="container">

    <!-- Welcome & Quick Stat Section -->
    <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1.5rem; margin-bottom: 2rem;">
        <div>
            <h1 class="page-title">
                <%= (authUser != null) ? "Welcome back, " + authUser.getName().split(" ")[0] : "Discover Campus Events" %>
            </h1>
            <p class="page-subtitle">
                Centralized directory of official academic sessions, hackathons, seminars, and club activities.
            </p>
        </div>

        <% if (authUser != null) { %>
            <div style="display:flex; gap:12px; align-items:center;">
                <a href="<%= request.getContextPath() %>/my-registrations" class="btn btn-secondary btn-sm" style="background:#fff;">
                    <span>&#128197;</span> My Registrations: <strong style="color:var(--primary); margin-left:4px;"><%= regCount != null ? regCount : 0 %></strong>
                </a>
                <a href="<%= request.getContextPath() %>/saved-events" class="btn btn-secondary btn-sm" style="background:#fff;">
                    <span>&#9829;</span> Saved: <strong style="color:var(--danger); margin-left:4px;"><%= saveCount != null ? saveCount : 0 %></strong>
                </a>
            </div>
        <% } %>
    </div>

    <!-- Featured Event Hero (Only show when not heavily filtered) -->
    <% if (featured != null && (curSearch == null || curSearch.isEmpty())) { %>
        <div class="featured-card">
            <div class="featured-content">
                <div class="featured-badge <%= featured.isPastEvent() ? "concluded" : "" %>">
                    <%= featured.isPastEvent() ? "&#9679; Concluded Campus Event" : "&#9733; Featured Campus Opportunity" %>
                </div>
                <h2 class="featured-title"><%= featured.getTitle() %></h2>
                
                <div class="featured-meta">
                    <span>&#128197; <%= featured.getFormattedDate() %> &bull; <%= featured.getStartTime() %></span>
                    <span>&#128205; <%= featured.getVenue() %></span>
                    <span>&#127891; <%= featured.getOrganizerName() %></span>
                </div>

                <p class="featured-desc">
                    <%= featured.getShortDescription() %>
                </p>

                <div class="featured-actions">
                    <a href="<%= request.getContextPath() %>/event-details?id=<%= featured.getId() %>" class="btn <%= featured.isPastEvent() ? "btn-secondary" : "btn-primary" %>">
                        <%= featured.isPastEvent() ? "View Event Details (Ended) &rarr;" : "View Event & Register &rarr;" %>
                    </a>
                    <% if (authUser != null) { %>
                        <button type="button" class="btn btn-secondary btn-save-toggle <%= featured.isUserSaved() ? "saved" : "" %>" data-event-id="<%= featured.getId() %>">
                            <span class="save-icon"><%= featured.isUserSaved() ? "&#9829;" : "&#9825;" %></span>
                            <span class="save-label"><%= featured.isUserSaved() ? "Saved" : "Save" %></span>
                        </button>
                    <% } %>
                </div>
            </div>
            <div class="featured-image-wrapper">
                <img src="<%= request.getContextPath() %>/images/<%= featured.getImage() %>" alt="<%= featured.getTitle() %>" onerror="this.src='<%= request.getContextPath() %>/images/gdg_hacktoberfest.jpg'">
            </div>
        </div>
    <% } %>

    <!-- Search & Filter Controls -->
    <div class="filter-panel">
        <form action="<%= request.getContextPath() %>/dashboard" method="GET" id="searchFilterForm">
            <div class="search-box-row">
                <div class="search-input-wrapper">
                    <span class="search-icon">&#128269;</span>
                    <input type="text" id="clientSearchInput" name="search" class="form-control search-input" 
                           placeholder="Search events, guest speakers, GDG, AIMSA, hackathons..." 
                           value="<%= curSearch != null ? curSearch : "" %>">
                </div>
                <button type="submit" class="btn btn-primary">Search</button>
                <% if ((curSearch != null && !curSearch.isEmpty()) || (curCat != null && !curCat.isEmpty() && !"All".equals(curCat)) || (curDept != null && !curDept.isEmpty() && !"All".equals(curDept))) { %>
                    <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">Clear</a>
                <% } %>
            </div>

            <div class="filter-controls-row">
                <div>
                    <select id="clientDeptSelect" name="department" class="form-select" onchange="document.getElementById('searchFilterForm').submit()">
                        <option value="All" <%= (curDept == null || "All".equalsIgnoreCase(curDept)) ? "selected" : "" %>>All Departments</option>
                        <option value="Computer Engineering" <%= "Computer Engineering".equalsIgnoreCase(curDept) ? "selected" : "" %>>Computer Engineering</option>
                        <option value="CSE (AI & ML)" <%= "CSE (AI & ML)".equalsIgnoreCase(curDept) ? "selected" : "" %>>CSE (AI & ML)</option>
                        <option value="Information Technology" <%= "Information Technology".equalsIgnoreCase(curDept) ? "selected" : "" %>>Information Technology</option>
                        <option value="Mechanical Engineering" <%= "Mechanical Engineering".equalsIgnoreCase(curDept) ? "selected" : "" %>>Mechanical Engineering</option>
                        <option value="Electronics & Telecom" <%= "Electronics & Telecom".equalsIgnoreCase(curDept) ? "selected" : "" %>>Electronics & Telecom</option>
                    </select>
                </div>

                <div>
                    <select id="clientYearSelect" name="year" class="form-select" onchange="document.getElementById('searchFilterForm').submit()">
                        <option value="All" <%= (curYear == null || "All".equalsIgnoreCase(curYear)) ? "selected" : "" %>>All Academic Years</option>
                        <option value="FE" <%= "FE".equalsIgnoreCase(curYear) ? "selected" : "" %>>FE (First Year)</option>
                        <option value="SE" <%= "SE".equalsIgnoreCase(curYear) ? "selected" : "" %>>SE (Second Year)</option>
                        <option value="TE" <%= "TE".equalsIgnoreCase(curYear) ? "selected" : "" %>>TE (Third Year)</option>
                        <option value="BE" <%= "BE".equalsIgnoreCase(curYear) ? "selected" : "" %>>BE (Final Year)</option>
                    </select>
                </div>

                <div>
                    <select name="sort" class="form-select" onchange="document.getElementById('searchFilterForm').submit()">
                        <option value="upcoming" <%= ("upcoming".equalsIgnoreCase(curSort) || curSort == null) ? "selected" : "" %>>Sort: Upcoming First</option>
                        <option value="latest" <%= "latest".equalsIgnoreCase(curSort) ? "selected" : "" %>>Sort: Recently Added</option>
                        <option value="deadline" <%= "deadline".equalsIgnoreCase(curSort) ? "selected" : "" %>>Sort: Deadline Approaching</option>
                    </select>
                </div>

                <div style="text-align: right; font-size: 0.85rem; color: var(--text-muted); font-weight: 500;" id="resultsCountBadge">
                    <%= (events != null ? events.size() : 0) %> events found
                </div>
            </div>

            <!-- Category Pills Bar -->
            <div class="category-pill-row">
                <input type="hidden" name="category" id="hiddenCategory" value="<%= curCat != null ? curCat : "All" %>">
                <% 
                    String[] cats = {"All", "Technical", "Competition", "Hackathon", "Workshop", "Seminar", "Cultural"};
                    for (String c : cats) {
                        boolean isActive = (curCat == null && "All".equals(c)) || (curCat != null && curCat.equalsIgnoreCase(c));
                %>
                    <button type="button" class="cat-pill <%= isActive ? "active" : "" %>" 
                            onclick="document.getElementById('hiddenCategory').value='<%= c %>'; document.getElementById('searchFilterForm').submit();">
                        <%= c %>
                    </button>
                <% } %>
            </div>
        </form>
    </div>

    <!-- Quick Filter by Student Club / Organizing Body -->
    <div id="clubs-strip" style="margin-bottom: 1.5rem;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.5rem;">
            <div style="font-size:0.8125rem; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.5px;">
                Filter by Campus Club &amp; Organizing Body:
            </div>
            <a href="<%= request.getContextPath() %>/clubs.jsp" style="font-size:0.8rem; font-weight:700; color:var(--ltce-blue-mid); text-decoration:underline;">
                &#127891; Which Club Should I Join? (Clubs Guide &rarr;)
            </a>
        </div>
        <div class="club-badge-strip">
            <button type="button" class="club-badge-pill" onclick="filterByClub('')">
                <span>All Organizers</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('CESA')">
                <img src="<%= request.getContextPath() %>/images/clubs/cesa.png" alt="CESA">
                <span>CESA (Computer)</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('AIMSA')">
                <img src="<%= request.getContextPath() %>/images/clubs/aimsa.png" alt="AIMSA">
                <span>AIMSA (AI &amp; ML)</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('Data Science')">
                <img src="<%= request.getContextPath() %>/images/clubs/dssa.png" alt="DSSA">
                <span>DSSA (Data Science)</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('GDG')">
                <img src="<%= request.getContextPath() %>/images/clubs/gdg.svg" alt="GDG">
                <span>GDG on Campus</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('GFG')">
                <img src="<%= request.getContextPath() %>/images/clubs/gfg.svg" alt="GFG">
                <span>GFG Student Chapter</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('E-CELL')">
                <img src="<%= request.getContextPath() %>/images/clubs/ecell.png" alt="E-CELL">
                <span>E-CELL LTCE</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('Technical Vidya')">
                <img src="<%= request.getContextPath() %>/images/clubs/technical_vidya.png" alt="Technical Vidya">
                <span>Technical Vidya</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('English')">
                <img src="<%= request.getContextPath() %>/images/clubs/english_club.png" alt="English Club">
                <span>The English Club</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('IIC')">
                <img src="<%= request.getContextPath() %>/images/clubs/iic.svg" alt="IIC">
                <span>IIC LTCE</span>
            </button>
            <button type="button" class="club-badge-pill" onclick="filterByClub('Placement')">
                <img src="<%= request.getContextPath() %>/images/clubs/tnp.svg" alt="T&P">
                <span>T&amp;P Cell</span>
            </button>
        </div>
    </div>

    <!-- Event Cards Grid -->
    <div class="events-grid">
        <% if (events != null && !events.isEmpty()) { 
            for (Event e : events) { 
        %>
            <div class="event-card event-card-item" 
                 data-title="<%= e.getTitle().toLowerCase() %>" 
                 data-organizer="<%= e.getOrganizerName().toLowerCase() %>" 
                 data-category="<%= e.getCategory().toLowerCase() %>"
                 data-dept="<%= e.getDepartment().toLowerCase() %>"
                 data-year="<%= e.getEligibleYear().toLowerCase() %>">

                <div class="event-card-media">
                    <img src="<%= request.getContextPath() %>/images/<%= e.getImage() %>" alt="<%= e.getTitle() %>" onerror="this.src='<%= request.getContextPath() %>/images/default_event.jpg'">
                    <span class="event-type-badge"><%= e.getCategory() %></span>
                    <% if (e.isDemoEvent()) { %>
                        <span class="card-demo-badge">SAMPLE / DEMO</span>
                        <div class="demo-watermark-overlay">
                            <span class="demo-watermark-text">SAMPLE / DEMO</span>
                        </div>
                    <% } else if (e.isPastEvent()) { %>
                        <span class="card-concluded-badge">CONCLUDED</span>
                    <% } %>

                    <div class="card-date-stamp <%= e.isPastEvent() ? "is-concluded" : (e.isToday() ? "is-today" : "") %>">
                        <span class="date-month"><%= e.getShortMonth() %></span>
                        <span class="date-day"><%= e.getDayString() %></span>
                        <% if (e.isPastEvent()) { %>
                            <span class="date-tag-status ended">ENDED</span>
                        <% } else if (e.isToday()) { %>
                            <span class="date-tag-status today">TODAY</span>
                        <% } %>
                    </div>

                    <% if (authUser != null) { %>
                        <button type="button" class="save-btn-floating btn-save-toggle <%= e.isUserSaved() ? "saved" : "" %>" 
                                data-event-id="<%= e.getId() %>" title="<%= e.isUserSaved() ? "Remove Bookmark" : "Save Event" %>">
                            <span class="save-icon"><%= e.isUserSaved() ? "&#9829;" : "&#9825;" %></span>
                        </button>
                    <% } %>
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
                        <% if (e.isUserRegistered()) { %>
                            <span class="seat-status-pill registered">&#10003; Registered</span>
                        <% } else if (e.isPastEvent()) { %>
                            <span class="seat-status-pill concluded">&#9679; Concluded</span>
                        <% } else if (e.isRegistrationOpen()) { %>
                            <span class="seat-status-pill open"><%= e.getRemainingSeats() %> seats left</span>
                        <% } else { %>
                            <span class="seat-status-pill full">Closed</span>
                        <% } %>

                        <a href="<%= request.getContextPath() %>/event-details?id=<%= e.getId() %>" class="btn <%= e.isPastEvent() ? "btn-secondary" : "btn-primary" %> btn-sm">
                            <%= e.isPastEvent() ? "View Details (Ended)" : "View Details" %>
                        </a>
                    </div>
                </div>
            </div>
        <%  } 
           } %>
    </div>

    <!-- Empty State -->
    <div id="noResultsMsg" style="display: <%= (events == null || events.isEmpty()) ? "block" : "none" %>; text-align: center; padding: 4rem 1rem; background: var(--bg-surface); border: 1px dashed var(--border-color); border-radius: var(--radius-md); margin-top: 1.5rem;">
        <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">&#128269;</div>
        <h3 style="font-size: 1.25rem; font-weight: 700;">No matching events found</h3>
        <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 4px;">
            Try clearing filters or checking other departments or categories.
        </p>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline btn-sm" style="margin-top: 1rem;">View All Events</a>
    </div>

</div>

<jsp:include page="includes/footer.jsp" />
