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
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, viewport-fit=cover">
    <meta name="theme-color" content="#082c50" media="(prefers-color-scheme: light)">
    <meta name="theme-color" content="#082c50" media="(prefers-color-scheme: dark)">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="apple-mobile-web-app-title" content="CampusConnect">
    <meta name="format-detection" content="telephone=no">
    <meta name="mobile-web-app-capable" content="yes">
    <title><%= (request.getAttribute("pageTitle") != null) ? request.getAttribute("pageTitle") + " | " : "" %>CampusConnect &bull; Lokmanya Tilak College of Engineering</title>
    
    <!-- Favicon using Official CampusConnect Emblem -->
    <link rel="icon" type="image/png" href="<%= cp %>/images/favicon.png">
    <link rel="shortcut icon" href="<%= cp %>/images/favicon.ico">
    <link rel="apple-touch-icon" href="<%= cp %>/images/campusconnect-final-logo-256.png">
    
    <!-- Modern Typography: Inter font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Primary Stylesheet with dynamic version to ensure instant browser refresh -->
    <link rel="stylesheet" href="<%= cp %>/css/style.css?v=6.7">
    
    <script>
        var contextPath = "<%= cp %>";
        function closeMobileMenu() {
            var d = document.getElementById('mobileNavDrawer');
            var o = document.getElementById('mobileDrawerOverlay');
            var t = document.getElementById('mobileMenuToggle');
            if (d) d.classList.remove('active');
            if (o) o.classList.remove('active');
            if (t) {
                t.classList.remove('active');
                t.setAttribute('aria-expanded', 'false');
            }
            document.body.style.overflow = '';
        }
        function openMobileMenu() {
            var d = document.getElementById('mobileNavDrawer');
            var o = document.getElementById('mobileDrawerOverlay');
            var t = document.getElementById('mobileMenuToggle');
            if (d) d.classList.add('active');
            if (o) o.classList.add('active');
            if (t) {
                t.classList.add('active');
                t.setAttribute('aria-expanded', 'true');
            }
            document.body.style.overflow = 'hidden';
        }
        function toggleMobileMenu(e) {
            if (e && e.preventDefault) e.preventDefault();
            if (e && e.stopPropagation) e.stopPropagation();
            var d = document.getElementById('mobileNavDrawer');
            if (d && d.classList.contains('active')) {
                closeMobileMenu();
            } else {
                openMobileMenu();
            }
        }
        window.closeMobileMenu = closeMobileMenu;
        window.openMobileMenu = openMobileMenu;
        window.toggleMobileMenu = toggleMobileMenu;
    </script>
