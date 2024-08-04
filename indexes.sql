/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 */

EXPLAIN PLAN FOR
-- Show medication (and in what amount) that were prescribed to Jozef Novák.
SELECT MedicationID, Med.Name, SUM(Pres.Amount) total_amount
FROM Patient Pat
         JOIN Appointment A USING (PatientID)
         JOIN Prescription Pres USING (AppointmentID)
         JOIN Medication Med USING (MedicationID)
WHERE Pat.Name = 'Jozef'
  AND Pat.Surname = 'Novák'
GROUP BY MedicationID, Med.Name;

SELECT PLAN_TABLE_OUTPUT -- unoptimized execution of the query
FROM TABLE ( DBMS_XPLAN.DISPLAY() );

-- Index that optimizes the search of patients by their name and surname.
CREATE INDEX Index_Patient_Name_Surname ON Patient (Name, Surname);
-- Indexes that optimize NATURAL JOINs of tables Patient|Appointment|Prescription.
CREATE INDEX Index_Appointment_PatientId ON Appointment (PatientID);
CREATE INDEX Index_Prescription ON Prescription (AppointmentID);

EXPLAIN PLAN FOR
SELECT MedicationID, Med.Name, SUM(Pres.Amount) total_amount
FROM Patient Pat
         JOIN Appointment A USING (PatientID)
         JOIN Prescription Pres USING (AppointmentID)
         JOIN Medication Med USING (MedicationID)
WHERE Pat.Name = 'Jozef'
  AND Pat.Surname = 'Novák'
GROUP BY MedicationID, Med.Name;

SELECT PLAN_TABLE_OUTPUT -- optimized execution of the query thanks to indexes
FROM TABLE ( DBMS_XPLAN.DISPLAY() );
