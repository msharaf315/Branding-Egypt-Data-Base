/*
Creating the procedures 
for the different types of users
*/



use iEgypt

GO 

CREATE PROC Original_Content_Search
@typename varchar(255), @categoryname varchar(255)
AS 
SELECT Original_Content.* 
FROM  Original_Content
INNER JOIN CONTENT ON Content.ID = Original_Content.ID
WHERE Original_Content.review_status=1 AND Original_Content.filter_status=1  
and (@typename = Content."type" or @categoryname = Content.category_type)

GO

ALTER PROC Contributor_Search
@fullname varchar(255)
AS
IF(@fullname is not null) begin
SELECT Contributor.*
from Contributor inner join "User" on Contributor.ID = "User".ID
where @fullname = "User".first_name + ' ' + "User".middle_name + ' '+ "User".last_name
end
go

CREATE PROC Register_User 
@usertype VARCHAR(255) ,
@email VARCHAR(255),
@password VARCHAR(255), 
@firstname VARCHAR(255), @middlename VARCHAR(255), @lastname VARCHAR(255),
@birth_date DATE,
@working_place_name VARCHAR(255),
@working_place_type VARCHAR(255),
@wokring_place_description VARCHAR(255),
@specilization VARCHAR(255),
@portofolio_link VARCHAR(255),
@years_experience int,
@hire_date DATE,
@working_hours int,
@payment_rate int ,
@user_id nvarchar(max)  OUTPUT
AS 
if(@usertype is not null and @email is not null and not exists(select * from "User" 
where @email="User".email) and @password is not null and @firstname is not null and 
@middlename is not null and @lastname is not null and @birth_date is not null)
begin 
INSERT INTO "User"(email,first_name,middle_name,last_name,birth_date,"password") VALUES
(@email,@firstname,@middlename,@lastname,@birth_date,@password)
SET @user_id =(SELECT "User".ID FROM "User" where "User".email=@email) 
IF @usertype = 'Viewer'
BEGIN
INSERT INTO Viewer (ID,working_place,working_place_type,working_place_description) VALUES
(@user_id,@working_place_name,@working_place_type,@wokring_place_description)
END 
ELSE 
IF @usertype = 'Contributor'
BEGIN
INSERT INTO Contributor (ID,years_of_experience,portfolio_link,specialization,notified_id) VALUES
(@user_id,@years_experience,@portofolio_link,@specilization,NULL)
END
ELSE 
IF @usertype = 'staff'
BEGIN
INSERT INTO Staff(ID,hire_date,working_hours,payment_rate,notified_id) VALUES
(@user_id,@hire_date,@working_hours,@payment_rate,NULL)
END
ELSE 
IF @usertype ='content_manager'
BEGIN
INSERT INTO Staff(ID,hire_date,working_hours,payment_rate,notified_id) VALUES
(@user_id,@hire_date,@working_hours,@payment_rate,NULL)
INSERT INTO Content_manager(ID,"type") VALUES
(@user_id,NULL)
END
ELSE
IF @usertype= 'Reviewer'
BEGIN
INSERT INTO Staff(ID,hire_date,working_hours,payment_rate,notified_id) VALUES
(@user_id,@hire_date,@working_hours,@payment_rate,NULL)
INSERT INTO Reviewer  VALUES (@user_id)
END
print @user_id
END
ELSE 
print 'some inputs are missing'
go

create  PROC Check_Type 
@typename varchar(255),
@content_manager_id INT
AS
DECLARE @temp varchar(255)
SET @temp =(SELECT Content_type."type" FROM Content_type
WHERE @typename = Content_type.type)
 IF @temp IS NULL
 BEGIN
 INSERT INTO Content_type VALUES(@typename)
 UPDATE Content_manager
SET  "type" = @typename 
WHERE ID= @content_manager_id;
END
ELSE
UPDATE Content_manager
SET  "type" = @typename 
WHERE ID= @content_manager_id;


GO
alter PROC Order_Contributor
AS
BEGIN
 SELECT years_of_experience,portfolio_link,specialization,first_name,middle_name,last_name,birth_date,age FROM Contributor
 inner join "User" on Contributor.id = "User".id
ORDER BY Contributor.years_of_experience DESC
END

go

Alter PROC Show_Original_Content
@contributor_id int
AS
BEGIN
IF @contributor_id IS NOT NULL	
begin
SELECT Original_Content.*,first_name,middle_name,last_name,age,portfolio_link,specialization,years_of_experience
FROM Original_Content
INNER JOIN Content ON Original_Content.ID = Content.ID
INNER  JOIN Contributor ON Content.contributor_id = Contributor.ID
INNER JOIN   "User"  ON  Contributor.ID = "User".id
WHERE @contributor_id= Contributor.ID AND filter_status = 1
END
ELSE 
SELECT Original_Content.*,first_name,middle_name,last_name,age,portfolio_link,specialization,years_of_experience Original_Content from Original_Content
INNER JOIN Content ON Original_Content.ID = Content.ID
INNER JOIN Contributor ON Content.contributor_id = contributor.ID AND filter_status = 1
INNER JOIN   "User"  ON  Contributor.ID = "User".id
END
GO