</head>
<body>

    <!-- ==============================================
         Unified Ultra-Premium Obsidian Glass Navbar (Single Sleek Header)
         ============================================== -->
    <header class="app-header">
        <div class="header-inner">
            <!-- Co-Branded Institutional & CampusConnect Lockup -->
            <div class="brand-cluster">
                <a href="<%= cp %>/" class="brand-logo-link" title="CampusConnect • Lokmanya Tilak College of Engineering">
                    <div class="brand-crest-wrap">
                        <img src="<%= cp %>/images/ltce_official_logo.png" alt="LTCE Crest" class="brand-crest-img" onerror="this.src='<%= cp %>/images/clubs/ltce.svg'">
                    </div>
                    <span class="brand-divider-bar" aria-hidden="true"></span>
                    <div class="brand-emblem-wrap">
                        <img src="<%= cp %>/images/campusconnect-final-logo-trans.png" alt="CampusConnect Official Logo" class="brand-mark-img">
                    </div>
                    <div class="brand-text-group">
                        <div class="brand-title-row">
                            <span class="brand-main-title">Campus<span class="brand-highlight">Connect</span></span>
                            <span class="brand-clg-badge">LTCE</span>
                        </div>
                        <span class="brand-tagline">Lokmanya Tilak College of Engineering</span>
                    </div>
                </a>
            </div>

            <!-- Desktop Navigation Links -->
            <nav class="desktop-nav" aria-label="Main Navigation">
                <ul class="nav-links-list">
                    <li><a href="<%= cp %>/" class="nav-item <%= curUri.endsWith("/") || curUri.endsWith("index.jsp") ? "active" : "" %>">Home</a></li>
                    <li><a href="<%= cp %>/dashboard" class="nav-item <%= curUri.contains("dashboard") || curUri.contains("events") ? "active" : "" %>">Explore Events</a></li>
                    <li><a href="<%= cp %>/clubs.jsp" class="nav-item nav-clubs-item <%= curUri.contains("clubs") ? "active" : "" %>">
                        <svg class="nav-svg-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <span>Clubs &amp; Chapters</span>
                    </a></li>
                    <li><a href="<%= cp %>/#how-it-works" class="nav-item">How It Works</a></li>
                    
                    <% if (authUser != null) { %>
                        <% if (authUser.isAdmin()) { %>
                            <li><a href="<%= cp %>/admin/dashboard" class="nav-item nav-admin-badge">Admin</a></li>
                            <li><a href="<%= cp %>/admin/create-event" class="nav-item nav-create-badge">+ Post</a></li>
                        <% } else { %>
                            <li><a href="<%= cp %>/my-registrations" class="nav-item <%= curUri.contains("registrations") ? "active" : "" %>">My Passes</a></li>
                            <li><a href="<%= cp %>/saved-events" class="nav-item <%= curUri.contains("saved") ? "active" : "" %>">Saved</a></li>
                        <% } %>
                    <% } %>
                </ul>
            </nav>

            <!-- Right Action Area (Auth Buttons / User Chip / Mobile Toggle) -->
            <div class="header-actions">
                <a href="https://ltce.in/" target="_blank" rel="noopener noreferrer" class="btn-portal-ghost" title="Official LTCE College Portal">
                    <svg class="portal-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                    </svg>
                    <span>ltce.in</span>
                    <svg class="portal-ext-svg" width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                        <polyline points="15 3 21 3 21 9"></polyline>
                        <line x1="10" y1="14" x2="21" y2="3"></line>
                    </svg>
                </a>

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
                <button type="button" class="btn-mobile-menu" id="mobileMenuToggle" onclick="toggleMobileMenu(event)" aria-label="Toggle navigation menu" aria-expanded="false">
                    <span class="hamburger-bar"></span>
                    <span class="hamburger-bar"></span>
                    <span class="hamburger-bar"></span>
                </button>
            </div>
        </div>
    </header>

    <!-- ==============================================
         3. Mobile Navigation Drawer (Obsidian Glass, Outside Header)
         ============================================== -->
    <div class="mobile-drawer-overlay" id="mobileDrawerOverlay" onclick="closeMobileMenu()" aria-hidden="true"></div>
    <div class="mobile-drawer" id="mobileNavDrawer" role="dialog" aria-modal="true" aria-label="Navigation Menu">
        <div class="mobile-drawer-header">
            <div class="mobile-drawer-brand">
                <img src="<%= cp %>/images/campusconnect-final-logo-trans.png" alt="CampusConnect" style="height:34px; width:34px; border-radius:50%; object-fit:cover; filter:drop-shadow(0 2px 6px rgba(0,0,0,0.3));">
                <span class="mobile-drawer-title">Campus<span style="color:var(--ltce-gold);">Connect</span></span>
            </div>
            <button type="button" class="btn-drawer-close" id="mobileDrawerClose" onclick="closeMobileMenu()" aria-label="Close navigation menu">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>

        <!-- Quick Mobile Search Form -->
        <form action="<%= cp %>/dashboard" method="GET" class="mobile-drawer-search">
            <input type="text" name="search" placeholder="Search hackathons, clubs, CESA..." class="mobile-search-input" autocomplete="off">
            <button type="submit" class="mobile-search-btn" aria-label="Search">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            </button>
        </form>

        <ul class="mobile-nav-list">
            <li><a href="<%= cp %>/" class="mobile-nav-link" onclick="closeMobileMenu()">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle; margin-right:8px;"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>Home
            </a></li>
            <li><a href="<%= cp %>/dashboard" class="mobile-nav-link" onclick="closeMobileMenu()">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle; margin-right:8px;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>Explore Events
            </a></li>
            <li><a href="<%= cp %>/clubs.jsp" class="mobile-nav-link highlight" onclick="closeMobileMenu()">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle; margin-right:8px;"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>Campus Clubs Directory
            </a></li>
            <li><a href="<%= cp %>/#how-it-works" class="mobile-nav-link" onclick="closeMobileMenu()">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle; margin-right:8px;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>How It Works
            </a></li>
            
            <% if (authUser != null) { %>
                <li class="mobile-nav-divider"></li>
                <% if (authUser.isAdmin()) { %>
                    <li><a href="<%= cp %>/admin/dashboard" class="mobile-nav-link" onclick="closeMobileMenu()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle; margin-right:8px;"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>Organizer / Admin Dashboard
                    </a></li>
                    <li><a href="<%= cp %>/admin/create-event" class="mobile-nav-link" style="color:var(--ltce-gold-hover); font-weight:700;" onclick="closeMobileMenu()">+ Create New Event</a></li>
                <% } else { %>
                    <li><a href="<%= cp %>/my-registrations" class="mobile-nav-link" onclick="closeMobileMenu()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle; margin-right:8px;"><path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z"></path></svg>My Registrations &amp; Passes
                    </a></li>
                    <li><a href="<%= cp %>/saved-events" class="mobile-nav-link" onclick="closeMobileMenu()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle; margin-right:8px;"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>Saved Events
                    </a></li>
                <% } %>
            <% } %>
        </ul>

        <div class="mobile-drawer-footer">
            <% if (authUser == null) { %>
                <div class="mobile-auth-stack">
                    <a href="<%= cp %>/register" class="btn btn-clean-primary" style="width:100%; text-align:center;" onclick="closeMobileMenu()">Student Sign Up</a>
                    <a href="<%= cp %>/login" class="btn btn-clean-ghost" style="width:100%; text-align:center;" onclick="closeMobileMenu()">Organizer / Student Sign In</a>
                </div>
            <% } else { %>
                <div class="mobile-user-card">
                    <div class="user-avatar-initial" style="width:40px; height:40px; font-size:1.1rem;"><%= authUser.getName().substring(0, 1).toUpperCase() %></div>
                    <div style="flex:1;">
                        <div style="font-weight:700; color:#ffffff;"><%= authUser.getName() %></div>
                        <div style="font-size:0.8rem; color:#94a3b8;"><%= authUser.getEmail() %> &bull; <%= authUser.getRole() %></div>
                    </div>
                    <a href="<%= cp %>/logout" class="btn-logout" title="Sign Out" style="color:#f87171;">&#x21AA;</a>
                </div>
            <% } %>
            <div class="mobile-drawer-clg-note">
                Lokmanya Tilak College of Engineering<br>Koparkhairane, Navi Mumbai
            </div>
        </div>
    </div>

    <!-- ==============================================
         Native-Feel Mobile Bottom Navigation Bar (Phones: Android & iOS)
         ============================================== -->
    <nav class="mobile-bottom-nav" aria-label="Quick Mobile Navigation">
        <div class="mobile-bottom-nav-inner">
            <a href="<%= cp %>/" class="mobile-bottom-link <%= curUri.endsWith("/") || curUri.endsWith("index.jsp") ? "active" : "" %>">
                <span class="mobile-bottom-icon">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                </span>
                <span class="mobile-bottom-label">Home</span>
            </a>
            
            <a href="<%= cp %>/dashboard" class="mobile-bottom-link <%= (curUri.contains("dashboard") || curUri.contains("event-details")) && !curUri.contains("admin") ? "active" : "" %>">
                <span class="mobile-bottom-icon">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                </span>
                <span class="mobile-bottom-label">Events</span>
            </a>

            <a href="<%= cp %>/clubs.jsp" class="mobile-bottom-link <%= curUri.contains("clubs") ? "active" : "" %>">
                <span class="mobile-bottom-icon">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                </span>
                <span class="mobile-bottom-label">Clubs</span>
            </a>

            <% if (authUser != null) { %>
                <% if (authUser.isAdmin()) { %>
                    <a href="<%= cp %>/admin/dashboard" class="mobile-bottom-link <%= curUri.contains("admin") ? "active" : "" %>">
                        <span class="mobile-bottom-icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="3"></circle>
                                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                            </svg>
                        </span>
                        <span class="mobile-bottom-label">Admin</span>
                    </a>
                <% } else { %>
                    <a href="<%= cp %>/my-registrations" class="mobile-bottom-link <%= curUri.contains("registrations") ? "active" : "" %>">
                        <span class="mobile-bottom-icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z"></path>
                                <path d="M13 5v2"></path>
                                <path d="M13 17v2"></path>
                                <path d="M13 11v2"></path>
                            </svg>
                        </span>
                        <span class="mobile-bottom-label">Passes</span>
                    </a>
                <% } %>
                <a href="<%= cp %>/logout" class="mobile-bottom-link" title="Sign Out (<%= authUser.getName() %>)">
                    <span class="mobile-bottom-avatar"><%= authUser.getName().substring(0, 1).toUpperCase() %></span>
                    <span class="mobile-bottom-label"><%= authUser.getName().split(" ")[0] %></span>
                </a>
            <% } else { %>
                <a href="<%= cp %>/login" class="mobile-bottom-link <%= curUri.contains("login") || curUri.contains("register") ? "active" : "" %>">
                    <span class="mobile-bottom-icon">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </span>
                    <span class="mobile-bottom-label">Sign In</span>
                </a>
            <% } %>
        </div>
    </nav>

    <main id="main-content">
