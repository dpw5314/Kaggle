SET FOREIGN_KEY_CHECKS=0;
use parentAID;

drop table AUCTIONDONATION;
drop table PARTICIPANT_RELATION;
drop table PARTICIPANTS CASCADE;
drop table PARTICIPANTS_ADDRESS CASCADE;
drop table PARTICIPANT_CONTACT;
drop table INDIVIDUALS CASCADE;
drop table ORGANIZATIONS CASCADE;
drop table EVENT CASCADE;
drop table EVENT_ADDRESS;
drop table EVENT_FLAG;
drop table EVENTS_ATTEND;
drop table PLEDGE;
drop table TICKETS;
drop table DONATIONS CASCADE;
drop table MONEYDONATIONS;
drop table INKINDDONATION;
drop table MODE_PAYMENT CASCADE;
drop table notes;
drop table APPEALS;
drop table installments;
drop table APPEALS_FLAG;
drop table PLEDGE_NOTES;
drop table participants_notes;
drop table event_notes;
drop table donations_notes;
drop table mode_payment_notes;
drop table appeals_notes;

SET FOREIGN_KEY_CHECKS=1;

 



create table PARTICIPANTS(
    Participant_DBID VARCHAR(25) DEFAULT '0',-- Participant ID that automatically created by database (trigger).
    Participant_APPID VARCHAR(25), -- Participant ID that created by application.
    DateOfJoin date,    -- The date that participants joined.
    ParticipantsTimeStamp timestamp, -- Timestamp
    RecordStatus char(15), -- Participants status.
    OperatorIntial varchar(8), -- Initial of the last operator.
    ParticipantType varchar(25), -- Type of participants, it can be individual or organization.
    -- Parent_ID varchar(10), -- Parent ID or Organization ID
    -- Event_DBID varchar(10), -- for relationship
    constraint PAR_PK primary key (Participant_DBID),
    -- constraint PARENT_FK foreign key (Parent_ID) references PARTICIPANTS (Participant_DBID),
    CONSTRAINT STATUS_PARTICIPANT CHECK (RecordStatus IN ('INSERT', 'UPDATE'))
    -- constraint PARENT_EVENT_FK foreign key (Event_DBID) references EVENT (Event_DBID)-- for relationship

)ENGINE = INNODB;

create table PARTICIPANTS_ADDRESS (
    Participant_DBID VARCHAR(25), -- The participant DBID from parent table PARTICIPANTS
    PostalCode int,   -- Postalcode of participants.
    AddressLine1 char(50), -- AddressLine one, if the address line is too long, save it to AddressLine2.
    AddressLine2 char(50), -- Optional Address Line.
    State varchar(30),     
    City varchar(30),       -- City of participants.
    Country varchar(50),    -- Country of participants.
    constraint Address_PK primary key (Participant_DBID, PostalCode, AddressLine1),
    constraint Address_FK foreign key (Participant_DBID) references PARTICIPANTS(Participant_DBID)    
)engine = INNODB;

create table PARTICIPANT_CONTACT(
	Participant_DBID VARCHAR(25),
    connectionText varchar(50),
    is_preferredconnection int(1),
    connectionType varchar(25),
    constraint CONTACT_PK primary key (Participant_DBID, connectionText),
    constraint CONTACT_FK foreign key (Participant_DBID) references PARTICIPANTS(Participant_DBID) 
)engine = INNODB;


create table ORGANIZATIONS (
    OrgParticipant_DBID VARCHAR(25), -- Parent key from participant, it's also the primary key of ORGANIZATIONS
    CorporateName VARCHAR(50),
    constraint ORGANIZATIONS_PK primary key (OrgParticipant_DBID),
    constraint ORGANIZATIONS_FK foreign key (OrgParticipant_DBID) references PARTICIPANTS (Participant_DBID)
)engine = INNODB;

create table INDIVIDUALS (
    Participant_DBID VARCHAR(25), -- This key is the foreign key from participant table nad also the primary key of INIDIVUALS
    gender char(10), -- Gender 
    pronoun char(10), -- Pronoun preference
    FirstName varchar(25), -- First Name of an individual
    SecondName varchar(25), -- SecondName of an individual.
    ThirdName varchar(25), -- Third name of an individual.
    FourthName varchar(25),  -- Fourth name of an individual, is it different from last name??
    Inidividual_suffix char(10), -- Suffix of an individual
    NickName varchar(50),  -- NickName of an individual
    Title varchar(50), -- Title of the individual, is it different from pronoun??
    -- Check constraint for gender???????? pronoun preference??
    OrgParticipant_DBID VARCHAR(25),
    Salutation varchar(10),
    constraint INDI_PK primary key (Participant_DBID),
    constraint INDI_FK foreign key (Participant_DBID) references PARTICIPANTS (Participant_DBID),
    constraint Org_INDI_FK foreign key (OrgParticipant_DBID) references ORGANIZATIONS (OrgParticipant_DBID)

)engine = INNODB;


