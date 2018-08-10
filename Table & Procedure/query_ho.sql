--List the individual that made the donation as organization before
select "individual" as "Individual ID"
from 
(select participant_dbID as "individual" from INDIVIDUALS, PARTICIPANTS where participant_dbID = Individual_dbID) ind,
ORGANISATIONS
where Organisation_DBID = ind."individual"