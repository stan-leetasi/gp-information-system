/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 Table schemes
 */

-- All patients (including foreign) have entries in table Patient.
CREATE TABLE Patient
(
    PatientID INT DEFAULT patient_ID_seq.nextval PRIMARY KEY,
    Name               NVARCHAR2(128) NOT NULL,
    Surname            NVARCHAR2(128) NOT NULL,
    BirthNumber        NVARCHAR2(10),
    InsuranceCompanyID INT,
    Address            NVARCHAR2(256),
    Contact   NVARCHAR2(16), -- phone number
    Gender    CHAR NOT NULL, -- M=male, F=female

    --(Sum of numbers on odd positions - sum of numbers on even positions) %11 == 0
    --Only for BirthNumbers that are 10 characters long
    CONSTRAINT chk_divisible_by_11 CHECK (
        LENGTH(BirthNumber) <> 10
            OR MOD((
                       TO_NUMBER(SUBSTR(BirthNumber, 1, 1)) + TO_NUMBER(SUBSTR(BirthNumber, 3, 1)) +
                       TO_NUMBER(SUBSTR(BirthNumber, 5, 1)) + TO_NUMBER(SUBSTR(BirthNumber, 7, 1)) +
                       TO_NUMBER(SUBSTR(BirthNumber, 9, 1)) -
                       TO_NUMBER(SUBSTR(BirthNumber, 2, 1)) - TO_NUMBER(SUBSTR(BirthNumber, 4, 1)) -
                       TO_NUMBER(SUBSTR(BirthNumber, 6, 1)) - TO_NUMBER(SUBSTR(BirthNumber, 8, 1)) -
                       TO_NUMBER(SUBSTR(BirthNumber, 10))
                       ), 11) = 0
        ),

    -- Ensure that months have the appropriate amount of days
    CONSTRAINT chk_day CHECK (
        BirthNumber IS NULL
            OR (
            (SUBSTR(BirthNumber, 3, 2) IN ('01', '03', '05', '07', '08', '10', '12',
                                           '51', '53', '55', '57', '58', '60', '62')
                AND
             TO_NUMBER(SUBSTR(BirthNumber, 5, 2)) BETWEEN 1 AND 31)
                OR
            (SUBSTR(BirthNumber, 3, 2) IN ('04', '06', '09', '11', '52', '54', '56',
                                           '59', '61')
                AND
             TO_NUMBER(SUBSTR(BirthNumber, 5, 2)) BETWEEN 1 AND 30)
                OR
            (SUBSTR(BirthNumber, 3, 2) = '02'
                AND
             TO_NUMBER(SUBSTR(BirthNumber, 5, 2)) BETWEEN 1 AND 29)
            )
        ),

    -- Check month format for male and female patients
    CONSTRAINT chk_month CHECK (
        BirthNumber IS NULL
            OR (
            (TO_NUMBER(SUBSTR(BirthNumber, 3, 2)) < 50
                AND
             TO_NUMBER(SUBSTR(BirthNumber, 3, 2)) BETWEEN 1 AND 12
                AND
             Gender = 'M')
                OR
            (TO_NUMBER(SUBSTR(BirthNumber, 3, 2)) > 50
                AND
             TO_NUMBER(SUBSTR(BirthNumber, 3, 2)) BETWEEN 51 AND 63
                AND
             Gender = 'F')
            )
        ),

    CONSTRAINT chk_birthnumber_format CHECK (
        BirthNumber IS NULL
            OR (
            (REGEXP_LIKE(BirthNumber, '^[0-9]{9}$') OR REGEXP_LIKE(BirthNumber, '^[0-9]{10}$'))
                AND
            TO_NUMBER(SUBSTR(BirthNumber, 1, 2)) BETWEEN 0 AND 99
                AND
            TO_NUMBER(SUBSTR(BirthNumber, 5, 2)) BETWEEN 1 AND 31
                AND
            LENGTH(BirthNumber) BETWEEN 9 AND 10
            )
        )
);

-- Foreign patients have an extra entry in table ForeignPatient.
CREATE TABLE ForeignPatient
(
    PatientID   INT PRIMARY KEY,
    Citizenship VARCHAR(3)  NOT NULL, -- ex. CZE, SVK, GRB,...
    PassportID  VARCHAR(32) NOT NULL,

    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID) ON DELETE CASCADE
);

CREATE TABLE Appointment
(
    AppointmentID INT DEFAULT appointment_ID_seq.nextval PRIMARY KEY,
    AppointmentType INT  DEFAULT 0 NOT NULL, -- application specific enumeration
    DateTime        DATE DEFAULT SYSDATE,
    DoctorsNote     NVARCHAR2(1000),
    Scheduled       NUMBER(1),               -- boolean
    PatientID       INT            NOT NULL,

    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID) ON DELETE CASCADE
);

CREATE TABLE AppointmentRequest
(
    RequestID     INT,
    Location      NVARCHAR2(256),
    RequestType   INT DEFAULT 0 NOT NULL, -- enumeration
    AppointmentID INT,

    PRIMARY KEY (RequestID, AppointmentID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointment (AppointmentID) ON DELETE CASCADE
);

CREATE TABLE MedicalProcedure
(
    ProcedureID   INT,
    ProcedureName NVARCHAR2(64) NOT NULL,
    Results       NVARCHAR2(1000),
    AppointmentID INT,

    PRIMARY KEY (ProcedureID, AppointmentID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointment (AppointmentID) ON DELETE CASCADE
);

CREATE TABLE Medication
(
    MedicationID INT PRIMARY KEY,
    Name NVARCHAR2(128) NOT NULL
);

CREATE TABLE Prescription
(
    AppointmentID INT,
    MedicationID  INT,
    Amount        INT DEFAULT 1 NOT NULL,

    PRIMARY KEY (AppointmentID, MedicationID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointment (AppointmentID) ON DELETE CASCADE,
    FOREIGN KEY (MedicationID) REFERENCES Medication (MedicationID) ON DELETE CASCADE
);

CREATE TABLE Invoice
(
    InvoiceID     INT DEFAULT invoice_ID_seq.nextval PRIMARY KEY,
    AppointmentID INT,
    Content       NVARCHAR2(1000),

    FOREIGN KEY (AppointmentID) REFERENCES Appointment (AppointmentID) ON DELETE CASCADE
);
