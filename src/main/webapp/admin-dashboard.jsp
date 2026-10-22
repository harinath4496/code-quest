<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.codequest.model.Admin" %>
<%
    Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;
    if (admin == null) {
        response.sendRedirect("admin-login.jsp?error=Please+authenticate+as+administrator");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard • CodeQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="admin-dashboard.jsp" class="nav-brand">
            <span class="brand-icon">⚔️</span>
            <span>CodeQuest Admin</span>
        </a>
        <ul class="nav-links">
            <li><a href="admin-dashboard.jsp" class="active">Overview</a></li>
            <li><a href="add-question.jsp">Add Mission</a></li>
            <li><a href="ViewQuestionsServlet">Question Catalog</a></li>
        </ul>
        <div class="nav-user">
            <span class="user-badge">🛡️ <%= admin.getUsername() %></span>
            <a href="AdminLogoutServlet" class="btn btn-outline btn-sm">Logout</a>
        </div>
    </nav>

    <main class="main-content">
        <div style="margin-bottom: 2rem;">
            <h1 style="font-size: 1.85rem; font-weight: 800; margin-bottom: 0.25rem;">Command Overview</h1>
            <p style="color: var(--text-secondary); font-size: 0.95rem;">Logged in as <strong><%= admin.getFullName() %></strong> (<%= admin.getEmail() %>)</p>
        </div>

        <%
            String successMsg = request.getParameter("success");
            if (successMsg != null && !successMsg.trim().isEmpty()) {
        %>
            <div class="alert alert-success">
                <span>✅</span>
                <span><%= successMsg %></span>
            </div>
        <%
            }
        %>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">📝</div>
                <div>
                    <div class="stat-value">Authoring</div>
                    <div class="stat-label">Create new programming challenges</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📚</div>
                <div>
                    <div class="stat-value">Curriculum</div>
                    <div class="stat-label">Java, SQL, DSA categories</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⚡</div>
                <div>
                    <div class="stat-value">Scoring</div>
                    <div class="stat-label">Dynamic XP level rewards</div>
                </div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; margin-top: 1rem;">
            <div class="card">
                <h3 class="card-title">Add New Mission</h3>
                <p class="card-subtitle">Formulate new questions with options, difficulty tier, and XP reward values.</p>
                <a href="add-question.jsp" class="btn btn-primary">Go to Author Form &rarr;</a>
            </div>

            <div class="card">
                <h3 class="card-title">View All Questions</h3>
                <p class="card-subtitle">Inspect the full mission catalog, review options, and verify answer configurations.</p>
                <a href="ViewQuestionsServlet" class="btn btn-outline">Open Question Table &rarr;</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest • Administrator Control Module</p>
    </footer>

</body>
</html>
