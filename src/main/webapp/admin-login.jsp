<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal • CodeQuest</title>
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
            <li><a href="register.jsp">Student Register</a></li>
            <li><a href="login.jsp">Student Login</a></li>
            <li><a href="admin-login.jsp" class="active">Admin Portal</a></li>
            <li><a href="MissionServlet">Programming Missions</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
        </ul>
        <div class="nav-user">
            <a href="login.jsp" class="btn btn-outline btn-sm">Student Area</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="container-narrow">
            <div class="card">
                <h2 class="card-title">🛡️ Admin Portal</h2>
                <p class="card-subtitle">Authenticate to manage programming missions and inspection metrics.</p>

                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage == null) {
                        errorMessage = request.getParameter("error");
                    }
                    if (errorMessage != null && !errorMessage.trim().isEmpty()) {
                %>
                    <div class="alert alert-error">
                        <span>⚠️</span>
                        <span><%= errorMessage %></span>
                    </div>
                <%
                    }
                %>

                <form action="AdminLoginServlet" method="post" autocomplete="off">
                    <div class="form-group">
                        <label for="username">Admin Username</label>
                        <input type="text" id="username" name="username" class="form-control" placeholder="admin" required autofocus>
                    </div>

                    <div class="form-group">
                        <label for="password">Security Password</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">Authenticate System</button>
                </form>

                <p style="margin-top: 1.5rem; text-align: center; color: var(--text-muted); font-size: 0.85rem;">
                    Default Instructor Account: <code style="color: var(--accent); font-family: var(--font-mono);">admin</code>
                </p>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest • Jakarta Servlets • JSP Scriptlets • JDBC • MySQL</p>
    </footer>

</body>
</html>
