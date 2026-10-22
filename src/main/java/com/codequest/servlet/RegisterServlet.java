package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Validate required fields
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All registration fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        username = username.trim();
        email = email.trim();

        if (username.length() < 3) {
            request.setAttribute("errorMessage", "Username must be at least 3 characters.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match. Please verify and retry.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Check unique username and email
            String checkSql = "SELECT username, email FROM users WHERE username = ? OR email = ?";
            checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, username);
            checkPs.setString(2, email);
            rs = checkPs.executeQuery();

            if (rs.next()) {
                String existingUser = rs.getString("username");
                String existingEmail = rs.getString("email");
                String msg;
                if (existingUser != null && existingUser.equalsIgnoreCase(username)) {
                    msg = "Username '" + username + "' is already taken. Please pick another.";
                } else {
                    msg = "Email address '" + email + "' is already registered.";
                }
                request.setAttribute("errorMessage", msg);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Insert new student starting with 0 XP and Level 1
            String insertSql = "INSERT INTO users (username, email, password, xp, level) VALUES (?, ?, ?, 0, 1)";
            insertPs = conn.prepareStatement(insertSql);
            insertPs.setString(1, username);
            insertPs.setString(2, email);
            insertPs.setString(3, password);
            insertPs.executeUpdate();

            // Redirect to login page with success notification
            response.sendRedirect("login.jsp?success=Registration successful! Enter your credentials to begin your quest.");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            DBConnection.close(null, checkPs, rs);
            DBConnection.close(conn, insertPs, null);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}
