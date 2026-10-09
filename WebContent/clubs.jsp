<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    request.setAttribute("pageTitle", "Campus Clubs & Student Bodies Directory");
    String cp = request.getContextPath();
%>
<jsp:include page="includes/header.jsp" />

<div class="container">

    <!-- Header Section -->
    <div style="margin-bottom: 1.75rem;">
        <div style="display:flex; align-items:center; gap:8px; margin-bottom: 0.5rem;">
            <span class="role-tag admin" style="background:#e0f2fe; color:#0369a1; font-weight:700;">STUDENT DIRECTORY</span>
            <span style="font-size:0.85rem; color:var(--text-muted);">&bull; Lokmanya Tilak College of Engineering</span>
        </div>
        <h1 class="page-title" style="font-size: 2rem;">Campus Clubs &amp; Student Bodies</h1>
        <p class="page-subtitle" style="font-size: 0.95rem; max-width: 650px;">
            Explore departmental student bodies and technical chapters at LTCE.
        </p>
    </div>

    <!-- Visual Clubs Constellation Showcase -->
    <div style="background: linear-gradient(135deg, #f8fafc 0%, #eff6ff 100%); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 1.5rem 1rem; margin-bottom: 2rem; text-align: center; box-shadow: 0 4px 16px rgba(8, 44, 80, 0.04);">
        <img src="<%= cp %>/images/campusconnect-final-logo-trans.png" alt="CampusConnect Hub Emblem" style="max-width: 380px; width: 100%; height: auto; margin: 0 auto; display: block; filter: drop-shadow(0 8px 24px rgba(8, 44, 80, 0.1));">
    </div>

    <!-- Quick Navigation / Filter Tabs -->
    <div class="clubs-filter-strip">
        <button type="button" class="cat-pill active" onclick="filterClubSection('all', this)">All Clubs</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('dept', this)">Department Bodies</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('tech', this)">Coding &amp; Tech</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('cultural', this)">Cultural &amp; Arts</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('startup', this)">Startups &amp; E-Cell</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('softskills', this)">Literature &amp; Careers</button>
    </div>

    <!-- Clubs Grid -->
    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1.25rem;" id="clubsGrid">

        <!-- 1. CESA (Computer Engineering) -->
        <div class="card club-card" data-category="dept" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #16a34a; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/cesa.png" alt="CESA" style="width: 54px; height: 54px; border-radius: 50%; object-fit: cover; border: 2px solid #16a34a; background: #000; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#f0fdf4; color:#166534; font-size:0.65rem;">Computer Engg Dept</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">CESA LTCE</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Departmental student body uniting Computer Engineering undergraduates for systems, dev battles, and tech excellence.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">CodeSprint</span>
                <span class="club-micro-tag">DSA Battles</span>
                <span class="club-micro-tag">Dev Bootcamps</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=CESA" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View CESA Events &rarr;</a>
            </div>
        </div>

        <!-- 2. AIMSA (CSE AI & ML) -->
        <div class="card club-card" data-category="dept" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #38bdf8; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/aimsa.png" alt="AIMSA" style="width: 54px; height: 54px; border-radius: 50%; object-fit: cover; border: 2px solid #38bdf8; background: #000; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#eff6ff; color:#1e40af; font-size:0.65rem;">CSE (AI &amp; ML) Dept</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">AIMSA</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Departmental home for AI &amp; ML engineers driving machine learning, robotics research, and hackathons.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">AI Hackathons</span>
                <span class="club-micro-tag">Model Training</span>
                <span class="club-micro-tag">Computer Vision</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=AIMSA" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View AIMSA Events &rarr;</a>
            </div>
        </div>

        <!-- 3. Cultural Club (AIML Dept) -->
        <div class="card club-card" data-category="dept cultural" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #ec4899; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/cultural_club.png" alt="Cultural Club" style="width: 54px; height: 54px; border-radius: 50%; object-fit: cover; border: 2px solid #ec4899; background: #fff; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#fdf2f8; color:#be185d; font-size:0.65rem;">Cultural Body &bull; AIML</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">Cultural Club</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Student cultural wing celebrating dance, music, arts, Navratri Garba, and college festive carnivals.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">Navratri Garba</span>
                <span class="club-micro-tag">Festivals</span>
                <span class="club-micro-tag">Music &amp; Arts</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=Cultural" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View Cultural Events &rarr;</a>
            </div>
        </div>

        <!-- 4. DSSA (CSE Data Science) -->
        <div class="card club-card" data-category="dept" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #f59e0b; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/dssa.png" alt="DSSA" style="width: 54px; height: 54px; border-radius: 50%; object-fit: cover; border: 2px solid #f59e0b; background: #fff; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                <div>
                    <span class="role-tag" style="background:#fef3c7; color:#92400e; font-size:0.65rem;">CSE (Data Science) Dept</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">DSSA LTCE</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Departmental student body empowering students in data pipelines, analytics, and Kaggle mentorship.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">Datathons</span>
                <span class="club-micro-tag">Tableau &amp; BI</span>
                <span class="club-micro-tag">Python Pandas</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=Data+Science" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View DSSA Events &rarr;</a>
            </div>
        </div>

        <!-- 4. GDG on Campus LTCE -->
        <div class="card club-card" data-category="tech" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #4285F4; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/gdg.png?v=3.0" alt="GDG" style="width: 54px; height: 54px; border-radius: 50%; object-fit: contain; padding: 5px; border: 2px solid #4285F4; background: #fff; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#e0f2fe; color:#0369a1; font-size:0.65rem;">Open For All Branches</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">GDG on Campus</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Google Developers community connecting campus students with global open-source ecosystems &amp; GSoC.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">Open Source</span>
                <span class="club-micro-tag">Hacktoberfest</span>
                <span class="club-micro-tag">Flutter &amp; Cloud</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=GDG" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View GDG Events &rarr;</a>
            </div>
        </div>

        <!-- 5. GFG Student Chapter -->
        <div class="card club-card" data-category="tech" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #2f8d46; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/gfg.png?v=3.0" alt="GFG" style="width: 54px; height: 54px; border-radius: 50%; object-fit: contain; padding: 4px; border: 2px solid #2f8d46; background: #fff; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#f0fdf4; color:#166534; font-size:0.65rem;">Open For All Branches</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">GFG Chapter</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Premier algorithmic coding chapter dedicated to DSA mastery, competitive programming, and placements.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">DSA Mastery</span>
                <span class="club-micro-tag">LeetCode Contests</span>
                <span class="club-micro-tag">Placement Prep</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=GFG" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View GFG Events &rarr;</a>
            </div>
        </div>

        <!-- 6. E-CELL LTCE -->
        <div class="card club-card" data-category="startup" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #0284c7; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/ecell.png" alt="E-Cell" style="width: 54px; height: 54px; border-radius: 50%; object-fit: contain; border: 2px solid #0284c7; background: #fff; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#fef3c7; color:#92400e; font-size:0.65rem;">IIT Bombay Affiliated</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">E-CELL LTCE</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Entrepreneurship cell fostering startup culture, venture pitches, and IIT Bombay E-Summit qualifiers.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">B-Plan Pitch</span>
                <span class="club-micro-tag">IITB E-Summit</span>
                <span class="club-micro-tag">Angel Connect</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=E-CELL" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View E-Cell Events &rarr;</a>
            </div>
        </div>

        <!-- 7. Technical Vidya -->
        <div class="card club-card" data-category="startup" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #475569; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/technical_vidya.png" alt="Technical Vidya" style="width: 54px; height: 54px; border-radius: 50%; object-fit: contain; border: 2px solid #475569; background: #fff; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#f1f5f9; color:#334155; font-size:0.65rem;">Open For All Branches</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">Technical Vidya</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Practical knowledge hub delivering founder masterclasses, hardware/software prototypes, and tech talks.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">Founder Talks</span>
                <span class="club-micro-tag">Seed Grants</span>
                <span class="club-micro-tag">Prototyping</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=Technical+Vidya" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View Events &rarr;</a>
            </div>
        </div>

        <!-- 8. The English Club -->
        <div class="card club-card" data-category="softskills" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #9333ea; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/english_club.png" alt="The English Club" style="width: 54px; height: 54px; border-radius: 50%; object-fit: contain; border: 2px solid #9333ea; background: #fff; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#faf5ff; color:#7e22ce; font-size:0.65rem;">Open For All Branches</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">The English Club</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Literary and communication forum training engineers in stage anchoring, collegiate debates, and GD confidence.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">Debates &amp; MUN</span>
                <span class="club-micro-tag">GD Practice</span>
                <span class="club-micro-tag">Public Speaking</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=English" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View Events &rarr;</a>
            </div>
        </div>

        <!-- 9. IIC LTCE -->
        <div class="card club-card" data-category="startup" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #f97316; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/iic.png?v=3.0" alt="IIC" style="width: 54px; height: 54px; border-radius: 50%; object-fit: contain; border: 2px solid #f97316; background: #fff; padding: 2px; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                <div>
                    <span class="role-tag" style="background:#fff7ed; color:#c2410c; font-size:0.65rem;">MoE Initiative</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">IIC LTCE</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Institution Innovation Council driving Ministry of Education patent filings, ARIIA metrics, and innovation competitions.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">Patents &amp; IPR</span>
                <span class="club-micro-tag">Project Deep Blue</span>
                <span class="club-micro-tag">Innovation Rounds</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=IIC" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View IIC Events &rarr;</a>
            </div>
        </div>

        <!-- 10. Training & Placement Cell -->
        <div class="card club-card" data-category="softskills" style="padding: 1.35rem 1.25rem 1.15rem; border-top: 4px solid #1e3a8a; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 0.85rem; align-items: center; margin-bottom: 0.75rem;">
                <img src="<%= cp %>/images/clubs/tnp.png?v=3.0" alt="T&P" style="width: 54px; height: 54px; border-radius: 50%; object-fit: contain; border: 2px solid #1e3a8a; background: #fff; padding: 2px; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                <div>
                    <span class="role-tag" style="background:#eff6ff; color:#1e40af; font-size:0.65rem;">Central Placement Wing</span>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--ltce-blue-dark); margin: 2px 0 0;">T&amp;P Cell</h3>
                </div>
            </div>
            <p style="font-size: 0.825rem; color: #475569; line-height: 1.45; margin-bottom: 0.75rem;">
                Career and recruitment cell connecting students with corporate recruiters through CRT bootcamps and interview drives.
            </p>
            <div style="display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 1rem;">
                <span class="club-micro-tag">CRT Bootcamps</span>
                <span class="club-micro-tag">GD Clinics</span>
                <span class="club-micro-tag">Campus Drives</span>
            </div>
            <div style="margin-top: auto;">
                <a href="<%= cp %>/dashboard?search=Placement" class="btn btn-outline btn-sm" style="width:100%; text-align:center;">View T&amp;P Events &rarr;</a>
            </div>
        </div>

    </div>

</div>

<script>
function filterClubSection(category, btn) {
    // Update active tab
    document.querySelectorAll('.cat-pill').forEach(b => b.classList.remove('active'));
    if (btn) btn.classList.add('active');

    const cards = document.querySelectorAll('.club-card');
    cards.forEach(card => {
        if (category === 'all' || card.getAttribute('data-category') === category) {
            card.style.display = 'flex';
        } else {
            card.style.display = 'none';
        }
    });
}
</script>

<jsp:include page="includes/footer.jsp" />
