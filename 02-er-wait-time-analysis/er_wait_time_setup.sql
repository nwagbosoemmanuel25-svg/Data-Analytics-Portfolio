-- ============================================================
-- ER WAIT TIME ANALYSIS - MySQL Setup Script
-- Day 3-4 | 30-Day Data Analytics Challenge
-- ============================================================

CREATE DATABASE IF NOT EXISTS er_analysis;
USE er_analysis;

DROP TABLE IF EXISTS er_visits;

CREATE TABLE er_visits (
    visit_id        INT PRIMARY KEY AUTO_INCREMENT,
    visit_date      DATE NOT NULL,
    arrival_time    TIME NOT NULL,
    triage_time     TIME,
    doctor_time     TIME,
    discharge_time  TIME,
    wait_time_mins  INT,        -- Arrival to doctor (key metric)
    triage_level    TINYINT,    -- 1=Critical, 2=Emergency, 3=Urgent, 4=Less Urgent, 5=Non-Urgent
    shift           VARCHAR(10),-- Morning / Afternoon / Night
    day_of_week     VARCHAR(10),
    department      VARCHAR(30),
    chief_complaint VARCHAR(50),
    outcome         VARCHAR(20),-- Admitted / Discharged / Transferred
    patient_age     INT,
    insurance_type  VARCHAR(20) -- Private / Medicare / Medicaid / Uninsured
);

-- ============================================================
-- INSERT SAMPLE DATA (200 visits across 30 days)
-- ============================================================
INSERT INTO er_visits (visit_date, arrival_time, triage_time, doctor_time, discharge_time, wait_time_mins, triage_level, shift, day_of_week, department, chief_complaint, outcome, patient_age, insurance_type) VALUES
('2024-01-01','07:10:00','07:18:00','07:55:00','09:30:00',45,3,'Morning','Monday','General ER','Chest Pain','Admitted',62,'Medicare'),
('2024-01-01','08:25:00','08:30:00','09:45:00','11:00:00',80,4,'Morning','Monday','General ER','Abdominal Pain','Discharged',34,'Private'),
('2024-01-01','10:05:00','10:10:00','11:50:00','13:15:00',105,4,'Morning','Monday','General ER','Back Pain','Discharged',45,'Medicaid'),
('2024-01-01','13:30:00','13:35:00','15:20:00','17:00:00',110,3,'Afternoon','Monday','Pediatric ER','Fever','Discharged',7,'Private'),
('2024-01-01','14:00:00','14:05:00','16:10:00','18:30:00',130,4,'Afternoon','Monday','General ER','Laceration','Discharged',28,'Uninsured'),
('2024-01-01','22:15:00','22:20:00','23:10:00','01:00:00',55,2,'Night','Monday','Trauma','Car Accident','Admitted',41,'Private'),
('2024-01-01','23:40:00','23:45:00','01:30:00','03:00:00',110,3,'Night','Monday','General ER','Shortness of Breath','Admitted',70,'Medicare'),

('2024-01-02','06:50:00','06:55:00','07:40:00','09:00:00',50,3,'Morning','Tuesday','General ER','Chest Pain','Admitted',55,'Private'),
('2024-01-02','09:15:00','09:20:00','10:00:00','11:30:00',45,3,'Morning','Tuesday','General ER','Dizziness','Discharged',66,'Medicare'),
('2024-01-02','11:30:00','11:35:00','13:10:00','14:45:00',100,4,'Morning','Tuesday','General ER','Nausea','Discharged',30,'Medicaid'),
('2024-01-02','14:45:00','14:50:00','16:40:00','18:00:00',115,4,'Afternoon','Tuesday','Pediatric ER','Ear Pain','Discharged',5,'Private'),
('2024-01-02','16:00:00','16:05:00','18:15:00','20:00:00',135,5,'Afternoon','Tuesday','General ER','Rash','Discharged',22,'Uninsured'),
('2024-01-02','20:30:00','20:32:00','20:45:00','22:30:00',15,1,'Night','Tuesday','Trauma','Stroke','Admitted',73,'Medicare'),
('2024-01-02','21:00:00','21:05:00','22:50:00','00:30:00',110,3,'Night','Tuesday','General ER','Abdominal Pain','Admitted',47,'Private'),

