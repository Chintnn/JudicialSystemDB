CREATE DATABASE jsds_2nf;
USE jsds_2nf;

-- 1. Court_2NF
CREATE TABLE Court_2NF (
    Court_ID INT PRIMARY KEY,
    Court_Name VARCHAR(100),
    Court_Location VARCHAR(255),
    Jurisdiction_Level VARCHAR(50)
);

-- 2. Case_Category_2NF
CREATE TABLE Case_Category_2NF (
    Category_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Description TEXT
);

-- 3. Person_2NF
CREATE TABLE Person_2NF (
    Person_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Date_of_Birth DATE,
    Contact VARCHAR(20),
    Address VARCHAR(255),
    National_ID VARCHAR(50) UNIQUE
);

-- 4. Lawyer_2NF
CREATE TABLE Lawyer_2NF (
    Lawyer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Contact VARCHAR(20),
    Specialization VARCHAR(100),
    Bar_Registration_Number VARCHAR(50) UNIQUE,
    Experience_Years INT
);

-- 5. Police_Station_2NF
CREATE TABLE Police_Station_2NF (
    Station_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Location VARCHAR(255),
    Station_Code VARCHAR(20) UNIQUE,
    Contact_Number VARCHAR(20)
);

-- 6. Case_Details_2NF
CREATE TABLE Case_Details_2NF (
    Case_ID INT PRIMARY KEY,
    Case_Number VARCHAR(50) UNIQUE,
    Filing_Date DATE,
    Case_Type VARCHAR(100),
    Status VARCHAR(50),
    Category_ID INT,
    Court_ID INT,
    FOREIGN KEY (Category_ID) REFERENCES Case_Category_2NF(Category_ID),
    FOREIGN KEY (Court_ID) REFERENCES Court_2NF(Court_ID)
);

-- 7. Verdict_2NF
CREATE TABLE Verdict_2NF (
    Verdict_ID INT PRIMARY KEY,
    Case_ID INT UNIQUE,
    Date DATE,
    Decision TEXT,
    Remarks TEXT,
    Penalty DECIMAL(10,2),
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID)
);

ALTER TABLE Case_Details_2NF ADD COLUMN Verdict_ID INT UNIQUE;
ALTER TABLE Case_Details_2NF ADD FOREIGN KEY (Verdict_ID) REFERENCES Verdict_2NF(Verdict_ID);

-- 8. Judge_2NF
CREATE TABLE Judge_2NF (
    Judge_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Designation VARCHAR(100),
    Experience_Years INT,
    Court_ID INT,
    FOREIGN KEY (Court_ID) REFERENCES Court_2NF(Court_ID)
);

-- 9. Petitioner_2NF
CREATE TABLE Petitioner_2NF (
    Person_ID INT PRIMARY KEY,
    Petition_Filed_Date DATE,
    Legal_Representative INT,
    FOREIGN KEY (Person_ID) REFERENCES Person_2NF(Person_ID),
    FOREIGN KEY (Legal_Representative) REFERENCES Lawyer_2NF(Lawyer_ID)
);

-- 10. Respondent_2NF
CREATE TABLE Respondent_2NF (
    Person_ID INT PRIMARY KEY,
    Response_Submitted_Date DATE,
    Legal_Representative INT,
    FOREIGN KEY (Person_ID) REFERENCES Person_2NF(Person_ID),
    FOREIGN KEY (Legal_Representative) REFERENCES Lawyer_2NF(Lawyer_ID)
);

-- 11. Police_Officer_2NF
CREATE TABLE Police_Officer_2NF (
    Person_ID INT PRIMARY KEY,
    Police_Station_ID INT,
    Badge_Number VARCHAR(50),
    Officer_Rank VARCHAR(50),
    Department VARCHAR(100),
    FOREIGN KEY (Person_ID) REFERENCES Person_2NF(Person_ID),
    FOREIGN KEY (Police_Station_ID) REFERENCES Police_Station_2NF(Station_ID)
);

