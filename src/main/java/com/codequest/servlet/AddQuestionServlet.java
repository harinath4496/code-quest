package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddQuestionServlet")
public class AddQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Protect admin route
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect("admin-login.jsp?error=Unauthorized: Admin credentials required.");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String optionA = request.getParameter("option_a");
        String optionB = request.getParameter("option_b");
        String optionC = request.getParameter("option_c");
        String optionD = request.getParameter("option_d");
        String correctOption = request.getParameter("correct_option");
        String xpRewardStr = request.getParameter("xp_reward");

        // Validation
        if (title == null || title.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            difficulty == null || difficulty.trim().isEmpty() ||
            optionA == null || optionA.trim().isEmpty() ||
            optionB == null || optionB.trim().isEmpty() ||
            optionC == null || optionC.trim().isEmpty() ||
            optionD == null || optionD.trim().isEmpty() ||
            correctOption == null || correctOption.trim().isEmpty() ||
            xpRewardStr == null || xpRewardStr.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All question fields are required.");
            request.getRequestDispatcher("add-question.jsp").forward(request, response);
            return;
        }

        int xpReward = 50;
        try {
            xpReward = Integer.parseInt(xpRewardStr.trim());
            if (xpReward <= 0) {
                request.setAttribute("errorMessage", "XP reward must be a positive integer.");
                request.getRequestDispatcher("add-question.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid XP reward number.");
            request.getRequestDispatcher("add-question.jsp").forward(request, response);
            return;
        }

        correctOption = correctOption.trim().toUpperCase();
        if (!correctOption.matches("[A-D]")) {
            request.setAttribute("errorMessage", "Correct option must be one of A, B, C, or D.");
            request.getRequestDispatcher("add-question.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO missions (title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_option, xp_reward) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setString(3, category.trim());
            ps.setString(4, difficulty.trim());
            ps.setString(5, optionA.trim());
            ps.setString(6, optionB.trim());
            ps.setString(7, optionC.trim());
            ps.setString(8, optionD.trim());
            ps.setString(9, correctOption);
            ps.setInt(10, xpReward);

            ps.executeUpdate();

            response.sendRedirect("ViewQuestionsServlet?success=New " + category + " mission created successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to save question: " + e.getMessage());
            request.getRequestDispatcher("add-question.jsp").forward(request, response);
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect("admin-login.jsp?error=Admin login required.");
            return;
        }
        response.sendRedirect("add-question.jsp");
    }
}