go
alter  PROC User_login
@email varchar(255),
@password varchar(255),
@user_id int OUTPUT
AS 
if not exists (select * from "user" where email = @email and @password = "password")
begin
set @user_id = -2;
end
else
begin
declare @lastloggedin date
declare @active bit
select @active = "user".active from "user" where  email = @email and @password = "password"
select @lastloggedin = "user".last_logged_in from "user" where  email = @email and @password = "password"
if(@active=0)
begin
declare @datedifference int
set @datedifference = datediff(day,@lastloggedin,current_timestamp)
if(@datedifference > 14)begin
set @user_id = -1
end
else begin
update "User"
set active=1 where email = @email and @password = "password"
set @user_id = (select id from "User" where email = @email and @password = "password")
end
end
else
set @user_id = (select id from "User" where email = @email and @password = "password")
end
go



CREATE PROC Show_Profile
@user_id int, 
@email varchar(255) OUTPUT, 
@password varchar(255) OUTPUT, 
@firstname varchar(255) OUTPUT, 
@middlename varchar(255) OUTPUT,
@lastname varchar(255) OUTPUT, 
@birth_date datetime OUTPUT, 
@working_place_name varchar(255) OUTPUT, 
@working_place_type varchar(255) OUTPUT, 
@working_place_description varchar(255) OUTPUT, 
@specilization varchar(255) OUTPUT,
@portofolio_link varchar(255) OUTPUT, 
@years_experience int OUTPUT, 
@hire_date datetime OUTPUT, 
@working_hours int OUTPUT, 
@payment_rate int OUTPUT
AS
DECLARE @active bit
SELECT @active = active FROM "User" WHERE ID = @user_id

IF NOT EXISTS (SELECT * FROM "User" WHERE ID = @user_id)
BEGIN
print 'User account does not exist'
END
ELSE IF (@active = 0)
BEGIN
SET @email =NULL
SET @password = NULL
SET @firstname = NULL
SET @middlename = NULL
SET @lastname = NULL
SET @birth_date = NULL
SET @working_place_name = NULL
SET @working_place_type = NULL
SET @working_place_description = NULL
SET @specilization = NULL
SET @portofolio_link = NULL 
SET @years_experience = NULL
SET @hire_date = NULL
SET @working_hours = NULL 
SET @payment_rate = NULL
END
ELSE
BEGIN
SELECT @email = email, @password = "password", @firstname = first_name, @middlename = middle_name, @lastname = last_name, @birth_date = birth_date FROM "User" WHERE ID = @user_ID
IF EXISTS (SELECT * FROM Viewer WHERE ID = @user_id)
BEGIN
SELECT @working_place_name = working_place, @working_place_type = working_place_type, @working_place_description = working_place_description FROM Viewer WHERE ID = @user_ID
END
IF EXISTS (SELECT * FROM Contributor WHERE ID = @user_id)
BEGIN
SELECT @specilization = specialization, @portofolio_link = portfolio_link, @years_experience = years_of_experience FROM Contributor WHERE ID = @user_ID
END
IF EXISTS (SELECT * FROM Staff WHERE ID = @user_id)
BEGIN
SELECT @hire_date = hire_date, @working_hours = working_hours, @payment_rate = payment_rate FROM Staff WHERE ID = @user_ID
END
END



GO
CREATE  PROC Edit_Profile
@user_id int, 
@email varchar(255), 
@password varchar(255), 
@firstname varchar(255), 
@middlename varchar(255),
@lastname varchar(255), 
@birth_date datetime, 
@working_place_name varchar(255), 
@working_place_type varchar(255), 
@working_place_description varchar(255), 
@specilization varchar(255),
@portofolio_link varchar(255), 
@years_experience int, 
@hire_date datetime, 
@working_hours int, 
@payment_rate int
AS

if (@email is not null) begin 
if not (@email = (select email from "User" where @user_id=id) ) begin
update "User"
set email = @email where @user_id=id
END
end

if (@password is not null) begin
if not (@password = (select "password" from "User" where @user_id=id) ) begin
update "User"
set "password" = @password where @user_id=id
END
end


if (@firstname is not null) begin
if not (@firstname = (select first_name from "User" where @user_id=id) ) begin
update "User"
set "first_name" = @firstname where @user_id=id
END
end

if (@middlename is not null) begin
if not (@middlename = (select middle_name from "User" where @user_id=id) ) begin
update "User"
set middle_name = @middlename where @user_id=id
END
end

