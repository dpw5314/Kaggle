use parentAID;

-- Query 1 --> Find the top 10 participants who donation the most money.
select *
from
(select donations.participant_dbid as 'Participant_DBID', 
	sum(MONEYDONATIONS.amount)as 'Total amount donated', 
    @curRank := @curRank + 1 as 'Rank' -- Use variable to rank the total amount of payment of participant
from donations, MONEYDONATIONS, (SELECT @curRank := 0) r
where MONEYDONATIONS.donation_dbid = donations.donation_dbid
group by donations.participant_dbid
order by rank) as tb1
where tb1.rank <= 10; -- Only show the first 10 results



-- Query 2 --> general query to create a list of individuals (and the organisation to which they belong to) 
-- if they have missed the pledge due date.

select appeals.pledge_DBID, appeals.Participant_DBID, 
	concat(individuals.FirstName,' ', individuals.SecondName,' ', individuals.ThirdName, ' ', individuals.FourthName) as 'Name', 
    appeals.event_DBID, 
    organizations.CorporateName, 
    appeals.Appeal_APPID, 
    pledge.DateMade,
    pledge.DateDue, 
    pledge.Amount
from appeals, individuals, organizations, pledge
where pledge.PLEDGE_DBID = appeals.pledge_dbid
and appeals.participant_dbid = individuals.Participant_DBID
and ((select relatedID from participant_relation 
	 where INDIVIDUALS.Participant_DBID = relationID and RelationType = 'Individual-Company') = organizations.OrgParticipant_DBID)
and pledge.datedue < (select date(NOW()));

-- Query 3 --> general query to find pledges due even after duedate given the participant_dbid

select pledge.pledge_DBID, appeals.event_DBID, appeals.appeals_DBID, pledge.datemade, pledge.datedue, pledge.amount
from appeals, pledge, participants
where pledge.participant_dbid = '' -- $input_pledge_participant_dbid  -- Plase change it if you have a different variable name in php.
and pledge.pledge_DBID = appeals.pledge_dbid
and pledge.datedue < (select date(NOW()));





-- Query 4 general query to find any note corresponding to the ids entered

select notes.note_dbid, notes.text, notes.NotesDate
from notes, participants_notes, donations_notes, event_notes, appeals_notes, pledge_notes, mode_payment_notes

where participants_notes.participant_dbid = $php_input_participant_id
	and donations_notes.donation_dbid = $php_input_donations_id
	and event_notes.event_dbid = $php_input_event_id
	and pledge_notes.pledge_dbid = $php_pledge_id
	and mode_payment_notes.Tranction_ID = $input_transaction_id
	and (participants_notes.note_dbid = notes.note_dbid or donations_notes.note_dbid = notes.note_dbid or event_notes.note_dbid = notes.note_dbid or 
	pledge_notes.note_dbid= notes.note_dbid or mode_payment_notes.note_dbid = notes.note_dbid); 



-- ........................... specifies data to be entered by user. 


-- Query 5 --> query to find the number of people that attended an event along with the number of donations received at the same.

select event.event_dbid, 
	count(EVENTS_ATTEND.participant_dbid) , 
    count(donations.donation_dbid)
from event, EVENTS_ATTEND, donations
where event.event_dbid = EVENTS_ATTEND.event_dbid
and event.event_dbid = donations.Event_DBID_R
group by event.event_dbid;


-- Query 6 --> List of Auction donations for an event showing results and totals

select AUCTIONDONATION.donation_DBID, AUCTIONDONATION.buyNowAmount, 
	AUCTIONDONATION.startingBid, AUCTIONDONATION.noOfBids, 
    AUCTIONDONATION.BidsIncrement, AUCTIONDONATION.type, 
    AUCTIONDONATION.declaredValue, AUCTIONDONATION.recoveredValue
    -- AUCTIONDONATION.EndingBid -- What is this attribute??? Doesn't exist in ERD.
from AUCTIONDONATION, event, donations
where AUCTIONDONATION.donation_dbid = donations.donation_dbid
and event.event_dbid = donations.donation_dbid
and event.event_dbid = $input_event_id ;


-- where .......... is a value specified by the user. 

-- Query 7 --> List of Auction Donations by who donated and percentage of declared value received

select AUCTIONDONATION.donation_dbid, 
	donations.participant_dbid, 
    AUCTIONDONATION.declaredvalue, 
    AUCTIONDONATION.recoveredValue, 
    ((AUCTIONDONATION.recoveredValue * 100)/AUCTIONDONATION.declaredValue) as 'Percentage of declared value received'
from AUCTIONDONATION, donations
where AUCTIONDONATION.donation_dbid = donations.donation_dbid;


-- Query 8 --> List of inkind donations selected by who gave and what date
select INKINDDONATION.donation_dbid, 
	INKINDDONATION.datereceived, 
	INKINDDONATION.declaredvalue, 
    INKINDDONATION.recoveredvalue, INKINDDONATION.description, INKINDDONATION.reason
from INKINDDONATION, donations
where INKINDDONATION.donation_dbid = donations.donation_dbid
 and donations.participant_dbid = $input_participant_dbid   -- Plase change it if you have a different variable name in php.
 and dateRecieved.datereceived between $input_start_date and $input_end_date ;


-- Quer 9
-- list every the donation_ID and participants_ID for a specific event
select do.donation_DBID as 'donation_DBID', 
	tb1.PARTICIPANTS_DBID_EVENT as 'PARTICIPANTS_DBID',
	tb1.event_name as 'event_name'
from 
(	select eve.EVENTName as 'event_name', par.PARTICIPANT_DBID as 'PARTICIPANTS_DBID_EVENT'
	from EVENT eve, EVENTS_ATTEND attend, PARTICIPANTS par
	where eve.event_DBID=attend.event_DBID and attend.PARTICIPANT_DBID = par.PARTICIPANT_DBID ) tb1, donations do
where do.PARTICIPANT_DBID = tb1.PARTICIPANTS_DBID_EVENT and tb1.event_name = '123'
;


-- Query 10 find the Status of participant who make the most times of money donation and the corresponding payment indormation

select data1.participant_initial as 'participant initial', 
	max(data1.most_money) as 'Donation Times',
    payment.checkno,
    payment.payment_type,
    payment.paypal_ID,
    payment.TransactionDate
from MODE_PAYMENT payment, (
    select count(mon.amount) as 'most_money', mon.donation_dbid as 'donation_dbid', pa.OperatorIntial as 'participant_initial',
		pa.Participant_DBID as 'ID'
	from PARTICIPANTS pa,DONATIONS do,MONEYDONATIONS mon 
	where pa.Participant_DBID = do.donation_dbid 
	and do.donation_dbid = mon.donation_dbid
	group by donation_dbid ) as data1
where payment.participantsid=data1.donation_dbid
group by data1.ID;


-- Query 10 -- Like a small search engine, search all rows that include the specific word.
select * from notes where match(Text) against ('hahaha');
select * from notes where match(Text) against ($user_input_from_php); -- It won't search the words like I, is, am .....

select * from notes;

