-- =============================================
-- UBUMENYI HUB - MySQL Database Schema
-- Knowledge for All Rwandans
-- =============================================

-- Create database
CREATE DATABASE IF NOT EXISTS ubumenyi_hub;
USE ubumenyi_hub;

-- =============================================
-- 1. USERS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'instructor', 'student', 'operator', 'inspector', 'manager') DEFAULT 'student',
    blockchain_id VARCHAR(50) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    reset_password_token VARCHAR(255) NULL,
    reset_password_expiry TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_blockchain_id (blockchain_id)
);

-- =============================================
-- 2. PROFILES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS profiles (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    district VARCHAR(100),
    date_of_birth DATE,
    profile_pic VARCHAR(255) DEFAULT '/assets/images/default-avatar.png',
    bio TEXT,
    skills JSON,
    experience_years INT DEFAULT 0,
    language ENUM('en', 'rw', 'fr') DEFAULT 'en',
    notifications BOOLEAN DEFAULT TRUE,
    email_updates BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- =============================================
-- 3. COURSES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    difficulty ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert') DEFAULT 'Beginner',
    duration_hours DECIMAL(5,2) DEFAULT 0,
    thumbnail VARCHAR(255),
    instructor_id INT NOT NULL,
    learning_outcomes JSON,
    tags JSON,
    is_published BOOLEAN DEFAULT FALSE,
    is_free BOOLEAN DEFAULT TRUE,
    price DECIMAL(10,2) DEFAULT 0,
    enrollment_count INT DEFAULT 0,
    rating DECIMAL(2,1) DEFAULT 0,
    rating_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id),
    INDEX idx_category (category),
    INDEX idx_difficulty (difficulty),
    INDEX idx_instructor (instructor_id),
    INDEX idx_is_published (is_published),
    FULLTEXT idx_search (title, description)
);

-- =============================================
-- 4. COURSE_CONTENT TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS course_content (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    content_type ENUM('video', 'pdf', 'quiz', 'assignment', 'simulation') NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    url VARCHAR(255),
    duration_min INT DEFAULT 0,
    order_index INT DEFAULT 0,
    is_offline_available BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_course_id (course_id),
    INDEX idx_content_type (content_type)
);

-- =============================================
-- 5. ENROLLMENTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_date TIMESTAMP NULL,
    progress DECIMAL(5,2) DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    rating DECIMAL(2,1) NULL,
    feedback TEXT,
    time_spent INT DEFAULT 0,
    last_accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (user_id, course_id),
    INDEX idx_user_id (user_id),
    INDEX idx_course_id (course_id),
    INDEX idx_is_completed (is_completed)
);

-- =============================================
-- 6. SIMULATIONS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS simulations (
    sim_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type ENUM('safety', 'operation', 'maintenance', 'emergency', 'process-control') NOT NULL,
    difficulty ENUM('Basic', 'Intermediate', 'Advanced', 'Expert') DEFAULT 'Basic',
    description TEXT,
    course_id INT NULL,
    instructor_id INT NOT NULL,
    scenarios JSON,
    equipment_templates JSON,
    is_offline_available BOOLEAN DEFAULT TRUE,
    total_attempts INT DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE SET NULL,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id),
    INDEX idx_type (type),
    INDEX idx_difficulty (difficulty),
    INDEX idx_instructor (instructor_id)
);

-- =============================================
-- 7. SIMULATION_RESULTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS simulation_results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    sim_id INT NOT NULL,
    user_id INT NOT NULL,
    scenario_name VARCHAR(100),
    score DECIMAL(5,2),
    accuracy DECIMAL(5,2),
    time_taken INT,
    attempts INT DEFAULT 1,
    actions JSON,
    status ENUM('active', 'completed', 'abandoned', 'failed') DEFAULT 'active',
    feedback TEXT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sim_id) REFERENCES simulations(sim_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_sim_id (sim_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
);

-- =============================================
-- 8. LIVE_SESSIONS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS live_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    type ENUM('lecture', 'workshop', 'qna', 'practical', 'webinar') DEFAULT 'lecture',
    instructor_id INT NOT NULL,
    scheduled_time TIMESTAMP NOT NULL,
    duration_minutes INT NOT NULL,
    meeting_platform ENUM('zoom', 'google_meet', 'custom') DEFAULT 'zoom',
    meeting_link VARCHAR(255),
    recording_url VARCHAR(255),
    max_participants INT DEFAULT 50,
    current_participants INT DEFAULT 0,
    is_recording_available BOOLEAN DEFAULT FALSE,
    status ENUM('scheduled', 'ongoing', 'completed', 'cancelled') DEFAULT 'scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id),
    INDEX idx_instructor (instructor_id),
    INDEX idx_scheduled_time (scheduled_time),
    INDEX idx_status (status)
);

