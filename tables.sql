﻿CREATE Table "User"(
ID int PRIMARY KEY IDENTITY,
email varchar(255),
first_name varchar(255),
middle_name varchar(255),
last_name varchar(255),
birth_date datetime NOT NULL,
age AS (YEAR(CURRENT_TIMESTAMP) - YEAR(birth_date)),
"password" varchar(255) NOT NULL,
last_logged_in datetime default current_timestamp,
active bit default 1
);
CREATE TABLE Content_type (
"type" varchar(255) PRIMARY KEY

);
CREATE TABLE Viewer (
ID INT PRIMARY KEY,
working_place varchar(255),
working_place_type varchar(255),
working_place_description varchar(255),
FOREIGN KEY(ID) REFERENCES "User" ON DELETE CASCADE	 ON UPDATE CASCADE
);
CREATE Table Notified_Person(
ID INT PRIMARY KEY IDENTITY
);
CREATE TABLE Contributor(
ID int PRIMARY KEY,
years_of_experience int,
portfolio_link varchar(255),
specialization  varchar(255),
notified_id int,
FOREIGN KEY(ID) REFERENCES "User" ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(notified_id) REFERENCES Notified_Person(ID) ON DELETE SET NULL ON UPDATE CASCADE 
);
CREATE TABLE Category (
 "type" varchar(255) PRIMARY KEY, 
 "description" varchar(255) NOT NULL
);
CREATE TABLE Sub_Category (
category_type varchar(255),
"name" varchar(255),
CONSTRAINT PK_Sub_Category PRIMARY KEY (category_type,"name"),
FOREIGN KEY(category_type) REFERENCES Category("type") ON DELETE CASCADE ON UPDATE CASCADE

);
CREATE TABLE Content (
ID int PRIMARY KEY IDENTITY,
link varchar(255),
uploaded_at datetime default current_timestamp NOT NULL,
contributor_id int,
category_type varchar(255), /*category_id*/
subcategory_name varchar(255),
"type" varchar(255), /*type_id*/
FOREIGN KEY(contributor_id) REFERENCES Contributor(ID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY("type") REFERENCES Content_type ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY(category_type,subcategory_name) REFERENCES Sub_Category(category_type,"name") ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE Staff(
ID int PRIMARY KEY,
hire_date date NOT NULL,
working_hours int,
payment_rate int NOT NULL,
total_salary AS(payment_rate*working_hours),
notified_id int,
FOREIGN KEY(ID) REFERENCES "User" ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(notified_id) REFERENCES Notified_Person(ID) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE Content_manager (
ID int PRIMARY KEY ,
"type" varchar(255),
FOREIGN KEY(ID) REFERENCES Staff ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY("type") REFERENCES Content_type ON DELETE SET NULL ON UPDATE CASCADE

);
CREATE TABLE Reviewer (
ID int PRIMARY KEY,
FOREIGN KEY(ID) REFERENCES Staff ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE "Message"(
 sent_at datetime,
 contributor_id int,
 viewer_id int,
 sender_type BIT not null,
 read_at datetime NOT NULL,
 "text" varchar(255) NOT NULL,
 read_status BIT NOT NULL  DEFAULT 0,
 CONSTRAINT PK_Message PRIMARY KEY (sent_at,contributor_id,viewer_id,sender_type),
 FOREIGN KEY(contributor_id) REFERENCES Contributor(ID) ON DELETE NO ACTION  ON UPDATE NO ACTION,
 FOREIGN KEY(viewer_id) REFERENCES Viewer(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE Notification_Object (
ID INT PRIMARY KEY IDENTITY

);
CREATE TABLE Original_Content (
ID int PRIMARY KEY,
content_manager_id int,
reviewer_id int ,
review_status bit NOT NULL DEFAULT 0,
filter_status bit NOT NULL DEFAULT 0,
rating int,
CHECK (rating between 0 and 5),
FOREIGN KEY(ID) REFERENCES Content ON DELETE CASCADE ON UPDATE NO ACTION,
FOREIGN KEY(reviewer_id) REFERENCES Reviewer(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
FOREIGN KEY(content_manager_id) REFERENCES Content_manager(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Existing_Request (
id int PRIMARY KEY IDENTITY,
original_content_id INT,
viewer_id INT,
FOREIGN KEY(original_content_id) REFERENCES Original_Content(ID) ON DELETE CASCADE ON UPDATE NO ACTION,
FOREIGN KEY(viewer_id) REFERENCES Viewer(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE New_Request (

id int PRIMARY KEY IDENTITY,
accept_status bit  DEFAULT NULL,
accept_date datetime,
specified bit NOT NULL DEFAULT 0,
information varchar(255),
viewer_id INT,
notif_obj_id INT,
contributor_id INT,
 FOREIGN KEY(viewer_id) REFERENCES Viewer(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
 FOREIGN KEY(notif_obj_id) REFERENCES Notification_Object(ID) ON DELETE SET NULL ON UPDATE CASCADE,
 FOREIGN KEY(contributor_id) REFERENCES Contributor(ID) ON DELETE NO ACTION ON UPDATE NO ACTION

);

CREATE TABLE New_Content (
ID int PRIMARY KEY ,
new_request_id int,
FOREIGN KEY(ID) REFERENCES Content ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(new_request_id) REFERENCES New_Request(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Comment (
Viewer_id int,
original_content_id int,
"date" datetime,
text varchar(255),
CONSTRAINT PK_Comment PRIMARY KEY (viewer_id,original_content_id,"date"),
FOREIGN KEY(Viewer_id) REFERENCES Viewer ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(original_content_id) REFERENCES Original_content(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE  Rate (
viewer_id int,
original_content_id int,
"date" datetime not null,
rate int not null,
CHECK(rate between 0 and 5),
CONSTRAINT PK_Rate PRIMARY KEY (viewer_id,original_content_id),
FOREIGN KEY(viewer_id) REFERENCES Viewer ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(original_content_id) REFERENCES Original_Content(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
);

CREATE TABLE "Event" (
id int PRIMARY KEY IDENTITY,
"description" varchar(255),
"location" varchar(255) NOT NULL,
city varchar(255) NOT NULL,
"time" datetime NOT NULL,
entertainer varchar(255),
notification_object_id int,
viewer_id int ,
FOREIGN KEY(notification_object_id) REFERENCES Notification_Object(ID) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY(viewer_id) REFERENCES Viewer(ID) ON DELETE SET NULL ON UPDATE CASCADE

);

CREATE TABLE Event_Photos_link(
event_id int,
link varchar(255) not null,
CONSTRAINT PK_Event_Photos_link PRIMARY KEY (event_id,link),
FOREIGN KEY(event_id) REFERENCES "Event"(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE   Event_Videos_link( 
event_id int,
link varchar(255) NOT NULL,
CONSTRAINT PK_Event_Videos_link PRIMARY KEY (event_id,link),
FOREIGN KEY(event_id) REFERENCES "Event"(ID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Advertisement (
id int PRIMARY KEY IDENTITY ,
"description" varchar(255),
"location" varchar(255),
event_id int ,
viewer_id int, 
FOREIGN KEY(viewer_id) REFERENCES Viewer ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY(event_id) REFERENCES "Event" ON DELETE NO ACTION ON UPDATE NO ACTION
);


CREATE TABLE Ads_Video_Link(
advertisement_id int,
link varchar(255) not null,
CONSTRAINT PK_Ads_Videos_link PRIMARY KEY (advertisement_id,link),
FOREIGN KEY(advertisement_id) REFERENCES Advertisement ON DELETE CASCADE ON UPDATE CASCADE


);

CREATE TABLE  Ads_Photos_Link(
advertisement_id int ,
link varchar(255) not null,
CONSTRAINT PK_Ads_Photos_link PRIMARY KEY (advertisement_id,link),
FOREIGN KEY(advertisement_id) REFERENCES Advertisement ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE Announcement (
ID int PRIMARY KEY IDENTITY,
seen_at varchar(255),
sent_at datetime,
notified_person_id int ,
notification_object_id int,
FOREIGN KEY(notified_person_id) REFERENCES Notified_Person(ID) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY(notification_object_id) REFERENCES Notification_Object(ID) ON DELETE SET NULL ON UPDATE CASCADE

);