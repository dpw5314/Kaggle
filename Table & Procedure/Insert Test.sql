use parentAID;
truncate PARTICIPANT_RELATION;
-- Testing
insert into participants values (NULL,NULL, NULL, NULL, 'INSERT', 'TC','Individual');  -- TEST SEQ
insert into participants values ('A14333', 'S1231325', NULL, NULL, 'INSERT', 'TC','Individual', NULL, NULL);
insert into participants values ('A14332', 'S1231325', NULL, NULL, 'INSERT', 'TC','Individual', NULL, NULL);
insert into participants values ('A14331', 'S1231325', NULL, NULL, 'INSERT', 'TC','Individual', NULL, NULL);
insert into participants values ('A14330', 'S1231325', NULL, NULL, 'INSERT', 'TC','Individual', NULL, NULL);
insert into participants values ('A14339', 'S1231325', NULL, NULL, 'INSERT', 'TC','Individual', NULL, NULL);
insert into participants values ('A14312', 'S1231325', NULL, NULL, 'INSERT', 'TC','Company', NULL, NULL);
insert into participants values ('A14355', 'S1231325', NULL, NULL, 'INSERT', 'TC','Company', NULL, NULL);
insert into participants values ('A14367', 'S1231325', NULL, NULL, 'INSERT', 'TC','Company', NULL, NULL);
insert into participants values ('A14376', 'S1231325', NULL, NULL, 'INSERT', 'TC','Company', NULL, NULL);
insert into participants values ('A14350', 'S1231325', NULL, NULL, 'INSERT', 'TC','Company', NULL, NULL);
insert into PARTICIPANT_RELATION values('A19953', 'A14333','Parent-Child');
insert into PARTICIPANT_RELATION values('A14332', 'A19953','Child-Parent');
insert into PARTICIPANT_RELATION values('A14331', 'A14332','Parent-Child');
insert into PARTICIPANT_RELATION values('A14331', 'A14333','Parent-Child');
insert into PARTICIPANT_RELATION values('A14332', 'A14333','Sibling-Sibling');
insert into PARTICIPANT_RELATION values('A19953', 'A14333','Spouse-Spouse');
insert into PARTICIPANT_RELATION values('A14330', 'A19953','Sibling-Silbing');
insert into PARTICIPANT_RELATION values('A19953', 'A14312','Individual-Company');
insert into PARTICIPANT_RELATION values('A14339', 'A14312','Individual-Company');
insert into PARTICIPANT_RELATION values('A14367', 'A14312','Company-Company');

-- SEQ TEST EVENT
insert into EVENT VALUES(NULL, NULL, NOW(), 'Inserted', 'HappyBackToTaiwan', '2017-12-31', 'Celebrate', 'TC');

-- SEQ TEST PLEDGE
insert into pledge values(NULL, NULL, NOW(), 'Inserted', 'Concert', '2017-12-31', 5, 'TC', '2018-01-01', NULL, NULL);

-- SEQ TEST TICKET
insert into tickets values(NULL, NULL, 'Inserted', 130, 'ConcertTicket', 'ReallyFunny', 'TC', 'Availabile');
desc tickets;
select * from tickets;

-- SEQ MODEPAYMENT
insert into MODE_PAYMENT VALUES (NULL, 1000, NOW(), 213212312, 3122441, 'Card', NULL, NULL, NULL);
desc MODE_PAYMENT;
select * from MODE_PAYMENT;

-- SEQ DONATION
insert into DONATIONS VALUES (NULL, NULL, 'TC', NOW(), 'Inserted', NULL, NULL, NULL, NULL);
desc DONATIONS;
select * from DONATIONS;

-- SEQ DONATION
insert into APPEALS VALUES (NULL, NULL, 'YESICAN', 'TC', NOW(), NOW()+5, 'Inserted', NOW(), 'ReallyGood', 130, NULL, NULL, NULL);
desc APPEALS;
select * from APPEALS;

-- SEQ NOTE
insert into NOTES VALUES (NULL, NOW(), 
'Inserted', 'TC', 'BLABLABALFJDLKFJSA:AKF', NOW());
desc NOTES;
select * from NOTES;


-- Query
select * from PARTICIPANTS;
select * from PARTICIPANTS_ADDRESS;
select * from INDIVIDUALS;
select * from ORGANIZATIONS;
select * from EVENT;
select * from EVENT_FLAG;
select * from PLEDGE;
select * from TICKETS;
select * from DONATIONS;
select * from MONEYDONATIONS;
select * from INKINDDONATION;
select * from AUCTIONDONATION;
select * from MODE_PAYMENT;
select * from PARTICIPANT_RELATION;