-- =============================================
-- 9. SESSION_ATTENDEES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS session_attendees (
    attendee_id INT PRIMARY KEY AUTO_INCREMENT,
    session_id INT NOT NULL,
    user_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    feedback TEXT,
    rating DECIMAL(2,1) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES live_sessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendee (session_id, user_id),
    INDEX idx_session_id (session_id),
    INDEX idx_user_id (user_id)
);

-- =============================================
-- 10. CERTIFICATES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS certificates (
    cert_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    enrollment_id INT NOT NULL,
    blockchain_hash VARCHAR(100) UNIQUE NOT NULL,
    blockchain_tx_hash VARCHAR(100),
    ipfs_hash VARCHAR(100),
    verification_code VARCHAR(50) UNIQUE NOT NULL,
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    download_url VARCHAR(255),
    issuer_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (issuer_id) REFERENCES users(user_id),
    INDEX idx_user_id (user_id),
    INDEX idx_blockchain_hash (blockchain_hash),
    INDEX idx_verification_code (verification_code)
);

-- =============================================
-- 11. RESOURCES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS resources (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    type ENUM('video', 'book', 'pdf', 'document', 'audio', 'image') NOT NULL,
    url VARCHAR(255) NOT NULL,
    description TEXT,
    language VARCHAR(20) DEFAULT 'en',
    is_offline_available BOOLEAN DEFAULT FALSE,
    file_size_mb DECIMAL(8,2) DEFAULT 0,
    download_count INT DEFAULT 0,
    category VARCHAR(50),
    tags JSON,
    thumbnail VARCHAR(255),
    duration INT DEFAULT 0,
    is_published BOOLEAN DEFAULT TRUE,
    uploaded_by INT,
    views INT DEFAULT 0,
    rating DECIMAL(2,1) DEFAULT 0,
    rating_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_type (type),
    INDEX idx_category (category),
    FULLTEXT idx_search (title, description)
);

-- =============================================
-- 12. NOTIFICATIONS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS notifications (
    notif_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    type ENUM('course', 'simulation', 'session', 'certificate', 'achievement', 'system', 'message') NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP NULL,
    link VARCHAR(255),
    data JSON,
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
);

-- =============================================
-- 13. ACHIEVEMENTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS achievements (
    achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(50) DEFAULT '🏆',
    points INT DEFAULT 0,
    badge_image VARCHAR(255),
    category ENUM('learning', 'simulation', 'social', 'engagement', 'special') DEFAULT 'learning',
    criteria JSON NOT NULL,
    is_hidden BOOLEAN DEFAULT FALSE,
    order_index INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 14. USER_ACHIEVEMENTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS user_achievements (
    user_achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_displayed BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_achievement (user_id, achievement_id),
    INDEX idx_user_id (user_id)
);

-- =============================================
-- 15. PAYMENTS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id INT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'RWF',
    payment_method ENUM('mobile_money', 'credit_card', 'bank_transfer', 'crypto') NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    status ENUM('pending', 'processing', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP NULL,
    metadata JSON,
    receipt_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_transaction_id (transaction_id)
);

-- =============================================
-- 16. AUDIT_LOGS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS audit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NULL,
    action VARCHAR(50) NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    resource_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    details JSON,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_timestamp (timestamp)
);

-- =============================================
-- 17. OFFLINE_SYNC TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS offline_sync (
    sync_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    device_id VARCHAR(100) NOT NULL,
    content_type ENUM('video', 'book', 'simulation', 'document') NOT NULL,
    content_id INT NOT NULL,
    sync_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sync_status ENUM('pending', 'synced', 'failed') DEFAULT 'pending',
    version VARCHAR(20),
    data_hash VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_sync_status (sync_status)
);