('2024-01-03','07:00:00','07:05:00','07:50:00','09:15:00',50,3,'Morning','Wednesday','General ER','Headache','Discharged',38,'Private'),
('2024-01-03','08:45:00','08:50:00','10:00:00','11:30:00',75,4,'Morning','Wednesday','General ER','Back Pain','Discharged',52,'Medicare'),
('2024-01-03','10:30:00','10:35:00','12:20:00','14:00:00',110,4,'Morning','Wednesday','Pediatric ER','Vomiting','Discharged',9,'Private'),
('2024-01-03','13:15:00','13:20:00','15:30:00','17:00:00',135,5,'Afternoon','Wednesday','General ER','Sore Throat','Discharged',19,'Uninsured'),
('2024-01-03','15:45:00','15:50:00','17:40:00','19:30:00',115,4,'Afternoon','Wednesday','General ER','Ankle Sprain','Discharged',25,'Private'),
('2024-01-03','22:00:00','22:05:00','23:30:00','01:00:00',90,3,'Night','Wednesday','General ER','Chest Pain','Admitted',68,'Medicare'),

('2024-01-04','07:30:00','07:35:00','08:20:00','10:00:00',50,3,'Morning','Thursday','General ER','Fever','Discharged',44,'Medicaid'),
('2024-01-04','09:00:00','09:05:00','10:45:00','12:00:00',105,4,'Morning','Thursday','General ER','Abdominal Pain','Discharged',31,'Private'),
('2024-01-04','12:00:00','12:05:00','14:00:00','15:30:00',120,4,'Afternoon','Thursday','General ER','Back Pain','Discharged',57,'Medicare'),
('2024-01-04','14:30:00','14:32:00','14:50:00','16:30:00',20,1,'Afternoon','Thursday','Trauma','Heart Attack','Admitted',72,'Medicare'),
('2024-01-04','16:15:00','16:20:00','18:20:00','20:00:00',125,5,'Afternoon','Thursday','General ER','Rash','Discharged',17,'Uninsured'),
('2024-01-04','20:45:00','20:50:00','22:30:00','00:00:00',105,3,'Night','Thursday','General ER','Dizziness','Discharged',60,'Medicare'),
('2024-01-04','23:15:00','23:20:00','01:10:00','02:45:00',115,3,'Night','Thursday','General ER','Chest Pain','Admitted',65,'Private'),

('2024-01-05','07:20:00','07:25:00','08:10:00','09:30:00',50,3,'Morning','Friday','General ER','Shortness of Breath','Admitted',69,'Medicare'),
('2024-01-05','09:30:00','09:35:00','11:15:00','12:45:00',105,4,'Morning','Friday','Pediatric ER','Ear Infection','Discharged',6,'Private'),
('2024-01-05','11:00:00','11:05:00','13:05:00','14:30:00',125,5,'Morning','Friday','General ER','Cough','Discharged',40,'Medicaid'),
('2024-01-05','14:00:00','14:05:00','16:20:00','18:00:00',140,4,'Afternoon','Friday','General ER','Abdominal Pain','Admitted',36,'Private'),
('2024-01-05','16:30:00','16:35:00','18:50:00','20:30:00',140,5,'Afternoon','Friday','General ER','Back Pain','Discharged',48,'Uninsured'),
('2024-01-05','19:00:00','19:05:00','21:10:00','22:45:00',130,4,'Night','Friday','General ER','Laceration','Discharged',23,'Private'),
('2024-01-05','22:30:00','22:35:00','00:20:00','02:00:00',110,3,'Night','Friday','General ER','Fever','Admitted',77,'Medicare'),

('2024-01-06','08:00:00','08:05:00','09:45:00','11:15:00',105,4,'Morning','Saturday','General ER','Headache','Discharged',35,'Private'),
('2024-01-06','10:00:00','10:05:00','12:10:00','13:45:00',130,5,'Morning','Saturday','General ER','Rash','Discharged',27,'Uninsured'),
('2024-01-06','12:30:00','12:35:00','14:40:00','16:30:00',130,4,'Afternoon','Saturday','Pediatric ER','Vomiting','Discharged',4,'Private'),
('2024-01-06','14:45:00','14:50:00','17:05:00','18:30:00',140,5,'Afternoon','Saturday','General ER','Sore Throat','Discharged',21,'Medicaid'),
('2024-01-06','17:00:00','17:05:00','19:15:00','20:45:00',135,4,'Afternoon','Saturday','General ER','Ankle Sprain','Discharged',29,'Private'),
('2024-01-06','21:00:00','21:05:00','22:45:00','00:30:00',105,3,'Night','Saturday','General ER','Chest Pain','Admitted',63,'Medicare'),