create table PARTICIPANT_RELATION (
	relationID VARCHAR(25),
    relatedID VARCHAR(25),
    RelationType varchar(230),
    constraint PARTICIPANT_RELATION_PK primary key (relationID, relatedID),
    constraint par_relation_fk1 foreign key (relationID) references PARTICIPANTS(Participant_DBID),
    constraint par_relation_fk2 foreign key (relatedID) references PARTICIPANTS (Participant_DBID)
) engine = INNODB;


create table EVENT(
    Event_DBID VARCHAR(25) DEFAULT '0', -- DBID of an event.
    Event_APPID VARCHAR(25), -- The application ID of an event.
    EventTimeStamp timestamp, -- The time stamp of the event
    EventStatus varchar(15), -- The record of the event
    EventName varchar(30), -- The name of the event
    EventDate date, --  The date of the event
    EventType varchar(15),
    OperatorInitial varchar(8),
    constraint EVENT_PK primary key (Event_DBID), -- Primary key constraint  
    CONSTRAINT STATUS_EVENTS CHECK (EventStatus IN ('INSERT', 'UPDATE'))
)engine = INNODB;


create table EVENTS_ATTEND(  -- for relationship
    Event_DBID VARCHAR(25), -- DBID of an event.
    Participant_DBID VARCHAR(10),
    constraint EVENT_ATTEND_PK primary key (Event_DBID,Participant_DBID), -- Primary key constraint  
    constraint EVENT_ATTEND_FK foreign key (EVENT_DBID) references EVENT(Event_DBID),
    constraint EVENT_ATTEND_FK1 foreign key (Participant_DBID) references PARTICIPANTS(Participant_DBID)
)engine = INNODB;

create table EVENT_ADDRESS (
    EVENT_DBID VARCHAR(25),
    State varchar(20), -- Address: state of the event
    City varchar(20), -- Address: city of the event
    Country varchar(30), -- Address: country of the event
    Street varchar(50), -- Address: street of the event
    PostalNumber int, -- Address: postol number of the event
    Apt varchar(10), -- Address: the apartment number of the event
    constraint EVENT_ADDRESS_PK primary key (EVENT_DBID),
    constraint EVENT_ADDRESS_FK foreign key (EVENT_DBID) references EVENT(Event_DBID)
)engine = INNODB;

create table EVENT_FLAG (
    EVENT_DBID VARCHAR(25),
    is_ticket int(1), 
    is_silentauction int(1), 
    is_liveauction int(1), 
    is_pledge int(1), 
    is_donation int(1),
    constraint EVENT_FLAG_PK primary key (EVENT_DBID),
    constraint EVENT_FLAG_FK foreign key (EVENT_DBID) references EVENT(Event_DBID),
    constraint EVENT_FLAG_CONSTRAINT check (is_ticket in (0,1) and is_silentauction in (0,1) and is_liveauction in (0,1)
                and is_pledge in (0,1) and is_donation in (0,1))
)engine = INNODB;

create table PLEDGE (
    PLEDGE_DBID VARCHAR(25) DEFAULT '0', -- The DBID of a pledge
    PLEDGE_APPID VARCHAR(25), -- The application ID of a pledge
    PLEDGETimeStamp timestamp, -- The timestamp of a pledge
    PLEDGEStatus varchar(15), -- The status of a pledge
    PLEDGEType varchar(15), -- The type of a pledge
    DateMade date,  -- The date that made this pledge
    Amount int, -- The amount of a pledge
    OperatorIntial varchar(8), -- Initial of the last operator
    DateDue date, -- The due date of a pledge
    EVENT_DBID varchar(10), -- The related event_dbid
    Participant_DBID varchar(10), -- The related participant_dbid
    constraint PLEDGE_PK primary key (PLEDGE_DBID),
    constraint PLEDGE_EVENT_FK foreign key (EVENT_DBID) references EVENT(EVENT_DBID), -- for relationship   
    constraint PLEDGE_PARTICIPANT_FK foreign key (Participant_DBID) references PARTICIPANTS(Participant_DBID)
)engine = INNODB;

