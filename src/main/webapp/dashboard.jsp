<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.codequest.model.User" %>
<%@ page import="com.codequest.model.Submission" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
    if (sessionUser == null) {
        response.sendRedirect("login.jsp?error=Please+sign+in+to+access+dashboard");
        return;
    }

    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect("DashboardServlet");
        return;
    }

    Integer completedMissions = (Integer) request.getAttribute("completedMissions");
    if (completedMissions == null) completedMissions = 0;

    Integer totalMissions = (Integer) request.getAttribute("totalMissions");
    if (totalMissions == null) totalMissions = 0;

    @SuppressWarnings("unchecked")
    List<Submission> recentSubmissions = (List<Submission>) request.getAttribute("recentSubmissions");

    int currentLvlXp = user.getXp() % 100;
    int xpToNext = 100 - currentLvlXp;
    int progressPercent = currentLvlXp;
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
                <span><%= currentLvlXp %> / 100 XP (<%= xpToNext %> XP to Level <%= user.getLevel() + 1 %>)</span>
            </div>
            <div class="progress-track">
                <div class="progress-fill" style="width: <%= progressPercent %>%;"></div>
            </div>
        </div>

        <!-- Recent Activity Table -->
        <div class="card">
            <h3 class="card-title">Recent Submissions</h3>
            <p class="card-subtitle">Your latest mission attempts and evaluation logs.</p>

            <%
                if (recentSubmissions != null && !recentSubmissions.isEmpty()) {
            %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Mission Title</th>
                                <th>Selected Option</th>
                                <th>Outcome</th>
                                <th>Timestamp</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Submission sub : recentSubmissions) {
                            %>
                                <tr>
                                    <td style="font-weight: 600;"><%= sub.getMissionTitle() %></td>
                                    <td>
                                        <span style="font-family: var(--font-mono); font-weight: 700; color: var(--text-secondary); background: var(--bg-subtle); padding: 0.2rem 0.5rem; border-radius: var(--radius-sm); border: 1px solid var(--border);">
                                            Option <%= sub.getSelectedOption() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (sub.isCorrect()) { %>
                                            <span style="color: var(--success); font-weight: 600;">✓ Correct</span>
                                        <% } else { %>
                                            <span style="color: var(--danger); font-weight: 600;">✗ Incorrect</span>
                                        <% } %>
                                    </td>
                                    <td style="color: var(--text-muted); font-size: 0.85rem;"><%= sub.getSubmittedAt() %></td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            <%
                } else {
            %>
                <div style="text-align: center; padding: 2rem 1rem; color: var(--text-secondary);">
                    <p style="font-size: 1.1rem; margin-bottom: 0.75rem;">No mission submissions recorded yet.</p>
                    <a href="MissionServlet" class="btn btn-primary btn-sm">Begin Your First Mission &rarr;</a>
                </div>
            <%
                }
            %>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest • Java Jakarta Servlets • JSP Scriptlets • JDBC • MySQL</p>
    </footer>

</body>
</html>
