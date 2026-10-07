<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    </main>

    <!-- ==============================================
         LTCE Institutional Footer
         ============================================== -->
    <footer class="ltce-footer">
        <div class="footer-container">
            <!-- Brand Column -->
            <div class="footer-col-brand">
                <div class="footer-brand-lockup">
                    <img src="<%= request.getContextPath() %>/images/campusconnect-final-logo-128.png" alt="CampusConnect LTCE" class="footer-brand-emblem" width="44" height="44" style="width:44px; height:44px; max-width:44px; max-height:44px; border-radius:50%; object-fit:cover; flex-shrink:0;">
                    <div class="footer-brand-text">
                        <span class="footer-brand-title">Campus<span style="color:var(--ltce-gold);">Connect</span></span>
                        <span class="footer-brand-sub">Lokmanya Tilak College of Engineering</span>
                    </div>
                </div>
                <p class="footer-desc">
                    Centralized event and student opportunity platform for Lokmanya Tilak College of Engineering. Eliminating notice board and WhatsApp clutter.
                </p>
                <div class="footer-address">
                    <strong>Lokmanya Tilak College of Engineering (Autonomous)</strong><br>
                    Sector-4, Vikas Nagar, Koparkhairane, Navi Mumbai &ndash; 400 709<br>
                    Affiliated to University of Mumbai &bull; Approved by AICTE
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
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=CESA">CESA (Computer Engg)</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=AIMSA">AIMSA (CSE AI &amp; ML)</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=Data+Science">DSSA (Data Science)</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=GDG">GDG on Campus LTCE</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=GFG">GFG Student Chapter</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=E-CELL">E-CELL LTCE</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=Technical+Vidya">Technical Vidya</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard?search=English">The English Club</a></li>
                    <li><a href="<%= request.getContextPath() %>/clubs.jsp" style="color:var(--ltce-gold); font-weight:700;">Explore All Campus Clubs &rarr;</a></li>
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
            <div class="bottom-bar-container" style="justify-content:center; text-align:center;">
                <div class="bottom-copy">
                    &copy; <%= java.time.Year.now() %> <strong>CampusConnect</strong> &bull; Lokmanya Tilak College of Engineering. All Rights Reserved.
                </div>
            </div>
        </div>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js?v=2.2"></script>
</body>
</html>
