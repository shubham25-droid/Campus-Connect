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
    <title><%= (request.getAttribute("pageTitle") != null) ? request.getAttribute("pageTitle") + " | " : "" %>CampusConnect - Connecting Students with Campus Opportunities</title>
    <link rel="stylesheet" href="<%= cp %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script>
        var contextPath = "<%= cp %>";
    </script>
</head>
<body>

    <!-- Institutional Header Strip -->
    <div class="college-bar">
        <div class="college-name">
            <span class="college-badge">LTCE</span>
            <span>Lokmanya Tilak College of Engineering &bull; Navi Mumbai</span>
        </div>
        <div class="portal-mode">
            <span>Centralized Campus Event Portal</span>
        </div>
    </div>

    <!-- Main Navigation Header -->
    <header class="navbar">
        <div class="nav-container">
            <a href="<%= cp %>/" class="brand-wrapper">
                <div class="brand-logo-icon">CC</div>
                <div class="brand-text">
                    <h1>CampusConnect</h1>
                    <span>Single Source of Truth for Campus Events</span>
                </div>
            </a>

            <nav>
                <ul class="nav-links">
                    <li><a href="<%= cp %>/dashboard">Explore Events</a></li>
                    <li><a href="<%= cp %>/#how-it-works">How It Works</a></li>
                    <% if (authUser != null) { %>
                        <% if (authUser.isAdmin()) { %>
                            <li><a href="<%= cp %>/admin/dashboard" class="btn-sm btn-outline">Admin Console</a></li>
                            <li><a href="<%= cp %>/admin/create-event" class="btn-sm btn-primary">+ Post Event</a></li>
                        <% } else { %>
                            <li><a href="<%= cp %>/my-registrations">My Registrations</a></li>
                            <li><a href="<%= cp %>/saved-events">Saved</a></li>
                        <% } %>
                    <% } %>
                </ul>
            </nav>

            <div class="nav-actions">
                <% if (authUser == null) { %>
                    <a href="<%= cp %>/login" class="btn btn-secondary btn-sm">Log In</a>
                    <a href="<%= cp %>/register" class="btn btn-primary btn-sm">Sign Up</a>
                <% } else { %>
                    <div class="user-menu-pill">
                        <div class="user-avatar"><%= authUser.getName().substring(0, 1).toUpperCase() %></div>
                        <span style="font-weight:600;"><%= authUser.getName().split(" ")[0] %></span>
                        <span class="role-tag <%= authUser.isAdmin() ? "admin" : "student" %>"><%= authUser.getRole() %></span>
                        <a href="<%= cp %>/logout" style="margin-left:6px; color:#ef4444; font-size:0.75rem; font-weight:600;">Logout</a>
                    </div>
                <% } %>
            </div>
        </div>
    </header>

    <main>
