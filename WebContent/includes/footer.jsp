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
                    Centralized event and student opportunity platform for Lokmanya Tilak College of Engineering.
                </p>
                <div class="footer-address">
                    Sector-4, Koparkhairane, Navi Mumbai &ndash; 400 709
                </div>
            </div>

            <!-- Quick Links -->
            <div class="footer-col-links">
                <h4>Navigation</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/dashboard">All Events</a></li>
                    <li><a href="<%= request.getContextPath() %>/clubs.jsp">Clubs Guide</a></li>
                    <li><a href="<%= request.getContextPath() %>/my-registrations">My Registrations</a></li>
                    <li><a href="<%= request.getContextPath() %>/login">Organizer Login</a></li>
                </ul>
            </div>

            <!-- External College Portals -->
            <div class="footer-col-links">
                <h4>College Links</h4>
                <ul>
                    <li><a href="https://ltce.in/" target="_blank" rel="noopener noreferrer">Official LTCE Website &rarr;</a></li>
                    <li><a href="https://ltce.in/iic-cell" target="_blank" rel="noopener noreferrer">IIC Innovation Portal</a></li>
                    <li><a href="https://ltce.in/contact.php" target="_blank" rel="noopener noreferrer">Campus Map &amp; Contact</a></li>
                </ul>
            </div>

            <!-- Policies & Terms -->
            <div class="footer-col-links">
                <h4>Legal &amp; Policies</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/privacy.jsp">Privacy Policy</a></li>
                    <li><a href="<%= request.getContextPath() %>/terms.jsp">Terms of Use</a></li>
                    <li><a href="https://ltce.in/" target="_blank" rel="noopener noreferrer">College Code of Conduct</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom-bar">
            <div class="bottom-bar-container" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                <div class="bottom-copy">
                    &copy; <%= java.time.Year.now() %> <strong>CampusConnect</strong> &bull; Lokmanya Tilak College of Engineering. All Rights Reserved.
                </div>
                <div style="display:flex; gap:14px; font-size:0.8rem;">
                    <a href="<%= request.getContextPath() %>/privacy.jsp" style="color:#94a3b8;">Privacy Policy</a>
                    <span style="color:#475569;">&bull;</span>
                    <a href="<%= request.getContextPath() %>/terms.jsp" style="color:#94a3b8;">Terms of Use</a>
                </div>
            </div>
        </div>
    </footer>

    <script src="<%= request.getContextPath() %>/js/main.js?v=6.7"></script>
</body>
</html>
