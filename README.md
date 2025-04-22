# Judicial System Database

## DBMS CA3 - Mini Project

---

## Overview

The **Judicial System Database** project is a comprehensive relational database designed to streamline and digitize the operations of a judicial system. It covers various judicial entities and processes, including courts, cases, hearings, verdicts, police involvement, legal representatives, and appeals. By establishing strong relationships among key entities such as judges, lawyers, petitioners, respondents, police officers, and witnesses, the system facilitates efficient data organization, retrieval, and integrity.

Key objectives:
- Seamless case tracking—from FIR filing and investigation to court hearings, verdicts, and appeals.
- Specialized tables like **Legal Act**, **Charges**, and **Evidence** to record critical legal details and proceedings.
- Scalable design with **AUTO_INCREMENT** for hearing and history records to ensure error-free data entry.
- Compliance with legal data standards for transparency, accountability, and operational efficiency.

This database lays the groundwork for a robust judicial management system, addressing critical pain points such as fragmented records, poor case traceability, and manual errors.

---

## Features

- **Entity-Centric Design**: Comprehensive tables for courts, cases, hearings, verdicts, appeals, police involvement, and more.
- **Data Integrity**: Foreign key constraints and transactions to maintain referential integrity across complex relationships.
- **Audit Trail**: History tables and auto-generated timestamps for tracking modifications over time.
- **Scalability**: AUTO_INCREMENT primary keys and partitioning-ready schema to manage high volumes of case data.
- **Real-Time Tracking**: Centralized schema to support rapid querying and reporting on case status and courtroom schedules.
- **Legal Compliance**: Schema aligned with common legal data standards, ensuring compatibility with other judicial software systems.

---

## Architecture & Schema Overview

1. **Core Entities**:
   - **Courts**: Stores information about different judiciary levels and locations.
   - **Cases**: Central table linking to FIR, charges, involved parties, and status.
   - **Hearings**: Tracks each hearing session with date, courtroom, and attending judge(s).
   - **Verdicts**: Records the final decision, sentencing details, and related documents.
   - **Appeals**: Captures the appeal process including appellant, respondent, and outcome.

2. **Supporting Entities**:
   - **Police Officers** & **FIRs**: Manage initial complaint filing and officer assignment.
   - **Legal Representatives**: Judges, lawyers, petitioners, and respondents with contact and qualification details.
   - **Evidence** & **Charges**: Store granular details about legal evidence and specific charges applied.
   - **Legal Acts**: Reference statutes and regulations invoked during case proceedings.

3. **Audit & History**:
   - **Case_History**: Logs changes to case status, assigned judge, or courtroom.
   - **Hearing_History**: Maintains chronological record of hearing updates, notes, and adjournments.

---

## Getting Started

### Prerequisites

- **Git**: For cloning the repository
- **MySQL Server** (v5.7 or higher) or **MariaDB**
- **MySQL Client** (Workbench, DBeaver, CLI)
- **Operating System**: Windows, macOS, or Linux

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Chintnn/JudicialSystemDB.git
   cd JudicialSystemDB
   ```

2. **Create the database**
   ```sql
   CREATE DATABASE judicial_system;
   ```

3. **Import schema and sample data**
   ```bash
   mysql -u <username> -p judicial_system < schema/JudicialSystemDB.sql
   ```
   Replace `<username>` with your MySQL user. Enter your password when prompted.

---

## Usage

### Connecting to the Database

Use your preferred SQL client to connect:

- **Command Line**:
  ```bash
  mysql -u <username> -p
  USE judicial_system;
  ```

- **MySQL Workbench or DBeaver**:
  1. Create a new connection
  2. Host: `localhost` (or your DB host)
  3. Port: `3306`
  4. Username: `<username>`
  5. Select **judicial_system** as the default schema


### Running Example Queries

- **List all active cases**:
  ```sql
  SELECT case_id, title, status, filing_date
  FROM Cases
  WHERE status != 'Closed';
  ```

- **Fetch hearing schedule for a judge**:
  ```sql
  SELECT h.hearing_id, c.case_id, c.title, h.hearing_date, h.courtroom_id
  FROM Hearings h
  JOIN Cases c ON h.case_id = c.case_id
  WHERE h.judge_id = 123;
  ```

- **Generate case history report**:
  ```sql
  SELECT *
  FROM Case_History
  WHERE case_id = 456
  ORDER BY change_timestamp DESC;
  ```

---

## Dependencies

- **MySQL Server 5.7+ / MariaDB**
- **SQL Client** (Workbench, DBeaver, CLI)
- **Git**

Optional tools for development:
- **DB Diagramming**: MySQL Workbench, DBDesigner
- **Data Visualization**: Metabase, Tableau


