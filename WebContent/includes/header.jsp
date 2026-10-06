<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    String cp = request.getContextPath();
    User authUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (request.getAttribute("pageTitle") != null) ? request.getAttribute("pageTitle") + " | " : "" %>CampusConnect &bull; Lokmanya Tilak College of Engineering</title>
    
    <!-- Favicon using new CampusConnect Logo Mark -->
    <link rel="icon" type="image/svg+xml" href="<%= cp %>/images/campusconnect-mark.svg">
    <link rel="shortcut icon" href="<%= cp %>/images/campusconnect-mark.svg">
    
    <!-- Stylesheets & Fonts -->
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <script>
        var contextPath = "<%= cp %>";
    </script>
</head>
<body>

    <!-- ==============================================
         1. Institutional Top Bar (Official LTCE Style)
         ============================================== -->
    <div class="ltce-top-bar">
        <div class="top-bar-container">
            <div class="top-bar-left">
                <span class="sanstha-name">Lokmanya Tilak Jankalyan Shikshan Sanstha's</span>
                <span class="top-divider">|</span>
                <span class="autonomous-tag">Autonomous Institute Affiliated to University of Mumbai</span>
            </div>
            <div class="top-bar-right">
                <span class="accred-pill naac">NAAC 'A' Grade</span>
                <span class="accred-pill nba">NBA Accredited</span>
                <a href="https://ltce.in/" target="_blank" rel="noopener noreferrer" class="top-portal-link">Official LTCE Website &rarr;</a>
            </div>
        </div>
    </div>

    <!-- ==============================================
         2. Institutional Header (CampusConnect & LTCE Branding)
         ============================================== -->
    <header class="ltce-middle-header">
        <div class="middle-header-container">
            <!-- Left: Official LTCE College Logo & CampusConnect Master Brand -->
            <div style="display:flex; align-items:center; gap:18px;">
                <a href="https://ltce.in/" target="_blank" title="Lokmanya Tilak College of Engineering Official Site">
                    <img src="<%= cp %>/images/ltce_official_logo.png" alt="LTCE Official Logo" style="height:62px; width:auto; display:block;" onerror="this.style.display='none'">
                </a>

                <div style="height: 48px; width: 1.5px; background: #e2e8f0;"></div>

                <a href="<%= cp %>/" class="middle-brand-group" title="CampusConnect Home">
                    <img src="<%= cp %>/images/campusconnect-logo.svg" alt="CampusConnect - Lokmanya Tilak College of Engineering" class="main-portal-logo">
                </a>
            </div>

            <!-- Institutional Highlights / Academic Verification Badge -->
            <div class="middle-trust-badges">
                <div class="trust-badge-item" style="border:none; background:transparent; padding:0;">
                    <img src="<%= cp %>/images/ltce_trust_logo.jpg" alt="LTJSS Sanstha" style="height:56px; width:auto; border-radius:4px;" onerror="this.style.display='none'">
                </div>

                <div class="trust-badge-item">
                    <div class="trust-badge-icon">&#128737;</div>
                    <div class="trust-badge-content">
                        <div class="trust-badge-title">Single Source of Truth</div>
                        <div class="trust-badge-sub">Official LTCE Campus Portal</div>
                    </div>
                </div>

                <div class="trust-badge-item">
                    <div class="trust-badge-icon">&#127891;</div>
                    <div class="trust-badge-content">
                        <div class="trust-badge-title">Zero WhatsApp Chaos</div>
                        <div class="trust-badge-sub">Structured Opportunity Hub</div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- ==============================================
         3. LTCE Sapphire Navbar with Golden Underline
         ============================================== -->
    <nav class="ltce-navbar">
        <div class="navbar-container">
            <ul class="nav-menu">
                <li><a href="<%= cp %>/" class="nav-link">Home</a></li>
                <li><a href="<%= cp %>/dashboard" class="nav-link">Explore Events</a></li>
                <li><a href="<%= cp %>/clubs.jsp" class="nav-link" style="color:#fef08a; font-weight:700;">&#127891; Clubs Directory</a></li>
                <li><a href="<%= cp %>/#how-it-works" class="nav-link">How It Works</a></li>
                <% if (authUser != null) { %>
                    <% if (authUser.isAdmin()) { %>
                        <li><a href="<%= cp %>/admin/dashboard" class="nav-link nav-admin-link">&#9881; Admin Console</a></li>
                        <li><a href="<%= cp %>/admin/create-event" class="nav-link nav-post-link">+ Post Event</a></li>
                    <% } else { %>
                        <li><a href="<%= cp %>/my-registrations" class="nav-link">My Registrations</a></li>
                        <li><a href="<%= cp %>/saved-events" class="nav-link">&#9829; Saved</a></li>
                    <% } %>
                <% } %>
            </ul>

            <div class="nav-auth-actions">
                <% if (authUser == null) { %>
                    <a href="<%= cp %>/login" class="btn-nav-login">Sign In</a>
                    <a href="<%= cp %>/register" class="btn-nav-register">Student Sign Up</a>
                <% } else { %>
                    <div class="nav-user-chip">
                        <div class="user-avatar-circle"><%= authUser.getName().substring(0, 1).toUpperCase() %></div>
                        <div class="user-info-text">
                            <span class="user-name"><%= authUser.getName().split(" ")[0] %></span>
                            <span class="role-badge <%= authUser.isAdmin() ? "admin" : "student" %>"><%= authUser.getRole() %></span>
                        </div>
                        <a href="<%= cp %>/logout" class="btn-logout" title="Sign Out &bull; <%= authUser.getEmail() %>">&#x21AA;</a>
                    </div>
                <% } %>
            </div>
        </div>
    </nav>

    <main>
