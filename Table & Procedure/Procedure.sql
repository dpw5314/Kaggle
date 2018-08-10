use parentAID;
call relation('A19953',	'A14333');
call relation('A14333', 'A19953');
call relation('A14367', 'A14312');
call relation('A14312', 'A14367');
call relation('A14330', 'A19953');
call relation('A19953', 'A14330');
call relation('A19953', NULL);
call relation('A14312', NULL);
call relation('A1432222', 'A143');
call relation ('A143332', NULL);



select * from PARTICIPANT_RELATION;
-- Procedure
DELIMITER //
DROP PROCEDURE IF EXISTS relation//
create procedure relation(relation varchar(10), related varchar(10) )
begin
	declare relationship varchar(10);
    declare rest varchar(10);
    declare leftvalue int;
    declare rightvalue int;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		BEGIN
			SET @handler_invoked = 1;
	END;
	if related is not null then
		
		SELECT 1 into leftvalue FROM PARTICIPANT_RELATION WHERE relationID = relation and relatedID= related;
		SELECT 1 into rightvalue FROM PARTICIPANT_RELATION WHERE relationID = related and relatedID= relation;
        if (leftvalue is not null or rightvalue is not null) then
			if(leftvalue = 1) then
				SELECT LEFT(RelationType,LOCATE('-',RelationType) - 1),
					RIGHT(RelationType, char_length(RelationType) - locate('-', RelationType))
                    into relationship, rest FROM PARTICIPANT_RELATION
				WHERE relationID = relation and relatedID= related;
                if(relationship = 'Individual' and rest = 'Company') then 
					SET relationship := 'Employee';
				end if;
                
			elseif (rightvalue = 1) then
				SELECT RIGHT(RelationType, char_length(RelationType) - locate('-', RelationType)),
					LEFT(RelationType,LOCATE('-',RelationType) - 1) 
					into relationship, rest FROM PARTICIPANT_RELATION
				WHERE relationID = related and relatedID= relation;
                if(relationship = 'Company' and rest = 'Company') then 
					SET relationship := 'SubCompany';
                end if;
            end if;
		   SELECT concat(relation, ' is the ', relationship, ' of ', related)as 'RELATIONSHIP';
        elseif (leftvalue is null and rightvalue is null) then SELECT 'CANNOT FOUND THE MATCH RELATIONS.' as 'Error';
        
        end if;
        /*
		SELECT concat(relation, ' is the ', LEFT(RelationType,LOCATE('-',RelationType) - 1), ' of ', related) as 'RELATIONSHIP' FROM PARTICIPANT_RELATION
        WHERE relationID = relation and relatedID= related*/
    else
		SELECT 
			case 
            when tb1.RelatedMember is not null then concat(relation, ' is the ', tb1.Relation, ' of ', tb1.RelatedMember )
            else 'Cannot find match data' end as 'Relation'
            FROM 
			((SELECT relatedID as RelatedMember, 
					case
						when LEFT(RelationType,LOCATE('-',RelationType) - 1) = 'Individual' and RIGHT(RelationType, char_length(RelationType) - locate('-', RelationType)) = 'Company' then 'Employee'
                        else LEFT(RelationType,LOCATE('-',RelationType) - 1) end
                    as Relation 
			   FROM PARTICIPANT_RELATION WHERE relationID = relation)
				UNION
			 (SELECT relationID as RelatedMember, 
					case 
                    when LEFT(RelationType,LOCATE('-',RelationType) - 1) = 'Company' and RIGHT(RelationType, char_length(RelationType) - locate('-', RelationType)) = 'Company' then 'SubCompany'
                    else RIGHT(RelationType, char_length(RelationType) - locate('-', RelationType)) end as Relation 
			  from PARTICIPANT_RELATION WHERE relatedID = relation)
             ) as tb1;
    end if;
end//



