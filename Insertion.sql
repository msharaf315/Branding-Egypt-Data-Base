/*
Inserting values into tables
*/


INSERT INTO Category VALUES
('Video','Videos showcasing items'),
('Music','Music showcasing item'),
('Short Film','A film showcasing the item');
INSERT INTO Sub_Category VALUES
('Video','Short Video'),
('Music','Heavy Metal');
SET IDENTITY_INSERT Notified_Person ON;
INSERT INTO Notified_Person (ID)VALUES 
(1),
(2),
(3),
(4),
(5);
SET IDENTITY_INSERT Notified_Person OFF;



SET IDENTITY_INSERT "User" ON;
INSERT INTO "User"(ID,email,first_name,middle_name,last_name,birth_date,"password") VALUES
(1,'jerabek@gmail.com','Bethann','F.','Jerabek','1998-05-01','10101010'),
(2,'d.hogle@msn.com','Dustin','John','Hogle','1995-05-07','mypassword'),
(3,'brad@live.com','Bradford','T.','Macri','1990-06-09','MC1990'),
(4,'schilke@guc.edu.eg','Kelsey','Marie','Schilke','1997-10-30','BDdEleanor41'),
(5,'chrissy@msn.com','Chris','A.','Byers','1996-11-01','KoolAidWizard85'),
(6,'e.roosevelt@yahoo.com','Eleanor','Theodore','Roosevelt','1951-11-08','12281995'),
(7,'kansasgirl@live.com','Dorothy','Lillian','Churchill','1995-12-08','JohnDoe58'),
(8,'amirakhaled@gmail.com','Amira','M.','Khaled','1990-09-08','123abc678'),
(9,'jeanbeth@student.guc.edu.eg','Jeannette','Bethany','Statham','1993-10-15','AdeleRules93'),
(10,'princess_ashley@gmail.com','Ashley','P.','Walter','1998-02-19','ashqueen19298'),
(11,'stan@yahoo.com','Adam','Stan','McCormick','1978-05-19','pass2629'),
(12,'olive.rey@msn.com','Olivia','Sarah','Reynolds','1950-06-19','polynation55'),
(13,'d.serag@gmail.com','Mamdouh','Ahmed','Serag','1971-08-08','qqwwrr3344');
SET IDENTITY_INSERT "User" OFF;
INSERT INTO Viewer (ID,working_place,working_place_type,working_place_description) VALUES
(1,'SLS School','School','Salam Langauge School'),
(2,'CISCO','Electronics Company','A company that makes electronics'),
(3,'GUC','University','The German Univesity in Cairo');
INSERT INTO Contributor (ID,years_of_experience,portfolio_link,specialization,notified_id) VALUES
(4,5,'database.com/Contributor4','Videographer',1),
(5,8,'database.com/Contributor5','Videographer',2),
(6,12,'database.com/Contributor6','Filmmaker',3),
(7,1,'database.com/Contributor7','Musician',4),
(8,3,'database.com/Contributor8','Photographer',5);
INSERT INTO Content_type ("type") VALUES
('MEDIA'),
('LOGOS'),
('FILMS');

SET IDENTITY_INSERT Content ON;
INSERT INTO Content(ID,link,uploaded_at,contributor_id,category_type,subcategory_name,"type") VALUES
(1,'database.com/Content1','2010-05-01 10:01:51',4,'Video','Short Video','MEDIA'),
(2,'database.com/Content2',' 2009-10-11 00:31:01 ',4,'Video','Short Video','MEDIA'),
(3,'database.com/Content3',' 2017-02-14 01:00:00 ',4,'Video','Short Video','MEDIA'),
(4,'database.com/Content4',' 2013-07-23 10:51:01 ',6,'Short Film',NULL,'FILMS'),
(5,'database.com/Content5',' 2005-11-11 11:41:21 ',6,'Short Film',NULL,'FILMS'),
(6,'database.com/Content6',' 2012-03-09 09:11:21 ',6,'Short Film',NULL,'FILMS');
SET IDENTITY_INSERT Content OFF;


INSERT INTO Staff(ID,hire_date,working_hours,payment_rate,notified_id) VALUES
(9,'2012-11-21',8,1,1),
(10,'2010-10-31',11,3,2),
(11,'2010-10-13',31,3,3),
(12,'2011-11-12',23,2,4),
(13,'2011-12-16',15,2,5);
INSERT INTO Reviewer(ID) VALUES
(9),
(10);
INSERT INTO Content_manager(ID,"type") VALUES
(11,'MEDIA'),
(12,'LOGOS'),
(13,'FILMS');
INSERT INTO Original_Content(ID,content_manager_id,reviewer_id,review_status,filter_status,rating) VALUES
(1,11,9,1,1,5),
(2,12,9,0,0,0),
(3,13,10,1,1,2);
SET IDENTITY_INSERT Existing_Request  ON;
INSERT INTO Existing_Request(id,original_content_id,viewer_id) VALUES
(1,1,1),
(2,2,2);
SET IDENTITY_INSERT Existing_Request  OFF;
SET IDENTITY_INSERT Notification_Object ON;
INSERT INTO Notification_Object (ID) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13);
SET IDENTITY_INSERT NOtification_Object OFF;
SET IDENTITY_INSERT New_Request ON;
INSERT INTO New_Request(id,accept_status,specified,information,viewer_id,notif_obj_id,contributor_id) VALUES
(1,1,0,'A new video of the beach',1,1,5),
(2,1,0,'A new video of the ocean',2,2,5),
(3,1,0,'A new short film of portsaid',2,3,6),
(4,1,0,'A new short film of CAIRO',2,3,6),
(5,1,0,'A new short film of Giza',2,3,6),
(6,1,0,'A new Song about cairo',2,6,7),
(7,1,0,'A new song about the pyramids',2,7,7),
(8,1,0,'A new song about cats in cairo',2,8,7),
(9,0,0,'some info',2,9,NULL),
(10,0,0,'some info',2,10,NULL),
(11,0,0,'some info',2,11,NULL);
SET IDENTITY_INSERT New_Request OFF;
INSERT INTO New_Content(ID,new_request_id) VALUES 
(4,3),
(5,4),
(6,5);
SET IDENTITY_INSERT "Event" ON;
INSERT INTO "Event"(id,"description","location",city,"time",entertainer,notification_object_id,viewer_id) VALUES
(1,'BRANDING EGYPT IN CAIRO','Egypt','Cairo','1/12/2018','Omar Khairat',12,1),
(2,'BRANDING EGYPT IN ALEX','Egypt','Alexandria','3/1/2018','Adele',13,2);
SET IDENTITY_INSERT "Event" OFF;

SET IDENTITY_INSERT Advertisement ON;
INSERT INTO Advertisement(id,"description","location",event_id,viewer_id)VALUES
(1,'Advertisement for an event in Cairo','Cairo',1,1),
(2,'Advertisement for an event in Alexandria','Alexanderia',2,2);
SET IDENTITY_INSERT Advertisement OFF;