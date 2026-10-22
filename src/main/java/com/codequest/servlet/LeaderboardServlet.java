package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.codequest.model.LeaderboardEntry;
import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LeaderboardServlet")
public class LeaderboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<LeaderboardEntry> leaderboard = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT u.id, u.username, u.level, u.xp, "
                       + "       COUNT(CASE WHEN s.is_correct = 1 THEN 1 END) AS completed_missions "
                       + "FROM users u "
                       + "LEFT JOIN mission_submissions s ON u.id = s.user_id "
                       + "GROUP BY u.id, u.username, u.level, u.xp "
                       + "ORDER BY u.xp DESC, completed_missions DESC, u.username ASC";

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            int rank = 1;
            while (rs.next()) {
                LeaderboardEntry entry = new LeaderboardEntry(
                    rank++,
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getInt("level"),
                    rs.getInt("completed_missions"),
                    rs.getInt("xp")
                );
                leaderboard.add(entry);
            }

            request.setAttribute("leaderboard", leaderboard);
            request.getRequestDispatcher("leaderboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load leaderboard: " + e.getMessage());
            request.getRequestDispatcher("index.html").forward(request, response);
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
