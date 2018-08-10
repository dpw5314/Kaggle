use parentAID;
drop trigger APPEALS_FKConstraint;

insert into APPEALS values('13334','cdak;df', 'Name', 'TC', '2012-12-01', '2012-12-30', 'Good','2012-12-03', 'Pretty good', 130, 'E112', '', '');

DELIMITER //
DROP PROCEDURE IF EXISTS APPEALS_FKConstraint//
CREATE TRIGGER  APPEALS_FKConstraint BEFORE INSERT ON  APPEALS
FOR EACH ROW
BEGIN
    declare EVENT_TRUE int;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
	BEGIN
			SET @handler_invoked = 1;
	END;
	SELECT 1 into EVENT_TRUE FROM EVENT WHERE Event_DBID = new.Event_DBID;
	if EVENT_TRUE is null then
		select 'Fuck You';
	
	end if;
END//
