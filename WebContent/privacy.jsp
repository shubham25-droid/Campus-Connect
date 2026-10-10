<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Privacy Policy");
    String cp = request.getContextPath();
%>
<jsp:include page="includes/header.jsp" />

<div class="container" style="max-width: 860px; margin: 2.5rem auto 4rem; padding: 0 1.25rem;">
    <!-- Breadcrumb & Header -->
    <div style="margin-bottom: 2rem;">
        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 0.5rem;">
            <a href="<%= cp %>/" style="font-size: 0.85rem; color: var(--text-muted);">Home</a>
            <span style="font-size: 0.8rem; color: var(--text-muted);">&rsaquo;</span>
            <span style="font-size: 0.85rem; color: var(--ltce-blue); font-weight: 600;">Privacy Policy</span>
        </div>
        <h1 style="font-size: 2.1rem; font-weight: 800; color: var(--text-primary); margin: 0 0 0.5rem;">Privacy Policy</h1>
        <p style="font-size: 0.95rem; color: var(--text-muted); margin: 0;">
            Lokmanya Tilak College of Engineering &bull; Last updated October 2026
        </p>
    </div>

    <!-- Privacy Content Card -->
    <div class="card" style="padding: 2.5rem; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 8px; line-height: 1.7;">
        
        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary); margin-top: 0;">1. Information We Collect</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            When students register on CampusConnect, we collect essential collegiate details: your name, email address, password hash, and student role (Student or Organizer). When you register for events or save events to your wishlist, we record event identifiers to issue verified entry passes.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">2. How Your Data Is Used</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            Your information is strictly used for campus operations:
        </p>
        <ul style="color: var(--text-secondary); margin-bottom: 1.5rem; padding-left: 1.5rem;">
            <li style="margin-bottom: 0.5rem;">Validating entry and event seat counts for departmental workshops and hackathons.</li>
            <li style="margin-bottom: 0.5rem;">Allowing organizers to communicate venue updates or schedule changes.</li>
            <li style="margin-bottom: 0.5rem;">Maintaining individual student registration histories and attendance records.</li>
        </ul>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">3. Data Protection and Storage</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            All student passwords are cryptographically salted and hashed. We do not sell, rent, or monetize student information to any third parties or advertisers. All database storage adheres to strict access controls restricted to authorized LTCE system administrators.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">4. Cookies and Sessions</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            CampusConnect uses standard HTTP session cookies solely to preserve your active login state and security tokens across requests. We do not use third-party tracking cookies or advertising pixels.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">5. Student Data Rights</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            Students may view their saved events and registration history at any time through the "My Registrations" portal. For account updates or data removal requests upon graduation, reach out to the department lab coordinators.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">6. Updates to This Policy</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0;">
            Any modifications to this privacy policy will be posted on this page. Significant updates will also be reflected in the official college notifications at <a href="https://ltce.in/" target="_blank" rel="noopener noreferrer" style="color: var(--ltce-blue); font-weight: 600;">ltce.in</a>.
        </p>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
