package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SubmitAnswerServlet")
public class SubmitAnswerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=Please log in to submit your mission answer.");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String missionIdStr = request.getParameter("mission_id");
        String selectedOption = request.getParameter("selected_option");

        if (missionIdStr == null || missionIdStr.trim().isEmpty() ||
            selectedOption == null || selectedOption.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Missing mission selection or answer choice.");
            request.getRequestDispatcher("MissionServlet").forward(request, response);
            return;
        }

        int missionId;
        try {
            missionId = Integer.parseInt(missionIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("MissionServlet?error=Invalid mission ID.");
            return;
        }

        selectedOption = selectedOption.trim().toUpperCase();

        Connection conn = null;
        PreparedStatement checkSubPs = null;
        PreparedStatement missionPs = null;
        PreparedStatement userPs = null;
        PreparedStatement insertSubPs = null;
        PreparedStatement updateUserPs = null;
        ResultSet checkSubRs = null;
        ResultSet missionRs = null;
        ResultSet userRs = null;

        try {
            conn = DBConnection.getConnection();

            // 1. Enforce one-attempt-per-mission rule
            String checkSubSql = "SELECT id, is_correct, selected_option FROM mission_submissions WHERE user_id = ? AND mission_id = ?";
            checkSubPs = conn.prepareStatement(checkSubSql);
            checkSubPs.setInt(1, userId);
            checkSubPs.setInt(2, missionId);
            checkSubRs = checkSubPs.executeQuery();

            if (checkSubRs.next()) {
                request.setAttribute("alreadyAttempted", true);
                request.setAttribute("previousIsCorrect", checkSubRs.getBoolean("is_correct"));
                request.setAttribute("previousChoice", checkSubRs.getString("selected_option"));
                request.setAttribute("errorMessage", "You have already completed your attempt for this mission. One attempt per mission is permitted.");
                request.getRequestDispatcher("mission-result.jsp").forward(request, response);
                return;
            }

            // 2. Fetch mission details and correct answer
            String missionSql = "SELECT title, category, difficulty, correct_option, xp_reward FROM missions WHERE id = ?";
            missionPs = conn.prepareStatement(missionSql);
            missionPs.setInt(1, missionId);
            missionRs = missionPs.executeQuery();

            if (!missionRs.next()) {
                response.sendRedirect("MissionServlet?error=Mission not found.");
                return;
            }

            String missionTitle = missionRs.getString("title");
            String missionCategory = missionRs.getString("category");
            String missionDifficulty = missionRs.getString("difficulty");
            String correctOption = missionRs.getString("correct_option");
            int xpReward = missionRs.getInt("xp_reward");

            // 3. Fetch current user XP and level
            String userSql = "SELECT xp, level FROM users WHERE id = ? FOR UPDATE";
            userPs = conn.prepareStatement(userSql);
            userPs.setInt(1, userId);
            userRs = userPs.executeQuery();

            if (!userRs.next()) {
                response.sendRedirect("LogoutServlet");
                return;
            }

            int currentXp = userRs.getInt("xp");
            int currentLevel = userRs.getInt("level");

            boolean isCorrect = correctOption.equalsIgnoreCase(selectedOption);
            int xpEarned = isCorrect ? xpReward : 0;
            int newXp = currentXp + xpEarned;
            // Level formula: 1 + (XP / 100)
            int newLevel = 1 + (newXp / 100);
            boolean leveledUp = newLevel > currentLevel;

            // 4. Begin Database Transaction
            conn.setAutoCommit(false);

            // Record submission
            String insertSubSql = "INSERT INTO mission_submissions (user_id, mission_id, selected_option, is_correct) VALUES (?, ?, ?, ?)";
            insertSubPs = conn.prepareStatement(insertSubSql);
            insertSubPs.setInt(1, userId);
            insertSubPs.setInt(2, missionId);
            insertSubPs.setString(3, selectedOption);
            insertSubPs.setBoolean(4, isCorrect);
            insertSubPs.executeUpdate();

            // Update user XP & level if correct
            if (isCorrect) {
                String updateUserSql = "UPDATE users SET xp = ?, level = ? WHERE id = ?";
                updateUserPs = conn.prepareStatement(updateUserSql);
                updateUserPs.setInt(1, newXp);
                updateUserPs.setInt(2, newLevel);
                updateUserPs.setInt(3, userId);
                updateUserPs.executeUpdate();
            }

            // Commit transaction
            conn.commit();

            // Update session values
            session.setAttribute("userLevel", newLevel);
            session.setAttribute("userXp", newXp);

            // Forward to mission-result.jsp
            request.setAttribute("missionTitle", missionTitle);
            request.setAttribute("missionCategory", missionCategory);
            request.setAttribute("missionDifficulty", missionDifficulty);
            request.setAttribute("selectedOption", selectedOption);
            request.setAttribute("correctOption", correctOption);
            request.setAttribute("isCorrect", isCorrect);
            request.setAttribute("xpEarned", xpEarned);
            request.setAttribute("totalXp", newXp);
            request.setAttribute("level", newLevel);
            request.setAttribute("leveledUp", leveledUp);

            request.getRequestDispatcher("mission-result.jsp").forward(request, response);

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            request.setAttribute("errorMessage", "Transaction failed during answer submission: " + e.getMessage());
            request.getRequestDispatcher("MissionServlet").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ignored) {}
            }
            DBConnection.close(null, checkSubPs, checkSubRs);
            DBConnection.close(null, missionPs, missionRs);
            DBConnection.close(null, userPs, userRs);
            DBConnection.close(null, insertSubPs, null);
            DBConnection.close(conn, updateUserPs, null);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("MissionServlet");
    }
}
