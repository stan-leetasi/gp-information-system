/*
 Authors:
 Michal Krulich (xkruli03)
 Stanislav Letaši (xletas00)
 */

-- Prints patients and their date of birth based on their birth number.
DECLARE
    CURSOR curs1 IS SELECT *
                    FROM Patient;
    pat        Patient%ROWTYPE;
    v_year     NVARCHAR2(4);
    v_month    NVARCHAR2(2);
    v_day      NVARCHAR2(2);
    v_year_num INT;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('SURNAME', 16) || ' ' || RPAD('NAME', 16) || ' ' || 'DATE OF BIRTH');
    OPEN curs1;
    LOOP
        FETCH curs1 INTO pat;
        EXIT WHEN curs1%NOTFOUND;
        IF pat.Birthnumber IS NULL THEN
            CONTINUE;
        END IF;

        -- birth number parsing
        v_year := SUBSTR(pat.Birthnumber, 1, 2);
        v_month := SUBSTR(pat.Birthnumber, 3, 2);
        v_day := SUBSTR(pat.Birthnumber, 5, 2);

        -- parse month correctly in female birth numbers
        IF SUBSTR(v_month, 1, 1) = '5' THEN
            v_month := '0' || SUBSTR(v_month, 2);
        ELSIF SUBSTR(v_month, 1, 1) = '6' THEN
            v_month := '1' || SUBSTR(v_month, 2);
        END IF;

        -- identify the correct century of the year
        v_year_num := TO_NUMBER(v_year);
        IF v_year_num < 54 THEN
            v_year := '20' || v_year;
        ELSE
            v_year := '19' || v_year;
        END IF;

        DBMS_OUTPUT.PUT_LINE(RPAD(pat.Surname, 16) || ' ' || RPAD(pat.Name, 16) || ' ' || v_day || '.' || v_month ||
                             '.' || v_year);
    END LOOP;
    CLOSE curs1;
END;
/

-- Updates contact information for patient Jozef Novotný who isn't present in the database so an exception is raised.
DECLARE
    e_nonexistent_patient EXCEPTION ;
BEGIN
    UPDATE Patient
    SET Contact = '+420907855421'
    WHERE Name = 'Jozef'
      AND Surname = 'Novotný';
    IF SQL%NOTFOUND THEN
        RAISE e_nonexistent_patient;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Contact information has been successfully updated.');
EXCEPTION
    WHEN e_nonexistent_patient THEN DBMS_OUTPUT.PUT_LINE('Patient was not found.');
END;
/
