/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 */

-- Materialized view of appointments that are scheduled for today made for nurse
CREATE MATERIALIZED VIEW appointments_today
REFRESH ON DEMAND AS
    SELECT Patient.Name AS Name,
            Patient.Surname AS Surname,
           TO_CHAR(Schedule_Appointment.DateTime, 'HH24:MI') AS Time,
           Schedule_Appointment.AppointmentType              AS "Type of Appointment"
    FROM XLETAS00.Schedule_Appointment
             JOIN XLETAS00.Patient ON Schedule_Appointment.PatientID = Patient.PatientID
    WHERE EXTRACT(DAY FROM Schedule_Appointment.DateTime) = EXTRACT(DAY FROM SYSDATE);

-- Show appointments today
SELECT * from appointments_today;

