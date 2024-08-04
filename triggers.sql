/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 */
 
-- Generate an Invoice when a new Appointment is added (only on accute/non-scheduled appointments)
CREATE OR REPLACE TRIGGER trg_generate_invoice
    AFTER INSERT ON Appointment
    FOR EACH ROW
    BEGIN

        IF :NEW.Scheduled = 0 THEN
            INSERT INTO Invoice (AppointmentID, Content)
            VALUES (:NEW.AppointmentID, 'Poplatok za akútne vyšetrenie');
        END IF;
    END;


-- Insert appointments to demonstrate trigger functionality
INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (9, 4, SYSDATE + INTERVAL '2' DAY, 'Angína, predpísané antibiotiká, týždeň domácej liečby', 0, 100001);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (10, 6, SYSDATE, 'Chrípka, týždeň domácej liečby', 0, 100002);

INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (11, 4, SYSDATE + INTERVAL '2' DAY, 'Preventívna kontrola, odber krvi', 1, 100003);

-- Display Invoice table
SELECT InvoiceID AS "Invoice", AppointmentID AS "Appointment", Content
FROM Invoice;



-- Procedure that calls an external tool to send a SMS message (right now only for demonstration purposes)
CREATE OR REPLACE PROCEDURE send_sms(recipient_number VARCHAR2, message NVARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Sending reminder SMS to ' || recipient_number || ': ' || message);
    -- Call the external tool
END send_sms;

-- Trigger that sends a SMS message to a patient after he has been scheduled for an appointment
CREATE OR REPLACE TRIGGER trg_send_sms_scheduled
AFTER INSERT ON Appointment
FOR EACH ROW
    DECLARE
        pat_contact NVARCHAR2(16);
        ap_time VARCHAR2(16);
    BEGIN
        IF :NEW.Scheduled = 1 THEN
            SELECT Contact INTO pat_contact FROM Patient WHERE PatientID = :NEW.PatientId;
            ap_time := TO_CHAR(:NEW.DateTime, 'DD.MM.YYYY HH24:MI');

            -- Call the send_sms procedure
            send_sms(pat_contact,'Ambulancia Dr.[Meno]: Boli ste objednaný na ' || ap_time);
        END IF;
END;

-- Demonstrate the trigger
-- "Enable DBMSOUTPUT" must be checked to see the output message
INSERT INTO Appointment (AppointmentID, AppointmentType, DateTime, DoctorsNote, Scheduled, PatientID)
VALUES (17, 2, TO_DATE('2024-12-10-10-30', 'YYYY-MM-DD-HH24-MI'), 'Preventívna kontrola', 1, 2);