('2024-01-07','09:00:00','09:05:00','10:50:00','12:30:00',110,4,'Morning','Sunday','General ER','Abdominal Pain','Discharged',43,'Private'),
('2024-01-07','11:00:00','11:05:00','13:10:00','14:45:00',130,5,'Morning','Sunday','General ER','Back Pain','Discharged',50,'Medicaid'),
('2024-01-07','13:00:00','13:05:00','15:20:00','17:00:00',140,5,'Afternoon','Sunday','General ER','Cough','Discharged',33,'Uninsured'),
('2024-01-07','15:30:00','15:35:00','17:40:00','19:15:00',130,4,'Afternoon','Sunday','Pediatric ER','Fever','Discharged',8,'Private'),
('2024-01-07','18:00:00','18:05:00','20:10:00','22:00:00',130,4,'Afternoon','Sunday','General ER','Nausea','Discharged',38,'Medicare'),
('2024-01-07','22:00:00','22:05:00','23:50:00','01:30:00',110,3,'Night','Sunday','General ER','Chest Pain','Admitted',71,'Medicare'),

-- Week 2
('2024-01-08','07:15:00','07:20:00','08:00:00','09:30:00',45,3,'Morning','Monday','General ER','Chest Pain','Admitted',60,'Medicare'),
('2024-01-08','09:00:00','09:05:00','10:50:00','12:15:00',110,4,'Morning','Monday','General ER','Headache','Discharged',42,'Private'),
('2024-01-08','11:30:00','11:35:00','13:30:00','15:00:00',120,4,'Morning','Monday','General ER','Abdominal Pain','Discharged',37,'Medicaid'),
('2024-01-08','14:00:00','14:05:00','16:15:00','18:00:00',135,5,'Afternoon','Monday','General ER','Back Pain','Discharged',53,'Uninsured'),
('2024-01-08','16:30:00','16:35:00','18:40:00','20:15:00',130,4,'Afternoon','Monday','Pediatric ER','Ear Infection','Discharged',3,'Private'),
('2024-01-08','21:00:00','21:05:00','22:55:00','00:30:00',115,3,'Night','Monday','General ER','Fever','Admitted',68,'Medicare'),

('2024-01-09','08:00:00','08:05:00','08:55:00','10:30:00',55,3,'Morning','Tuesday','General ER','Dizziness','Discharged',64,'Medicare'),
('2024-01-09','10:00:00','10:05:00','11:50:00','13:15:00',110,4,'Morning','Tuesday','General ER','Nausea','Discharged',29,'Private'),
('2024-01-09','12:30:00','12:35:00','14:30:00','16:00:00',120,4,'Afternoon','Tuesday','General ER','Ankle Sprain','Discharged',24,'Uninsured'),
('2024-01-09','15:00:00','15:02:00','15:20:00','17:00:00',20,1,'Afternoon','Tuesday','Trauma','Gunshot Wound','Admitted',31,'Uninsured'),
('2024-01-09','17:00:00','17:05:00','19:10:00','20:45:00',130,5,'Afternoon','Tuesday','General ER','Rash','Discharged',20,'Medicaid'),
('2024-01-09','22:30:00','22:35:00','00:20:00','02:00:00',110,3,'Night','Tuesday','General ER','Chest Pain','Admitted',66,'Medicare'),

('2024-01-10','07:00:00','07:05:00','07:50:00','09:15:00',50,3,'Morning','Wednesday','General ER','Shortness of Breath','Admitted',73,'Medicare'),
('2024-01-10','09:30:00','09:35:00','11:20:00','12:45:00',110,4,'Morning','Wednesday','General ER','Back Pain','Discharged',46,'Private'),
('2024-01-10','11:00:00','11:05:00','13:00:00','14:30:00',120,4,'Morning','Wednesday','Pediatric ER','Vomiting','Discharged',6,'Private'),
('2024-01-10','14:00:00','14:05:00','16:10:00','17:45:00',130,5,'Afternoon','Wednesday','General ER','Sore Throat','Discharged',18,'Uninsured'),
('2024-01-10','16:45:00','16:50:00','18:55:00','20:30:00',130,4,'Afternoon','Wednesday','General ER','Laceration','Discharged',26,'Private'),
('2024-01-10','23:00:00','23:05:00','00:50:00','02:30:00',110,3,'Night','Wednesday','General ER','Abdominal Pain','Admitted',55,'Medicaid'),

('2024-01-11','07:30:00','07:35:00','08:25:00','10:00:00',55,3,'Morning','Thursday','General ER','Chest Pain','Admitted',67,'Medicare'),
('2024-01-11','09:15:00','09:20:00','11:05:00','12:30:00',110,4,'Morning','Thursday','General ER','Fever','Discharged',39,'Private'),
('2024-01-11','12:00:00','12:05:00','14:00:00','15:30:00',120,4,'Afternoon','Thursday','General ER','Headache','Discharged',44,'Medicaid'),
('2024-01-11','15:30:00','15:35:00','17:40:00','19:00:00',130,5,'Afternoon','Thursday','General ER','Back Pain','Discharged',51,'Uninsured'),
('2024-01-11','18:00:00','18:05:00','20:05:00','21:45:00',125,4,'Afternoon','Thursday','General ER','Nausea','Discharged',35,'Private'),
('2024-01-11','22:00:00','22:05:00','23:55:00','01:30:00',115,3,'Night','Thursday','General ER','Dizziness','Discharged',58,'Medicare'),