-- 12. Witness_2NF
CREATE TABLE Witness_2NF (
    Person_ID INT PRIMARY KEY,
    Testimony_Date DATE,
    Type_of_Witness VARCHAR(100),
    FOREIGN KEY (Person_ID) REFERENCES Person_2NF(Person_ID)
);

-- 13. Court_Staff_2NF
CREATE TABLE Court_Staff_2NF (
    Staff_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Role VARCHAR(100),
    Contact VARCHAR(20),
    Court_ID INT,
    FOREIGN KEY (Court_ID) REFERENCES Court_2NF(Court_ID)
);

-- 14. Hearing_2NF
CREATE TABLE Hearing_2NF (
    Hearing_ID INT PRIMARY KEY,
    Case_ID INT,
    Judge_ID INT,
    Date DATE,
    Time TIME,
    Description TEXT,
    Outcome VARCHAR(255),
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID),
    FOREIGN KEY (Judge_ID) REFERENCES Judge_2NF(Judge_ID)
);

-- 15. FIR_2NF
CREATE TABLE FIR_2NF (
    FIR_ID INT PRIMARY KEY,
    Case_ID INT,
    Police_Station_ID INT,
    Filed_By INT,
    Date DATE,
    Details TEXT,
    Crime_Location VARCHAR(255),
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID),
    FOREIGN KEY (Police_Station_ID) REFERENCES Police_Station_2NF(Station_ID),
    FOREIGN KEY (Filed_By) REFERENCES Police_Officer_2NF(Person_ID)
);

-- 16. Evidence_2NF
CREATE TABLE Evidence_2NF (
    Evidence_ID INT PRIMARY KEY,
    Case_ID INT,
    Type VARCHAR(100),
    Description TEXT,
    Collected_By INT,
    Submission_Date DATE,
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID),
    FOREIGN KEY (Collected_By) REFERENCES Police_Officer_2NF(Person_ID)
);

-- 17. Legal_Act_2NF
CREATE TABLE Legal_Act_2NF (
    Act_ID INT PRIMARY KEY,
    Act_Name VARCHAR(255),
    Section VARCHAR(100),
    Description TEXT,
    Enactment_Year INT
);

-- 18. Charges_2NF
CREATE TABLE Charges_2NF (
    Charge_ID INT PRIMARY KEY,
    Case_ID INT,
    Legal_Act_ID INT,
    Description TEXT,
    Severity_Level VARCHAR(50),
    Charge_Date DATE,
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID),
    FOREIGN KEY (Legal_Act_ID) REFERENCES Legal_Act_2NF(Act_ID)
);

-- 19. Bail_2NF
CREATE TABLE Bail_2NF (
    Bail_ID INT PRIMARY KEY,
    Case_ID INT,
    Person_ID INT,
    Granted_Date DATE,
    Conditions TEXT,
    Bail_Amount DECIMAL(10,2),
    Status VARCHAR(50),
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID),
    FOREIGN KEY (Person_ID) REFERENCES Person_2NF(Person_ID)
);

-- 20. Settlement_2NF
CREATE TABLE Settlement_2NF (
    Settlement_ID INT PRIMARY KEY,
    Case_ID INT,
    Terms TEXT,
    Date DATE,
    Agreement_Signed BOOLEAN,
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID)
);

-- 21. Case_History_2NF
CREATE TABLE Case_History_2NF (
    History_ID INT PRIMARY KEY,
    Case_ID INT,
    Date DATE,
    Status_Update TEXT,
    Notes TEXT,
    Updated_By INT,
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID),
    FOREIGN KEY (Updated_By) REFERENCES Court_Staff_2NF(Staff_ID)
);

-- 22. Court_Room_2NF
CREATE TABLE Court_Room_2NF (
    Room_ID INT PRIMARY KEY,
    Court_ID INT,
    Room_Number VARCHAR(20),
    Capacity INT,
    Availability_Status VARCHAR(50),
    FOREIGN KEY (Court_ID) REFERENCES Court_2NF(Court_ID)
);

