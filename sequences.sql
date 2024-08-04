/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 Sequences for automatic ID generation
 */

CREATE SEQUENCE patient_ID_seq
    START WITH 100000 -- use custom primary keys lower than this value when inserting an entry with an explicit primary key
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE appointment_ID_seq
    START WITH 100000 -- use custom primary keys lower than this value when inserting an entry with an explicit primary key
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE invoice_ID_seq
    START WITH 100000 -- use custom primary keys lower than this value when inserting an entry with an explicit primary key
    INCREMENT BY 1
    NOMAXVALUE;