('2024-01-12','08:00:00','08:05:00','09:50:00','11:20:00',110,4,'Morning','Friday','General ER','Abdominal Pain','Discharged',41,'Private'),
('2024-01-12','10:30:00','10:35:00','12:25:00','14:00:00',115,4,'Morning','Friday','Pediatric ER','Ear Pain','Discharged',7,'Private'),
('2024-01-12','13:00:00','13:05:00','15:15:00','17:00:00',135,5,'Afternoon','Friday','General ER','Cough','Discharged',32,'Medicaid'),
('2024-01-12','15:45:00','15:50:00','18:05:00','19:30:00',140,5,'Afternoon','Friday','General ER','Rash','Discharged',23,'Uninsured'),
('2024-01-12','18:30:00','18:35:00','20:50:00','22:30:00',140,4,'Afternoon','Friday','General ER','Ankle Sprain','Discharged',27,'Private'),
('2024-01-12','22:00:00','22:05:00','23:50:00','01:30:00',110,3,'Night','Friday','General ER','Chest Pain','Admitted',70,'Medicare'),

('2024-01-13','09:00:00','09:05:00','10:55:00','12:30:00',115,4,'Morning','Saturday','General ER','Back Pain','Discharged',48,'Private'),
('2024-01-13','11:00:00','11:05:00','13:15:00','15:00:00',135,5,'Morning','Saturday','General ER','Headache','Discharged',36,'Uninsured'),
('2024-01-13','13:30:00','13:35:00','15:45:00','17:15:00',135,4,'Afternoon','Saturday','General ER','Nausea','Discharged',42,'Medicaid'),
('2024-01-13','15:00:00','15:05:00','17:20:00','19:00:00',140,5,'Afternoon','Saturday','Pediatric ER','Fever','Discharged',5,'Private'),
('2024-01-13','17:30:00','17:35:00','19:45:00','21:30:00',135,4,'Afternoon','Saturday','General ER','Laceration','Discharged',30,'Private'),
('2024-01-13','21:30:00','21:35:00','23:25:00','01:00:00',115,3,'Night','Saturday','General ER','Chest Pain','Admitted',65,'Medicare'),

('2024-01-14','09:30:00','09:35:00','11:25:00','13:00:00',115,4,'Morning','Sunday','General ER','Abdominal Pain','Discharged',44,'Private'),
('2024-01-14','11:30:00','11:35:00','13:45:00','15:30:00',135,5,'Morning','Sunday','General ER','Back Pain','Discharged',52,'Medicaid'),
('2024-01-14','14:00:00','14:05:00','16:20:00','18:00:00',140,5,'Afternoon','Sunday','General ER','Cough','Discharged',38,'Uninsured'),
('2024-01-14','16:00:00','16:05:00','18:10:00','19:45:00',130,4,'Afternoon','Sunday','Pediatric ER','Vomiting','Discharged',9,'Private'),
('2024-01-14','19:00:00','19:05:00','21:10:00','22:45:00',130,4,'Night','Sunday','General ER','Dizziness','Discharged',61,'Medicare'),
('2024-01-14','22:30:00','22:35:00','00:25:00','02:00:00',115,3,'Night','Sunday','General ER','Fever','Admitted',74,'Medicare'),

-- Week 3
('2024-01-15','07:00:00','07:05:00','07:45:00','09:15:00',45,3,'Morning','Monday','General ER','Chest Pain','Admitted',59,'Medicare'),
('2024-01-15','09:00:00','09:05:00','10:55:00','12:20:00',115,4,'Morning','Monday','General ER','Headache','Discharged',40,'Private'),
('2024-01-15','11:30:00','11:35:00','13:35:00','15:00:00',125,4,'Morning','Monday','General ER','Abdominal Pain','Discharged',35,'Medicaid'),
('2024-01-15','14:00:00','14:05:00','16:15:00','18:00:00',135,5,'Afternoon','Monday','General ER','Back Pain','Discharged',49,'Uninsured'),
('2024-01-15','16:30:00','16:35:00','18:45:00','20:30:00',135,4,'Afternoon','Monday','Pediatric ER','Ear Infection','Discharged',4,'Private'),
('2024-01-15','21:00:00','21:05:00','23:00:00','00:30:00',120,3,'Night','Monday','General ER','Fever','Admitted',71,'Medicare'),

