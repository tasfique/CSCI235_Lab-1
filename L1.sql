SQL> CREATE OR REPLACE TRIGGER statementTrigger
AFTER INSERT ON RunningSubject

DECLARE
  subCount NUMBER(1);

BEGIN
  SELECT COUNT(*)
  INTO subCount
  FROM RunningSubject
  GROUP BY year, asession
  HAVING COUNT(*)>7;
  
  IF subCount > 7 THEN
     RAISE_APPLICATION_ERROR(-20001,'No more than 7 subjects per session!');
  END IF;
  EXCEPTION
  WHEN no_data_found then subCount:=0;
END;
/

Trigger STATEMENTTRIGGER compiled

SQL> INSERT INTO RunningSubject VALUES ('CSCI236', 'AUTUMN', 2015, 150);

Error starting at line : 27 in command -
INSERT INTO RunningSubject VALUES ('CSCI236', 'AUTUMN', 2015, 150)
Error report -
SQL Error: ORA-20001: No more than 7 subjects per session!
ORA-06512: at "CSCI235.STATEMENTTRIGGER", line 12
ORA-04088: error during execution of trigger 'CSCI235.STATEMENTTRIGGER'

SQL> /
SQL> CREATE OR REPLACE TRIGGER rowTrigger
  BEFORE INSERT ON ACADEMIC
  FOR EACH ROW
  WHEN(NEW.Staff# > 0)

DECLARE
  staffNum ACADEMIC.STAFF#%TYPE;
BEGIN
  SELECT MAX(STAFF#) INTO staffNum FROM ACADEMIC;
  IF(:NEW.STAFF#!=staffNum + 1) THEN
    RAISE_APPLICATION_ERROR(-20001, 'When inserting a new staff record, the staff number must be continuous');
  END IF;
END;
/

Trigger ROWTRIGGER compiled

SQL> INSERT INTO ACADEMIC VALUES('1000000150','John','Stones','johnny@gmial.com', 'UOW', '6578', 'PROFESSOR');

Error starting at line : 45 in command -
INSERT INTO ACADEMIC VALUES('1000000150','John','Stones','johnny@gmial.com', 'UOW', '6578', 'PROFESSOR')
Error report -
SQL Error: ORA-20001: When inserting a new staff record, the staff number must be continuous
ORA-06512: at "CSCI235.ROWTRIGGER", line 6
ORA-04088: error during execution of trigger 'CSCI235.ROWTRIGGER'

SQL> /
SQL> spool off
