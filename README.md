# CAMPUSCONNECT
### Connecting Students with Every Campus Opportunity
**An Institutional Digital Platform for Lokmanya Tilak College of Engineering (LTCE), Navi Mumbai**

---

## 1. Executive Summary & Problem Statement

College event information is currently fragmented across countless informal WhatsApp groups:
* Department and Class groups
* Student Council and Committee groups
* Technical Club groups (GDG on Campus, AIMSA, CSI, IEEE, ACM)
* Cultural & Sports groups
* Batch-specific and unofficial peer chats

### Real Problems Solved:
1. **Organizer Fatigue:** Faculty and student organizers spend hours repeatedly copy-pasting identical announcements into 15+ different WhatsApp groups.
2. **Missed Opportunities:** Students miss critical hackathons, workshops, and placement drives simply because they are not members of that specific group or the chat got buried.
3. **Information Buried in Noise:** Important rules, deadlines, and registration links vanish beneath hundreds of conversational messages.
4. **No Central Archive:** Colleges lack a searchable, institutional record of past and upcoming events.
5. **Registration Chaos:** Disconnected Google Forms lead to duplicate submissions, unclear eligibility, and manual spreadsheet consolidation.

---

## 2. The CampusConnect Solution

CampusConnect serves as the **Single Source of Truth** for all campus events and opportunities:

```
┌─────────────────────────┐
│  ORGANIZER POSTS ONCE   │  (Department, Club, or Faculty)
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ STORED CENTRALLY IN DB  │  (Structured parameters: dates, seats, eligibility)
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│   STUDENTS DISCOVER     │  (Filter by Branch, Year, Category)
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│  STUDENTS REGISTER      │  (One-click official registration, no duplicate entries)
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ ORGANIZER MANAGES PASS  │  (Live attendee roster, printable pass & CSV export)
└─────────────────────────┘
```

> **Important Positioning:** CampusConnect is not positioned to fight WhatsApp; rather, it complements it. Organizers and students can share a single, structured CampusConnect event link with WhatsApp preview, directing everyone to verified information.

---

## 3. Key Features

### For Students:
* **Instant Discovery:** Search events by keyword, organizer, or topic with real-time responsive filtering.
* **Granular Filtering:** Filter by Department (Computer, AI&ML, IT, Mechanical, Extc), Academic Year (FE, SE, TE, BE), and Category (Technical, Competition, Hackathon, Workshop, Seminar).
* **Detailed Event View:** Structured overview with date, time, venue, eligibility rules, speaker profiles, and live remaining seat counters.
* **One-Click Registration:** Instant registration with duplicate prevention and vacancy validation.
* **My Registrations:** Personal dashboard of all registered events with digital printable entry pass.
* **Saved Bookmarks:** Save upcoming opportunities for quick reference later.
* **WhatsApp Share:** Pre-populated structured announcement text with verified link.

### For Organizers & Administrators:
* **Metric Overview:** Key performance cards showing Total Events, Upcoming Events, Total Registrations, and Active Events.
* **Event Management:** Create, edit, and cancel events with structured input validation.
* **Real-time Attendee Rosters:** Filter registrations per event with verified student profiles (Name, Email, Branch, Academic Year).
* **Export & Print:** One-click CSV export and print preview for faculty submission and HOD approval.

---

## 4. Technology Stack (Java Full Stack Syllabus Alignment)

This application strictly aligns with university-prescribed **Java Full Stack Web Development** syllabi:

| Layer | Technology | Syllabus Role & Implementation |
|---|---|---|
| **Frontend** | HTML5, CSS3, Vanilla JavaScript | Responsive institutional design, semantic forms, client-side validation, live search filtering, and asynchronous bookmark toggling. |
| **Presentation (View)** | JavaServer Pages (JSP) | Server-rendered dynamic pages, modular layout inclusion (`header.jsp`, `footer.jsp`), session status checks, and data iteration. |
| **Controller** | Java Servlets (`javax.servlet`) | Handles HTTP requests, session management, access control checks, business validations, and request forwarding (MVC). |
| **Model** | Java POJO Beans | Strongly-typed business entities (`User`, `Event`, `Registration`) with encapsulation and helper accessors. |
| **Persistence (DAO)** | JDBC (`PreparedStatement`) | Data Access Objects (`UserDAO`, `EventDAO`, `RegistrationDAO`) using parameterized queries to guarantee SQL injection safety. |
| **Database** | MySQL (with zero-config fallback) | Normalized relational database (`campusconnect_db`) with primary keys, foreign keys, unique constraints, and indexes. |
| **Application Server** | Apache Tomcat 9 | Standard Java Servlet/JSP container running on port 8080. |