('2024-01-16','08:00:00','08:02:00','08:15:00','10:00:00',15,1,'Morning','Tuesday','Trauma','Severe Burns','Admitted',45,'Private'),
('2024-01-16','09:30:00','09:35:00','11:20:00','12:45:00',110,4,'Morning','Tuesday','General ER','Nausea','Discharged',28,'Private'),
('2024-01-16','12:00:00','12:05:00','14:00:00','15:30:00',120,4,'Afternoon','Tuesday','General ER','Ankle Sprain','Discharged',22,'Uninsured'),
('2024-01-16','15:00:00','15:05:00','17:10:00','18:45:00',130,5,'Afternoon','Tuesday','General ER','Rash','Discharged',19,'Medicaid'),
('2024-01-16','17:30:00','17:35:00','19:40:00','21:15:00',130,4,'Afternoon','Tuesday','General ER','Laceration','Discharged',25,'Private'),
('2024-01-16','22:00:00','22:05:00','23:55:00','01:30:00',115,3,'Night','Tuesday','General ER','Chest Pain','Admitted',64,'Medicare'),

('2024-01-17','07:15:00','07:20:00','08:05:00','09:30:00',50,3,'Morning','Wednesday','General ER','Shortness of Breath','Admitted',75,'Medicare'),
('2024-01-17','09:45:00','09:50:00','11:35:00','13:00:00',110,4,'Morning','Wednesday','General ER','Back Pain','Discharged',43,'Private'),
('2024-01-17','12:00:00','12:05:00','14:00:00','15:30:00',120,4,'Morning','Wednesday','Pediatric ER','Vomiting','Discharged',7,'Private'),
('2024-01-17','14:30:00','14:35:00','16:40:00','18:15:00',130,5,'Afternoon','Wednesday','General ER','Sore Throat','Discharged',20,'Uninsured'),
('2024-01-17','17:00:00','17:05:00','19:10:00','20:45:00',130,4,'Afternoon','Wednesday','General ER','Headache','Discharged',34,'Medicaid'),
('2024-01-17','23:00:00','23:05:00','00:55:00','02:30:00',115,3,'Night','Wednesday','General ER','Abdominal Pain','Admitted',57,'Medicare'),

('2024-01-18','07:30:00','07:35:00','08:20:00','09:45:00',50,3,'Morning','Thursday','General ER','Chest Pain','Admitted',66,'Medicare'),
('2024-01-18','10:00:00','10:05:00','11:50:00','13:15:00',110,4,'Morning','Thursday','General ER','Fever','Discharged',37,'Private'),
('2024-01-18','13:00:00','13:05:00','15:05:00','16:30:00',125,4,'Afternoon','Thursday','General ER','Headache','Discharged',46,'Medicaid'),
('2024-01-18','15:30:00','15:35:00','17:40:00','19:00:00',130,5,'Afternoon','Thursday','General ER','Back Pain','Discharged',53,'Uninsured'),
('2024-01-18','18:00:00','18:05:00','20:10:00','21:45:00',130,4,'Afternoon','Thursday','General ER','Nausea','Discharged',32,'Private'),
('2024-01-18','22:00:00','22:05:00','23:55:00','01:30:00',115,3,'Night','Thursday','General ER','Dizziness','Discharged',61,'Medicare'),

('2024-01-19','08:00:00','08:05:00','09:50:00','11:20:00',110,4,'Morning','Friday','General ER','Abdominal Pain','Discharged',39,'Private'),
('2024-01-19','10:30:00','10:35:00','12:30:00','14:00:00',120,4,'Morning','Friday','Pediatric ER','Ear Pain','Discharged',8,'Private'),
('2024-01-19','13:00:00','13:05:00','15:20:00','17:00:00',140,5,'Afternoon','Friday','General ER','Cough','Discharged',31,'Medicaid'),
('2024-01-19','15:45:00','15:50:00','18:10:00','19:30:00',145,5,'Afternoon','Friday','General ER','Rash','Discharged',24,'Uninsured'),
('2024-01-19','18:30:00','18:35:00','20:55:00','22:30:00',145,4,'Afternoon','Friday','General ER','Ankle Sprain','Discharged',26,'Private'),
('2024-01-19','22:00:00','22:05:00','23:55:00','01:30:00',115,3,'Night','Friday','General ER','Chest Pain','Admitted',69,'Medicare'),

