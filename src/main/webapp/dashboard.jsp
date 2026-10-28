<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.codequest.model.User" %>
<%
    User sessionUser = (session != null) ? (User) session.getAttribute("studentUser") : null;
    if (sessionUser == null && session != null) {
        sessionUser = (User) session.getAttribute("user");
    }
    if (sessionUser == null) {
        response.sendRedirect("login.jsp?error=Please+sign+in+to+access+dashboard");
        return;
    }

    User user = (User) request.getAttribute("currentUser");
    if (user == null) {
        user = (User) request.getAttribute("user");
    }
    if (user == null) {
        user = sessionUser;
    }

    Integer completedMissions = (Integer) request.getAttribute("completedMissions");
    if (completedMissions == null) completedMissions = 0;

    Integer totalMissions = (Integer) request.getAttribute("totalMissions");
    if (totalMissions == null) totalMissions = 0;

    Integer xpInCurrentLevel = (Integer) request.getAttribute("xpInCurrentLevel");
    if (xpInCurrentLevel == null) xpInCurrentLevel = user.getXp() % 100;

    Integer xpRequiredForNextLevel = (Integer) request.getAttribute("xpRequiredForNextLevel");
    if (xpRequiredForNextLevel == null) xpRequiredForNextLevel = 100 - xpInCurrentLevel;

    Integer levelProgressPercent = (Integer) request.getAttribute("levelProgressPercent");
    if (levelProgressPercent == null) levelProgressPercent = xpInCurrentLevel;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard • CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <span class="brand-icon">⚔️</span>
            <span>CodeQuest</span>
        </a>
        <ul class="nav-links">
            <li><a href="DashboardServlet" class="active">Dashboard</a></li>
            <li><a href="MissionServlet">Missions</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
        </ul>
        <div class="nav-user">
            <div class="user-badge">
                <span><%= user.getUsername() %></span>
                <span class="level-tag">LVL <%= user.getLevel() %></span>
            </div>
            <a href="LogoutServlet" class="btn btn-outline btn-sm">Logout</a>
        </div>
    </nav>

    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 1.85rem; font-weight: 800; margin-bottom: 0.25rem;">Welcome back, <%= user.getUsername() %></h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem;">Player Profile • <%= user.getEmail() %></p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="MissionServlet" class="btn btn-primary btn-sm">Solve Missions &rarr;</a>
                <a href="LeaderboardServlet" class="btn btn-outline btn-sm">Leaderboard</a>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">⭐</div>
                <div>
                    <div class="stat-value"><%= user.getLevel() %></div>
                    <div class="stat-label">Current Level</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⚡</div>
                <div>
                    <div class="stat-value"><%= user.getXp() %></div>
                    <div class="stat-label">Total Experience (XP)</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎯</div>
                <div>
                    <div class="stat-value"><%= completedMissions %> / <%= totalMissions %></div>
                    <div class="stat-label">Missions Solved</div>
                </div>
            </div>
        </div>

        <!-- XP Progress Tracker -->
        <div class="progress-container">
            <div class="progress-header">
                <span>Level <%= user.getLevel() %> Progression</span>
                <span><%= xpInCurrentLevel %> / 100 XP (<%= xpRequiredForNextLevel %> XP to Level <%= user.getLevel() + 1 %>)</span>
            </div>
            <div class="progress-track">
                <div class="progress-fill" style="width: <%= levelProgressPercent %>%;"></div>
            </div>
        </div>

        <!-- Quick Launch Cards -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.25rem;">
            <div class="card">
                <h3 class="card-title">☕ Java Challenges</h3>
                <p class="card-subtitle">Test concurrency, memory models, streams, and OOP design patterns.</p>
                <a href="MissionServlet?category=Java" class="btn btn-primary btn-sm">Explore Java &rarr;</a>
            </div>
            <div class="card">
                <h3 class="card-title">💾 SQL Quests</h3>
                <p class="card-subtitle">Solve multi-table joins, subqueries, group aggregates, and ACID isolation.</p>
                <a href="MissionServlet?category=SQL" class="btn btn-primary btn-sm">Explore SQL &rarr;</a>
            </div>
            <div class="card">
                <h3 class="card-title">🧠 Algorithmic DSA</h3>
                <p class="card-subtitle">Tackle tree traversals, dynamic programming, and Big-O complexity.</p>
                <a href="MissionServlet?category=DSA" class="btn btn-primary btn-sm">Explore DSA &rarr;</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest • Java Jakarta Servlets • JSP Scriptlets • JDBC • MySQL</p>
    </footer>

</body>
</html>
