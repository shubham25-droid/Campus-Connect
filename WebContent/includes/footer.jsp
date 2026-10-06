<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    </main>

    <!-- ==============================================
         LTCE Institutional Footer
         ============================================== -->
    <footer class="ltce-footer">
        <div class="footer-container">
            <!-- Brand Column -->
            <div class="footer-col-brand">
                <img src="<%= request.getContextPath() %>/images/campusconnect-logo-white.svg" alt="CampusConnect LTCE" class="footer-brand-logo">
                <p class="footer-desc">
                    The centralized college event and student opportunity platform for Lokmanya Tilak College of Engineering. Eliminating WhatsApp announcement fatigue, establishing a single source of truth, and empowering students to discover every campus opportunity.
                </p>
                <div class="footer-address">
                    <strong>Lokmanya Tilak College of Engineering (Autonomous)</strong><br>
                    Sector-4, Vikas Nagar, Koparkhairane, Navi Mumbai &ndash; 400 709, Maharashtra, India<br>
                    Affiliated to University of Mumbai &bull; Approved by AICTE, New Delhi
                </div>
            </div>

            <!-- Quick Links -->
            <div class="footer-col-links">
                <h4>Platform Navigation</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/">Home Portal</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard">Explore Events</a></li>
                    <li><a href="<%= request.getContextPath() %>/my-registrations">My Registrations &amp; Passes</a></li>
                    <li><a href="<%= request.getContextPath() %>/saved-events">Bookmarked Opportunities</a></li>
                    <li><a href="<%= request.getContextPath() %>/login">Organizer &amp; Admin Sign In</a></li>
                </ul>
            </div>

            <!-- Campus Chapters & Student Bodies -->
            <div class="footer-col-links">
                <h4>Clubs &amp; Student Bodies</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=GDG">Google Developer Groups (GDG)</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=AIMSA">AIMSA (CSE AI &amp; ML)</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=IIC">Institution Innovation Council (IIC)</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=CSI">CSI &amp; IEEE Student Chapters</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=Placement">Training &amp; Placement Cell (T&amp;P)</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=Hackathon">LTCE Innovation &amp; SIH Cell</a></li>
                </ul>
            </div>

            <!-- External College Portals -->
            <div class="footer-col-links">
                <h4>College Links</h4>
                <ul>
                    <li><a href="https://ltce.in/" target="_blank" rel="noopener noreferrer">Official LTCE Website &rarr;</a></li>
                    <li><a href="https://ltce.in/iic-cell" target="_blank" rel="noopener noreferrer">IIC Innovation Portal</a></li>
                    <li><a href="https://ltce.in/contact.php" target="_blank" rel="noopener noreferrer">Campus Directory &amp; Map</a></li>
                    <li><a href="https://enquiry.ltjss.net/new_admission_enquiry/" target="_blank" rel="noopener noreferrer">Admissions Enquiry</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom-bar">
            <div class="bottom-bar-container">
                <div class="bottom-copy">
                    &copy; <%= java.time.Year.now() %> <strong>CampusConnect</strong> &bull; Lokmanya Tilak College of Engineering. All Rights Reserved.
                </div>
                <div class="bottom-tech-pill">
                    Java Full Stack MVC Architecture &bull; Servlets &bull; JSP &bull; JDBC &bull; MySQL
                </div>
            </div>
        </div>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