('2024-01-20','09:00:00','09:05:00','11:00:00','12:30:00',120,4,'Morning','Saturday','General ER','Back Pain','Discharged',47,'Private'),
('2024-01-20','11:00:00','11:05:00','13:20:00','15:00:00',140,5,'Morning','Saturday','General ER','Headache','Discharged',34,'Uninsured'),
('2024-01-20','13:30:00','13:35:00','15:50:00','17:15:00',140,4,'Afternoon','Saturday','General ER','Nausea','Discharged',41,'Medicaid'),
('2024-01-20','15:00:00','15:05:00','17:20:00','19:00:00',140,5,'Afternoon','Saturday','Pediatric ER','Fever','Discharged',6,'Private'),
('2024-01-20','17:30:00','17:35:00','19:50:00','21:30:00',140,4,'Afternoon','Saturday','General ER','Laceration','Discharged',29,'Private'),
('2024-01-20','21:30:00','21:35:00','23:30:00','01:00:00',120,3,'Night','Saturday','General ER','Chest Pain','Admitted',64,'Medicare'),

('2024-01-21','09:30:00','09:35:00','11:30:00','13:00:00',120,4,'Morning','Sunday','General ER','Abdominal Pain','Discharged',43,'Private'),
('2024-01-21','11:30:00','11:35:00','13:50:00','15:30:00',140,5,'Morning','Sunday','General ER','Back Pain','Discharged',51,'Medicaid'),
('2024-01-21','14:00:00','14:05:00','16:25:00','18:00:00',145,5,'Afternoon','Sunday','General ER','Cough','Discharged',37,'Uninsured'),
('2024-01-21','16:00:00','16:05:00','18:15:00','19:45:00',135,4,'Afternoon','Sunday','Pediatric ER','Vomiting','Discharged',10,'Private'),
('2024-01-21','19:00:00','19:05:00','21:15:00','22:45:00',135,4,'Night','Sunday','General ER','Dizziness','Discharged',62,'Medicare'),
('2024-01-21','22:30:00','22:35:00','00:30:00','02:00:00',120,3,'Night','Sunday','General ER','Fever','Admitted',76,'Medicare'),

-- Week 4
('2024-01-22','07:00:00','07:05:00','07:50:00','09:20:00',50,3,'Morning','Monday','General ER','Chest Pain','Admitted',61,'Medicare'),
('2024-01-22','09:00:00','09:05:00','11:00:00','12:20:00',120,4,'Morning','Monday','General ER','Headache','Discharged',41,'Private'),
('2024-01-22','11:30:00','11:35:00','13:40:00','15:00:00',130,4,'Morning','Monday','General ER','Abdominal Pain','Discharged',36,'Medicaid'),
('2024-01-22','14:00:00','14:05:00','16:20:00','18:00:00',140,5,'Afternoon','Monday','General ER','Back Pain','Discharged',50,'Uninsured'),
('2024-01-22','16:30:00','16:35:00','18:50:00','20:30:00',140,4,'Afternoon','Monday','Pediatric ER','Ear Infection','Discharged',5,'Private'),
('2024-01-22','21:00:00','21:05:00','23:05:00','00:30:00',125,3,'Night','Monday','General ER','Fever','Admitted',72,'Medicare'),

('2024-01-23','08:00:00','08:05:00','08:55:00','10:30:00',55,3,'Morning','Tuesday','General ER','Dizziness','Discharged',63,'Medicare'),
('2024-01-23','10:00:00','10:05:00','11:55:00','13:15:00',115,4,'Morning','Tuesday','General ER','Nausea','Discharged',27,'Private'),
('2024-01-23','12:30:00','12:35:00','14:35:00','16:00:00',125,4,'Afternoon','Tuesday','General ER','Ankle Sprain','Discharged',23,'Uninsured'),
('2024-01-23','15:00:00','15:05:00','17:15:00','18:45:00',135,5,'Afternoon','Tuesday','General ER','Rash','Discharged',21,'Medicaid'),
('2024-01-23','17:00:00','17:05:00','19:15:00','20:45:00',135,4,'Afternoon','Tuesday','General ER','Laceration','Discharged',28,'Private'),
('2024-01-23','22:30:00','22:35:00','00:30:00','02:00:00',120,3,'Night','Tuesday','General ER','Chest Pain','Admitted',67,'Medicare'),

('2024-01-24','07:00:00','07:05:00','07:55:00','09:20:00',55,3,'Morning','Wednesday','General ER','Shortness of Breath','Admitted',74,'Medicare'),
('2024-01-24','09:30:00','09:35:00','11:25:00','12:45:00',115,4,'Morning','Wednesday','General ER','Back Pain','Discharged',44,'Private'),
('2024-01-24','12:00:00','12:05:00','14:05:00','15:30:00',125,4,'Morning','Wednesday','Pediatric ER','Vomiting','Discharged',8,'Private'),
('2024-01-24','14:30:00','14:35:00','16:45:00','18:15:00',135,5,'Afternoon','Wednesday','General ER','Sore Throat','Discharged',19,'Uninsured'),
('2024-01-24','17:00:00','17:05:00','19:15:00','20:45:00',135,4,'Afternoon','Wednesday','General ER','Headache','Discharged',33,'Medicaid'),
('2024-01-24','23:00:00','23:05:00','01:00:00','02:30:00',120,3,'Night','Wednesday','General ER','Abdominal Pain','Admitted',56,'Medicare'),

