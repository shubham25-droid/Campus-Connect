<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Login");
    String error = (String) request.getAttribute("errorMessage");
    String msg = request.getParameter("msg");
    String redirect = request.getParameter("redirect");
    String enteredEmail = (String) request.getAttribute("enteredEmail");
%>
<jsp:include page="includes/header.jsp" />

<div class="container" style="max-width: 460px; padding-top: 3.5rem;">
    <div class="card" style="padding: 2.25rem;">
        <div style="text-align: center; margin-bottom: 1.75rem;">
            <img src="<%= request.getContextPath() %>/images/campusconnect-final-logo-trans.png?v=3.0" alt="CampusConnect" style="width:68px; height:68px; margin:0 auto 12px; display:block; object-fit:contain;">
            <h2 style="font-size: 1.5rem; font-weight: 800; color: var(--ltce-blue-dark);">Welcome Back</h2>
            <p style="font-size: 0.875rem; color: var(--text-muted); margin-top: 4px;">Log in to your CampusConnect LTCE account</p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
        <% if ("logged_out".equals(msg)) { %>
            <div class="alert alert-info">You have been logged out successfully.</div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="POST">
            <% if (redirect != null) { %>
                <input type="hidden" name="redirect" value="<%= redirect %>">
            <% } %>

            <div class="form-group">
                <label class="form-label" for="loginEmail">College Email</label>
                <input type="email" id="loginEmail" name="email" class="form-control" placeholder="Enter your college email" required value="<%= enteredEmail != null ? enteredEmail : "" %>">
            </div>

            <div class="form-group">
                <label class="form-label" for="loginPassword">Password</label>
                <input type="password" id="loginPassword" name="password" class="form-control" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="btn btn-primary btn-full" style="margin-top: 0.5rem;">Log In to Account</button>
        </form>

        <div style="text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--text-muted);">
            Don't have an account yet? <a href="<%= request.getContextPath() %>/register" style="font-weight: 600;">Sign up as a Student</a>
        </div>

        <!-- Quick 1-Click Demo Login Panel (Ideal for Evaluator / HOD Demo) -->
        <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px dashed var(--border-color);">
            <div style="font-size: 0.775rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 0.75rem; text-align: center;">
                Academic Demonstration Accounts
            </div>
            <div style="display: flex; gap: 8px;">
                <button type="button" class="btn btn-outline btn-sm btn-full" onclick="fillDemo('student')">
                    &#127891; Student Demo
                </button>
                <button type="button" class="btn btn-outline btn-sm btn-full" onclick="fillDemo('admin')">
                    &#128188; Admin Demo
                </button>
            </div>
            <div style="font-size: 0.72rem; color: var(--text-subtle); text-align: center; margin-top: 8px;">
                Clicking auto-populates credentials for instant testing.
            </div>
        </div>
    </div>
</div>

<script>
function fillDemo(role) {
    if (role === 'student') {
        document.getElementById('loginEmail').value = 'student@campusconnect.com';
        document.getElementById('loginPassword').value = 'student123';
    } else {
        document.getElementById('loginEmail').value = 'admin@campusconnect.com';
        document.getElementById('loginPassword').value = 'admin123';
    }
}
</script>

<jsp:include page="includes/footer.jsp" />