-- =============================================
-- 18. USER_STATS TABLE (Denormalized for performance)
-- =============================================
CREATE TABLE IF NOT EXISTS user_stats (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    total_points INT DEFAULT 0,
    courses_completed INT DEFAULT 0,
    certificates_earned INT DEFAULT 0,
    hours_learned INT DEFAULT 0,
    simulations_run INT DEFAULT 0,
    achievements_unlocked INT DEFAULT 0,
    daily_streak INT DEFAULT 0,
    last_activity_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- =============================================
-- Create triggers for automatic stats updates
-- =============================================

-- Trigger: Update user_stats when enrollment is completed
DELIMITER //
CREATE TRIGGER update_user_stats_on_completion
AFTER UPDATE ON enrollments
FOR EACH ROW
BEGIN
    IF NEW.is_completed = TRUE AND OLD.is_completed = FALSE THEN
        INSERT INTO user_stats (user_id, courses_completed)
        VALUES (NEW.user_id, 1)
        ON DUPLICATE KEY UPDATE
            courses_completed = courses_completed + 1;
    END IF;
END//
DELIMITER ;

-- Trigger: Update user_stats when certificate is issued
DELIMITER //
CREATE TRIGGER update_user_stats_on_certificate
AFTER INSERT ON certificates
FOR EACH ROW
BEGIN
    INSERT INTO user_stats (user_id, certificates_earned)
    VALUES (NEW.user_id, 1)
    ON DUPLICATE KEY UPDATE
        certificates_earned = certificates_earned + 1;
END//
DELIMITER ;

-- =============================================
-- Insert default achievements
-- =============================================
INSERT INTO achievements (name, description, icon, points, category, criteria) VALUES
('First Steps', 'Complete your first course', '🎓', 50, 'learning', '{"type": "course_completed", "count": 1}'),
('30-Day Streak', 'Daily activity for 30 days', '🔥', 200, 'engagement', '{"type": "daily_streak", "days": 30}'),
('Top Performer', 'Score in top 10% of any course', '⭐', 100, 'learning', '{"type": "top_percentile", "percent": 10}'),
('Community Hero', '50 helpful forum posts', '🤝', 150, 'social', '{"type": "forum_posts", "count": 50}'),
('Expert Learner', 'Complete 10 courses', '🧠', 300, 'learning', '{"type": "course_completed", "count": 10}'),
('Ambassador', 'Refer 5 friends', '🌟', 250, 'social', '{"type": "referrals", "count": 5}');

-- =============================================
-- Create sample admin user (password: admin123)
-- =============================================
INSERT INTO users (username, email, password_hash, role, blockchain_id, is_active) VALUES
('admin', 'admin@ubumenyi.rw', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.5ZqWZqWZqWZqWZqWZqWZqWZqW', 'admin', 'UBM-ADMIN-001', TRUE);

INSERT INTO profiles (user_id, full_name, phone, district, bio, skills) VALUES
(1, 'System Administrator', '+250788000000', 'Kigali', 'Ubumenyi Hub Administrator', '["Management", "Blockchain", "Education"]');

-- =============================================
-- Create sample courses
-- =============================================
INSERT INTO courses (title, description, category, difficulty, duration_hours, instructor_id, is_published, learning_outcomes, tags) VALUES
('Mining Safety Fundamentals', 'Learn essential safety protocols for mining operations. This course covers hazard identification, emergency response, and safety equipment usage.', 'safety', 'Beginner', 4, 1, TRUE, '["Understand safety protocols", "Identify hazards", "Emergency response"]', '["safety", "mining", "training"]'),
('Equipment Operation & Control', 'Master mining equipment operation with hands-on simulations and practical exercises.', 'mining', 'Intermediate', 6, 1, TRUE, '["Operate excavators", "Control conveyor belts", "Monitor crushers"]', '["equipment", "operation", "mining"]'),
('Blockchain for Mining Industry', 'Understanding blockchain technology and its applications in the mining industry.', 'blockchain', 'Advanced', 5, 1, TRUE, '["Understand blockchain basics", "Apply to mining", "Implement smart contracts"]', '["blockchain", "technology", "innovation"]');

-- =============================================
-- Create sample simulations
-- =============================================
INSERT INTO simulations (name, type, difficulty, description, instructor_id, scenarios) VALUES
('Emergency Response Drill', 'safety', 'Basic', 'Practice emergency response procedures for mining accidents. Learn evacuation protocols, first aid, and communication.', 1, '[
    {"name": "Fire Evacuation", "description": "Coordinate evacuation during a mine fire", "timeLimit": 600},
    {"name": "Medical Emergency", "description": "Handle medical emergencies in the mine", "timeLimit": 300}
]'),
('Excavator Operation Simulator', 'operation', 'Intermediate', 'Operate a virtual excavator in various conditions. Practice digging, loading, and maneuvering.', 1, '[
    {"name": "Basic Operation", "description": "Learn basic excavator controls", "timeLimit": 900},
    {"name": "Advanced Maneuvering", "description": "Complex terrain navigation", "timeLimit": 1200}
]');

-- =============================================
-- Create sample live sessions
-- =============================================
INSERT INTO live_sessions (title, description, type, instructor_id, scheduled_time, duration_minutes, max_participants) VALUES
('Mining Safety Best Practices', 'Learn about the latest mining safety protocols and emergency response procedures.', 'lecture', 1, DATE_ADD(NOW(), INTERVAL 1 DAY), 60, 50),
('Equipment Maintenance Workshop', 'Practical workshop on preventive maintenance for mining equipment.', 'workshop', 1, DATE_ADD(NOW(), INTERVAL 2 DAY), 90, 40);