/*
Testing the execution of the Procedures
with different values and different cases

*/


EXEC Original_Content_Search @typename =null ,@categoryname ='video'
EXEC Contributor_Search @fullname ='Chris A. Byers'
EXEC Register_User 
@usertype = 'admin',
@email = 'sheveshenkoa7mad3absamee3@gmail.com',
@password ='8888', 
@firstname = 'x', @middlename = 'b', @lastname = 'l',
@birth_date = '2018-07-07',
@working_place_name = null,
@working_place_type = null,
@wokring_place_description = 'descr',
@specilization = null,
@portofolio_link ='linkgedyd',
@years_experience =9,
@hire_date =' 2017-07-07',
@working_hours=7,
@payment_rate =500 ,
@user_id = output  


EXEC Check_Type 
@typename ='mashenka7',
@content_manager_id =11

EXEC Order_Contributor
EXEC Show_Original_Content @contributor_id = 4

declare @output  int 
exec User_login 'jerabek@gmail.com','10101',@output out
print @output


declare @email varchar(255) ,
@password varchar(255),
 @firstname varchar(255),
 @middlename varchar(255),
 @lastname  varchar(255),
 @birth_date  date,
 @working_place_name varchar(255),
 @working_place_type varchar(255),
 @working_place_description varchar(255),
 @specilization varchar(255),
 @portofolio_link varchar(255),
 @years_experience int,
 @hire_date date,
 @working_hours int,
 @payment_rate int
exec Show_Profile '1' ,
@email out ,
@password out,
@firstname  out,
@middlename  out,
@lastname  out,
@birth_date  out,
@working_place_name  out,
@working_place_type  out,
@working_place_description  out,
@specilization  out,
@portofolio_link  out,
@years_experience  out,
@hire_date  out,
@working_hours  out,
@payment_rate  out

print @email 
print @password
print @firstname
print @lastname
print @birth_date
print @working_place_name
print @working_place_description
print @specilization 
print @portofolio_link
print @years_experience
print @hire_date
print @working_hours
print @payment_rate




exec Edit_Profile
600,'testrun@test.com',null,null,null,null,null,null,null,null,null,null,null,null,null,null

exec Deactivate_Profile 3

exec Show_Event @event_id = 1

exec Show_Notification 5


