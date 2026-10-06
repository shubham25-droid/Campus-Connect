<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    request.setAttribute("pageTitle", "Campus Clubs & Student Bodies Directory");
    String cp = request.getContextPath();
%>
<jsp:include page="includes/header.jsp" />

<div class="container">

    <!-- Header Section -->
    <div style="margin-bottom: 2.25rem;">
        <div style="display:flex; align-items:center; gap:8px; margin-bottom: 0.5rem;">
            <span class="role-tag admin" style="background:#e0f2fe; color:#0369a1; font-weight:700;">STUDENT ORIENTATION GUIDE</span>
            <span style="font-size:0.85rem; color:var(--text-muted);">&bull; Lokmanya Tilak College of Engineering</span>
        </div>
        <h1 class="page-title" style="font-size: 2.25rem;">Campus Clubs &amp; Student Chapters Directory</h1>
        <p class="page-subtitle" style="font-size: 1.05rem; max-width: 780px;">
            Confused about which club to join? Explore all official departmental student bodies and college-wide technical chapters. Learn what each club does, their core activities, and which one fits your career goals.
        </p>
    </div>

    <!-- Quick Navigation / Filter Tabs -->
    <div style="display:flex; gap:0.75rem; flex-wrap:wrap; margin-bottom: 2rem; border-bottom: 1px solid var(--border-color); padding-bottom: 1rem;">
        <button type="button" class="cat-pill active" onclick="filterClubSection('all', this)">All Clubs &amp; Chapters</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('dept', this)">Department-Specific (AIMSA, CESA, DSSA)</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('tech', this)">Coding &amp; Open Source (GDG, GFG)</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('startup', this)">Startups &amp; E-Cell (Technical Vidya, E-Cell IITB)</button>
        <button type="button" class="cat-pill" onclick="filterClubSection('softskills', this)">Literature &amp; Soft Skills (English Club)</button>
    </div>

    <!-- Clubs Grid -->
    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1.5rem;" id="clubsGrid">

        <!-- 1. CESA (Computer Engineering) -->
        <div class="card club-card" data-category="dept" style="padding: 1.75rem; border-top: 4px solid #16a34a; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/cesa.png" alt="CESA Logo" style="width: 72px; height: 72px; border-radius: 50%; object-fit: cover; border: 2px solid #16a34a; background: #000; box-shadow: 0 2px 6px rgba(0,0,0,0.15);">
                <div>
                    <span class="role-tag" style="background:#f0fdf4; color:#166534; border:1px solid #bbf7d0; font-size:0.7rem;">Computer Engg Department Only</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">CESA LTCE</h3>
                    <div style="font-size: 0.8rem; color: #16a34a; font-weight: 600;">Computer Engineering Students Association</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                The official departmental association uniting all Computer Engineering undergraduates at LTCE with a focus on core software engineering and technical excellence.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">Computer Engineering branch students passionate about system software, Web &amp; App development, departmental representation, and coding battles.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> CodeSprint Hackathons, Technical Paper Presentations, Linux &amp; Git Bootcamps, Departmental Sports Meet.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=CESA" class="btn btn-outline btn-sm" style="flex:1;">View CESA Events &rarr;</a>
            </div>
        </div>

        <!-- 2. AIMSA (CSE AI & ML) -->
        <div class="card club-card" data-category="dept" style="padding: 1.75rem; border-top: 4px solid #38bdf8; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/aimsa.png" alt="AIMSA Logo" style="width: 72px; height: 72px; border-radius: 50%; object-fit: cover; border: 2px solid #38bdf8; background: #000; box-shadow: 0 2px 6px rgba(0,0,0,0.15);">
                <div>
                    <span class="role-tag" style="background:#eff6ff; color:#1e40af; border:1px solid #bfdbfe; font-size:0.7rem;">CSE (AI &amp; ML) Department Only</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">AIMSA</h3>
                    <div style="font-size: 0.8rem; color: #0284c7; font-weight: 600;">"Redefining the Future"</div>
                </div>
            </div>
            
            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                <strong>Artificial Intelligence &amp; Machine Learning Student Association</strong> &ndash; The departmental home for all AI &amp; ML engineering students at LTCE.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">CSE (AI &amp; ML) students eager to work on Machine Learning algorithms, Computer Vision, Generative AI models, and robotics research.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> AI Hackathons, Hands-on Model Training, Industry Guest Sessions, Sustainability Poster Competitions.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=AIMSA" class="btn btn-outline btn-sm" style="flex:1;">View AIMSA Events &rarr;</a>
            </div>
        </div>

        <!-- 3. DSSA (CSE Data Science) -->
        <div class="card club-card" data-category="dept" style="padding: 1.75rem; border-top: 4px solid #f59e0b; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/dssa.png" alt="DSSA Logo" style="width: 72px; height: 72px; border-radius: 50%; object-fit: cover; border: 2px solid #f59e0b; background: #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                <div>
                    <span class="role-tag" style="background:#fef3c7; color:#92400e; border:1px solid #fde68a; font-size:0.7rem;">CSE (Data Science) Department Only</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">DSSA LTCE</h3>
                    <div style="font-size: 0.8rem; color: #d97706; font-weight: 600;">Data Science Students Association</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                Departmental student chapter catering to big data pipelines, statistical modeling, data visualization, and Kaggle competition mentorship.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">CSE (Data Science) students aiming for careers as Data Engineers, Business Intelligence Analysts, or Big Data architects.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> Kaggle Datathons, Tableau &amp; PowerBI workshops, Data visualization sprints, Python Pandas masterclasses.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=Data+Science" class="btn btn-outline btn-sm" style="flex:1;">View DSSA Events &rarr;</a>
            </div>
        </div>

        <!-- 4. GDG on Campus LTCE -->
        <div class="card club-card" data-category="tech" style="padding: 1.75rem; border-top: 4px solid #4285F4; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/gdg.svg" alt="GDG Logo" style="width: 72px; height: 72px; border-radius: 16px; object-fit: contain; border: 1px solid #e2e8f0; background: #fff; padding: 4px; box-shadow: 0 2px 6px rgba(0,0,0,0.08);">
                <div>
                    <span class="role-tag" style="background:#e0f2fe; color:#0369a1; border:1px solid #bae6fd; font-size:0.7rem;">Open for ALL Branches &amp; Years</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">GDG on Campus</h3>
                    <div style="font-size: 0.8rem; color: #4285F4; font-weight: 600;">Google Developer Groups LTCE</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                Official Google Developers student community connecting students with global open-source ecosystems, Hacktoberfest, and industry developer mentorship.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">Anyone across ALL departments who wants to contribute to Open Source, prepare for GSoC (Google Summer of Code), learn Flutter/Cloud/Firebase, and win Devcon passes &amp; MLH swag.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> Hacktoberfest Sprints, Google Cloud Study Jams, Android Study Jams, Speaker Sessions by Tech Founders.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=GDG" class="btn btn-outline btn-sm" style="flex:1;">View GDG Events &rarr;</a>
            </div>
        </div>

        <!-- 5. GFG Student Chapter -->
        <div class="card club-card" data-category="tech" style="padding: 1.75rem; border-top: 4px solid #2f8d46; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/gfg.svg" alt="GFG Logo" style="width: 72px; height: 72px; border-radius: 16px; object-fit: contain; border: 1px solid #e2e8f0; background: #fff; padding: 4px; box-shadow: 0 2px 6px rgba(0,0,0,0.08);">
                <div>
                    <span class="role-tag" style="background:#f0fdf4; color:#166534; border:1px solid #bbf7d0; font-size:0.7rem;">Open for ALL Branches &amp; Years</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">GFG Chapter</h3>
                    <div style="font-size: 0.8rem; color: #2f8d46; font-weight: 600;">GeeksforGeeks LTCE Student Chapter</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                The premier algorithmic coding club dedicated to Data Structures, Algorithms, Competitive Programming, and campus placement prep.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">Students who want to crack product-based placement coding rounds (TCS Digital, Microsoft, Amazon, Capgemini) and master LeetCode/GFG algorithms.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> 30 Days of DSA, Weekly Coding Contests, Mock Technical Coding Interviews, Aptitude &amp; Logic Clinics.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=GFG" class="btn btn-outline btn-sm" style="flex:1;">View GFG Events &rarr;</a>
            </div>
        </div>

        <!-- 6. E-CELL LTCE -->
        <div class="card club-card" data-category="startup" style="padding: 1.75rem; border-top: 4px solid #0284c7; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/ecell.png" alt="E-Cell LTCE Logo" style="width: 72px; height: 72px; border-radius: 50%; object-fit: contain; border: 2px solid #0284c7; background: #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#fef3c7; color:#92400e; border:1px solid #fde68a; font-size:0.7rem;">Affiliated with E-Cell IIT Bombay</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">E-CELL LTCE</h3>
                    <div style="font-size: 0.8rem; color: #0284c7; font-weight: 600;">"Ideate &bull; Innovate &bull; Impact"</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                Entrepreneurship Cell fostering the startup spirit among engineers, in formal association with the National Entrepreneurship Challenge (NEC) by E-Cell IIT Bombay.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">Aspiring founders, product managers, and creative problem solvers who want to learn venture funding, pitch decks, and build real businesses from engineering ideas.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> E-Summit preliminary pitch rounds, Business Plan (B-Plan) competitions, Angel investor connect, Startup visits.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=E-CELL" class="btn btn-outline btn-sm" style="flex:1;">View E-Cell Events &rarr;</a>
            </div>
        </div>

        <!-- 7. Technical Vidya -->
        <div class="card club-card" data-category="startup" style="padding: 1.75rem; border-top: 4px solid #475569; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/technical_vidya.png" alt="Technical Vidya Logo" style="width: 72px; height: 72px; border-radius: 50%; object-fit: contain; border: 2px solid #475569; background: #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#f1f5f9; color:#334155; border:1px solid #cbd5e1; font-size:0.7rem;">Open for ALL Branches &amp; Years</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">Technical Vidya</h3>
                    <div style="font-size: 0.8rem; color: #475569; font-weight: 600;">Startup &amp; Practical Tech Mentorship</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                Student-driven practical knowledge hub focusing on tech entrepreneurship, hands-on prototype building, and senior-to-junior engineering mentorship.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">Students looking for pragmatic industry project guidance, founder talks, prototype testing, and converting final-year projects into startup products.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> Founder Talk series, Seed Grant Workshops, Hardware/Software Prototyping masterclasses.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=Technical+Vidya" class="btn btn-outline btn-sm" style="flex:1;">View Events &rarr;</a>
            </div>
        </div>

        <!-- 8. The English Club (Crystal / Literature) -->
        <div class="card club-card" data-category="softskills" style="padding: 1.75rem; border-top: 4px solid #9333ea; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/english_club.png" alt="The English Club Logo" style="width: 72px; height: 72px; border-radius: 50%; object-fit: contain; border: 2px solid #9333ea; background: #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                <div>
                    <span class="role-tag" style="background:#faf5ff; color:#7e22ce; border:1px solid #e9d5ff; font-size:0.7rem;">Open for ALL Branches &amp; Years</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">The English Club</h3>
                    <div style="font-size: 0.8rem; color: #9333ea; font-weight: 600;">Crystal Eloquence &amp; Literary Arts</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                The dedicated forum for soft skills, public speaking, debates, elocution, stage anchoring, and campus placement Group Discussion (GD) confidence.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">Students who want to conquer stage fright, improve spoken English fluency, master corporate HR Group Discussions, or compete in collegiate debates.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> Parliamentary Debates, Model United Nations (MUN), Placement GD Clinics, Poetry Slams, Anchor Training.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=English" class="btn btn-outline btn-sm" style="flex:1;">View Events &rarr;</a>
            </div>
        </div>


        <!-- 9. IIC LTCE -->
        <div class="card club-card" data-category="startup" style="padding: 1.75rem; border-top: 4px solid #f97316; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/iic.svg" alt="IIC Logo" style="width: 72px; height: 72px; border-radius: 16px; object-fit: contain; border: 1px solid #e2e8f0; background: #fff; padding: 4px; box-shadow: 0 2px 6px rgba(0,0,0,0.08);">
                <div>
                    <span class="role-tag" style="background:#fff7ed; color:#c2410c; border:1px solid #ffedd5; font-size:0.7rem;">Ministry of Education Initiative</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">IIC LTCE</h3>
                    <div style="font-size: 0.8rem; color: #f97316; font-weight: 600;">Institution Innovation Council</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                Established under the Ministry of Education (MoE), Government of India, to systematically foster innovation, patent drafting, and startup support at LTCE.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">Students with patentable engineering ideas, research hardware/software prototypes, and those wanting to participate in national innovation rankings (ARIIA, SIH).</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> National Innovation Contests, Intellectual Property Rights (IPR) &amp; Patent seminars, SIH Internal rounds.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=IIC" class="btn btn-outline btn-sm" style="flex:1;">View IIC Events &rarr;</a>
            </div>
        </div>

        <!-- 10. Training & Placement Cell -->
        <div class="card club-card" data-category="softskills" style="padding: 1.75rem; border-top: 4px solid #1e3a8a; display:flex; flex-direction:column;">
            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem;">
                <img src="<%= cp %>/images/clubs/tnp.svg" alt="T&P Logo" style="width: 72px; height: 72px; border-radius: 16px; object-fit: contain; border: 1px solid #e2e8f0; background: #fff; padding: 4px; box-shadow: 0 2px 6px rgba(0,0,0,0.08);">
                <div>
                    <span class="role-tag" style="background:#eff6ff; color:#1e40af; border:1px solid #bfdbfe; font-size:0.7rem;">College-Wide Placement Wing</span>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--ltce-blue-dark); margin-top: 4px;">T&amp;P Cell</h3>
                    <div style="font-size: 0.8rem; color: #1e3a8a; font-weight: 600;">Training &amp; Placement Cell</div>
                </div>
            </div>

            <p style="font-size: 0.875rem; color: #475569; line-height: 1.5; margin-bottom: 1rem;">
                The central career conduit connecting LTCE engineering students with top recruiters like TCS, Capgemini, LTI, Infosys, and tier-1 product organizations.
            </p>

            <div style="background: var(--bg-alt); border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1rem; font-size: 0.825rem; line-height: 1.45;">
                <div style="color: var(--ltce-blue); font-weight: 700; margin-bottom: 2px;">&#127919; Kisme Jaana Chahiye? (Who Should Join):</div>
                <div style="color: #334155;">3rd &amp; Final year students (TE &amp; BE) preparing for campus recruitment training (CRT), resume clinics, and corporate interview drives.</div>
            </div>

            <div style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                <strong>&#9733; Core Activities:</strong> Campus Recruitment Training (CRT), Alumni Mock Interviews, Resume Screening Clinics, HR Q&amp;A sessions.
            </div>

            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                <a href="<%= cp %>/dashboard?search=Placement" class="btn btn-outline btn-sm" style="flex:1;">View T&amp;P Events &rarr;</a>
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
