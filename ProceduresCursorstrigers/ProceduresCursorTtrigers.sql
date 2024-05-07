
-- cursor
DELIMITER |
CREATE PROCEDURE coachCursor()
BEGIN
DECLARE finished INT;
DECLARE coachName VARCHAR(100);
DECLARE coachEgn VARCHAR(10);
DECLARE coachCursor CURSOR FOR
SELECT name, egn FROM coach
WHERE salary IS NOT NULL;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=1;
OPEN coachCursor;
coach_loop: WHILE(finished=0)
DO
FETCH coachCursor INTO coachName,coachEgn;
IF (finished=1)
THEN
LEAVE coach_loop;
END IF;
SELECT coachName,coachEgn;
END WHILE;
CLOSE coachCursor;
SET finished=0;
SELECT 'finished';
END;
|
DELIMITER ;
CALL coachCursor();

-- triger
CREATE TABLE Student(
id INT AUTO_INCREMENT PRIMARY KEY,
id_student INT NOT NULL,
name VARCHAR(100) NOT NULL,
egn VARCHAR(10) NOT NULL,
phone VARCHAR(10) NOT NULL
);


CREATE TABLE newStudent(
id INT AUTO_INCREMENT PRIMARY KEY,
event ENUM('INSERT','UPDATE','DELETE') NOT NULL,
old_id_student INT NOT NULL,
new_id_student INT NOT NULL,
old_name VARCHAR(100) NOT NULL,
new_name VARCHAR(100) NOT NULL,
old_egn VARCHAR(10) NOT NULL,
new_egn VARCHAR(10) NOT NULL,
old_phone VARCHAR(10) NOT NULL,
new_phone VARCHAR(10) NOT NULL,
dateOfLog DATETIME
):

DELIMITER |
CREATE TRIGGER triger AFTER UPDATE ON student
FOR EACH ROW
BEGIN
INSERT INTO newStudent(event,old_id_student,new_id_student,old_name,new_name,old_egn,new_egn,old_phone,new_phone,dateOfLog)
VALUES('UPDATE',OLD.id_student,NEW.id_student,OLD.name,NEW.name,OLD.egn,NEW.egn,OLD.phone,NEW.phone,NOW());
END;
|
DELIMITER ;