<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    String cp = request.getContextPath();
    User authUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
    String curUri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0">
    <title><%= (request.getAttribute("pageTitle") != null) ? request.getAttribute("pageTitle") + " | " : "" %>CampusConnect &bull; Lokmanya Tilak College of Engineering</title>
    
    <!-- Favicon using CampusConnect Logo Mark -->
    <link rel="icon" type="image/svg+xml" href="<%= cp %>/images/campusconnect-mark.svg">
    <link rel="shortcut icon" href="<%= cp %>/images/campusconnect-mark.svg">
    
    <!-- Modern Typography: Inter font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Primary Stylesheet -->
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
    
    <script>
        var contextPath = "<%= cp %>";
    </script>
</head>
<body>

    <!-- ==============================================
         1. Ultra-clean Institutional Micro Bar
         ============================================== -->
    <div class="inst-micro-bar">
        <div class="inst-bar-inner">
            <div class="inst-info-left">
                <span class="inst-trust-title">Lokmanya Tilak Jankalyan Shikshan Sanstha's</span>
                <span class="inst-sep">&bull;</span>
                <span class="inst-clg-name">Autonomous Institute &bull; Affiliated to University of Mumbai</span>
                <span class="inst-badge naac">NAAC 'A' GRADE</span>
                <span class="inst-badge nba">NBA ACCREDITED</span>
            </div>
            <div class="inst-info-right">
                <a href="https://ltce.in/" target="_blank" rel="noopener noreferrer" class="inst-link">
                    Official LTCE Portal <span>&rarr;</span>
                </a>
            </div>
        </div>
    </div>

    <!-- ==============================================
         2. Sticky Unified Main Navbar (Modern & Clean)
         ============================================== -->
    <header class="app-header">
        <div class="header-inner">
            <!-- Brand Lockup: College Crest + App Mark + Clean Typography -->
            <div class="brand-cluster">
                <a href="https://ltce.in/" target="_blank" class="clg-crest-link" title="Lokmanya Tilak College of Engineering">
                    <img src="<%= cp %>/images/ltce_official_logo.png" alt="LTCE Crest" class="clg-crest-img" onerror="this.style.display='none'">
                </a>
                <div class="brand-divider"></div>
                <a href="<%= cp %>/" class="brand-logo-link" title="CampusConnect Home">
                    <div class="brand-text-group">
                        <span class="brand-main-title">Campus<span class="brand-highlight">Connect</span></span>
                        <span class="brand-tagline">LTCE OPPORTUNITY BOARD</span>
                    </div>
                </a>
            </div>

            <!-- Desktop Navigation Links -->
            <nav class="desktop-nav" aria-label="Main Navigation">
                <ul class="nav-links-list">
                    <li><a href="<%= cp %>/" class="nav-item <%= curUri.endsWith("/") || curUri.endsWith("index.jsp") ? "active" : "" %>">Home</a></li>
                    <li><a href="<%= cp %>/dashboard" class="nav-item <%= curUri.contains("dashboard") || curUri.contains("events") ? "active" : "" %>">Explore Events</a></li>
                    <li><a href="<%= cp %>/clubs.jsp" class="nav-item nav-clubs-item <%= curUri.contains("clubs") ? "active" : "" %>">
                        <span class="nav-icon">&#127891;</span> Clubs &amp; Chapters <span class="nav-counter">10</span>
                    </a></li>
                    <li><a href="<%= cp %>/#how-it-works" class="nav-item">How It Works</a></li>
                    
                    <% if (authUser != null) { %>
                        <% if (authUser.isAdmin()) { %>
                            <li><a href="<%= cp %>/admin/dashboard" class="nav-item nav-admin-badge">&#9881; Admin</a></li>
                            <li><a href="<%= cp %>/admin/create-event" class="nav-item nav-create-badge">+ Post</a></li>
                        <% } else { %>
                            <li><a href="<%= cp %>/my-registrations" class="nav-item <%= curUri.contains("registrations") ? "active" : "" %>">&#128197; My Passes</a></li>
                            <li><a href="<%= cp %>/saved-events" class="nav-item <%= curUri.contains("saved") ? "active" : "" %>">&#9829; Saved</a></li>
                        <% } %>
                    <% } %>
                </ul>
            </nav>

            <!-- Right Action Area (Auth Buttons / User Chip / Mobile Toggle) -->
            <div class="header-actions">
                <% if (authUser == null) { %>
                    <a href="<%= cp %>/login" class="btn-clean-ghost">Sign In</a>
                    <a href="<%= cp %>/register" class="btn-clean-primary">Get Started</a>
                <% } else { %>
                    <div class="user-pill">
                        <div class="user-avatar-initial"><%= authUser.getName().substring(0, 1).toUpperCase() %></div>
                        <div class="user-pill-meta">
                            <span class="user-pill-name"><%= authUser.getName().split(" ")[0] %></span>
                            <span class="user-pill-role <%= authUser.isAdmin() ? "admin" : "student" %>"><%= authUser.getRole() %></span>
                        </div>
                        <a href="<%= cp %>/logout" class="user-pill-logout" title="Sign Out">&#x21AA;</a>
                    </div>
                <% } %>

                <!-- Mobile Hamburger Menu Button -->
                <button type="button" class="btn-mobile-menu" id="mobileMenuToggle" aria-label="Toggle navigation menu" aria-expanded="false">
                    <span class="hamburger-bar"></span>
                    <span class="hamburger-bar"></span>
                    <span class="hamburger-bar"></span>
                </button>
            </div>
        </div>

        <!-- ==============================================
             3. Mobile Navigation Drawer (Optimized for Phones)
             ============================================== -->
        <div class="mobile-drawer-overlay" id="mobileDrawerOverlay"></div>
        <div class="mobile-drawer" id="mobileNavDrawer">
            <div class="mobile-drawer-header">
                <div class="mobile-drawer-brand">
                    <img src="<%= cp %>/images/campusconnect-mark.svg" alt="CampusConnect" style="height:28px; width:28px;">
                    <span style="font-weight:800; font-size:1.15rem; color:var(--ltce-blue-dark);">Campus<span style="color:var(--ltce-gold);">Connect</span></span>
                </div>
                <button type="button" class="btn-drawer-close" id="mobileDrawerClose" aria-label="Close menu">&times;</button>
            </div>

            <!-- Quick Mobile Search Form -->
            <form action="<%= cp %>/dashboard" method="GET" class="mobile-drawer-search">
                <input type="text" name="search" placeholder="Search hackathons, clubs, CESA..." class="mobile-search-input">
                <button type="submit" class="mobile-search-btn">&#128269;</button>
            </form>

            <ul class="mobile-nav-list">
                <li><a href="<%= cp %>/" class="mobile-nav-link">&#127968; Home</a></li>
                <li><a href="<%= cp %>/dashboard" class="mobile-nav-link">&#128197; Explore Events</a></li>
                <li><a href="<%= cp %>/clubs.jsp" class="mobile-nav-link highlight">&#127891; Campus Clubs Directory (10)</a></li>
                <li><a href="<%= cp %>/#how-it-works" class="mobile-nav-link">&#9889; How It Works</a></li>
                
                <% if (authUser != null) { %>
                    <li class="mobile-nav-divider"></li>
                    <% if (authUser.isAdmin()) { %>
                        <li><a href="<%= cp %>/admin/dashboard" class="mobile-nav-link">&#9881; Organizer / Admin Dashboard</a></li>
                        <li><a href="<%= cp %>/admin/create-event" class="mobile-nav-link" style="color:var(--ltce-gold-hover); font-weight:700;">+ Create New Event</a></li>
                    <% } else { %>
                        <li><a href="<%= cp %>/my-registrations" class="mobile-nav-link">&#127915; My Registrations &amp; Passes</a></li>
                        <li><a href="<%= cp %>/saved-events" class="mobile-nav-link">&#9829; Saved Events</a></li>
                    <% } %>
                <% } %>
            </ul>

            <div class="mobile-drawer-footer">
                <% if (authUser == null) { %>
                    <div class="mobile-auth-stack">
                        <a href="<%= cp %>/register" class="btn btn-clean-primary" style="width:100%; text-align:center;">Student Sign Up</a>
                        <a href="<%= cp %>/login" class="btn btn-clean-ghost" style="width:100%; text-align:center;">Organizer / Student Sign In</a>
                    </div>
                <% } else { %>
                    <div class="mobile-user-card">
                        <div class="user-avatar-initial" style="width:40px; height:40px; font-size:1.1rem;"><%= authUser.getName().substring(0, 1).toUpperCase() %></div>
                        <div style="flex:1;">
                            <div style="font-weight:700; color:var(--ltce-blue-dark);"><%= authUser.getName() %></div>
                            <div style="font-size:0.8rem; color:var(--text-muted);"><%= authUser.getEmail() %> &bull; <%= authUser.getRole() %></div>
                        </div>
                        <a href="<%= cp %>/logout" class="btn-logout" title="Sign Out">&#x21AA;</a>
                    </div>
                <% } %>
                <div class="mobile-drawer-clg-note">
                    Lokmanya Tilak College of Engineering (Autonomous)<br>Koparkhairane, Navi Mumbai
                </div>
            </div>
        </div>
    </header>

    <main id="main-content">