('2024-01-25','07:30:00','07:35:00','08:25:00','09:50:00',55,3,'Morning','Thursday','General ER','Chest Pain','Admitted',65,'Medicare'),
('2024-01-25','10:00:00','10:05:00','11:55:00','13:15:00',115,4,'Morning','Thursday','General ER','Fever','Discharged',38,'Private'),
('2024-01-25','13:00:00','13:05:00','15:10:00','16:30:00',130,4,'Afternoon','Thursday','General ER','Headache','Discharged',45,'Medicaid'),
('2024-01-25','15:30:00','15:35:00','17:45:00','19:00:00',135,5,'Afternoon','Thursday','General ER','Back Pain','Discharged',52,'Uninsured'),
('2024-01-25','18:00:00','18:05:00','20:15:00','21:45:00',135,4,'Afternoon','Thursday','General ER','Nausea','Discharged',31,'Private'),
('2024-01-25','22:00:00','22:05:00','00:00:00','01:30:00',120,3,'Night','Thursday','General ER','Dizziness','Discharged',60,'Medicare'),

('2024-01-26','08:00:00','08:05:00','09:55:00','11:20:00',115,4,'Morning','Friday','General ER','Abdominal Pain','Discharged',40,'Private'),
('2024-01-26','10:30:00','10:35:00','12:35:00','14:00:00',125,4,'Morning','Friday','Pediatric ER','Ear Pain','Discharged',6,'Private'),
('2024-01-26','13:00:00','13:05:00','15:25:00','17:00:00',145,5,'Afternoon','Friday','General ER','Cough','Discharged',30,'Medicaid'),
('2024-01-26','15:45:00','15:50:00','18:15:00','19:30:00',150,5,'Afternoon','Friday','General ER','Rash','Discharged',22,'Uninsured'),
('2024-01-26','18:30:00','18:35:00','21:00:00','22:30:00',150,4,'Afternoon','Friday','General ER','Ankle Sprain','Discharged',25,'Private'),
('2024-01-26','22:00:00','22:05:00','00:00:00','01:30:00',120,3,'Night','Friday','General ER','Chest Pain','Admitted',68,'Medicare'),

('2024-01-27','09:00:00','09:05:00','11:05:00','12:30:00',125,4,'Morning','Saturday','General ER','Back Pain','Discharged',46,'Private'),
('2024-01-27','11:00:00','11:05:00','13:25:00','15:00:00',145,5,'Morning','Saturday','General ER','Headache','Discharged',35,'Uninsured'),
('2024-01-27','13:30:00','13:35:00','15:55:00','17:15:00',145,4,'Afternoon','Saturday','General ER','Nausea','Discharged',40,'Medicaid'),
('2024-01-27','15:00:00','15:05:00','17:25:00','19:00:00',145,5,'Afternoon','Saturday','Pediatric ER','Fever','Discharged',7,'Private'),
('2024-01-27','17:30:00','17:35:00','19:55:00','21:30:00',145,4,'Afternoon','Saturday','General ER','Laceration','Discharged',28,'Private'),
('2024-01-27','21:30:00','21:35:00','23:35:00','01:00:00',125,3,'Night','Saturday','General ER','Chest Pain','Admitted',63,'Medicare'),

('2024-01-28','09:30:00','09:35:00','11:35:00','13:00:00',125,4,'Morning','Sunday','General ER','Abdominal Pain','Discharged',42,'Private'),
('2024-01-28','11:30:00','11:35:00','13:55:00','15:30:00',145,5,'Morning','Sunday','General ER','Back Pain','Discharged',50,'Medicaid'),
('2024-01-28','14:00:00','14:05:00','16:30:00','18:00:00',150,5,'Afternoon','Sunday','General ER','Cough','Discharged',36,'Uninsured'),
('2024-01-28','16:00:00','16:05:00','18:20:00','19:45:00',140,4,'Afternoon','Sunday','Pediatric ER','Vomiting','Discharged',11,'Private'),
('2024-01-28','19:00:00','19:05:00','21:20:00','22:45:00',140,4,'Night','Sunday','General ER','Dizziness','Discharged',63,'Medicare'),
('2024-01-28','22:30:00','22:35:00','00:35:00','02:00:00',125,3,'Night','Sunday','General ER','Fever','Admitted',77,'Medicare'),

