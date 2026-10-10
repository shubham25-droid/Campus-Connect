<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    request.setAttribute("pageTitle", "Server Error (500)");
    String cp = request.getContextPath();
%>
<jsp:include page="includes/header.jsp" />

<div class="container" style="max-width: 680px; margin: 5rem auto; text-align: center; padding: 0 1.25rem;">
    <div style="font-size: 4rem; font-weight: 900; color: #ef4444; line-height: 1; margin-bottom: 1rem;">
        500
    </div>
    <h1 style="font-size: 1.75rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.75rem;">
        Something Went Wrong
    </h1>
    <p style="font-size: 1rem; color: var(--text-secondary); line-height: 1.6; margin-bottom: 2rem;">
        An unexpected error occurred while processing your request. Our campus portal administrators have been notified. Please try again shortly.
    </p>
    <div style="display: flex; justify-content: center; gap: 12px; flex-wrap: wrap;">
        <a href="<%= cp %>/" class="btn btn-primary" style="padding: 10px 22px; border-radius: 8px;">
            Return to Safety
        </a>
        <a href="<%= cp %>/dashboard" class="btn btn-secondary" style="padding: 10px 22px; border-radius: 8px;">
            View Events
        </a>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
