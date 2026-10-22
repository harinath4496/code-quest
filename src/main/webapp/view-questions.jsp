<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.codequest.model.Admin" %>
<%@ page import="com.codequest.model.Mission" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;
    if (admin == null) {
        response.sendRedirect("admin-login.jsp?error=Please+authenticate+as+administrator");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Mission> questions = (List<Mission>) request.getAttribute("questions");
    if (questions == null) {
        response.sendRedirect("ViewQuestionsServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Question Catalog • CodeQuest Admin</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="admin-dashboard.jsp" class="nav-brand">
            <span class="brand-icon">⚔️</span>
            <span>CodeQuest Admin</span>
        </a>
        <ul class="nav-links">
            <li><a href="admin-dashboard.jsp">Overview</a></li>
            <li><a href="add-question.jsp">Add Mission</a></li>
            <li><a href="ViewQuestionsServlet" class="active">Question Catalog</a></li>
        </ul>
        <div class="nav-user">
            <span class="user-badge">🛡️ <%= admin.getUsername() %></span>
            <a href="AdminLogoutServlet" class="btn btn-outline btn-sm">Logout</a>
        </div>
    </nav>

    <main class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
            <div>
                <h1 style="font-size: 1.85rem; font-weight: 800; margin-bottom: 0.25rem;">Question Catalog</h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem;">Total <%= questions.size() %> active missions in the database repository</p>
            </div>
            <a href="add-question.jsp" class="btn btn-primary btn-sm">+ Add New Question</a>
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

        <div class="card" style="padding: 1rem;">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 50px;">ID</th>
                            <th>Mission Title</th>
                            <th>Category</th>
                            <th>Difficulty</th>
                            <th>Options</th>
                            <th>Key</th>
                            <th>XP</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Mission m : questions) {
                                String catBadge = "badge-java";
                                if ("SQL".equalsIgnoreCase(m.getCategory())) catBadge = "badge-sql";
                                else if ("DSA".equalsIgnoreCase(m.getCategory())) catBadge = "badge-dsa";

                                String diffBadge = "badge-easy";
                                if ("Medium".equalsIgnoreCase(m.getDifficulty())) diffBadge = "badge-medium";
                                else if ("Hard".equalsIgnoreCase(m.getDifficulty())) diffBadge = "badge-hard";
                        %>
                            <tr>
                                <td style="font-family: var(--font-mono); color: var(--text-muted);"><%= m.getId() %></td>
                                <td style="font-weight: 600; color: var(--text-primary);"><%= m.getTitle() %></td>
                                <td><span class="badge <%= catBadge %>"><%= m.getCategory() %></span></td>
                                <td><span class="badge <%= diffBadge %>"><%= m.getDifficulty() %></span></td>
                                <td style="font-size: 0.82rem; color: var(--text-secondary); max-width: 280px;">
                                    <div><strong>A:</strong> <%= m.getOptionA() %></div>
                                    <div><strong>B:</strong> <%= m.getOptionB() %></div>
                                    <div><strong>C:</strong> <%= m.getOptionC() %></div>
                                    <div><strong>D:</strong> <%= m.getOptionD() %></div>
                                </td>
                                <td>
                                    <span style="font-weight: 800; color: var(--accent); font-family: var(--font-mono); background-color: var(--bg-subtle); padding: 0.2rem 0.5rem; border-radius: var(--radius-sm); border: 1px solid var(--border);">
                                        <%= m.getCorrectOption() %>
                                    </span>
                                </td>
                                <td style="font-family: var(--font-mono); font-weight: 700; color: #fbbf24;">+<%= m.getXpReward() %></td>
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
        <p>&copy; 2026 CodeQuest • Administrator Control Module</p>
    </footer>

</body>
</html>
