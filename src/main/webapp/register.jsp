<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration &bull; CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <span class="brand-icon">&#x2694;&#xFE0F;</span>
            <span>CodeQuest</span>
        </a>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="register.jsp" class="active">Student Register</a></li>
            <li><a href="login.jsp">Student Login</a></li>
            <li><a href="admin-login.jsp">Admin Portal</a></li>
            <li><a href="MissionServlet">Programming Missions</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
        </ul>
        <div class="nav-user">
            <a href="login.jsp" class="btn btn-outline btn-sm">&#x1F511; Login</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="container-narrow">
            <div class="card">
                <h2 class="card-title">&#x1F680; Player Registration</h2>
                <p class="card-subtitle">Create your CodeQuest adventurer profile to begin solving missions.</p>

                <%
                    // Dynamic Error and Success message rendering via Scriptlets (No EL / No JSTL)
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage == null) {
                        errorMessage = request.getParameter("error");
                    }
                    if (errorMessage != null && !errorMessage.trim().isEmpty()) {
                %>
                    <div class="alert alert-error">
                        <span>&#x26A0;&#xFE0F;</span>
                        <span><%= errorMessage %></span>
                    </div>
                <%
                    }
                %>

                <form action="RegisterServlet" method="post" autocomplete="off">
                    <div class="form-group">
                        <label for="username">&#x1F464; Player Username</label>
                        <input type="text" id="username" name="username" class="form-control" placeholder="e.g. NeoCoder42" required autofocus minlength="3">
                    </div>

                    <div class="form-group">
                        <label for="email">&#x2709;&#xFE0F; Email Address</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="player@codequest.org" required>
                    </div>

                    <div class="form-group">
                        <label for="password">&#x1F512; Password</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Create strong password" required minlength="4">
                    </div>

                    <div class="form-group">
                        <label for="confirm_password">&#x1F510; Confirm Password</label>
                        <input type="password" id="confirm_password" name="confirm_password" class="form-control" placeholder="Re-type your password" required minlength="4">
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">&#x2694;&#xFE0F; Initialize Quest Account</button>
                </form>

                <p style="margin-top: 1.5rem; text-align: center; color: var(--text-secondary); font-size: 0.9rem;">
                    Already registered? <a href="login.jsp" style="color: var(--accent-cyan); text-decoration: none; font-weight: 600;">Sign in here &rarr;</a>
                </p>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest &bull; Java Jakarta Servlets &bull; JSP Scriptlets &bull; JDBC &bull; MySQL</p>
    </footer>

</body>
</html>
