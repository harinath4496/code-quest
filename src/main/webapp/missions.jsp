<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.codequest.model.User" %>
<%@ page import="com.codequest.model.Mission" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%
    User user = (session != null) ? (User) session.getAttribute("user") : null;
    if (user == null) {
        response.sendRedirect("login.jsp?error=Please+login+to+access+programming+missions");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Mission> missions = (List<Mission>) request.getAttribute("missions");
    if (missions == null) {
        response.sendRedirect("MissionServlet");
        return;
    }

    @SuppressWarnings("unchecked")
    Set<Integer> solvedMissionIds = (Set<Integer>) request.getAttribute("solvedMissionIds");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "ALL";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Programming Missions • CodeQuest</title>
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
                <span><%= user.getUsername() %></span>
                <span class="level-tag">LVL <%= user.getLevel() %></span>
            </div>
            <a href="LogoutServlet" class="btn btn-outline btn-sm">Logout</a>
        </div>
    </nav>

    <main class="main-content">
        <div style="margin-bottom: 2rem;">
            <h1 style="font-size: 1.85rem; font-weight: 800; margin-bottom: 0.25rem;">Programming Missions</h1>
            <p style="color: var(--text-secondary); font-size: 0.95rem;">Select your answer and submit to earn XP and advance your rank.</p>
        </div>

        <!-- Filter bar -->
        <div class="filter-bar">
            <span style="font-size: 0.85rem; font-weight: 600; color: var(--text-secondary);">Categories:</span>
            <div class="filter-pills">
                <a href="MissionServlet" class="filter-pill <%= "ALL".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">All Missions</a>
                <a href="MissionServlet?category=Java" class="filter-pill <%= "Java".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">Java</a>
                <a href="MissionServlet?category=SQL" class="filter-pill <%= "SQL".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">SQL</a>
                <a href="MissionServlet?category=DSA" class="filter-pill <%= "DSA".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">DSA</a>
            </div>
        </div>

        <!-- Missions List -->
        <div class="missions-grid">
            <%
                int index = 0;
                for (Mission m : missions) {
                    index++;
                    boolean isSolved = (solvedMissionIds != null && solvedMissionIds.contains(m.getId()));

                    String catBadge = "badge-java";
                    if ("SQL".equalsIgnoreCase(m.getCategory())) catBadge = "badge-sql";
                    else if ("DSA".equalsIgnoreCase(m.getCategory())) catBadge = "badge-dsa";

                    String diffBadge = "badge-easy";
                    if ("Medium".equalsIgnoreCase(m.getDifficulty())) diffBadge = "badge-medium";
                    else if ("Hard".equalsIgnoreCase(m.getDifficulty())) diffBadge = "badge-hard";
            %>
                <div class="mission-card <%= isSolved ? "solved" : "" %>">
                    <div class="mission-header">
                        <div>
                            <div class="mission-meta">
                                <span class="badge <%= catBadge %>"><%= m.getCategory() %></span>
                                <span class="badge <%= diffBadge %>"><%= m.getDifficulty() %></span>
                                <span class="badge badge-xp">+<%= m.getXpReward() %> XP</span>
                                <% if (isSolved) { %>
                                    <span class="badge" style="background-color: var(--success-subtle); color: var(--success); border: 1px solid rgba(16, 185, 129, 0.3);">✓ Solved</span>
                                <% } %>
                            </div>
                            <h2 style="font-size: 1.15rem; font-weight: 700; margin-top: 0.5rem; color: var(--text-primary);">
                                #<%= m.getId() %>: <%= m.getTitle() %>
                            </h2>
                        </div>
                    </div>

                    <div class="mission-desc">
                        <%= m.getDescription() %>
                    </div>

                    <form action="SubmitAnswerServlet" method="post">
                        <input type="hidden" name="missionId" value="<%= m.getId() %>">

                        <div class="options-grid">
                            <label class="option-label">
                                <input type="radio" name="selectedOption" value="A" required>
                                <span class="option-letter">A</span>
                                <span><%= m.getOptionA() %></span>
                            </label>

                            <label class="option-label">
                                <input type="radio" name="selectedOption" value="B" required>
                                <span class="option-letter">B</span>
                                <span><%= m.getOptionB() %></span>
                            </label>

                            <label class="option-label">
                                <input type="radio" name="selectedOption" value="C" required>
                                <span class="option-letter">C</span>
                                <span><%= m.getOptionC() %></span>
                            </label>

                            <label class="option-label">
                                <input type="radio" name="selectedOption" value="D" required>
                                <span class="option-letter">D</span>
                                <span><%= m.getOptionD() %></span>
                            </label>
                        </div>

                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <button type="submit" class="btn btn-primary btn-sm">
                                <%= isSolved ? "Retry Mission" : "Submit Answer" %>
                            </button>
                            <span style="font-size: 0.8rem; color: var(--text-muted);">
                                Single choice • Instant verification
                            </span>
                        </div>
                    </form>
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
