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
                <div class="featured-badge">&#9733; Featured Campus Opportunity</div>
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
                    <a href="<%= request.getContextPath() %>/event-details?id=<%= featured.getId() %>" class="btn btn-primary">
                        View Event & Register &rarr;
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
                    <img src="<%= request.getContextPath() %>/images/<%= e.getImage() %>" alt="<%= e.getTitle() %>" onerror="this.src='<%= request.getContextPath() %>/images/gdg_hacktoberfest.jpg'">
                    <span class="event-type-badge"><%= e.getCategory() %></span>

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
                        <div class="event-meta-item">
                            <span>&#127891;</span>
                            <span><%= e.getOrganizerName() %></span>
                        </div>
                    </div>

                    <div class="event-card-footer">
                        <% if (e.isUserRegistered()) { %>
                            <span class="seat-status-pill registered">&#10003; Registered</span>
                        <% } else if (e.isRegistrationOpen()) { %>
                            <span class="seat-status-pill open"><%= e.getRemainingSeats() %> seats left</span>
                        <% } else { %>
                            <span class="seat-status-pill full">Closed</span>
                        <% } %>

                        <a href="<%= request.getContextPath() %>/event-details?id=<%= e.getId() %>" class="btn btn-primary btn-sm">
                            View Details
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