-- 23. Appeal_2NF
CREATE TABLE Appeal_2NF (
    Appeal_ID INT PRIMARY KEY,
    Case_ID INT,
    Filed_By INT,
    Date DATE,
    Reason TEXT,
    Status VARCHAR(50),
    Appeal_Level VARCHAR(50),
    FOREIGN KEY (Case_ID) REFERENCES Case_Details_2NF(Case_ID),
    FOREIGN KEY (Filed_By) REFERENCES Person_2NF(Person_ID)
);

-- 1. Court_2NF
INSERT INTO Court_2NF (Court_ID, Court_Name, Court_Location, Jurisdiction_Level) VALUES
(1, 'Supreme Court of India', 'New Delhi', 'National'),
(2, 'Delhi High Court', 'Delhi', 'State'),
(3, 'Bombay High Court', 'Mumbai', 'State'),
(4, 'Madras High Court', 'Chennai', 'State'),
(5, 'Calcutta High Court', 'Kolkata', 'State');

-- 2. Case_Category_2NF
INSERT INTO Case_Category_2NF (Category_ID, Name, Description) VALUES
(1, 'Criminal', 'Offenses against the law including theft, assault, and murder'),
(2, 'Civil', 'Disputes between individuals or organizations over rights and duties'),
(3, 'Family', 'Cases related to divorce, custody, and inheritance'),
(4, 'Corporate', 'Legal issues involving businesses or corporations'),
(5, 'Labor', 'Disputes involving workers and employers');

-- 3. Person_2NF
INSERT INTO Person_2NF (Person_ID, Name, Date_of_Birth, Contact, Address, National_ID) VALUES
(1, 'Aarav Mehta', '1985-03-15', '9876543210', '12 MG Road, Delhi', 'IND0012345'),
(2, 'Priya Sharma', '1990-07-22', '9811122233', 'Flat 204, Green Apartments, Mumbai', 'IND0012346'),
(3, 'Rahul Khanna', '1978-11-03', '9898989898', '56 Park Street, Kolkata', 'IND0012347'),
(4, 'Sneha Kapoor', '1995-01-10', '9845612300', '22 Lake View, Bengaluru', 'IND0012348'),
(5, 'Vikram Batra', '1980-06-27', '9823456789', '88 Civil Lines, Lucknow', 'IND0012349');

-- 4. Lawyer_2NF
INSERT INTO Lawyer_2NF (Lawyer_ID, Name, Contact, Specialization, Bar_Registration_Number, Experience_Years) VALUES
(1, 'Nikhil Arora', '9871100011', 'Criminal', 'BRN001', 12),
(2, 'Sakshi Menon', '9822200022', 'Civil', 'BRN002', 8),
(3, 'Manav Singh', '9813300033', 'Corporate', 'BRN003', 15),
(4, 'Aisha Qureshi', '9884400044', 'Family', 'BRN004', 10),
(5, 'Rajat Mehra', '9835500055', 'Labor', 'BRN005', 6);

-- 5. Police_Station_2NF
INSERT INTO Police_Station_2NF (Station_ID, Name, Location, Station_Code, Contact_Number) VALUES
(1, 'Connaught Place Station', 'Delhi', 'PSDL001', '01123450001'),
(2, 'Bandra Station', 'Mumbai', 'PSMH002', '02233440002'),
(3, 'Salt Lake Station', 'Kolkata', 'PSWB003', '03344550003'),
(4, 'Indiranagar Station', 'Bengaluru', 'PSKA004', '08055660004'),
(5, 'Hazratganj Station', 'Lucknow', 'PSUP005', '05226670005');

