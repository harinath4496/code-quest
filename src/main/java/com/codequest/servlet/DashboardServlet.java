package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.model.User;
import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=Please log in to view your Quest Dashboard.");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        Connection conn = null;
        PreparedStatement userPs = null;
        PreparedStatement countPs = null;
        PreparedStatement totalMissionsPs = null;
        ResultSet userRs = null;
        ResultSet countRs = null;
        ResultSet totalMissionsRs = null;

        try {
            conn = DBConnection.getConnection();

            // 1. Fetch live user stats
            String userSql = "SELECT id, username, email, password, xp, level, created_at FROM users WHERE id = ?";
            userPs = conn.prepareStatement(userSql);
            userPs.setInt(1, userId);
            userRs = userPs.executeQuery();

            if (!userRs.next()) {
                response.sendRedirect("LogoutServlet");
                return;
            }

            User user = new User(
                userRs.getInt("id"),
                userRs.getString("username"),
                userRs.getString("email"),
                userRs.getString("password"),
                userRs.getInt("xp"),
                userRs.getInt("level"),
                userRs.getTimestamp("created_at")
            );

            // Update session user cache
            session.setAttribute("studentUser", user);
            session.setAttribute("userLevel", user.getLevel());
            session.setAttribute("userXp", user.getXp());

            // 2. Fetch completed missions count
            String countSql = "SELECT COUNT(*) FROM mission_submissions WHERE user_id = ? AND is_correct = 1";
            countPs = conn.prepareStatement(countSql);
            countPs.setInt(1, userId);
            countRs = countPs.executeQuery();
            int completedMissions = 0;
            if (countRs.next()) {
                completedMissions = countRs.getInt(1);
            }

            // 3. Fetch total missions count in platform
            String totalSql = "SELECT COUNT(*) FROM missions";
            totalMissionsPs = conn.prepareStatement(totalSql);
            totalMissionsRs = totalMissionsPs.executeQuery();
            int totalMissions = 0;
            if (totalMissionsRs.next()) {
                totalMissions = totalMissionsRs.getInt(1);
            }

            // 4. Progress calculation
            // Each level requires 100 XP
            int xpInCurrentLevel = user.getXp() % 100;
            int xpRequiredForNextLevel = 100 - xpInCurrentLevel;
            int levelProgressPercent = xpInCurrentLevel; // since 100 is the bucket

            request.setAttribute("currentUser", user);
            request.setAttribute("completedMissions", completedMissions);
            request.setAttribute("totalMissions", totalMissions);
            request.setAttribute("xpInCurrentLevel", xpInCurrentLevel);
            request.setAttribute("xpRequiredForNextLevel", xpRequiredForNextLevel);
            request.setAttribute("levelProgressPercent", levelProgressPercent);

            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("index.html").forward(request, response);
        } finally {
            DBConnection.close(null, countPs, countRs);
            DBConnection.close(null, totalMissionsPs, totalMissionsRs);
            DBConnection.close(conn, userPs, userRs);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