---

## 5. System Architecture (MVC)

CampusConnect strictly implements the classic **Model-View-Controller (MVC)** architectural pattern:

```
                      Browser (Student / Organizer)
                                │      ▲
             HTTP GET/POST      │      │  HTML / CSS / JS
                                ▼      │
                     ┌───────────────────────────┐
                     │        CONTROLLERS        │
                     │ (LoginServlet, EventDAO,  │
                     │  RegistrationServlet...)  │
                     └─────────────┬─────────────┘
                                   │
              Dispatches Data      ▼      Queries / Updates
          ┌────────────────────────┴────────────────────────┐
          ▼                                                 ▼
┌──────────────────┐                              ┌──────────────────┐
│      VIEWS       │                              │   DAO & MODEL    │
│  (JSP Templates, │                              │  (UserDAO, POJOs,│
│  dashboard.jsp)  │                              │   DBConnection)  │
└──────────────────┘                              └─────────┬────────┘
                                                            │
                                                     JDBC PreparedStmt
                                                            │
                                                            ▼
                                                  ┌──────────────────┐
                                                  │     DATABASE     │
                                                  │ (MySQL / Schema) │
                                                  └──────────────────┘
```

---

## 6. Directory Structure & Clean Separation of Concerns

The project adheres strictly to the Java Enterprise Dynamic Web Project standard, with total physical separation of presentation (HTML/JSP), styling (CSS), client interaction (JavaScript), server business logic (Servlets), data access (DAO/JDBC), and database schemas:

```
Campus-Connect/
│
├── WebContent/                     ──▶ [VIEW LAYER] Client-Facing Web Resources
│   ├── css/
│   │   └── style.css               ──▶ [CSS] Centralized styling, variables, 3D animations & themes
│   ├── js/
│   │   └── main.js                 ──▶ [JAVASCRIPT] Client-side filters, modal controls & interactions
│   ├── images/
│   │   ├── clubs/                  ──▶ [SVG/PNG] High-fidelity student chapter and college logos
│   │   └── *.jpg, *.png            ──▶ [ASSETS] Official event posters & banners
│   ├── includes/
│   │   ├── header.jsp              ──▶ [JSP COMPONENT] Institutional navigation bar & responsive drawer
│   │   └── footer.jsp              ──▶ [JSP COMPONENT] Institutional footer, quick links & scripts
│   ├── admin/
│   │   ├── dashboard.jsp           ──▶ [ADMIN] Metric analytics & event control panel
│   │   ├── create-event.jsp        ──▶ [ADMIN] Event publishing form
│   │   ├── edit-event.jsp          ──▶ [ADMIN] Event update form
│   │   └── registrations.jsp       ──▶ [ADMIN] Attendee roster & CSV export
│   ├── WEB-INF/
│   │   ├── web.xml                 ──▶ [CONFIG] Servlet mappings, error pages & session timeout
│   │   └── lib/*.jar               ──▶ [LIBRARIES] JSTL, JDBC drivers (MySQL & H2)
│   ├── index.jsp                   ──▶ [VIEW] Modern collegiate landing page with 3D pass & live search
│   ├── dashboard.jsp               ──▶ [VIEW] Filterable event discovery portal
│   ├── event-details.jsp           ──▶ [VIEW] Event page with uncropped high-res poster lightbox
│   ├── clubs.jsp                   ──▶ [VIEW] Student chapter directory
│   ├── login.jsp                   ──▶ [VIEW] Authentication login portal
│   ├── register.jsp                ──▶ [VIEW] Student registration portal
│   ├── my-registrations.jsp        ──▶ [VIEW] Student pass & ticket printing
│   └── saved-events.jsp            ──▶ [VIEW] Student bookmarks
│
├── src/                            ──▶ [CONTROLLER & MODEL LAYER] Java Backend MVC
│   ├── controller/                 ──▶ [SERVLETS] HTTP Request handlers & routing
│   │   ├── EventServlet.java       ──▶ Event discovery, search & filtering dispatcher
│   │   ├── EventDetailsServlet.java──▶ Single event details controller
│   │   ├── RegistrationServlet.java──▶ Event registration & cancellation handler
│   │   ├── LoginServlet.java       ──▶ Authentication & role-based session manager
│   │   ├── RegisterServlet.java    ──▶ User signup controller
│   │   ├── ClubServlet.java        ──▶ Student bodies directory controller
│   │   └── AdminEventServlet.java  ──▶ Organizer CRUD & roster controller
│   ├── dao/                        ──▶ [DATA ACCESS OBJECTS] JDBC PreparedStatement queries
│   │   ├── EventDAO.java           ──▶ Event queries, filters, counters & persistence
│   │   ├── RegistrationDAO.java    ──▶ Registration transactions & attendee rosters
│   │   └── UserDAO.java            ──▶ User credentials & profile lookup
│   ├── model/                      ──▶ [POJO BEANS] Encapsulated business domain models
│   │   ├── Event.java              ──▶ Event entity bean with convenience formatters
│   │   ├── User.java               ──▶ User account bean
│   │   └── Registration.java       ──▶ Student-Event registration relation bean
│   └── util/
│       └── DBConnection.java       ──▶ Thread-safe JDBC Connection pool & auto-fallback
│
├── database/
│   └── schema.sql                  ──▶ [DATABASE] Standard ANSI SQL normalized DDL & seed data
│
├── lib/*.jar                       ──▶ Compile-time dependencies (Servlet API, JSTL, JDBC)
├── build.bat / build.ps1           ──▶ Automated compilation & deployment scripts
├── run.bat / run.ps1               ──▶ One-click server launcher
├── .gitignore                      ──▶ Clean version control filter
└── README.md                       ──▶ Academic project documentation
```