-- 6. Case_Details_2NF (Insert without Verdict_ID initially)
INSERT INTO Case_Details_2NF (Case_ID, Case_Number, Filing_Date, Case_Type, Status, Category_ID, Court_ID) VALUES
(1, 'C-2024-001', '2024-01-10', 'Criminal', 'Pending', 1, 1),
(2, 'C-2024-002', '2024-01-15', 'Civil', 'Ongoing', 2, 2),
(3, 'C-2024-003', '2024-01-20', 'Family', 'Closed', 3, 3),
(4, 'C-2024-004', '2024-02-01', 'Criminal', 'Pending', 4, 4),
(5, 'C-2024-005', '2024-02-10', 'Civil', 'Appealed', 5, 5);

-- 7. Verdict_2NF
INSERT INTO Verdict_2NF (Verdict_ID, Case_ID, Date, Decision, Remarks, Penalty) VALUES
(1, 1, '2024-03-20', 'Guilty', 'Strong evidence presented.', 5000.00),
(2, 2, '2024-03-25', 'Not Guilty', 'Lack of evidence.', 0.00),
(3, 3, '2024-04-01', 'Dismissed', 'Jurisdiction issue.', 0.00),
(4, 4, '2024-04-05', 'Guilty', 'Confession recorded.', 7000.00),
(5, 5, '2024-04-10', 'Not Guilty', 'Defendant cleared.', 0.00);

-- Update Case_Details_2NF with Verdict_ID
UPDATE Case_Details_2NF SET Verdict_ID = 1 WHERE Case_ID = 1;
UPDATE Case_Details_2NF SET Verdict_ID = 2 WHERE Case_ID = 2;
UPDATE Case_Details_2NF SET Verdict_ID = 3 WHERE Case_ID = 3;
UPDATE Case_Details_2NF SET Verdict_ID = 4 WHERE Case_ID = 4;
UPDATE Case_Details_2NF SET Verdict_ID = 5 WHERE Case_ID = 5;

-- 8. Judge_2NF
INSERT INTO Judge_2NF (Judge_ID, Name, Designation, Experience_Years, Court_ID) VALUES
(1, 'Justice Arvind Rao', 'Chief Justice', 25, 1),
(2, 'Justice Meera Das', 'Associate Judge', 18, 2),
(3, 'Justice Vikram Sinha', 'Senior Judge', 20, 3),
(4, 'Justice Neelam Gupta', 'Judge', 12, 4),
(5, 'Justice Ramesh Iyer', 'Associate Judge', 16, 5);

-- 9. Petitioner_2NF
INSERT INTO Petitioner_2NF (Person_ID, Petition_Filed_Date, Legal_Representative) VALUES
(1, '2023-01-15', 3),
(2, '2023-02-20', 4), -- Adjusted to avoid non-existent Lawyer_ID
(3, '2023-03-05', 1),
(4, '2023-04-18', 5), -- Adjusted to avoid non-existent Lawyer_ID
(5, '2023-05-25', 2);

-- 10. Respondent_2NF
INSERT INTO Respondent_2NF (Person_ID, Response_Submitted_Date, Legal_Representative) VALUES
(1, '2023-01-20', 5),
(2, '2023-02-25', 2),
(3, '2023-03-10', 4), -- Adjusted to avoid non-existent Lawyer_ID
(4, '2023-04-22', 3), -- Adjusted to avoid non-existent Lawyer_ID
(5, '2023-05-30', 1);

-- 11. Police_Officer_2NF
INSERT INTO Police_Officer_2NF (Person_ID, Police_Station_ID, Badge_Number, Officer_Rank, Department) VALUES
(1, 1, 'B1001', 'Sub Inspector', 'Criminal Investigation'),
(2, 2, 'B1002', 'Inspector', 'Homicide'),
(3, 3, 'B1003', 'Head Constable', 'Traffic'),
(4, 4, 'B1004', 'Constable', 'Cyber Crime'),
(5, 5, 'B1005', 'Inspector', 'Anti-Narcotics');

