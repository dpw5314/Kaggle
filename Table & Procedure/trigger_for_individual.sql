CREATE OR REPLACE TRIGGER PARTICIPANTS_trigger 
before
     INSERT or update 
     ON INDIVIDUALS
for each row
declare
individual_Participant_DBID  INDIVIDUALS.Participant_DBID%type;
begin

 individual_Participant_DBID := :new.Participant_DBID;
if (:new.gender is not null ) then
insert into PARTICIPANTS (Participant_DBID) values (individual_Participant_DBID); 
end if;
end;
/