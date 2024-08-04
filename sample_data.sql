/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 Sample data for DB functionality demonstration
 */

-- Patients
INSERT INTO Patient (PatientID, Name, Surname, BirthNumber, InsuranceCompanyID, Address, Gender)
VALUES (1, 'Jozef', 'Novák', '8201212019', 22, 'Purkyňova 2640', 'M');

INSERT INTO Patient (PatientID, Name, Surname, BirthNumber, InsuranceCompanyID, Address, Gender)
VALUES (2, 'Jozefína', 'Nováková', '9256201185', 20, 'Purkyňova 2640', 'F');

INSERT INTO Patient (Name, Surname, BirthNumber, Gender)
VALUES ('Karol', 'Varga', '620719382', 'M');

INSERT INTO Patient (Name, Surname, BirthNumber, Gender)
VALUES ('Karolína', 'Vargová', '575623159', 'F');

INSERT INTO Patient (Name, Surname, Gender)
VALUES ('John', 'Doe', 'M');

INSERT INTO ForeignPatient (PatientID, Citizenship, PassportID)
VALUES (patient_ID_seq.currval, 'USA', 'AB123456');

INSERT INTO Patient (Name, Surname, Gender)
VALUES ('Charlotte', 'Smith', 'F');

INSERT INTO ForeignPatient (PatientID, Citizenship, PassportID)
VALUES (patient_ID_seq.currval, 'GBR', 'CD987654');


-- Appointments
INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (1, 1, TO_DATE('2023-03-21', 'YYYY-MM-DD'), 'Operácia žlčníka', 1, 1);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (2, 2, TO_DATE('2023-03-12', 'YYYY-MM-DD'), 'Opakovaná kontrola za 7 dní', 0, 2);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (3, 3, SYSDATE, 'Zhoršenie stavu po operácii', 0, 1);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (4, 4, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Odobraná krv, kontrola', 1, 2);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (5, 5, TO_DATE('2023-09-11', 'YYYY-MM-DD'), 'Kontrola po operácii, odber krvi', 1, 1);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (6, 4, TO_DATE('2023-12-12', 'YYYY-MM-DD'), 'Preventívna kontrola, odber krvi', 1, 100001);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (7, 6, TO_DATE('2023-03-30', 'YYYY-MM-DD'), 'Kontrola po prekonaní virózy, odber krvi', 0, 100002);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (8, 4, SYSDATE, 'Preventívna kontrola, odber krvi', 0, 100003);


-- Appointment Requests
INSERT INTO AppointmentRequest (RequestID, Location, RequestType, AppointmentID)
VALUES (1, 'Fakultní nemocnice Brno', 1, 1);

INSERT INTO AppointmentRequest (RequestID, Location, RequestType, AppointmentID)
VALUES (1, 'Poliklinika Starý Liskovec', 2, 2);

INSERT INTO AppointmentRequest (RequestID, Location, RequestType, AppointmentID)
VALUES (1, 'Fakultní nemocnice Brno', 3, 5);

INSERT INTO AppointmentRequest (RequestID, Location, RequestType, AppointmentID)
VALUES (1, 'Poliklinika Starý Liskovec', 3, 7);

INSERT INTO AppointmentRequest (RequestID, Location, RequestType, AppointmentID)
VALUES (1, 'Fakultní nemocnice Brno', 3, 8);


-- Medical Procedures
INSERT INTO MedicalProcedure (ProcedureID, ProcedureName, Results, AppointmentID)
VALUES (1, 'Preventívna kontrola', 'Nutná operácia žlčníka', 1);

INSERT INTO MedicalProcedure (ProcedureID, ProcedureName, Results, AppointmentID)
VALUES (1, 'Preventívna kontrola', 'Domáca liečba', 2);

INSERT INTO MedicalProcedure (ProcedureID, ProcedureName, Results, AppointmentID)
VALUES (1, 'Vyšetrenie', 'Všetko v poriadku', 3);

INSERT INTO MedicalProcedure (ProcedureID, ProcedureName, Results, AppointmentID)
VALUES (1, 'Odber krvi', 'Všetko v poriadku', 4);

INSERT INTO MedicalProcedure (ProcedureID, ProcedureName, Results, AppointmentID)
VALUES (1, 'Odber krvi', 'Nutná návšteva urológa', 5);

INSERT INTO MedicalProcedure (ProcedureID, ProcedureName, Results, AppointmentID)
VALUES (1, 'Odber krvi', 'Všetko v poriadku', 6);

INSERT INTO MedicalProcedure (ProcedureID, ProcedureName, Results, AppointmentID)
VALUES (1, 'Odber krvi', 'Okamžitá hospitalizácia', 7);

INSERT INTO MedicalProcedure (ProcedureID, ProcedureName, Results, AppointmentID)
VALUES (1, 'Odber krvi', 'Nutná návšteva gastroenterológa', 8);


-- Medication
INSERT INTO Medication (MedicationID, Name)
VALUES (425, 'Strepsils');

INSERT INTO Medication (MedicationID, Name)
VALUES (127, 'Cholagol');

INSERT INTO Medication (MedicationID, Name)
VALUES (780, 'Zodac');

INSERT INTO Medication (MedicationID, Name)
VALUES (125, 'Ampicillin');


-- Prescription
INSERT INTO Prescription (AppointmentID, MedicationID, Amount)
VALUES (1, 127, 1);

INSERT INTO Prescription (AppointmentID, MedicationID, Amount)
VALUES (1, 780, 2);

INSERT INTO Prescription (AppointmentID, MedicationID, Amount)
VALUES (2, 425, 1);

INSERT INTO Prescription (AppointmentID, MedicationID, Amount)
VALUES (3, 780, 1);

INSERT INTO Prescription (AppointmentID, MedicationID, Amount)
VALUES (3, 125, 2);

INSERT INTO Prescription (AppointmentID, MedicationID, Amount)
VALUES (5, 125, 1);

INSERT INTO Prescription (AppointmentID, MedicationID, Amount)
VALUES (7, 125, 2);

INSERT INTO Prescription (AppointmentID, MedicationID, Amount)
VALUES (8, 125, 3);


-- Invoices
INSERT INTO Invoice (InvoiceID, AppointmentID, Content)
VALUES (200, 1, 'Poplatok za vyšetrenie');

INSERT INTO Invoice (InvoiceID, AppointmentID, Content)
VALUES (300, 2, 'Poplatok za preventívnu prehliadku');