-- 12. Witness_2NF
INSERT INTO Witness_2NF (Person_ID, Testimony_Date, Type_of_Witness) VALUES
(1, '2023-01-22', 'Eyewitness'),
(2, '2023-02-14', 'Expert'),
(3, '2023-03-01', 'Medical'),
(4, '2023-03-15', 'Character'),
(5, '2023-04-10', 'Police');

-- 13. Court_Staff_2NF
INSERT INTO Court_Staff_2NF (Staff_ID, Name, Role, Contact, Court_ID) VALUES
(1, 'Amit Desai', 'Clerk', '9001010001', 1),
(2, 'Nisha Sharma', 'Typist', '9001010002', 2),
(3, 'Ravi Mehta', 'Bailiff', '9001010003', 3),
(4, 'Sunita Rao', 'Stenographer', '9001010004', 4),
(5, 'Manoj Yadav', 'Court Manager', '9001010005', 5);

-- 14. Hearing_2NF
INSERT INTO Hearing_2NF (Hearing_ID, Case_ID, Judge_ID, Date, Time, Description, Outcome) VALUES
(1, 1, 1, '2023-01-10', '10:00:00', 'Initial hearing for case 1', 'Adjourned'),
(2, 2, 2, '2023-01-15', '11:30:00', 'Preliminary statements', 'In Progress'),
(3, 3, 3, '2023-01-20', '09:45:00', 'Witness statements recorded', 'Completed'),
(4, 4, 4, '2023-01-25', '12:00:00', 'Cross examination begins', 'Adjourned'),
(5, 5, 5, '2023-01-30', '10:15:00', 'Evidence submitted', 'Completed');

-- 15. FIR_2NF
INSERT INTO FIR_2NF (FIR_ID, Case_ID, Police_Station_ID, Filed_By, Date, Details, Crime_Location) VALUES
(1, 1, 1, 1, '2023-01-01', 'Robbery reported by local shop owner.', 'Market Street, Delhi'),
(2, 2, 2, 2, '2023-01-03', 'Complaint filed for property damage.', 'Sector 10, Mumbai'),
(3, 3, 3, 3, '2023-01-05', 'Domestic violence case registered.', 'MG Road, Bengaluru'),
(4, 4, 4, 4, '2023-01-07', 'Cyber fraud complaint lodged.', 'Salt Lake, Kolkata'),
(5, 5, 5, 5, '2023-01-09', 'Car theft case initiated.', 'Banjara Hills, Hyderabad');

-- 16. Evidence_2NF
INSERT INTO Evidence_2NF (Evidence_ID, Case_ID, Type, Description, Collected_By, Submission_Date) VALUES
(1, 1, 'Document', 'Bank transaction records of the suspect.', 1, '2023-01-02'),
(2, 2, 'Digital', 'Security camera footage from store.', 2, '2023-01-04'),
(3, 3, 'Physical', 'Broken glass with blood stains.', 3, '2023-01-06'),
(4, 4, 'Digital', 'Chat logs indicating fraud.', 4, '2023-01-08'),
(5, 5, 'Physical', 'Knife recovered from crime scene.', 5, '2023-01-10');

-- 17. Legal_Act_2NF
INSERT INTO Legal_Act_2NF (Act_ID, Act_Name, Section, Description, Enactment_Year) VALUES
(1, 'Indian Penal Code', '302', 'Punishment for murder', 1860),
(2, 'Indian Penal Code', '420', 'Cheating and dishonestly inducing delivery of property', 1860),
(3, 'Indian Penal Code', '376', 'Punishment for rape', 1860),
(4, 'Indian Penal Code', '307', 'Attempt to murder', 1860),
(5, 'Indian Penal Code', '380', 'Theft in dwelling house', 1860);

