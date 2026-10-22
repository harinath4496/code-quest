package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.model.User;
import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember_me");

        if (identifier == null || identifier.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Please provide both identifier (username/email) and password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        identifier = identifier.trim();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, username, email, password, xp, level, created_at FROM users WHERE (username = ? OR email = ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            rs = ps.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (storedPassword.equals(password)) {
                    // Successful authentication - create HTTP Session
                    HttpSession session = request.getSession(true);

                    User user = new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getInt("xp"),
                        rs.getInt("level"),
                        rs.getTimestamp("created_at")
                    );

                    session.setAttribute("studentUser", user);
                    session.setAttribute("userId", user.getId());
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("userLevel", user.getLevel());
                    session.setAttribute("userXp", user.getXp());

                    // Cookie demonstration: remember username
                    if ("on".equalsIgnoreCase(rememberMe) || "true".equalsIgnoreCase(rememberMe)) {
                        Cookie cookie = new Cookie("codequest_remembered_user", user.getUsername());
                        cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                        response.addCookie(cookie);
                    } else {
                        // Clear cookie
                        Cookie cookie = new Cookie("codequest_remembered_user", "");
                        cookie.setMaxAge(0);
                        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                        response.addCookie(cookie);
                    }

                    // Redirect to student dashboard
                    response.sendRedirect("DashboardServlet");
                    return;
                }
            }

            // Authentication failed
            request.setAttribute("errorMessage", "Invalid username/email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database connection error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
