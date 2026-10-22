package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.codequest.model.Mission;
import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MissionServlet")
public class MissionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer currentUserId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        String selectedCategory = request.getParameter("category");
        String selectedDifficulty = request.getParameter("difficulty");

        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement solvedPs = null;
        ResultSet rs = null;
        ResultSet solvedRs = null;

        List<Mission> missions = new ArrayList<>();
        Set<Integer> solvedMissionIds = new HashSet<>();

        try {
            conn = DBConnection.getConnection();

            // 1. Fetch completed mission IDs for logged in student
            if (currentUserId != null) {
                String solvedSql = "SELECT mission_id FROM mission_submissions WHERE user_id = ? AND is_correct = 1";
                solvedPs = conn.prepareStatement(solvedSql);
                solvedPs.setInt(1, currentUserId);
                solvedRs = solvedPs.executeQuery();
                while (solvedRs.next()) {
                    solvedMissionIds.add(solvedRs.getInt("mission_id"));
                }
            }

            // 2. Query questions with dynamic category and difficulty filtering
            StringBuilder sql = new StringBuilder(
                "SELECT id, title, description, category, difficulty, option_a, option_b, option_c, option_d, xp_reward, created_at FROM missions WHERE 1=1"
            );
            List<Object> params = new ArrayList<>();

            if (selectedCategory != null && !selectedCategory.trim().isEmpty() && !"ALL".equalsIgnoreCase(selectedCategory)) {
                sql.append(" AND category = ?");
                params.add(selectedCategory.trim());
            }

            if (selectedDifficulty != null && !selectedDifficulty.trim().isEmpty() && !"ALL".equalsIgnoreCase(selectedDifficulty)) {
                sql.append(" AND difficulty = ?");
                params.add(selectedDifficulty.trim());
            }

            sql.append(" ORDER BY id ASC");

            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                int missionId = rs.getInt("id");

                // Note: correct_option is deliberately NOT selected from MySQL to protect integrity!
                Mission m = new Mission();
                m.setId(missionId);
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setCategory(rs.getString("category"));
                m.setDifficulty(rs.getString("difficulty"));
                m.setOptionA(rs.getString("option_a"));
                m.setOptionB(rs.getString("option_b"));
                m.setOptionC(rs.getString("option_c"));
                m.setOptionD(rs.getString("option_d"));
                m.setCorrectOption(null); // Explicitly sanitized
                m.setXpReward(rs.getInt("xp_reward"));
                m.setCreatedAt(rs.getTimestamp("created_at"));
                m.setSolvedByCurrentUser(solvedMissionIds.contains(missionId));

                missions.add(m);
            }

            request.setAttribute("missionsList", missions);
            request.setAttribute("activeCategory", (selectedCategory == null || selectedCategory.isEmpty()) ? "ALL" : selectedCategory);
            request.setAttribute("activeDifficulty", (selectedDifficulty == null || selectedDifficulty.isEmpty()) ? "ALL" : selectedDifficulty);

            request.getRequestDispatcher("missions.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading missions: " + e.getMessage());
            request.getRequestDispatcher("index.html").forward(request, response);
        } finally {
            DBConnection.close(null, solvedPs, solvedRs);
            DBConnection.close(conn, ps, rs);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
