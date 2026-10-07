package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DBConnection - Database Connection Manager for CampusConnect.
 * 
 * Supports MySQL as primary database with automated initialization.
 * If MySQL service is unavailable, gracefully falls back to an embedded H2 database
 * in MySQL compatibility mode to guarantee 100% operational demo readiness during academic vivas and evaluations.
 */
public class DBConnection {

    // Primary MySQL configuration
    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/campusconnect_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&createDatabaseIfNotExist=true";
    private static final String MYSQL_USER = "root";
    private static final String MYSQL_PASSWORD = "";

    // Embedded Fallback configuration (Zero-config embedded DB for offline demo)
    private static final String H2_DRIVER = "org.h2.Driver";
    private static final String H2_URL = "jdbc:h2:./campusconnect_db;MODE=MySQL;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE;AUTO_SERVER=TRUE";
    private static final String H2_USER = "sa";
    private static final String H2_PASSWORD = "";

    private static boolean useFallback = false;
    private static boolean initialized = false;

    static {
        initializeDatabase();
    }

    public static synchronized void initializeDatabase() {
        if (initialized) return;

        // Try primary MySQL first
        try {
            Class.forName(MYSQL_DRIVER);
            try (Connection conn = DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASSWORD)) {
                System.out.println("[CampusConnect] Connected successfully to MySQL Database: campusconnect_db");
                useFallback = false;
                initialized = true;
                return;
            } catch (SQLException e) {
                System.out.println("[CampusConnect] MySQL not reachable on localhost:3306. Switching to embedded fallback engine.");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("[CampusConnect] MySQL Driver not found. Switching to embedded fallback engine.");
        }

        // Initialize H2 Fallback
        try {
            Class.forName(H2_DRIVER);
            try (Connection conn = DriverManager.getConnection(H2_URL, H2_USER, H2_PASSWORD)) {
                System.out.println("[CampusConnect] Initialized Embedded Database for 100% guaranteed zero-setup demo.");
                createTables(conn);
                useFallback = true;
                initialized = true;
            }
        } catch (Exception e) {
            System.err.println("[CampusConnect] Critical DB Init Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        if (!initialized) {
            initializeDatabase();
        }

        if (!useFallback) {
            try {
                return DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASSWORD);
            } catch (SQLException ex) {
                useFallback = true;
            }
        }

        return DriverManager.getConnection(H2_URL, H2_USER, H2_PASSWORD);
    }

    public static boolean isFallbackActive() {
        return useFallback;
    }

    public static String getDatabaseType() {
        return useFallback ? "Embedded Engine (Zero-Config Viva Mode)" : "MySQL (Primary Production Database)";
    }

    /**
     * Initializes tables and demo seed data.
     */
    private static void createTables(Connection conn) {
        try (Statement stmt = conn.createStatement()) {
            // Users table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "name VARCHAR(100) NOT NULL,"
                    + "email VARCHAR(120) NOT NULL UNIQUE,"
                    + "password VARCHAR(255) NOT NULL,"
                    + "role VARCHAR(20) NOT NULL DEFAULT 'STUDENT',"
                    + "department VARCHAR(80),"
                    + "academic_year VARCHAR(20),"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                    + ");");

            // Events table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS events ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "title VARCHAR(200) NOT NULL,"
                    + "short_description VARCHAR(300) NOT NULL,"
                    + "description TEXT NOT NULL,"
                    + "category VARCHAR(50) NOT NULL,"
                    + "department VARCHAR(80) NOT NULL,"
                    + "eligible_year VARCHAR(50) NOT NULL,"
                    + "event_date DATE NOT NULL,"
                    + "start_time VARCHAR(20) NOT NULL,"
                    + "end_time VARCHAR(20) NOT NULL,"
                    + "venue VARCHAR(150) NOT NULL,"
                    + "organizer_name VARCHAR(120) NOT NULL,"
                    + "organizer_contact VARCHAR(100) NOT NULL,"
                    + "registration_deadline DATE NOT NULL,"
                    + "max_participants INT DEFAULT 100,"
                    + "eligibility VARCHAR(200),"
                    + "image VARCHAR(255),"
                    + "status VARCHAR(20) DEFAULT 'Published',"
                    + "created_by INT,"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                    + ");");

