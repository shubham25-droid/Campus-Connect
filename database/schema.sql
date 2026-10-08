-- ===================================================
-- CampusConnect Database Schema
-- Connecting Students with Every Campus Opportunity
-- ===================================================

CREATE DATABASE IF NOT EXISTS campusconnect_db;
USE campusconnect_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
    department VARCHAR(80),
    academic_year VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Events Table
CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    short_description VARCHAR(300) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    department VARCHAR(80) NOT NULL,
    eligible_year VARCHAR(50) NOT NULL,
    event_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    venue VARCHAR(150) NOT NULL,
    organizer_name VARCHAR(120) NOT NULL,
    organizer_contact VARCHAR(100) NOT NULL,
    registration_deadline DATE NOT NULL,
    max_participants INT DEFAULT 100,
    eligibility VARCHAR(200),
    image VARCHAR(255),
    status ENUM('Draft', 'Published', 'Cancelled', 'Completed') DEFAULT 'Published',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_event_date (event_date),
    INDEX idx_status (status),
    INDEX idx_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Registrations Table
CREATE TABLE IF NOT EXISTS registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('CONFIRMED', 'CANCELLED', 'ATTENDED') DEFAULT 'CONFIRMED',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    UNIQUE KEY uq_user_event (user_id, event_id),
    INDEX idx_reg_user (user_id),
    INDEX idx_reg_event (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Saved Events (Bookmarks) Table
CREATE TABLE IF NOT EXISTS saved_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    UNIQUE KEY uq_saved_user_event (user_id, event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===================================================
-- Initial Seed Data
-- ===================================================

-- Demo Accounts (passwords: 'admin123', 'student123' or plain/hashed)
INSERT INTO users (id, name, email, password, role, department, academic_year) VALUES
(1, 'Admin / Organizer Coordinator', 'admin@campusconnect.com', 'admin123', 'ADMIN', 'Computer Engineering', 'Faculty'),
(2, 'Student Demo Account', 'student@campusconnect.com', 'student123', 'STUDENT', 'Computer Engineering', 'TE - 3rd Year'),
(3, 'Aarav Patel', 'aarav@campusconnect.com', 'student123', 'STUDENT', 'CSE (AI & ML)', 'SE - 2nd Year')
ON DUPLICATE KEY UPDATE name=name;

-- Realistic Campus Events (Based on LTCE College Posters and Top Campus Opportunities)
INSERT INTO events (id, title, short_description, description, category, department, eligible_year, event_date, start_time, end_time, venue, organizer_name, organizer_contact, registration_deadline, max_participants, eligibility, image, status, created_by) VALUES
(1, 
'Orientation + GDG x Hacktoberfest HF 2026',
'Kickstart your Open Source journey with GDG on Campus LTCE! Featuring expert guest speakers, Devcon passes worth $99, and exclusive MLH swag.',
'Join the official Orientation of Google Developer Groups (GDG) on Campus Lokmanya Tilak College of Engineering in collaboration with Hacktoberfest 2026!\n\nGuest Speakers:\n• Shankar Warang (Co-founder & Investor @Nothing, Tychee Labs & GRYD)\n• Anurag Pandey (Maintainer & Contributor @IPFS-Meshkit)\n\nLearn how to contribute to Open Source, get mentorship on Git/GitHub, build impactful projects, and discover how to win exclusive Devcon passes, stickers, badges, and limited-edition tech merchandise. Free entry for all LTCE students!',
'Technical',
'Computer Engineering',
'All Years (FE, SE, TE, BE)',
'2026-10-06',
'14:00:00',
'16:30:00',
'A510 Auditorium, LTCE Campus',
'GDG on Campus LTCE',
'gdg@ltce.in | Student Chapter Desk',
'2026-10-06',
250,
'Open to all branches & years of LTCE',
'gdg_hacktoberfest.png',
'Published',
1),

(2,
'Poster Making & Presentation Competition: Emerging Tech for Sustainability',
'Organized by Institution Innovation Council (IIC) × AIMSA. Present your ideas on AI, IoT, Robotics, and Renewable Energy for a greener future.',
'Lokmanya Tilak College of Engineering (An Autonomous Institute Affiliated to University of Mumbai) - Institution Innovation Council (IIC) in collaboration with AIMSA presents the Annual Poster Making and Presentation Competition.\n\nTheme: "Emerging Technology Integration for Environment and Sustainability"\n\nExplore how AI, IoT, Robotics, Drones, Renewable Energy, Smart Systems & Data Analytics can drive a sustainable future.\n\nCoordinators:\n• Student Coordinators: Bhavishya Chauhan, Haresh Chavan (AIMSA), Vishal Gupta, Mitali Joshi (IIC)\n• Faculty Coordinators: Prof. Arti Ochani, Prof. Megha Khadke, Prof. Ujjwala Pandharkar\n• Leadership: Dr. Snehal Junnarkar (IIC Convener), Dr. Sheeba P.S (IIC VP), Dr. Chaitrali Chaudhari (HOD CSE AI&ML), Dr. Subhash Shinde (Principal & IIC President).\n\nPrizes and Certificates of Merit for Top 3 Presenters!',
'Competition',
'CSE (AI & ML)',
'SE, TE, BE',
'2026-10-05',
'13:00:00',
'14:00:00',
'C Building, 4th Floor Quadrangle',
'IIC × AIMSA',
'aimsa@ltce.in | Student Coordination Desk',
'2026-10-05',
120,
'Teams of 1-3 students from any engineering department',
'iic_aimsa_poster.png',
'Published',
1),

(3,
'Smart India Hackathon (SIH) 2026 Internal College Round',
'The preliminary qualifying hackathon for Smart India Hackathon. Pitch your hardware & software solutions to internal evaluators.',
'Compete with the sharpest minds at LTCE to represent the college at the national Smart India Hackathon 2026. Teams will be evaluated on problem statement alignment, technical viability, architectural elegance, and feasibility.',
'Hackathon',
'All Departments',
'SE, TE, BE',
'2026-10-18',
'09:00:00',
'18:00:00',
'Central Computing Facility (CCF)',
'LTCE Innovation Cell',
'innovation@ltce.in | Innovation Helpdesk',
'2026-10-16',
60,
'Team of 6 members with mandatory 1 female participant',
'sih_hackathon.png',
'Published',
1),

(4,
'Hands-on Masterclass: Full-Stack Web Development with Spring & React',
'A deep dive technical workshop covering RESTful API architecture, state management, and modern cloud deployment patterns.',
'Master the art of building scalable enterprise web applications. We will cover clean MVC architecture, RESTful API contract design, JDBC/ORM best practices, and responsive interfaces.',
'Workshop',
'Information Technology',
'TE, BE',
'2026-10-24',
'10:30:00',
'16:00:00',
'Lab 302, IT Department',
'CSI Student Chapter',
'csi@ltce.in | Student Chapter Desk',
'2026-10-23',
80,
'Basic understanding of Java and JavaScript recommended',
'web_bootcamp.png',
'Published',
1),

(5,
'Seminar: Cracking Product-Based Company Placements & Resume Clinic',
'Get your resume reviewed by alumni working at Microsoft, Google, and Amazon. Learn DSA strategy, system design basics, and interview etiquette.',
'Organized by the Training & Placement Cell (T&P). Features LTCE alumni panel discussion, live mock interviews, and personalized 1-on-1 resume reviews.',
'Seminar',
'All Departments',
'TE, BE',
'2026-10-30',
'15:00:00',
'17:30:00',
'Seminar Hall 1, Admin Block',
'Training & Placement Cell',
'tnp@ltce.in | Training & Placement Cell',
'2026-10-29',
200,
'Open to 3rd & Final year students preparing for campus placements',
'resume_seminar.png',
'Published',
1)
ON DUPLICATE KEY UPDATE title=title;

-- Demo Registrations
INSERT INTO registrations (user_id, event_id, status) VALUES
(2, 1, 'CONFIRMED'),
(2, 2, 'CONFIRMED')
ON DUPLICATE KEY UPDATE status=status;

-- Demo Saved Events
INSERT INTO saved_events (user_id, event_id) VALUES
(2, 3),
(2, 4)
ON DUPLICATE KEY UPDATE saved_at=saved_at;
