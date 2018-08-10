--list every the donation_ID and participants_ID for a specific event
select do.donation_DBID as "donation_DBID", eventpart."PARTICIPANTS_DBID_EVENT" as "PARTICIPANTS_DBID",eventpart."event_name" as "event_name"
(
select eve.EVENT_name as "event_name", par.PARTICIPANTS_DBID as "PARTICIPANTS_DBID_EVENT"
from EVENT eve, EVENT_ATTEND attend, PARTICIPANTS par
where eve.event_DBID=attend.event_DBID and attend.PARTICIPANTS_DBID = par.PARTICIPANTS_DBID ) eventpart, donation do
where do.PARTICIPANTS_DBID = eventpart."PARTICIPANTS_DBID_EVENT" and eventpart."event_name" = "123"
;
