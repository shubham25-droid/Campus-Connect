<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    </main>

    <footer>
        <div class="footer-container">
            <div class="footer-brand">
                <h4>CampusConnect &bull; LTCE</h4>
                <p style="margin-bottom: 0.75rem; color: #94a3b8; font-size: 0.875rem;">
                    The centralized college event and student opportunity platform. Solving announcement fragmentation, eliminating duplicate coordination, and connecting every student with every campus opportunity.
                </p>
                <div style="font-size:0.8rem; color:#64748b;">
                    Lokmanya Tilak College of Engineering (Autonomous)<br>
                    Sector-4, Vikas Nagar, Koparkhairane, Navi Mumbai - 400709
                </div>
            </div>

            <div class="footer-links">
                <h5>Platform</h5>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/dashboard">Discover Events</a></li>
                    <li><a href="<%= request.getContextPath() %>/my-registrations">My Registrations</a></li>
                    <li><a href="<%= request.getContextPath() %>/saved-events">Saved Opportunities</a></li>
                    <li><a href="<%= request.getContextPath() %>/login">Organizer Portal</a></li>
                </ul>
            </div>

            <div class="footer-links">
                <h5>Clubs & Bodies</h5>
                <ul>
                    <li><span style="color:#cbd5e1;">GDG on Campus LTCE</span></li>
                    <li><span style="color:#cbd5e1;">Institution Innovation Council (IIC)</span></li>
                    <li><span style="color:#cbd5e1;">AIMSA (AI & ML Association)</span></li>
                    <li><span style="color:#cbd5e1;">CSI & IEEE Student Branches</span></li>
                    <li><span style="color:#cbd5e1;">Training & Placement Cell</span></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <span>&copy; <%= java.time.Year.now() %> CampusConnect. Built for Lokmanya Tilak College of Engineering.</span>
            <span style="color:#64748b;">Java Full Stack MVC Architecture &bull; Servlets &bull; JSP &bull; MySQL &bull; JDBC</span>
        </div>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