create table TICKETS( 
    TICKET_DBID VARCHAR(25) DEFAULT '0', -- The database id of a ticket
    TICKET_APPID VARCHAR(25), -- The application id of a ticket
    TICKETStatus varchar(15),  -- The status of a ticket
    price int, -- The price of a ticket
    Name varchar(20), -- The ticket name
    Description varchar(20), -- The description of a ticket
    OperatorIntial varchar(15), -- Initial of the last operator
    Availability VARCHAR(15), -- If the ticket is still available
    constraint TICKET_PK primary key (TICKET_DBID) -- Primary key constraint
)engine = INNODB;
/*
CREATE TABLE MODE_PAYMENT (
Tranction_ID VARCHAR(10),
cardNo int,
vcode int(3),
cheque_no int, 
payment_type char(10),
amount int, -- I'm not sure what kind of data type you want to use for amt
participantsid VARCHAR(10),
constraint MODE_PAYMENT_pk primary key (Tranction_ID),
constraint participantsid_fk foreign key (participantsid) references PARTICIPANTS(Participant_DBID),
constraint LENGTH_VCODE check (LENGTH(vcode) = 3)
);
*/

CREATE TABLE MODE_PAYMENT (
Tranction_ID VARCHAR(25) DEFAULT '0',
amount int,
TransactionDate date,
checkNo int(15),
cardNo int (15),
payment_type varchar(20),
EFT_ID varchar (20),
paypal_ID varchar (20),
participantsid VARCHAR(25),
constraint MODE_PAYMENT_pk primary key (Tranction_ID),
constraint participantsid_fk foreign key (participantsid) references PARTICIPANTS(Participant_DBID)
)engine = INNODB;

CREATE TABLE DONATIONS (
donation_dbid  VARCHAR(25) DEFAULT '0',
donations_applicationID VARCHAR(25), 
operator_initial  VARCHAR(10), 
D_timestamp timestamp, 
status varchar(15),
participant_dbID VARCHAR(25),
transaction_dbID VARCHAR(25),
Event_DBID_R VARCHAR(25),  -- for relationship 
PLEDGE_DBID_R VARCHAR(25),
constraint DONATIONS_PK primary key (donation_dbid),
constraint DONATION_FK_PARTICIPANT foreign key (participant_dbID) references PARTICIPANTS (Participant_DBID),
constraint DONATION_FK_TRANCTION foreign key (transaction_dbID) references MODE_PAYMENT (Tranction_ID),
CONSTRAINT STATUS_DONATION CHECK (status IN ('INSERT', 'UPDATE')),
constraint DONATION_FK_EVENT foreign key (Event_DBID_R) references EVENT (Event_DBID),-- for relationship 
constraint DONATION_FK_PLEDGE foreign key (PLEDGE_DBID_R) references PLEDGE (PLEDGE_DBID)-- for relationship 

)engine = INNODB;



CREATE TABLE MONEYDONATIONS (
donation_dbid  VARCHAR(25),
dateRecieved date,
type varchar(15),
amount int,
constraint MONEYDONATIONS_PK primary key (donation_dbid),
constraint moneydonations_fk foreign key (donation_dbid) references DONATIONS(donation_dbid)
)engine = INNODB;


CREATE TABLE INKINDDONATION (
donation_dbid  VARCHAR(25),
dateReceived date,
declaredValue int,
reason varchar(30),
description varchar(30),
recoveredValue int,
constraint INKINDDONATION_pk primary key (donation_dbid),
constraint INKIND_moneydonations_fk foreign key (donation_dbid) references DONATIONS(donation_dbid),
CONSTRAINT valuecheck CHECK (recoveredValue >=0)
)engine = INNODB;


CREATE TABLE AUCTIONDONATION (
donation_dbid  VARCHAR(25),
declaredValue int,
buyNowAmount int,
noOfBids int,
bidsIncrement int,
startingBid int,
recoveredValue int,
Type varchar(15),
constraint AUCTIONDONATION_pk primary key (donation_dbid),
constraint AUCTIONDONATION_fk foreign key (donation_dbid) references DONATIONS(donation_dbid),
CONSTRAINT recover_valuecheck CHECK (recoveredValue >=0),
CONSTRAINT increment_check CHECK (bidsIncrement >=0),
CONSTRAINT amountbuy_check CHECK (buyNowAmount >=0)

)engine = INNODB;



create table APPEALS(
Appeals_DBID VARCHAR(25) DEFAULT '0',
Appeal_APPID VARCHAR(25), 
AppealName varchar(20),
OperatorInitial VARCHAR(10),
StartDate date, 
EndDate date, 
APPEALStatus varchar(15),
APPEAL_TimeStamp timestamp, 
Description varchar(25),
TargetAmount int,
Event_DBID VARCHAR(25),
PLEDGE_DBID VARCHAR(25),
Participant_DBID VARCHAR(25),
constraint APPEALS_PK primary key (Appeals_DBID),
CONSTRAINT TargetAmount_check CHECK (TargetAmount >=0),
CONSTRAINT STATUS_APPEALS CHECK (APPEALStatus IN ('INSERT', 'UPDATE')),
constraint APPEALS_EVENT_FK foreign key (Event_DBID) references EVENT (Event_DBID),
constraint APPEALS_PARTICIPANT_FK foreign key (Participant_DBID) references PARTICIPANTS (Participant_DBID),
constraint APPEALS_PLEDGE_FK foreign key (PLEDGE_DBID) references PLEDGE(PLEDGE_DBID)
)engine = INNODB;
--  the cardinality of appeal to donation is strange

