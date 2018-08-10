--find the Status of participant who make the most money donation and the corresponding payment indormation
with data as(
    select max(count(mon.amount)) as "most_money", mon.donation_dbid as "donation_dbid", pa.OperatorInitial as "participant initial"
	from PARTICIPANTS pa,DONATIONS do,MONEY_DONATION mon 
	where pa.Participant_DBID=do.donation_dbid 
	and do.donation_dbid = mon.donation_dbid
	group by donation_dbid )
select data."participant initial" as "participant initial", data."most_money",payment.checkno,payment.type,payment.paypal_ID,payment.date
from MODE_OF_PAYMENT payment
where payment.participant_dbID=data."donation_dbid"
