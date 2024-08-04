/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 */

-- List patients who have appointment requests to be examined in 'Poliklinika Starý Liskovec'.
SELECT DISTINCT PatientID, Name, Surname
FROM Patient
         NATURAL JOIN Appointment
         NATURAL JOIN AppointmentRequest
WHERE Location = 'Poliklinika Starý Liskovec';


-- Show medication (and in what amount) that were prescribed to Jozef Novák.
SELECT MedicationID, Med.Name, SUM(Pres.Amount) total_amount
FROM Patient Pat
         JOIN Appointment A USING (PatientID)
         JOIN Prescription Pres USING (AppointmentID)
         JOIN Medication Med USING (MedicationID)
WHERE Pat.Name = 'Jozef'
  AND Pat.Surname = 'Novák'
GROUP BY MedicationID, Med.Name;


-- Calculate the total amount of prescribed medication paid by the individual insurance companies.
SELECT InsuranceCompanyID, SUM(Amount) total_amount
FROM Patient
         NATURAL JOIN Appointment
         NATURAL JOIN Prescription
WHERE InsuranceCompanyID IS NOT NULL
GROUP BY InsuranceCompanyID;


-- List nationalities of treated patients and their count in descending order.
SELECT Citizenship, COUNT(*) patients_count -- foreign patients
FROM ForeignPatient
GROUP BY Citizenship
UNION
SELECT 'CZE' Citizenship, COUNT(*) patients_count -- local patients (don't have a record in ForeignPatient table)
FROM Patient
WHERE PatientID NOT IN (SELECT PatientID FROM ForeignPatient)
ORDER BY patients_count DESC;


-- List all patients that had an appointment in March 2023
SELECT DISTINCT Patient.PatientID AS "ID", Patient.Name, Patient.Surname
FROM Patient
         JOIN Appointment ON Patient.PatientID = Appointment.PatientID
WHERE EXTRACT(YEAR FROM Appointment.DateTime) = 2023
  AND EXTRACT(MONTH FROM Appointment.DateTime) = 3;


-- List all patients that were sent for an appointment with a specialist after a blood test (Odber krvi)
SELECT DISTINCT Pat.PatientID AS "ID", Pat.Name, Pat.Surname, Ap.DateTime AS "Date"
FROM Patient Pat
         JOIN Appointment Ap ON Ap.PatientID = Pat.PatientID
         JOIN MedicalProcedure Mp ON Mp.AppointmentID = Ap.AppointmentID
         JOIN AppointmentRequest Apr ON Apr.AppointmentID = Mp.AppointmentID
WHERE Mp.ProcedureName = 'Odber krvi'
ORDER BY ap.DateTime;


-- List all patients that got prescribed 2 doses of Ampicillin (during one appointment)
SELECT Pat.PatientID AS "ID", Pat.Name, Pat.Surname, Ap.DateTime AS "Date", Ap.DoctorsNote AS "Doctor's Note"
FROM Patient Pat
         JOIN Appointment Ap ON Ap.PatientID = Pat.PatientID
WHERE EXISTS (SELECT 1
              FROM Prescription Perc
                       JOIN Medication Md ON Perc.MedicationID = Md.MedicationID
              WHERE Perc.Amount = 2
                AND Perc.AppointmentID = Ap.AppointmentID
                AND Md.Name = 'Ampicillin')
ORDER BY ap.DateTime;


-- Lists patients who have been prescribed an amount of medication greater than the overall average
WITH prescribed_average AS (SELECT AVG(total) average -- calculate average amount of prescribed medication for patient
                            FROM (SELECT SUM(COALESCE(Amount, 0)) total
                                  FROM Patient
                                           LEFT JOIN Appointment USING (PatientID)
                                           LEFT JOIN Prescription USING (AppointmentID)
                                  GROUP BY PatientID))
SELECT Surname,
       Name,
       CASE
           WHEN Gender = 'M' THEN 'Male'
           WHEN Gender = 'F' THEN 'Female'
           END AS  Gender,
       SUM(Amount) Total_prescribed
FROM Patient
         NATURAL JOIN Appointment
         NATURAL JOIN Prescription
         CROSS JOIN prescribed_average
GROUP BY Surname, Name, Gender, prescribed_average.average
HAVING SUM(Amount) > prescribed_average.average
ORDER BY Total_prescribed DESC;
