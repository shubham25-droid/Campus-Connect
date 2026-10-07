<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Student Registration");
    String error = (String) request.getAttribute("errorMessage");
    String enteredName = (String) request.getAttribute("enteredName");
    String enteredEmail = (String) request.getAttribute("enteredEmail");
    String enteredDept = (String) request.getAttribute("enteredDepartment");
    String enteredYear = (String) request.getAttribute("enteredYear");
%>
<jsp:include page="includes/header.jsp" />

<div class="container" style="max-width: 520px; padding-top: 2.5rem;">
    <div class="card" style="padding: 2.25rem;">
        <div style="text-align: center; margin-bottom: 1.75rem;">
            <img src="<%= request.getContextPath() %>/images/campusconnect-final-logo-trans.png?v=3.0" alt="CampusConnect" style="width:68px; height:68px; margin:0 auto 12px; display:block; object-fit:contain;">
            <h2 style="font-size: 1.5rem; font-weight: 800; color: var(--ltce-blue-dark);">Student Registration</h2>
            <p style="font-size: 0.875rem; color: var(--text-muted); margin-top: 4px;">Join CampusConnect LTCE to discover and register for campus opportunities</p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form id="studentRegisterForm" action="<%= request.getContextPath() %>/register" method="POST">
            <div class="form-group">
                <label class="form-label" for="regName">Full Name</label>
                <input type="text" id="regName" name="name" class="form-control" placeholder="Enter your full name" required value="<%= enteredName != null ? enteredName : "" %>">
            </div>

            <div class="form-group">
                <label class="form-label" for="regEmail">College Email Address</label>
                <input type="email" id="regEmail" name="email" class="form-control" placeholder="student@ltce.in" required value="<%= enteredEmail != null ? enteredEmail : "" %>">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="regDepartment">Department</label>
                    <select id="regDepartment" name="department" class="form-select" required>
                        <option value="">Select Department</option>
                        <option value="Computer Engineering" <%= "Computer Engineering".equals(enteredDept) ? "selected" : "" %>>Computer Engineering</option>
                        <option value="CSE (AI & ML)" <%= "CSE (AI & ML)".equals(enteredDept) ? "selected" : "" %>>CSE (AI & ML)</option>
                        <option value="Information Technology" <%= "Information Technology".equals(enteredDept) ? "selected" : "" %>>Information Technology</option>
                        <option value="Mechanical Engineering" <%= "Mechanical Engineering".equals(enteredDept) ? "selected" : "" %>>Mechanical Engineering</option>
                        <option value="Electronics & Telecom" <%= "Electronics & Telecom".equals(enteredDept) ? "selected" : "" %>>Electronics & Telecom</option>
                        <option value="Electrical Engineering" <%= "Electrical Engineering".equals(enteredDept) ? "selected" : "" %>>Electrical Engineering</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="regYear">Academic Year</label>
                    <select id="regYear" name="year" class="form-select" required>
                        <option value="">Select Year</option>
                        <option value="FE - 1st Year" <%= "FE - 1st Year".equals(enteredYear) ? "selected" : "" %>>FE (First Year)</option>
                        <option value="SE - 2nd Year" <%= "SE - 2nd Year".equals(enteredYear) ? "selected" : "" %>>SE (Second Year)</option>
                        <option value="TE - 3rd Year" <%= "TE - 3rd Year".equals(enteredYear) ? "selected" : "" %>>TE (Third Year)</option>
                        <option value="BE - 4th Year" <%= "BE - 4th Year".equals(enteredYear) ? "selected" : "" %>>BE (Final Year)</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="regPassword">Password</label>
                    <input type="password" id="regPassword" name="password" class="form-control" placeholder="Minimum 6 characters" required minlength="6">
                </div>

                <div class="form-group">
                    <label class="form-label" for="regConfirmPassword">Confirm Password</label>
                    <input type="password" id="regConfirmPassword" name="confirmPassword" class="form-control" placeholder="Re-type password" required minlength="6">
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-full" style="margin-top: 0.75rem;">Create Student Account</button>
        </form>

        <div style="text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--text-muted);">
            Already registered? <a href="<%= request.getContextPath() %>/login" style="font-weight: 600;">Log in here</a>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