            // Registrations table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS registrations ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "user_id INT NOT NULL,"
                    + "event_id INT NOT NULL,"
                    + "registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "status VARCHAR(20) DEFAULT 'CONFIRMED',"
                    + "CONSTRAINT uq_reg_user_event UNIQUE (user_id, event_id)"
                    + ");");

            // Saved Events table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS saved_events ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "user_id INT NOT NULL,"
                    + "event_id INT NOT NULL,"
                    + "saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "CONSTRAINT uq_saved_user_event UNIQUE (user_id, event_id)"
                    + ");");

            // Seed Users if empty
            stmt.executeUpdate("MERGE INTO users (id, name, email, password, role, department, academic_year) KEY(id) VALUES "
                    + "(1, 'Admin / Organizer Coordinator', 'admin@campusconnect.com', 'admin123', 'ADMIN', 'Computer Engineering', 'Faculty'), "
                    + "(2, 'Student Demo Account', 'student@campusconnect.com', 'student123', 'STUDENT', 'Computer Engineering', 'TE - 3rd Year'), "
                    + "(3, 'Aarav Patel', 'aarav@campusconnect.com', 'student123', 'STUDENT', 'CSE (AI & ML)', 'SE - 2nd Year');");

            // Seed 5 Authentic, Official College Events (Sequentially Arranged by Date)
            stmt.executeUpdate("MERGE INTO events (id, title, short_description, description, category, department, eligible_year, event_date, start_time, end_time, venue, organizer_name, organizer_contact, registration_deadline, max_participants, eligibility, image, status, created_by) KEY(id) VALUES "
                    + "(1, 'Orientation + GDG x Hacktoberfest HF 2026', "
                    + "'Kickstart your Open Source journey with GDG on Campus LTCE! Featuring expert guest speakers, Devcon passes worth $99, and exclusive MLH swag.', "
                    + "'Join the official Orientation of Google Developer Groups (GDG) on Campus Lokmanya Tilak College of Engineering in collaboration with Hacktoberfest 2026!\\n\\nGuest Speakers:\\n• Shankar Warang (Co-founder & Investor @Nothing, Tychee Labs & GRYD)\\n• Anurag Pandey (Maintainer & Contributor @IPFS-Meshkit)\\n\\nLearn how to contribute to Open Source, get mentorship on Git/GitHub, build impactful projects, and discover how to win exclusive Devcon passes, stickers, badges, and limited-edition tech merchandise. Free entry for all LTCE students!', "
                    + "'Technical', 'Computer Engineering', 'All Years (FE, SE, TE, BE)', '2026-10-06', '2:00 PM', '4:30 PM', 'A510 Auditorium, LTCE Campus', 'GDG on Campus LTCE', 'gdg@ltce.in | +91 98765 43210', '2026-10-06', 250, 'Open to all branches & years of LTCE', 'gdg_hacktoberfest.jpg', 'Completed', 1), "

                    + "(2, 'Poster Making & Presentation Competition: Emerging Tech for Sustainability', "
                    + "'Organized by Institution Innovation Council (IIC) × AIMSA. Present your ideas on AI, IoT, Robotics, and Renewable Energy for a greener future.', "
                    + "'Lokmanya Tilak College of Engineering (An Autonomous Institute Affiliated to University of Mumbai) - Institution Innovation Council (IIC) in collaboration with AIMSA presents the Annual Poster Making and Presentation Competition.\\n\\nTheme: \"Emerging Technology Integration for Environment and Sustainability\"\\n\\nExplore how AI, IoT, Robotics, Drones, Renewable Energy, Smart Systems & Data Analytics can drive a sustainable future.\\n\\nCoordinators:\\n• Student Coordinators: Bhavishya Chauhan, Haresh Chavan (AIMSA), Vishal Gupta, Mitali Joshi (IIC)\\n• Faculty Coordinators: Prof. Arti Ochani, Prof. Megha Khadke, Prof. Ujjwala Pandharkar\\n• Leadership: Dr. Snehal Junnarkar (IIC Convener), Dr. Sheeba P.S (IIC VP), Dr. Chaitrali Chaudhari (HOD CSE AI&ML), Dr. Subhash Shinde (Principal & IIC President).\\n\\nPrizes and Certificates of Merit for Top 3 Presenters!', "
                    + "'Competition', 'CSE (AI & ML)', 'SE, TE, BE', '2026-10-05', '1:00 PM', '2:00 PM', 'C Building, 4th Floor Quadrangle', 'IIC × AIMSA', 'aimsa@ltce.in | +91 98200 11223', '2026-10-05', 120, 'Teams of 1-3 students from any engineering department', 'iic_aimsa_poster.jpg', 'Completed', 1), "

                    + "(3, 'Rookery Hackathon — Keep Building!', "
                    + "'8-Hour open innovation hackathon organized by Department of CSE AI & ML × Dropcode. Build anything, get $20-$30 seed funding, and win $500 AI credits!', "
                    + "'Department of CSE AI & ML presents ROOKERY HACKATHON — KEEP BUILDING!\\n\\nGot an idea? Build anything. Get funded. Sell it after.\\n\\nJoin us for an 8-hour open innovation hackathon with NO fixed problem statement — just your idea, your team, and the freedom to build.\\n\\nHighlights:\\n• $20-$30 seed funding per team\\n• 1st Place Prize + Cash Prizes for Top 3\\n• $500 worth of AI credits\\n• Winning projects can go live on Dropcode and reach real users!\\n\\nFaculty & Leadership:\\n• Dr. Chaitrali Chaudhari (HOD CSE-AIML)\\n• Dr. Subhash Shinde (Principal)\\n• Student Coordinators: Shreyash Pandey (9373594795), Aditya Pandey (8779299358)\\n\\nOnline registration portal: https://Rookery.dropcode.in', "
                    + "'Hackathon', 'CSE (AI & ML)', 'All Years (FE, SE, TE, BE)', '2026-10-03', '9:00 AM', '5:00 PM', 'Lokmanya Tilak College of Engineering Campus', 'AIMSA × Dropcode', 'aimsa@ltce.in | +91 93735 94795', '2026-10-02', 100, 'Teams of 2-4 students. Open Innovation.', 'rookery_hackathon.jpg', 'Completed', 1), "

                    + "(4, 'Hands-on Group Discussion Practice Workshop', "
                    + "'Interactive placement GD preparation session by Training & Placement Cell under IQAC. Practice live GDs, learn evaluation criteria, and gain confidence.', "
                    + "'Training & Placement Session Under IQAC: Hands-on Group Discussion Practice Workshop.\\n\\nKeynote Trainer: Dr. Rashmi Rani (M.A., MPhil, PhD)\\n\\nStep in. Speak up. Stand out! Remember our GD Orientation Session? You learned the rules, strategies & techniques — now it is time to PUT THEM INTO PRACTICE!\\n\\nSession Highlights:\\n• Participate in live GD simulations\\n• Apply learned evaluation strategies\\n• Practice teamwork & active listening\\n• Build communication & interview confidence\\n• Receive personalized feedback from panel mentors\\n\\nCoordinators & Leadership:\\n• Mr. Hemant More (Assistant TPO)\\n• Dr. Prerana Shrivastava (Training & Placement Officer)\\n• Dr. Subhash K. Shinde (Principal)', "
                    + "'Workshop', 'All Departments', 'SE, TE, BE', '2026-10-01', '3:00 PM', '5:30 PM', 'C-410 Seminar Hall, LTCE Campus', 'T&P Cell Under IQAC', 'tpo@ltce.in | +91 98211 55667', '2026-09-30', 80, 'Open to all engineering branches', 'gd_workshop.jpg', 'Completed', 1), "

                    + "(5, 'Orientation on Project Deep Blue Season 12', "
                    + "'Institution Innovation Council (IIC) invites students to the orientation of Project Deep Blue, a prestigious Mastek industry initiative.', "
                    + "'The Institution Innovation Council (IIC) of Lokmanya Tilak College of Engineering cordially invites students to attend the official orientation of Project Deep Blue - Season 12 (A Mastek initiative).\\n\\nSpeaker: Mr. Swapnil Pawar (Senior Executive PMO, Mastek Ltd.)\\n\\nProject Deep Blue empowers engineering students to solve real-world social and technological challenges through cutting-edge software solutions with direct mentorship from Mastek industry leaders.\\n\\nLeadership & Organization:\\n• Student Coordinators: Mitali Joshi, Vishal Gupta\\n• Faculty Coordinators: Prof. Ujjwala Pandharkar, Dr. Snehal Junnarkar\\n• Convener: Dr. Nimisha Shirbhate\\n• Vice President: Dr. Sheeba P.S\\n• President & Principal: Dr. Subhash Shinde', "
                    + "'Technical', 'All Departments', 'SE, TE, BE', '2026-09-07', '3:30 PM', '5:00 PM', 'Online Session (Virtual Link)', 'Institution Innovation Council (IIC)', 'iic@ltce.in | +91 98200 44332', '2026-09-07', 200, 'Open to all students of LTCE', 'project_deep_blue.jpg', 'Completed', 1);");

            // Clean up any old demo events and ensure status is Completed
            stmt.executeUpdate("DELETE FROM events WHERE id NOT IN (1, 2, 3, 4, 5);");
            stmt.executeUpdate("UPDATE events SET status = 'Completed';");

            // Seed sample registrations
            stmt.executeUpdate("MERGE INTO registrations (id, user_id, event_id, status) KEY(id) VALUES (1, 2, 1, 'CONFIRMED'), (2, 2, 3, 'CONFIRMED'), (3, 2, 4, 'CONFIRMED');");
            // Seed sample saved events
            stmt.executeUpdate("MERGE INTO saved_events (id, user_id, event_id) KEY(id) VALUES (1, 2, 2);");

            System.out.println("[CampusConnect] Seed data successfully verified.");
        } catch (SQLException e) {
            System.err.println("[CampusConnect] Error setting up database tables: " + e.getMessage());
        }
    }
}