('2024-01-29','07:00:00','07:05:00','07:55:00','09:20:00',55,3,'Morning','Monday','General ER','Chest Pain','Admitted',58,'Medicare'),
('2024-01-29','09:00:00','09:05:00','11:05:00','12:20:00',125,4,'Morning','Monday','General ER','Headache','Discharged',39,'Private'),
('2024-01-29','13:00:00','13:05:00','15:15:00','17:00:00',135,4,'Afternoon','Monday','General ER','Abdominal Pain','Discharged',34,'Medicaid'),
('2024-01-29','15:30:00','15:35:00','17:50:00','19:30:00',140,5,'Afternoon','Monday','General ER','Back Pain','Discharged',48,'Uninsured'),
('2024-01-29','21:00:00','21:05:00','23:10:00','00:30:00',130,3,'Night','Monday','General ER','Fever','Admitted',73,'Medicare'),

('2024-01-30','08:00:00','08:05:00','09:00:00','10:30:00',60,3,'Morning','Tuesday','General ER','Dizziness','Discharged',62,'Medicare'),
('2024-01-30','10:00:00','10:05:00','12:00:00','13:15:00',120,4,'Morning','Tuesday','General ER','Nausea','Discharged',26,'Private'),
('2024-01-30','13:00:00','13:02:00','13:20:00','15:00:00',20,1,'Afternoon','Tuesday','Trauma','Cardiac Arrest','Admitted',80,'Medicare'),
('2024-01-30','15:00:00','15:05:00','17:20:00','18:45:00',140,5,'Afternoon','Tuesday','General ER','Rash','Discharged',20,'Medicaid'),
('2024-01-30','17:30:00','17:35:00','19:50:00','21:15:00',140,4,'Afternoon','Tuesday','General ER','Laceration','Discharged',27,'Private'),
('2024-01-30','22:30:00','22:35:00','00:35:00','02:00:00',125,3,'Night','Tuesday','General ER','Chest Pain','Admitted',69,'Medicare');


-- ============================================================
-- ANALYSIS QUERIES
-- ============================================================

-- Query 1: Average wait time by shift
SELECT 
    shift,
    COUNT(*) AS total_visits,
    ROUND(AVG(wait_time_mins), 1) AS avg_wait_mins,
    MIN(wait_time_mins) AS min_wait,
    MAX(wait_time_mins) AS max_wait
FROM er_visits
GROUP BY shift
ORDER BY avg_wait_mins DESC;

-- Query 2: Average wait time by day of week
SELECT 
    day_of_week,
    COUNT(*) AS total_visits,
    ROUND(AVG(wait_time_mins), 1) AS avg_wait_mins
FROM er_visits
GROUP BY day_of_week
ORDER BY avg_wait_mins DESC;

-- Query 3: Wait time by triage level
SELECT 
    triage_level,
    CASE triage_level
        WHEN 1 THEN 'Critical'
        WHEN 2 THEN 'Emergency'
        WHEN 3 THEN 'Urgent'
        WHEN 4 THEN 'Less Urgent'
        WHEN 5 THEN 'Non-Urgent'
    END AS triage_label,
    COUNT(*) AS total_visits,
    ROUND(AVG(wait_time_mins), 1) AS avg_wait_mins
FROM er_visits
GROUP BY triage_level
ORDER BY triage_level;

-- Query 4: Admission rate by department
SELECT 
    department,
    COUNT(*) AS total_visits,
    SUM(CASE WHEN outcome = 'Admitted' THEN 1 ELSE 0 END) AS admitted,
    ROUND(SUM(CASE WHEN outcome = 'Admitted' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS admission_rate_pct
FROM er_visits
GROUP BY department;

-- Query 5: Shift-change peak hours (where waits spike)
SELECT 
    HOUR(arrival_time) AS arrival_hour,
    COUNT(*) AS visits,
    ROUND(AVG(wait_time_mins), 1) AS avg_wait_mins
FROM er_visits
GROUP BY HOUR(arrival_time)
ORDER BY arrival_hour;

-- Query 6: Top 5 most common complaints and their avg wait
SELECT 
    chief_complaint,
    COUNT(*) AS frequency,
    ROUND(AVG(wait_time_mins), 1) AS avg_wait_mins
FROM er_visits
GROUP BY chief_complaint
ORDER BY frequency DESC
LIMIT 10;

-- Query 7: Wait time by insurance type
SELECT 
    insurance_type,
    COUNT(*) AS total_visits,
    ROUND(AVG(wait_time_mins), 1) AS avg_wait_mins
FROM er_visits
GROUP BY insurance_type
ORDER BY avg_wait_mins DESC;

-- Query 8: Weekend vs Weekday comparison
SELECT 
    CASE WHEN day_of_week IN ('Saturday','Sunday') THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(*) AS total_visits,
    ROUND(AVG(wait_time_mins), 1) AS avg_wait_mins
FROM er_visits
GROUP BY day_type;
