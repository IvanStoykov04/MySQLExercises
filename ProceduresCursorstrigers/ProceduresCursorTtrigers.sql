
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