-- 18. Charges_2NF
INSERT INTO Charges_2NF (Charge_ID, Case_ID, Legal_Act_ID, Description, Severity_Level, Charge_Date) VALUES
(1, 1, 1, 'Accused of first-degree murder under IPC 302.', 'Felony', '2023-01-02'),
(2, 2, 2, 'Fraudulently obtained money under IPC 420.', 'Major', '2023-01-03'),
(3, 3, 3, 'Charged with rape under IPC 376.', 'Felony', '2023-01-04'),
(4, 4, 4, 'Attempted to kill the victim under IPC 307.', 'Major', '2023-01-05'),
(5, 5, 5, 'Committed theft from a residential premises.', 'Minor', '2023-01-06');

-- 19. Bail_2NF
INSERT INTO Bail_2NF (Bail_ID, Case_ID, Person_ID, Granted_Date, Conditions, Bail_Amount, Status) VALUES
(1, 1, 1, '2023-01-03', 'Report weekly to police station', 5000.00, 'Granted'),
(2, 2, 2, '2023-01-05', 'Travel restrictions applied', 10000.00, 'Granted'),
(3, 3, 3, '2023-01-07', 'Surrender passport', 15000.00, 'Granted'),
(4, 4, 4, '2023-01-09', 'No contact with victim', 12000.00, 'Granted'),
(5, 5, 5, '2023-01-11', 'Stay within city limits', 7000.00, 'Granted');

-- 20. Settlement_2NF
INSERT INTO Settlement_2NF (Settlement_ID, Case_ID, Terms, Date, Agreement_Signed) VALUES
(1, 1, 'Both parties agreed to monetary compensation of $5,000.', '2023-01-05', TRUE),
(2, 2, 'Plaintiff will drop charges in exchange for public apology.', '2023-01-07', TRUE),
(3, 3, 'Defendant will vacate disputed land within 30 days.', '2023-01-09', TRUE),
(4, 4, 'Company to reinstate employee with back pay.', '2023-01-11', TRUE),
(5, 5, 'Tenant agrees to pay remaining dues and vacate premises.', '2023-01-13', TRUE);

-- 21. Case_History_2NF
INSERT INTO Case_History_2NF (History_ID, Case_ID, Date, Status_Update, Notes, Updated_By) VALUES
(1, 1, '2023-01-06', 'Case filed and registered.', 'Initial filing completed.', 1),
(2, 2, '2023-01-08', 'Evidence submitted.', 'Digital footage provided.', 2),
(3, 3, '2023-01-10', 'First hearing held.', 'Judge requested additional info.', 3),
(4, 4, '2023-01-12', 'Witness statement recorded.', 'Cross-examination scheduled.', 4),
(5, 5, '2023-01-14', 'Adjourned.', 'Lawyer requested extension.', 5);

-- 22. Court_Room_2NF
INSERT INTO Court_Room_2NF (Room_ID, Court_ID, Room_Number, Capacity, Availability_Status) VALUES
(1, 1, 'A-101', 50, 'Available'),
(2, 1, 'A-102', 45, 'Occupied'),
(3, 2, 'B-201', 60, 'Under Maintenance'),
(4, 2, 'B-202', 55, 'Available'),
(5, 3, 'C-301', 70, 'Occupied');

-- 23. Appeal_2NF
INSERT INTO Appeal_2NF (Appeal_ID, Case_ID, Filed_By, Date, Reason, Status, Appeal_Level) VALUES
(1, 1, 1, '2023-02-01', 'Disagreement with judgment.', 'Pending', 'High'),
(2, 2, 2, '2023-02-03', 'New evidence discovered.', 'Granted', 'High'),
(3, 3, 3, '2023-02-05', 'Ineffective counsel.', 'Dismissed', 'District'),
(4, 4, 4, '2023-02-07', 'Unfair trial proceedings.', 'Pending', 'Supreme'),
(5, 5, 5, '2023-02-09', 'Sentencing too harsh.', 'Granted', 'High');


-- Demo Check
SELECT * FROM Petitioner_2NF;
SELECT * FROM Respondent_2NF;
SELECT * FROM Case_Details_2NF;
SELECT * FROM Verdict_2NF;