---

## 7. Database Schema Design

The database schema is normalized to 3NF and includes constraints to guarantee relational integrity.

### Tables:
1. **`users`**
   * `id` (INT, PK, AUTO_INCREMENT)
   * `name` (VARCHAR(100))
   * `email` (VARCHAR(120), UNIQUE)
   * `password` (VARCHAR(255))
   * `role` (ENUM: 'STUDENT', 'ADMIN')
   * `department` (VARCHAR(80))
   * `academic_year` (VARCHAR(20))
   * `created_at` (TIMESTAMP)

2. **`events`**
   * `id` (INT, PK, AUTO_INCREMENT)
   * `title` (VARCHAR(200))
   * `short_description` (VARCHAR(300))
   * `description` (TEXT)
   * `category` (VARCHAR(50))
   * `department` (VARCHAR(80))
   * `eligible_year` (VARCHAR(50))
   * `event_date` (DATE)
   * `start_time` (VARCHAR(20))
   * `end_time` (VARCHAR(20))
   * `venue` (VARCHAR(150))
   * `organizer_name` (VARCHAR(120))
   * `organizer_contact` (VARCHAR(100))
   * `registration_deadline` (DATE)
   * `max_participants` (INT)
   * `eligibility` (VARCHAR(200))
   * `image` (VARCHAR(255))
   * `status` (ENUM: 'Draft', 'Published', 'Cancelled', 'Completed')
   * `created_by` (INT, FK -> users.id)
   * `created_at`, `updated_at` (TIMESTAMP)

3. **`registrations`**
   * `id` (INT, PK, AUTO_INCREMENT)
   * `user_id` (INT, FK -> users.id)
   * `event_id` (INT, FK -> events.id)
   * `registered_at` (TIMESTAMP)
   * `status` (ENUM: 'CONFIRMED', 'CANCELLED', 'ATTENDED')
   * *UNIQUE constraint on `(user_id, event_id)` prevents duplicate registrations.*

4. **`saved_events`**
   * `id` (INT, PK, AUTO_INCREMENT)
   * `user_id` (INT, FK -> users.id)
   * `event_id` (INT, FK -> events.id)
   * `saved_at` (TIMESTAMP)
   * *UNIQUE constraint on `(user_id, event_id)` prevents duplicate bookmarks.*

