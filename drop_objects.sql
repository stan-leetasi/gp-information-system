/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 Theme: General practitioner's office
 */
 
DROP TABLE Prescription;
DROP TABLE Invoice;
DROP TABLE ForeignPatient;
DROP TABLE AppointmentRequest;
DROP TABLE MedicalProcedure;
DROP TABLE Medication;
DROP TABLE Appointment;
DROP TABLE Patient;

DROP SEQUENCE patient_ID_seq;
DROP SEQUENCE appointment_ID_seq;
DROP SEQUENCE invoice_ID_seq;

DROP MATERIALIZED VIEW appointments_today;