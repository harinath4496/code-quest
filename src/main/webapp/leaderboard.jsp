<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.codequest.model.User" %>
<%@ page import="com.codequest.model.LeaderboardEntry" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (session != null) ? (User) session.getAttribute("studentUser") : null;
    if (sessionUser == null && session != null) {
        sessionUser = (User) session.getAttribute("user");
    }

    @SuppressWarnings("unchecked")
    List<LeaderboardEntry> leaderboard = (List<LeaderboardEntry>) request.getAttribute("leaderboard");
    if (leaderboard == null) {
        response.sendRedirect("LeaderboardServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Global Leaderboard • CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <span class="brand-icon">⚔️</span>
            <span>CodeQuest</span>
        </a>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <% if (sessionUser != null) { %>
                <li><a href="DashboardServlet">Dashboard</a></li>
            <% } else { %>
                <li><a href="register.jsp">Student Register</a></li>
                <li><a href="login.jsp">Student Login</a></li>
            <% } %>
            <li><a href="MissionServlet">Missions</a></li>
            <li><a href="LeaderboardServlet" class="active">Leaderboard</a></li>
        </ul>
        <div class="nav-user">
            <% if (sessionUser != null) { %>
                <div class="user-badge">
                    <span><%= sessionUser.getUsername() %></span>
                    <span class="level-tag">LVL <%= sessionUser.getLevel() %></span>
                </div>
                <a href="LogoutServlet" class="btn btn-outline btn-sm">Logout</a>
            <% } else { %>
                <a href="login.jsp" class="btn btn-primary btn-sm">Login to Play</a>
            <% } %>
        </div>
    </nav>

    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h1 style="font-size: 1.85rem; font-weight: 800; margin-bottom: 0.25rem;">Global Leaderboard</h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem;">Real-time player rankings ranked by total XP and solved missions.</p>
            </div>
            <% if (sessionUser != null) { %>
                <a href="MissionServlet" class="btn btn-primary btn-sm">Solve More Missions &rarr;</a>
            <% } %>
        </div>

        <div class="card" style="padding: 1rem;">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 80px; text-align: center;">Rank</th>
                            <th>Player</th>
                            <th>Level</th>
                            <th>Missions Solved</th>
                            <th>Total Experience</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (LeaderboardEntry entry : leaderboard) {
                                boolean isCurrent = (sessionUser != null && sessionUser.getUsername().equalsIgnoreCase(entry.getUsername()));
                                int r = entry.getRank();
                                String rankClass = "rank-other";
                                String medal = String.valueOf(r);
                                if (r == 1) { rankClass = "rank-1"; medal = "🥇"; }
                                else if (r == 2) { rankClass = "rank-2"; medal = "🥈"; }
                                else if (r == 3) { rankClass = "rank-3"; medal = "🥉"; }
                        %>
                            <tr class="<%= isCurrent ? "highlight-user" : "" %>">
                                <td style="text-align: center;">
                                    <span class="rank-badge <%= rankClass %>"><%= medal %></span>
                                </td>
                                <td>
                                    <span style="font-weight: 700; color: <%= isCurrent ? "var(--accent)" : "var(--text-primary)" %>;">
                                        <%= entry.getUsername() %>
                                    </span>
                                    <% if (isCurrent) { %>
                                        <span class="badge" style="background-color: var(--accent-subtle); color: var(--accent); margin-left: 0.5rem; font-size: 0.7rem;">YOU</span>
                                    <% } %>
                                </td>
                                <td>
                                    <span style="font-family: var(--font-mono); font-weight: 600; color: var(--text-secondary);">
                                        Level <%= entry.getLevel() %>
                                    </span>
                                </td>
                                <td style="font-family: var(--font-mono); color: var(--text-secondary);">
                                    <%= entry.getCompletedMissions() %>
                                </td>
                                <td style="font-family: var(--font-mono); font-weight: 700; color: #fbbf24;">
                                    <%= entry.getTotalXp() %> XP
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest • Java Jakarta Servlets • JSP Scriptlets • JDBC • MySQL</p>
    </footer>

</body>
</html>