The complete SQL setup script is located at:
[database/schema.sql](file:///D:/Antigravity%20Workspace/JAVA%20project/database/schema.sql)

---

## 8. Adding Club Logos & Branding

CampusConnect includes built-in visual branding for campus student bodies and technical chapters.

### Pre-configured Club Logos:
The folder `WebContent/images/clubs/` includes high-fidelity SVG logos for:
* **GDG on Campus LTCE** (`gdg.svg`)
* **AIMSA (Artificial Intelligence & ML Student Association)** (`aimsa.svg`)
* **Institution Innovation Council (IIC - MoE Initiative)** (`iic.svg`)
* **Computer Society of India (CSI)** (`csi.svg`)
* **IEEE Student Branch** (`ieee.svg`)
* **Rotaract Club of LTCE** (`rotaract.svg`)
* **Training & Placement Cell** (`tnp.svg`)
* **SIH Innovation Cell** (`sih.svg`)
* **ACM LTCE Chapter** (`acm.svg`)
* **Lokmanya Tilak College of Engineering (LTCE)** (`ltce.svg`)

### How to Add More Club Logos:
1. Save your club's logo file (SVG or PNG format) into:
   ```
   WebContent/images/clubs/<club_name>.svg
   ```
2. When creating an event in the Admin Console, enter or select the club name.
3. The platform automatically displays the official club badge on the Landing Page, Event Discovery cards, Filter strip, and Dedicated Event Details page.

---

## 9. Demo Accounts & Credentials

For academic viva demonstrations and evaluation, predefined accounts are ready:

| Role | Email | Password | Access Level |
|---|---|---|---|
| **Student** | `student@campusconnect.com` | `student123` | Event Discovery, Registration, Saved Events, Digital Pass |
| **Admin / Organizer** | `admin@campusconnect.com` | `admin123` | Create Events, Edit Events, Manage Attendees, Metric Dashboard |

*Tip: The login page provides 1-click demo buttons to automatically populate these credentials.*

---

## 10. Installation & Running Instructions

### Prerequisites
* JDK 17 (or JDK 8/11/21)
* Apache Tomcat 9 (included pre-configured in project root)
* MySQL Server (optional; zero-config embedded demo mode activates automatically if MySQL is not running)

### Running on Windows:

1. **Option A — One-Click Batch Script:**
   ```cmd
   .\run.bat
   ```
   *(Automatically compiles sources, deploys to Tomcat, and starts the server)*

2. **Option B — PowerShell Script:**
   ```powershell
   .\run.ps1
   ```

3. **Open in Browser:**
   Navigate to:
   ```
   http://localhost:8080/CampusConnect/
   ```
   or simply:
   ```
   http://localhost:8080/
   ```

---

## 11. Real Campus Opportunities Included

The initial database is seeded with authentic college events matching official LTCE club posters:

1. **Orientation + GDG x Hacktoberfest HF 2026**
   * Organizer: *Google Developer Groups on Campus LTCE*
   * Speakers: *Shankar Warang (Co-founder @Nothing, Tychee Labs), Anurag Pandey (Maintainer @IPFS-Meshkit)*
   * Venue: *A510 Auditorium, LTCE*
   * Perks: *Devcon passes worth $99, MLH t-shirts & stickers*

2. **Poster Making & Presentation Competition: Emerging Tech for Sustainability**
   * Organizer: *Institution Innovation Council (IIC) × AIMSA (AI & ML Association)*
   * Faculty Coordinators: *Prof. Arti Ochani, Prof. Megha Khadke, Prof. Ujjwala Pandharkar, Dr. Snehal Junnarkar, Dr. Chaitrali Chaudhari (HOD CSE AI&ML), Dr. Subhash Shinde (Principal)*
   * Venue: *C Building, 4th Floor Quadrangle*

3. **Smart India Hackathon (SIH) 2026 College Round**
   * Organizer: *LTCE Innovation Cell*
   * Venue: *Central Computing Facility (CCF)*

4. **Hands-on Masterclass: Full-Stack Web Development**
   * Organizer: *CSI Student Chapter*
   * Venue: *Lab 302, IT Department*

5. **Seminar: Cracking Product-Based Placements & Resume Clinic**
   * Organizer: *Training & Placement Cell (T&P)*
   * Venue: *Seminar Hall 1, Admin Block*

---

## 12. Future Scope & Roadmap

While this MVP addresses the core event discovery and registration challenges, the clean MVC architecture allows seamless extension for:
* **QR Code Check-in:** Instant ticket scanner on student phones at the auditorium gate.
* **Automated Certificate Generation:** PDF participation certificates sent to registered attendees after attendance is marked.
* **Faculty & Club Portals:** Multi-tiered authorization where clubs submit events for HOD digital sign-off before publishing.
* **Direct WhatsApp Cloud API:** Automated alert triggers directly to student phone numbers.
* **Inter-College Cross Discovery:** Expanding to affiliated institutes across Mumbai University.

---

&copy; 2026 CampusConnect &bull; Lokmanya Tilak College of Engineering. Built for academic viva and institutional adoption.
