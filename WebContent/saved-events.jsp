<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Event" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Saved Opportunities");
    List<Event> savedEvents = (List<Event>) request.getAttribute("savedEvents");
%>
<jsp:include page="includes/header.jsp" />

<div class="container">

    <div class="page-header" style="display:flex; justify-content:space-between; align-items:flex-end; flex-wrap:wrap; gap:1rem;">
        <div>
            <h1 class="page-title">Saved Opportunities</h1>
            <p class="page-subtitle">Your bookmarked campus events, hackathons, and technical bootcamps</p>
        </div>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline btn-sm">Explore More Events &rarr;</a>
    </div>

    <% if (savedEvents != null && !savedEvents.isEmpty()) { %>
        <div class="events-grid">
            <% for (Event e : savedEvents) { %>
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
                        </div>

                        <div class="event-card-footer">
                            <form action="<%= request.getContextPath() %>/toggle-save" method="POST" style="margin:0;">
                                <input type="hidden" name="eventId" value="<%= e.getId() %>">
                                <input type="hidden" name="returnUrl" value="<%= request.getContextPath() %>/saved-events">
                                <button type="submit" class="btn btn-sm btn-outline" style="color:var(--danger); border-color:var(--danger-border);">
                                    Remove Bookmark
                                </button>
                            </form>
                            <a href="<%= request.getContextPath() %>/event-details?id=<%= e.getId() %>" class="btn btn-primary btn-sm">
                                View & Register
                            </a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div style="text-align: center; padding: 4.5rem 1.5rem; background: var(--bg-surface); border: 1px dashed var(--border-color); border-radius: var(--radius-md);">
            <div style="font-size: 3rem; margin-bottom: 0.75rem; color: var(--danger);">&#9825;</div>
            <h3 style="font-size: 1.35rem; font-weight: 700; color: var(--secondary);">No Saved Events Yet</h3>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 6px; max-width: 480px; margin-left: auto; margin-right: auto;">
                When browsing events, click the heart icon on any event to save it here for quick reference and reminders.
            </p>
            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-primary" style="margin-top: 1.25rem;">
                Browse Campus Events
            </a>
        </div>
    <% } %>

</div>

<jsp:include page="includes/footer.jsp" />
