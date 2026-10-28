<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.codequest.model.Admin" %>
<%
    Admin admin = (session != null) ? (Admin) session.getAttribute("adminUser") : null;
    if (admin == null && session != null) {
        admin = (Admin) session.getAttribute("admin");
    }
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
    <title>Add Question • CodeQuest Admin</title>
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
            <li><a href="add-question.jsp" class="active">Add Mission</a></li>
            <li><a href="ViewQuestionsServlet">Question Catalog</a></li>
        </ul>
        <div class="nav-user">
            <span class="user-badge">🛡️ <%= admin.getUsername() %></span>
            <a href="AdminLogoutServlet" class="btn btn-outline btn-sm">Logout</a>
        </div>
    </nav>

    <main class="main-content">
        <div style="max-width: 720px; margin: 0 auto;">
            <div class="card">
                <h2 class="card-title">Add Programming Mission</h2>
                <p class="card-subtitle">Configure question content, options, correct answer key, and assigned XP reward.</p>

                <%
                    String errorMsg = (String) request.getAttribute("errorMessage");
                    if (errorMsg == null) {
                        errorMsg = request.getParameter("error");
                    }
                    String successMsg = request.getParameter("success");

                    if (errorMsg != null && !errorMsg.trim().isEmpty()) {
                %>
                    <div class="alert alert-error">
                        <span>⚠️</span>
                        <span><%= errorMsg %></span>
                    </div>
                <%
                    }
                    if (successMsg != null && !successMsg.trim().isEmpty()) {
                %>
                    <div class="alert alert-success">
                        <span>✅</span>
                        <span><%= successMsg %></span>
                    </div>
                <%
                    }
                %>

                <form action="AddQuestionServlet" method="post">
                    <div class="form-group">
                        <label for="title">Mission Title</label>
                        <input type="text" id="title" name="title" class="form-control" placeholder="e.g. Java Volatile Keyword Semantics" required>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label for="category">Category</label>
                            <select id="category" name="category" class="form-control" required>
                                <option value="Java">Java</option>
                                <option value="SQL">SQL</option>
                                <option value="DSA">DSA</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="difficulty">Difficulty</label>
                            <select id="difficulty" name="difficulty" class="form-control" required>
                                <option value="Easy">Easy</option>
                                <option value="Medium" selected>Medium</option>
                                <option value="Hard">Hard</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="description">Question Prompt / Code Snippet</label>
                        <textarea id="description" name="description" class="form-control" placeholder="Explain or provide snippet..." required rows="4"></textarea>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label for="option_a">Option A</label>
                            <input type="text" id="option_a" name="option_a" class="form-control" placeholder="First option" required>
                        </div>
                        <div class="form-group">
                            <label for="option_b">Option B</label>
                            <input type="text" id="option_b" name="option_b" class="form-control" placeholder="Second option" required>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label for="option_c">Option C</label>
                            <input type="text" id="option_c" name="option_c" class="form-control" placeholder="Third option" required>
                        </div>
                        <div class="form-group">
                            <label for="option_d">Option D</label>
                            <input type="text" id="option_d" name="option_d" class="form-control" placeholder="Fourth option" required>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label for="correct_option">Correct Answer Key</label>
                            <select id="correct_option" name="correct_option" class="form-control" required>
                                <option value="A">Option A</option>
                                <option value="B">Option B</option>
                                <option value="C">Option C</option>
                                <option value="D">Option D</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="xp_reward">XP Reward</label>
                            <input type="number" id="xp_reward" name="xp_reward" class="form-control" value="50" min="10" max="500" required>
                        </div>
                    </div>

                    <div style="margin-top: 1rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">Save Mission To Database</button>
                        <a href="ViewQuestionsServlet" class="btn btn-outline">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>&copy; 2026 CodeQuest • Administrator Control Module</p>
    </footer>

</body>
</html>
