<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.codequest.model.User" %>
<%@ page import="com.codequest.model.Mission" %>
<%
    User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
    if (sessionUser == null) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    Boolean isCorrect = (Boolean) request.getAttribute("isCorrect");
    if (isCorrect == null) {
        response.sendRedirect("MissionServlet");
        return;
    }

    String message = (String) request.getAttribute("message");
    Integer xpEarned = (Integer) request.getAttribute("xpEarned");
    if (xpEarned == null) xpEarned = 0;

    Boolean levelUp = (Boolean) request.getAttribute("levelUp");
    if (levelUp == null) levelUp = false;

    Integer newLevel = (Integer) request.getAttribute("newLevel");
    if (newLevel == null) newLevel = sessionUser.getLevel();

    Mission mission = (Mission) request.getAttribute("mission");
    String selectedOption = (String) request.getAttribute("selectedOption");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evaluation Result • CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <span class="brand-icon">⚔️</span>
            <span>CodeQuest</span>
        </a>
        <ul class="nav-links">
            <li><a href="DashboardServlet">Dashboard</a></li>
            <li><a href="MissionServlet" class="active">Missions</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
        </ul>
        <div class="nav-user">
            <div class="user-badge">
                <span><%= sessionUser.getUsername() %></span>
                <span class="level-tag">LVL <%= sessionUser.getLevel() %></span>
            </div>
            <a href="LogoutServlet" class="btn btn-outline btn-sm">Logout</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="card result-card">
            <% if (isCorrect) { %>
                <div class="result-icon">🎯</div>
                <h1 class="result-title-success">Mission Accomplished!</h1>
                <p style="color: var(--text-secondary); margin-bottom: 1.5rem; font-size: 1.05rem;"><%= message %></p>

                <% if (xpEarned > 0) { %>
                    <div style="font-family: var(--font-mono); font-size: 1.5rem; font-weight: 800; color: #fbbf24; margin-bottom: 1rem;">
                        +<%= xpEarned %> XP GAINED
                    </div>
                <% } %>

                <% if (levelUp) { %>
                    <div class="level-up-banner">
                        ⭐ LEVEL UP! You reached <strong>Level <%= newLevel %></strong>! Keep pushing!
                    </div>
                <% } %>

            <% } else { %>
                <div class="result-icon">⚠️</div>
                <h1 class="result-title-error">Incorrect Answer</h1>
                <p style="color: var(--text-secondary); margin-bottom: 1.5rem; font-size: 1.05rem;"><%= message %></p>
                <div style="background-color: var(--bg-input); padding: 1rem; border-radius: var(--radius-md); border: 1px solid var(--border); margin-bottom: 1.5rem; font-size: 0.9rem;">
                    You selected: <strong>Option <%= selectedOption %></strong>. Review the problem statement and try again!
                </div>
            <% } %>

            <% if (mission != null) { %>
                <div style="background-color: var(--bg-surface); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 1rem; margin-bottom: 2rem; text-align: left;">
                    <div style="font-size: 0.8rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600;">Mission Reviewed</div>
                    <div style="font-size: 1rem; font-weight: 700; color: var(--text-primary); margin-top: 0.25rem;"><%= mission.getTitle() %></div>
                </div>
            <% } %>

            <div style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
                <a href="MissionServlet" class="btn btn-primary">Return to Missions &rarr;</a>
                <a href="DashboardServlet" class="btn btn-outline">Player Dashboard</a>
                <a href="LeaderboardServlet" class="btn btn-outline">Leaderboard</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest • Java Jakarta Servlets • JSP Scriptlets • JDBC • MySQL</p>
    </footer>

</body>
</html>