create table APPEALS_FLAG (
	Appeals_DBID VARCHAR(25),
    is_ticket int(1), 
    is_silentauction int(1), 
    is_liveauction int(1), 
    is_pledge int(1), 
    is_donation int(1),
    constraint APPEAL_FLAG_PK primary key(Appeals_DBID),
    constraint APPEAL_FLAG_FK foreign key(Appeals_DBID) references APPEALS(Appeals_DBID)  ON UPDATE CASCADE ON DELETE RESTRICT
)engine = INNODB;

Create table installments(
PLEDGE_DBID_R VARCHAR(25),
Tranction_ID_R VARCHAR(25),
CONSTRAINT installments_pk primary key (Tranction_ID_R,PLEDGE_DBID_R),
constraint PLEDGE_R_fk foreign key (PLEDGE_DBID_R) references PLEDGE(PLEDGE_DBID),
constraint Tranction_ID_R_fk foreign key (Tranction_ID_R) references MODE_PAYMENT(Tranction_ID)
)engine = INNODB;


-- notes and the relationship--------
Create table NOTES(
Note_DBID VARCHAR(25) DEFAULT '0',
NotesDate date,
notes_Status varchar(15),
Note_Operator_Initial  VARCHAR(10),
Text varchar(255),
Note_TimeStamp timestamp,
   CONSTRAINT NOTES_pk primary key (Note_DBID),
   fulltext(Text)

)engine = INNODB;

Create table PLEDGE_NOTES(
    PLEDGE_DBID VARCHAR(25), -- The DBID of a pledge
    Note_DBID VARCHAR(25),
   CONSTRAINT PLEDGE_NOTES_pk primary key (Note_DBID,PLEDGE_DBID),
   constraint PLEDGE_NOTES_fk foreign key (PLEDGE_DBID) references PLEDGE(PLEDGE_DBID),
    constraint PLEDGE_NOTES_fk_2 foreign key (Note_DBID) references NOTES(Note_DBID)
)engine = INNODB;

create table MODE_PAYMENT_notes(
   Tranction_ID VARCHAR(25),
   Note_DBID VARCHAR(25),
 CONSTRAINT MODE_PAYMENT_notes_pk primary key (Tranction_ID,Note_DBID),
 constraint MODE_PAYMENT_notes_fk foreign key (Tranction_ID) references MODE_PAYMENT(Tranction_ID),
 constraint MODE_PAYMENT_notes_fk_2 foreign key (Note_DBID) references NOTES(Note_DBID)
)engine = INNODB;

create table appeals_notes(
Appeals_DBID VARCHAR(25),
Note_DBID VARCHAR(25),  
 CONSTRAINT appeals_notes_pk primary key (Note_DBID,Appeals_DBID),
 constraint appeals_notes_fk foreign key (Appeals_DBID) references APPEALS(Appeals_DBID),
 constraint appeals_notes_fk_2 foreign key (Note_DBID) references NOTES(Note_DBID)
)engine = INNODB;

create table donations_notes(
donation_dbid VARCHAR(25),
Note_DBID VARCHAR(25),

 CONSTRAINT donation_notes_pk primary key (Note_DBID,donation_dbid),
 constraint donation_notes_fk foreign key (donation_dbid) references DONATIONS(donation_dbid),
 constraint donation_notes_fk2 foreign key (Note_DBID) references NOTES(Note_DBID)
)engine = INNODB;

create table event_notes(

Note_DBID VARCHAR(25),
Event_DBID VARCHAR(25),

 CONSTRAINT event_notes_DBID_pk primary key (Event_DBID,Note_DBID),
 constraint event_notes_DBID_fk foreign key (Event_DBID) references EVENT(Event_DBID),
 constraint event_notes_DBID_fk_2 foreign key (Note_DBID) references NOTES(Note_DBID)
)engine = INNODB;

create table participants_notes(
Participant_DBID VARCHAR(25),
Note_DBID VARCHAR(25),

 CONSTRAINT participants_notes_pk primary key (Participant_DBID,Note_DBID),
 constraint participants_notes_fk foreign key (Participant_DBID) references PARTICIPANTS(Participant_DBID),
 constraint participants_notes_fk_2 foreign key (Note_DBID) references NOTES(Note_DBID)

)engine = INNODB;


commit;

