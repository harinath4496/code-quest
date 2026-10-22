package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.model.Admin;
import com.codequest.util.DBConnection;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(
    name = "AdminLoginServlet",
    urlPatterns = {"/AdminLoginServlet"},
    initParams = {
        @WebInitParam(name = "adminPortalTitle", value = "CodeQuest Operations Command Center"),
        @WebInitParam(name = "allowedDomain", value = "codequest.com")
    }
)
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String portalTitle;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        // Demonstrate ServletConfig: read servlet-specific init parameter
        portalTitle = config.getInitParameter("adminPortalTitle");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Demonstrate ServletContext: read application-wide context parameter
        ServletContext context = getServletContext();
        String appName = context.getInitParameter("appName");

        String identifier = request.getParameter("username");
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Admin username/email and password are required.");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
            return;
        }

        identifier = identifier.trim();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, username, email, password, full_name, created_at FROM admins WHERE (username = ? OR email = ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            rs = ps.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");
                if (dbPassword.equals(password)) {
                    // Successful admin authentication
                    HttpSession session = request.getSession(true);

                    Admin admin = new Admin(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getTimestamp("created_at")
                    );

                    session.setAttribute("adminUser", admin);
                    session.setAttribute("adminUsername", admin.getUsername());
                    session.setAttribute("adminFullName", admin.getFullName());
                    session.setAttribute("portalTitle", portalTitle);
                    session.setAttribute("appName", appName);

                    response.sendRedirect("admin-dashboard.jsp");
                    return;
                }
            }

            request.setAttribute("errorMessage", "Invalid administrator credentials.");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admin-login.jsp");
    }
}
