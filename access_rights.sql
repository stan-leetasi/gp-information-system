/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 */

-- "xkruli03" represents a user of type "Nurse" in a real-world use-case scenario
GRANT ALL ON Patient TO XKRULI03;
GRANT ALL ON ForeignPatient TO XKRULI03;
GRANT ALL ON Medication TO XKRULI03;

GRANT SELECT ON MedicalProcedure TO XKRULI03;
GRANT SELECT ON AppointmentRequest TO XKRULI03;
GRANT SELECT ON Invoice TO XKRULI03;

-- A nurse can schedule a patient for an appointment, but can't view or write a doctor's note
CREATE OR REPLACE VIEW Schedule_Appointment AS
    SELECT AppointmentID, AppointmentType, DateTime, Scheduled, PatientID
    FROM Appointment;

GRANT ALL ON Schedule_Appointment TO XKRULI03;