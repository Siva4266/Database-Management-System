CREATE DATABASE IF NOT EXISTS CollegeManagementSystem;
USE CollegeManagementSystem;

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Faculty;
DROP TABLE IF EXISTS Departments;

CREATE TABLE Departments (
 department_id INT AUTO_INCREMENT PRIMARY KEY,
 department_name VARCHAR(100) NOT NULL UNIQUE,
 office_location VARCHAR(100) NOT NULL
);
CREATE TABLE Faculty (
 faculty_id INT AUTO_INCREMENT PRIMARY KEY,
 faculty_name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE,
 department_id INT NOT NULL,
 salary DECIMAL(10,2) NOT NULL CHECK (salary >= 0),
 employment_status VARCHAR(20) NOT NULL DEFAULT 'Active',
 CHECK (employment_status IN ('Active','On Leave','Retired')),
 FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
CREATE TABLE Students (
 student_id INT AUTO_INCREMENT PRIMARY KEY,
 register_no VARCHAR(20) NOT NULL UNIQUE,
 student_name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE,
 date_of_birth DATE,
 admission_year YEAR NOT NULL,
 department_id INT NOT NULL,
 FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
CREATE TABLE Courses (
 course_id INT AUTO_INCREMENT PRIMARY KEY,
 course_code VARCHAR(20) NOT NULL UNIQUE,
 course_name VARCHAR(120) NOT NULL,
 credits TINYINT NOT NULL CHECK (credits BETWEEN 1 AND 6),
 department_id INT NOT NULL,
 faculty_id INT NOT NULL,
 FOREIGN KEY (department_id) REFERENCES Departments(department_id),
 FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);
CREATE TABLE Enrollments (
 enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 course_id INT NOT NULL,
 semester TINYINT NOT NULL CHECK (semester BETWEEN 1 AND 8),
 academic_year VARCHAR(9) NOT NULL,
 grade VARCHAR(2) NOT NULL DEFAULT 'NA',
 enrollment_date DATE NOT NULL,
 UNIQUE (student_id, course_id, semester, academic_year),
 CHECK (grade IN ('O','A+','A','B+','B','C','F','NA')),
 FOREIGN KEY (student_id) REFERENCES Students(student_id),
 FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Departments (department_name, office_location) VALUES
('Computer Science','Block A - 201'),('Commerce','Block B - 105'),('Mathematics','Block C - 301');
INSERT INTO Faculty (faculty_name,email,department_id,salary,employment_status) VALUES
('Ananya Rao','ananya.rao@college.edu',1,65000,'Active'),
('Rahul Menon','rahul.menon@college.edu',1,62000,'Active'),
('Meera Iyer','meera.iyer@college.edu',2,58000,'Active'),
('Kiran Das','kiran.das@college.edu',3,60000,'On Leave');
INSERT INTO Students (register_no,student_name,email,date_of_birth,admission_year,department_id) VALUES
('CS2026001','Aarav Sharma','aarav@students.college.edu','2007-02-14',2026,1),
('CS2026002','Diya Nair','diya@students.college.edu','2006-11-08',2026,1),
('CS2025003','Ishaan Patel','ishaan@students.college.edu','2006-04-20',2025,1),
('CO2026001','Sara Khan','sara@students.college.edu','2007-07-11',2026,2),
('MA2025001','Vikram Reddy','vikram@students.college.edu','2005-12-01',2025,3),
('CO2025002','Nisha Joseph','nisha@students.college.edu','2006-09-17',2025,2);
INSERT INTO Courses (course_code,course_name,credits,department_id,faculty_id) VALUES
('CS101','Database Management Systems',4,1,1),('CS102','Programming in Python',3,1,2),
('CS201','Data Structures',4,1,1),('CO101','Financial Accounting',3,2,3),
('MA101','Discrete Mathematics',4,3,4);
INSERT INTO Enrollments (student_id,course_id,semester,academic_year,grade,enrollment_date) VALUES
(1,1,1,'2026-2027','A','2026-08-01'),(1,2,1,'2026-2027','A+','2026-08-01'),
(2,1,1,'2026-2027','B+','2026-08-02'),(2,2,1,'2026-2027','A','2026-08-02'),
(3,3,3,'2026-2027','B','2026-07-25'),(4,4,1,'2026-2027','A+','2026-08-03'),
(5,5,3,'2026-2027','B+','2026-07-28'),(6,4,3,'2026-2027','A','2026-07-29'),
(3,1,3,'2026-2027','A','2026-08-04');

-- Assignment 8: Basic queries
SELECT student_name, register_no FROM Students WHERE department_id=1 ORDER BY student_name;
SELECT department_id, COUNT(*) AS student_count FROM Students GROUP BY department_id;
SELECT course_id, COUNT(*) AS enrolled_students FROM Enrollments GROUP BY course_id HAVING COUNT(*) >= 2;
SELECT COUNT(*) AS total_students FROM Students;
SELECT SUM(credits) AS total_credits FROM Courses;
SELECT AVG(salary) AS average_salary FROM Faculty;
SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM Faculty;

-- Assignment 9: Joins and subqueries
SELECT s.student_name,s.register_no,d.department_name
FROM Students s JOIN Departments d ON s.department_id=d.department_id;
SELECT c.course_code,c.course_name,f.faculty_name,d.department_name
FROM Courses c JOIN Faculty f ON c.faculty_id=f.faculty_id
JOIN Departments d ON c.department_id=d.department_id;
SELECT s.student_name,c.course_name,e.semester,e.academic_year,e.grade
FROM Enrollments e JOIN Students s ON e.student_id=s.student_id
JOIN Courses c ON e.course_id=c.course_id;
SELECT s.student_name,COUNT(e.enrollment_id) AS courses_taken
FROM Students s LEFT JOIN Enrollments e ON s.student_id=e.student_id
GROUP BY s.student_id,s.student_name ORDER BY courses_taken DESC;
SELECT student_name FROM Students WHERE student_id IN
 (SELECT student_id FROM Enrollments WHERE grade='A+');
SELECT faculty_name,salary FROM Faculty
WHERE salary > (SELECT AVG(salary) FROM Faculty);
SELECT d.department_name,COUNT(s.student_id) AS student_count
FROM Departments d LEFT JOIN Students s ON d.department_id=s.department_id
GROUP BY d.department_id,d.department_name;
