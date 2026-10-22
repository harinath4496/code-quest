<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%
    // Check for Remembered User Cookie
    String rememberedUser = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("codequest_remembered_user".equals(c.getName())) {
                rememberedUser = c.getValue();
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login &bull; CodeQuest</title>
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
            <li><a href="register.jsp">Student Register</a></li>
            <li><a href="login.jsp" class="active">Student Login</a></li>
            <li><a href="admin-login.jsp">Admin Portal</a></li>
            <li><a href="MissionServlet">Programming Missions</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
        </ul>
        <div class="nav-user">
            <a href="register.jsp" class="btn btn-outline btn-sm">&#x1F680; Register</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="container-narrow">
            <div class="card">
                <h2 class="card-title">&#x1F511; Student Login</h2>
                <p class="card-subtitle">Enter your adventurer credentials to access missions and your dashboard.</p>

                <%
                    // Dynamic Error and Success message rendering via Scriptlets (No EL / No JSTL)
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage == null) {
                        errorMessage = request.getParameter("error");
                    }
                    String successMessage = request.getParameter("success");

                    if (errorMessage != null && !errorMessage.trim().isEmpty()) {
                %>
                    <div class="alert alert-error">
                        <span>&#x26A0;&#xFE0F;</span>
                        <span><%= errorMessage %></span>
                    </div>
                <%
                    }
                    if (successMessage != null && !successMessage.trim().isEmpty()) {
                %>
                    <div class="alert alert-success">
                        <span>&#x2705;</span>
                        <span><%= successMessage %></span>
                    </div>
                <%
                    }
                %>

                <form action="LoginServlet" method="post" autocomplete="off">
                    <div class="form-group">
                        <label for="identifier">&#x1F464; Username or Email</label>
                        <input type="text" id="identifier" name="identifier" class="form-control" 
                               value="<%= rememberedUser %>" 
                               placeholder="Enter your username or email" required autofocus>
                    </div>

                    <div class="form-group">
                        <label for="password">&#x1F512; Password</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                    </div>

                    <div class="form-check">
                        <input type="checkbox" id="remember_me" name="remember_me" <%= (!rememberedUser.isEmpty()) ? "checked" : "" %>>
                        <label for="remember_me" style="margin-bottom: 0; cursor: pointer;">Remember my username</label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">&#x2694;&#xFE0F; Enter The Quest</button>
                </form>

                <p style="margin-top: 1.5rem; text-align: center; color: var(--text-secondary); font-size: 0.9rem;">
                    Don't have an adventurer account? <a href="register.jsp" style="color: var(--accent-cyan); text-decoration: none; font-weight: 600;">Register here &rarr;</a>
                </p>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest &bull; Java Jakarta Servlets &bull; JSP Scriptlets &bull; JDBC &bull; MySQL</p>
    </footer>

</body>
</html>
