<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Terms of Use");
    String cp = request.getContextPath();
%>
<jsp:include page="includes/header.jsp" />

<div class="container" style="max-width: 860px; margin: 2.5rem auto 4rem; padding: 0 1.25rem;">
    <!-- Breadcrumb & Header -->
    <div style="margin-bottom: 2rem;">
        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 0.5rem;">
            <a href="<%= cp %>/" style="font-size: 0.85rem; color: var(--text-muted);">Home</a>
            <span style="font-size: 0.8rem; color: var(--text-muted);">&rsaquo;</span>
            <span style="font-size: 0.85rem; color: var(--ltce-blue); font-weight: 600;">Terms of Use</span>
        </div>
        <h1 style="font-size: 2.1rem; font-weight: 800; color: var(--text-primary); margin: 0 0 0.5rem;">Terms of Use</h1>
        <p style="font-size: 0.95rem; color: var(--text-muted); margin: 0;">
            Lokmanya Tilak College of Engineering &bull; Last updated October 2026
        </p>
    </div>

    <!-- Terms Content Card -->
    <div class="card" style="padding: 2.5rem; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 8px; line-height: 1.7;">
        
        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary); margin-top: 0;">1. Scope and Acceptance</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            CampusConnect is the institutional event and club directory operated for students, faculty, and student bodies at Lokmanya Tilak College of Engineering (LTCE), Koparkhairane, Navi Mumbai. By accessing this platform, creating an account, or registering for campus activities, you agree to these terms.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">2. Eligibility and Student Accounts</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            Students should use their official college credentials or valid personal email address. You are responsible for maintaining the confidentiality of your account credentials. Impersonation of other students, faculty members, or college officials is strictly prohibited.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">3. Event Registration and Passes</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            Event registration confirmation passes generated through CampusConnect are issued for individual participation. Passes are non-transferable unless explicitly permitted by the organizing committee. Attendees must follow LTCE campus safety rules, laboratory protocols, and decorum at all venues.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">4. Organizer Responsibilities</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            Event organizers and student chapter heads (CESA, AIMSA, DSSA, GDG, GFG, E-Cell) must ensure event descriptions, schedules, fees (if applicable), and venues are accurate and approved by department faculty coordinators.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">5. Acceptable Use and College Discipline</h2>
        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
            All users must comply with the LTCE Student Code of Conduct and University of Mumbai guidelines. Submitting misleading event submissions, unauthorized commercial promotions, or disruptive content will result in immediate account suspension.
        </p>

        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary);">6. Contact and Inquiries</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0;">
            For inquiries regarding platform policies or event authorization, contact the Lokmanya Tilak College of Engineering Student Affairs Office at Sector-4, Vikas Nagar, Koparkhairane, Navi Mumbai 400709 or visit the official college portal at <a href="https://ltce.in/" target="_blank" rel="noopener noreferrer" style="color: var(--ltce-blue); font-weight: 600;">ltce.in</a>.
        </p>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