if (@lastname is not null) begin
if not (@lastname = (select last_name from "User" where @user_id=id) ) begin
update "User"
set last_name = last_name where @user_id=id
END
end

if (@birth_date is not null) begin
if not (@birth_date = (select birth_date from "User" where @user_id=id) ) begin
update "User"
set birth_date = birth_date where @user_id=id
END
end

if (@password is not null) begin
if not (@password = (select "password" from "User" where @user_id=id) ) begin
update "User"
set "password" = @password where @user_id=id
END
end

if exists (select id from Viewer where id= @user_id)
begin 

if (@working_place_name is not null) begin
if not (@working_place_name = (select working_place from Viewer where @user_id=id) ) begin
update Viewer
set  working_place = @working_place_name where @user_id=id
END
end

if (@working_place_type is not null) begin
if not (@working_place_type = (select working_place_type from Viewer where @user_id=id) ) begin
update Viewer
set  working_place_type = @working_place_type where @user_id=id
END
end

if (@working_place_description is not null) begin
if not (@working_place_description = (select working_place_description from "Viewer" where @user_id=id) ) begin
update Viewer
set  working_place_description = @working_place_description where @user_id=id
END
end

end 

if exists (select id from Contributor where id= @user_id)
begin

if (@specilization is not null) begin
if not (@specilization= (select specialization from Contributor where @user_id=id) ) begin
update Contributor
set specialization = @specilization where @user_id=id
END
end

if (@portofolio_link is not null) begin
if not (@specilization= (select portfolio_link from Contributor where @user_id=id) ) begin
update Contributor
set portfolio_link = @portofolio_link where @user_id=id
END
end

if (@years_experience is not null) begin
if not (@years_experience= (select years_of_experience from Contributor where @user_id=id) ) begin
update Contributor
set years_of_experience = @years_experience where @user_id=id
END
end
END

if exists (select id from Staff where id= @user_id) begin
if (@hire_date is not null) begin
if not (@hire_date = (select hire_date from Staff where @user_id=id) ) begin
update Staff
set  hire_date = @hire_date where @user_id=id
END
end

if (@working_hours is not null) begin
if not (@working_hours = (select working_hours from Staff where @user_id=id) ) begin
update Staff
set  working_hours = @working_hours where @user_id=id
END
end

if (@payment_rate is not null) begin
if not (@payment_rate = (select payment_rate from Staff where @user_id=id) ) begin
update Staff
set  payment_rate = @payment_rate where @user_id=id
END
end
end

GO
CREATE PROC Deactivate_Profile
@user_id int
AS
UPDATE "User" SET active = 0 WHERE ID = @user_id

GO


CREATE PROC Show_Event
@event_id int
AS
IF EXISTS (SELECT * FROM "Event" WHERE id = @event_id)
BEGIN
SELECT * FROM "Event" WHERE id = @event_id
SELECT first_name, middle_name, last_name FROM "User" WHERE ID = (SELECT viewer_id FROM "Event" WHERE id = @event_id )
END
ELSE
BEGIN
SELECT * FROM "Event" WHERE ("time" > current_timestamp)
END

GO


alter PROC Show_Notification
@user_id int
as
declare @notfid int
declare @notfobjid  int
if exists (select * from Staff where id =@user_id) begin
set @notfid = (select notified_id from staff where @user_id=id)
if (@notfid is not null ) begin
set @notfobjid =(select notification_object_id from Announcement where notified_person_id =@notfid)
select * from Announcement where @notfobjid =notification_object_id
select * from "event" where @notfobjid =notification_object_id
select * from new_request where @notfobjid =notif_obj_id
end
end

if exists (select * from Contributor where id =@user_id) begin
set @notfid = (select notified_id from contributor where @user_id=id)
if (@notfid is not null ) begin
set @notfobjid =(select notification_object_id from Announcement where notified_person_id =@notfid)
select * from Announcement where @notfobjid =notification_object_id
select * from "event" where @notfobjid =notification_object_id
select * from new_request where @notfobjid =notif_obj_id
end
end

go



GO
create proc Show_New_Content
@viewer_id int,
@content_id int
as
if (@content_id is not null)
begin 
select  nc.ID,c.ID as 'Contributor ID',u.first_name,u.middle_name,u.last_name
from New_Content nc inner join New_Request nr on nc.new_request_ID=nr.id inner join Contributor c on nr.contributer_id=c.ID inner join [user] u on c.ID= u.ID
where @content_id=nc.ID and @viewer_id=nr.viewer_id
end
else 
begin
select   nc.ID,c.ID as 'Contributor ID',u.first_name,u.middle_name,u.last_name,con.*
from New_Content nc inner join new_request nr on nc.new_request_ID=nr.id inner join Contributor c on nr.contributer_id=c.ID inner join [user] u on c.ID= u.ID
inner join content con on con.ID=nc.ID
where @viewer_id=nr.viewer_id
end



