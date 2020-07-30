Create SCHEMA project AUTHORIZATION klaho028;

set search_path="project";


CREATE TABLE Branch(
BranchNumber Serial,
NumberofEmployees Integer NOT NULL,
Country VarChar(200) NOT NULL,
Manager_SSN Integer Default 0,
PRIMARY KEY (BranchNumber, Country)
);

CREATE TABLE Employee(
SSN Integer Default 0,
HashedPassword VarChar(200) NOT NULL,
FName VarChar(200) NOT NULL,
MName VarChar(200) NOT NULL,
LName VarChar(200) NOT NULL,
Address VarChar(200) NOT NULL,
City VarChar(200) NOT NULL,
Province_State VarChar(200) NOT NULL,
Country VarChar(200) NOT NULL,
EPosition VarChar(200) NOT NULL,
Salary Integer NOT NULL,
EmailAddress VarChar(200) NOT NULL,
PhoneNumber VarChar(200) NOT NULL,
Super_SSN Integer Default 0,
BranchNumber Integer  NOT NULL,
PRIMARY KEY (SSN), 
FOREIGN KEY(Super_SSN) REFERENCES Employee(SSN)
ON DELETE SET DEFAULT 
ON UPDATE CASCADE, 
FOREIGN KEY(BranchNumber, Country) REFERENCES Branch(BranchNumber, Country)
ON DELETE CASCADE
);


CREATE TABLE Host(
HostID Serial NOT NULL,
HashedPassword VarChar(200) NOT NULL,
FName VarChar(200) NOT NULL,
MName VarChar(200) NOT NULL,
LName VarChar(200) NOT NULL,
Address VarChar(200) NOT NULL,
City VarChar(200) NOT NULL,
Province_State VarChar(200) NOT NULL,
Country VarChar(200) Default 0,
BranchNumber integer Default 0,
PRIMARY KEY (HostID), 
FOREIGN KEY(BranchNumber, Country) REFERENCES Branch(BranchNumber, Country)
ON DELETE CASCADE
);


CREATE TABLE Guest(
GuestID Serial NOT NULL,
HashedPassword VarChar(200) NOT NULL,
FName VarChar(200) NOT NULL,
MName VarChar(200) NOT NULL,
LName VarChar(200) NOT NULL,
Address VarChar(200) NOT NULL,
City VarChar(200) NOT NULL,
Province_State VarChar(200) NOT NULL,
Country VarChar(200) NOT NULL,
BranchNumber Integer NOT NULL,
EmailAddress VarChar(200) NOT NULL,
PRIMARY KEY (GuestID),
FOREIGN KEY(Country, BranchNumber) REFERENCES Branch (Country, BranchNumber)
ON DELETE CASCADE
);

CREATE TABLE Property(
PropertyID Serial NOT NULL,
Rented BIT(1) NOT NULL,
Address VarChar(200) NOT NULL,
City VarChar(200) NOT NULL,
Province_State VarChar(200) NOT NULL,
Country VarChar(200) NOT NULL,
PropertyType VarChar(200) NOT NULL,
Accommodates Integer NOT NULL,
Amenities VarChar(200) NOT NULL,
Bedroom integer NOT NULL,
Beds integer NOT NULL,
Bathroom integer NOT NULL, 
HostID Integer NOT NULL, 
PropManagerID Integer NOT NULL,
BranchNumber integer Default 0,
CONSTRAINT  PropertyType_Check CHECK (PropertyType = 'Apartment' or PropertyType = 'Bed and Breakfast' or PropertyType = 'Unique Home' or PropertyType = 'Vacation Home' or PropertyType = 'Cottage'),
PRIMARY KEY (PropertyID), 
FOREIGN KEY(HostID) REFERENCES Host(HostID)
ON DELETE CASCADE,
FOREIGN KEY(BranchNumber, Country) REFERENCES Branch(BranchNumber, Country)
ON DELETE CASCADE, 
FOREIGN KEY(PropManagerID) REFERENCES Employee(SSN)
ON DELETE SET DEFAULT 
ON UPDATE CASCADE
);

CREATE TABLE Room (
PropertyID Integer REFERENCES Property(PropertyID) ON DELETE CASCADE,
RoomID Serial NOT NULL,
RoomType Varchar(200) NOT NULL,
Accommodates Integer NOT NULL,
Amenities VarChar(200) NOT NULL,
CONSTRAINT  RoomType_Check CHECK (RoomType = 'Unique Space' or RoomType = 'Private' or RoomType = 'Shared'),
Primary Key (RoomID,PropertyID)
);

CREATE TABLE Pricing (
PricingID Serial NOT NULL,
Rules Varchar(200),
NumberOfGuests integer NOT NULL,
HomeType VarChar(200) NOT NULL,
Amenities VarChar(200) NOT NULL,
DailyCost integer NOT NULL,
HostID Integer NOT NULL, 
PropertyID Integer NOT NULL,
RoomId integer default null,
CONSTRAINT  HomeType_Check CHECK (HomeType = 'Apartment' or HomeType = 'Bed and Breakfast' or HomeType = 'Unique Home' or HomeType = 'Vacation Home' or HomeType = 'Cottage' or  HomeType = 'Unique Space' or  HomeType = 'Private' or  HomeType = 'Shared'),
Primary Key (PricingID), 
FOREIGN KEY(HostID) REFERENCES Host(HostID)
ON DELETE CASCADE,
FOREIGN KEY(PropertyID) REFERENCES Property(PropertyID)
ON DELETE CASCADE,
FOREIGN KEY(PropertyID, RoomID) REFERENCES Room(PropertyID, RoomID)
ON DELETE CASCADE
);

CREATE TABLE Rental_Agreement (
OrderID Serial NOT NULL,
TotalPrice integer default 0,
Signature VarChar(200) NOT NULL,
SigningDate Date NOT NULL,
StartDate Date NOT NULL,
EndDate Date NOT NULL,
GuestID Integer NOT NULL, 
PricingID Integer NOT NULL, 
OccupancyRate Integer NOT NULL,
Primary Key (OrderID),
FOREIGN KEY(GuestID) REFERENCES Guest(GuestID),
FOREIGN KEY(PricingID) REFERENCES Pricing(PricingID)
);

CREATE TABLE Payment(
PaymentID Serial NOT NULL,
PaymentAccepted BIT(1) NOT NULL,
PaymentType VarChar(200) NOT NULL,
PaymentStatus VarChar(200) NOT NULL,
TotalPrice Integer NOT NULL,
HostID Integer NOT NULL, 
GuestID Integer NOT NULL,
OrderID Integer NOT NULL, 
CONSTRAINT  PaymentType_Check CHECK (PaymentType = 'Credit' or PaymentType = 'Cash' or PaymentType = 'Check' or PaymentType = 'Debit'),
CONSTRAINT  PaymentStatus_Check CHECK (PaymentStatus = 'Pending' or PaymentStatus = 'Approved' or PaymentStatus = 'Declined' or PaymentStatus = 'Completed'),
PRIMARY KEY (PaymentID), 
FOREIGN KEY(HostID) REFERENCES Host(HostID)
ON DELETE CASCADE, 
FOREIGN KEY(GuestID) REFERENCES Guest(GuestID),
FOREIGN KEY(OrderID) REFERENCES Rental_Agreement(OrderID)
);





CREATE TABLE Review (
ReviewID Serial NOT NULL,
Communication integer NOT NULL,
Cleanliness integer NOT NULL,
TheValue integer NOT NULL,
OverallRating integer Not NUll,
TheComment VarChar(500),
OrderID Integer NOT NULL,
Primary Key (ReviewID), 
CONSTRAINT  Communication_Rating_Check CHECK (Communication >= 1 and Communication <= 10),
CONSTRAINT  Cleanliness_Rating_Check CHECK (Cleanliness >= 1 and Cleanliness <= 10),
CONSTRAINT  TheValue_Rating_Check CHECK (TheValue >= 1 and TheValue <= 10),
FOREIGN KEY(OrderID) REFERENCES Rental_Agreement (OrderID)
ON DELETE SET DEFAULT 
);

CREATE TABLE Host_Phone (
PhoneNumber varchar(200) NOT NULL ,
HostID Integer NOT NULL REFERENCES Host(HostID) ON DELETE  CASCADE,
Primary Key (HostID, PhoneNumber)
);

CREATE TABLE Guest_Phone (
PhoneNumber varchar(200) NOT NULL,
GuestID Integer NOT NULL  REFERENCES Guest(GuestID) ON DELETE CASCADE,
Primary Key (GuestID, PhoneNumber) 
);

CREATE TABLE Host_Email (
Email VarChar(200) NOT NULL,
HostID Integer NOT NULL REFERENCES Host(HostID) ON DELETE CASCADE,
Primary Key(HostID, Email)  
);

Create or Replace Function TotalPriceFunction()
Returns trigger as 
$BODY$
Begin
update Rental_Agreement set TotalPrice = (date_part('day', age(New.enddate, new.startdate))*(Select dailycost from pricing where pricingid = New.pricingid))where orderid = new.orderid;
RETURN NEW;
end;
$BODY$ language plpgsql;


Create Trigger totalPriceTrigger After Insert On Rental_Agreement
For each row 
execute procedure TotalPriceFunction();


Create or Replace Function overallRatingFunction()
Returns trigger as 
$BODY$
Begin
Update Review set OverallRating = ((New.Communication::float + new.Cleanliness::float + new.TheValue::float)/3) where reviewid = new.reviewid;
return new;
end;
$BODY$ language plpgsql;

Create Trigger overallRatingTrigger After Insert On Review
For each row 
execute procedure overallRatingFunction();



INSERT INTO Branch (BranchNumber,NumberofEmployees,Country,Manager_SSN) VALUES (1,5,'Belarus',1690030);
INSERT INTO Branch (BranchNumber,NumberofEmployees,Country,Manager_SSN) VALUES (2,5,'Isle of Man',1664042);
INSERT INTO Branch (BranchNumber,NumberofEmployees,Country,Manager_SSN) VALUES (3,5,'Turkey',1663062);
INSERT INTO Branch (BranchNumber,NumberofEmployees,Country,Manager_SSN) VALUES (4,5,'Belgium',1625020);
INSERT INTO Branch (BranchNumber,NumberofEmployees,Country,Manager_SSN) VALUES (5,5,'Marshall Islands',1611111);


INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1663062,'Password123','Black','Ingrid','Damon','P.O. Box 895, 1380 Metus Ave','Kawerau','North Island','Turkey','Manager',75778,'felis.eget@luctusaliquetodio.org','1-980-896-3370',1663062,3);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1690030,'Password123','Wilkins','Darrel','Rebecca','Ap #768-1544 At, Road','Silchar','AS','Belarus','Manager',96415,'Cras.interdum.Nunc@dolorFuscemi.ca','1-236-109-1824',1690030,1);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1664042,'Password123','Petersen','Ocean','Robert','Ap #365-6513 Commodo Av.','Yeosu','South Jeolla','Isle of Man','Manager',56165,'dui@egettinciduntdui.org','1-629-224-7948',1664042,2);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1625020,'Password123','Carpenter','Aretha','Stacey','116 Lacinia Rd.','Irkutsk','Irkutsk Oblast','Belgium','Manager',88548,'nec@faucibusorci.org','1-317-688-3641',1625020,4);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1611111,'Password123','Battle','Pamela','Reece','P.O. Box 974, 9628 Fringilla. Rd.','Aguachica','Cesar','Marshall Islands','Manager',52658,'augue.ac@dolorQuisque.com','1-982-252-6500',1611111,5);

INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1695100,'Password123','Cole','Wing','Dieter','Ap #872-2772 Viverra. Road','Awaran','BL','Belarus','Employee',75250,'Etiam@adipiscingnonluctus.ca','1-451-945-2673',1690030,1);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1694032,'Password123','Chandler','Geraldine','Clayton','590-2446 Justo Street','Madrid','MA','Belarus','Employee',76533,'auctor.nunc@fermentum.net','1-938-293-4185',1690030,1);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1630061,'Password123','Mason','Nicholas','Thomas','1389 Ac Street','Purral','SJ','Belarus','Employee',75771,'vulputate@ornarelectusjusto.co.uk','1-908-526-1767',1690030,1);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1691022,'Password123','Butler','Abigail','Thane','Ap #558-4178 Magna. Avenue','Rattray','PE','Belarus','Employee',91395,'at.pede@hymenaeosMauris.org','1-687-102-0888',1690030,1);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1607091,'Password123','Moody','Angelica','Chester','7578 Ante Avenue','Auburn','Maine', 'Isle of Man','Employee',80285,'eget@semNullainterdum.org','1-106-246-4345',1664042,2);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1694072,'Password123','Davenport','Farrah','Rashad','P.O. Box 212, 643 Dolor. Street','Vienna','Wie','Isle of Man','Employee',89167,'ipsum@eratvel.ca','1-232-703-0384',1664042,2);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1649100,'Password123','Weeks','Irene','Leandra','P.O. Box 747, 1555 Neque Rd.','Bergama','İzmir','Isle of Man','Employee',67730,'lacus.Etiam.bibendum@massa.net','1-612-837-9586',1664042,2);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1634123,'Password123','Rutledge','Guinevere','Brianna','895-8889 Vulputate Rd.','Tame','ARA','Isle of Man','Employee',92972,'arcu@tristiquepharetra.org','1-864-973-8462',1664042,2);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1620010,'Password123','Jimenez','Ria','Gregory','329-4379 Risus. Street','Bello','ANT','Turkey','Employee',57388,'tempus@orci.edu','1-620-160-3813',1663062,3);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1674060,'Password123','Snyder','Lilah','Iola','P.O. Box 149, 9503 Penatibus Rd.','Dublin','L','Turkey','Employee',78155,'Integer.mollis.Integer@fringillaDonecfeugiat.com','1-908-519-0177',1663062,3);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1625012,'Password123','Parrish','Brock','Harlan','928-4271 Ut Road','Hudson Bay','SK','Turkey','Employee',98504,'ipsum@orcisem.edu','1-803-935-5123',1663062,3);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1654121,'Password123','Huff','Camille','Desirae','592-8409 Condimentum. Ave','Wageningen','Gl','Turkey','Employee',94620,'mauris.Suspendisse.aliquet@rutrum.com','1-816-250-2121',1663062,3);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1664030,'Password123','Kirkland','Yoshio','Dean','891-2907 Massa. St.','Ingraj Bazar','West Bengal','Belgium','Employee',90391,'enim.Etiam.gravida@interdumenimnon.net','1-583-894-5704',1625020,4);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1660090,'Password123','Richardson','Silas','Brynn','P.O. Box 946, 4924 Sit St.','Tuxtla Gutiérrez','Chiapas','Belgium','Employee',73571,'pede@luctusvulputatenisi.ca','1-949-875-4076',1625020,4);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1659101,'Password123','Foley','Jorden','Ignatius','Ap #388-5148 Nisl Rd.','Chimbote','Ancash','Belgium','Employee',58471,'ullamcorper.eu@consequatenim.edu','1-680-263-3428',1625020,4);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1628020,'Password123','Mccray','Margaret','Lael','Ap #172-2094 Ut, Street','Carson City','Nevada','Belgium','Employee',77306,'at.pede@purus.edu','1-824-266-5913',1625020,4);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1616101,'Password123','Booth','Theodore','Kitra','P.O. Box 701, 3826 Nam St.','Söderhamn','Gävleborgs län','Marshall Islands','Employee',96718,'sem.ut@leoin.co.uk','1-212-672-9312',1611111,5);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1677061,'Password123','Beach','Summer','Leila','6388 Amet, Road','Vienna','Vienna','Marshall Islands','Employee',72542,'dictum.eleifend@rutrumeu.ca','1-121-639-3254',1611111,5);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1605110,'Password123','Boyle','Simone','Kasper','589-6141 Cras Street','Port Hope','Ontario','Marshall Islands','Employee',89915,'at@ornareInfaucibus.net','1-473-745-0282',1611111,5);
INSERT INTO Employee (SSN,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EPosition,Salary,EmailAddress,PhoneNumber,Super_SSN,BranchNumber) VALUES (1617030,'Password123','Wade','Chava','Kitra','P.O. Box 126, 9325 Lectus. Av.','Vienna','Vienna','Marshall Islands','Employee',80542,'elit.Nulla.facilisi@Integersemelit.co.uk','1-261-993-6558',1611111,5);

INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (1,'Password123','Cross','Ali','Riley','1015 Ut Rd.','San Leucio del Sannio','CAM','Belarus',1);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (2,'Password123','Mullins','Jerry','Ciara','217-9074 Lorem Av.','Hawera','North Island','Belarus',1);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (3,'Password123','Blake','Curran','Hilary','Ap #198-9841 Ac, Rd.','Melipilla','Metropolitana de Santiago','Isle of Man',2);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (4,'Password123','Fleming','Walter','Zephr','Ap #497-5731 Neque Road','Lambayeque','LAM','Isle of Man',2);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (5,'Password123','Baxter','Rogan','Bernard','151-4011 Neque. Road','Malang','East Java','Turkey',3);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (6,'Password123','Bird','Orlando','Carl','P.O. Box 867, 9926 Nec Street','Lerum','Västra Götalands län','Turkey',3);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (7,'Password123','Ramos','Caldwell','Amos','4652 Enim. St.','Paraíso','C','Belgium',4);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (8,'Password123','Rose','Boris','Emily','P.O. Box 923, 7634 Aliquam St.','Vienna','Vienna','Belgium',4);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (9,'Password123','Day','Skyler','Marvin','P.O. Box 539, 7538 Cum Street','Galway','C','Marshall Islands',5);
INSERT INTO Host (HostID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,BranchNumber) VALUES (10,'Password123','Cline','Cadman','Herman','6128 Curabitur Avenue','Shaki','OY','Marshall Islands',5);

INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (1,'Password123','Burks','Melvin','Ivana','457-2624 Lectus Ave','Abbotsford','BC','Marshall Islands','egestas.Sed@dictum.com',5);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (2,'Password123','Cherry','Anika','Riley','Ap #436-9020 Lorem, St.','Koryazhma','Arkhangelsk Oblast','Marshall Islands','ac@dolorFusce.edu',5);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (3,'Password123','Horn','Vernon','Armando','6165 At St.','Belfast','Ulster','Isle of Man','nec.eleifend.non@Integer.ca',2);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (4,'Password123','Johnson','Burke','Harrison','P.O. Box 856, 7824 Felis Av.','Vienna','Wie','Isle of Man','arcu@Namtempor.net',2);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (5,'Password123','Zamora','Leo','Bianca','Ap #575-4481 Tempus Avenue','San Isidro de El General','San José','Turkey','ac.mattis@Nullamvelit.co.uk',3);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (6,'Password123','Bird','Harlan','Aurora','551-4524 Sem. St.','Canoas','RS','Turkey','arcu@risusMorbimetus.ca',3);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (7,'Password123','Gilmore','Olympia','Jolene','Ap #503-7811 Nam Road','Parauapebas','PA','Belgium','nec@leoin.co.uk',4);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (8,'Password123','Heath','Chancellor','Barry','964-7401 Risus. Rd.','Dutse','Jigawa','Belgium','Donec@idmagnaet.com',4);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (9,'Password123','Alvarado','Sasha','Moses','9822 Metus Road','Placilla','O''Higgins','Belarus','lacinia.at@vitae.ca',1);
INSERT INTO Guest (GuestID,HashedPassword,FName,MName,LName,Address,City,Province_State,Country,EmailAddress,BranchNumber) VALUES (10,'Password123','Arnold','Evan','Aline','7318 Phasellus Street','Guelph','Ontario','Belarus','Etiam.imperdiet@ornarefacilisiseget.org',1);






INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (1,'1','8383 Diam St.','Saintes','Poitou-Charentes','Belarus','Bed and Breakfast',1,'eget massa. Suspendisse eleifend. Cras',1,3,1,1,1690030,1);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (2,'0','161-3446 Enim. Rd.','Tarma','Junín','Belarus','Apartment',1,'ut, nulla. Cras eu tellus',3,5,2,1,1690030,1);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (3,'1','Ap #840-5462 Phasellus Avenue','Vezirköprü','Sam','Belarus','Apartment',4,'aliquet, metus urna convallis erat,',2,3,1,2,1690030,1);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (4,'1','Ap #660-1042 Dolor. Street','Konin','WP','Isle of Man','Cottage',1,'facilisis vitae, orci. Phasellus dapibus',2,4,2,3,1664042,2);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (5,'1','409-5000 Leo. Road','Istanbul','Ist','Isle of Man','Vacation Home',1,'Mauris ut quam vel sapien',2,5,2,4,1664042,2);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (6,'0','Ap #720-704 Imperdiet Street','Yaroslavl',c,'Isle of Man','Vacation Home',2,'odio. Nam interdum enim non',3,5,1,4,1664042,2);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (7,'1','599-6277 Neque Rd.','Nicoya','Guanacaste','Turkey','Cottage',3,'elit erat vitae risus. Duis',2,3,1,5,1663062,3);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (8,'0','P.O. Box 989, 9094 Donec St.','Matagami','Quebec','Turkey','Apartment',5,'Pellentesque tincidunt tempus risus. Donec',1,5,2,6,1663062,3);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (9,'0','P.O. Box 888, 3017 Semper Rd.','Wimborne Minster','Dorset','Turkey','Vacation Home',4,'Pellentesque ultricies dignissim lacus. Aliquam',2,4,2,5,1663062,3);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (10,'0','P.O. Box 191, 5040 Ullamcorper Road','Petrópolis','Rio de Janeiro','Belgium','Apartment',1,'sodales elit erat vitae risus.',1,3,2,7,1625020,4);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (11,'1','Ap #696-805 Velit Avenue','Móstoles','MA','Belgium','Unique Home',5,'urna, nec luctus felis purus',2,5,2,7,1625020,4);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (12,'1','8969 Ridiculus Rd.','Lodhran','PU','Belgium','Cottage',1,'mattis. Integer eu lacus. Quisque',2,3,1,8,1625020,4);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (13,'1','Ap #466-1589 Dictum. Av.','Łódź','LD','Marshall Islands','Bed and Breakfast',1,'odio. Aliquam vulputate ullamcorper magna.',3,3,2,9,1611111,5);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (14,'1','3708 Sociis Ave','Kapolei','HI','Marshall Islands','Cottage',4,'eu, placerat eget, venenatis a,',2,4,2,10,1611111,5);
INSERT INTO Property (PropertyID,Rented,Address,City,Province_State,Country,PropertyType,Accommodates,Amenities,Bedroom,Beds,Bathroom,HostID,PropManagerID,BranchNumber) VALUES (15,'1','2106 Consectetuer St.','Vienna','Wie','Marshall Islands','Unique Home',1,'luctus felis purus ac tellus.',3,5,2,10,1611111,5);


INSERT INTO Room (PropertyID,RoomID,RoomType,Accommodates,Amenities) VALUES (3,1000,'Private',1,'nascetur ridiculus mus. Proin vel');
INSERT INTO Room (PropertyID,RoomID,RoomType,Accommodates,Amenities) VALUES (5,1001,'Shared',2,'tellus eu augue porttitor interdum.');
INSERT INTO Room (PropertyID,RoomID,RoomType,Accommodates,Amenities) VALUES (3,1002,'Unique Space',1,'lorem, vehicula et, rutrum eu,');
INSERT INTO Room (PropertyID,RoomID,RoomType,Accommodates,Amenities) VALUES (3,1003,'Unique Space',2,'Maecenas iaculis aliquet diam. Sed');
INSERT INTO Room (PropertyID,RoomID,RoomType,Accommodates,Amenities) VALUES (5,1004,'Private',1,'magna. Suspendisse tristique neque venenatis');

INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100000,'ipsum cursus vestibulum. Mauris magna.',6,'Vacation Home','Cras',292,1,1,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100001,'amet orci. Ut sagittis lobortis mauris.',5,'Cottage','Quisque nonummy ipsum non arcu. Vivamus sit amet risus. Donec',114,1,2,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100003,'aliquam iaculis, lacus pede sagittis augue, eu tempor erat',6,'Unique Home','eleifend vitae,',129,3,4,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100005,'ante',3,'Apartment','nulla. Integer urna. Vivamus molestie dapibus ligula.',264,4,6,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100006,'ac risus. Morbi metus. Vivamus euismod urna. Nullam lobortis quam',1,'Vacation Home','erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie',220,5,7,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100007,'convallis',3,'Vacation Home','Cras pellentesque. Sed dictum. Proin eget',278,6,8,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100008,'molestie dapibus ligula. Aliquam erat volutpat.',9,'Cottage','in felis. Nulla tempor',105,5,9,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100009,'diam luctus lobortis. Class aptent taciti sociosqu ad litora',1,'Apartment','sem',236,7,10,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100010,'aliquet molestie tellus. Aenean',4,'Unique Home','at, nisi. Cum sociis natoque penatibus et magnis dis parturient',108,7,11,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100011,'nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc',2,'Vacation Home','quis,',214,8,12,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100012,'adipiscing, enim mi tempor lorem, eget mollis lectus pede et',10,'Unique Home','Praesent eu nulla at sem',225,9,13,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100013,'eu',8,'Apartment','luctus ut, pellentesque eget, dictum placerat,',230,10,14,null);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100014,'sollicitudin',7,'Vacation Home','egestas. Duis ac arcu. Nunc mauris. Morbi non sapien',214,10,15,null);

INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100015,'aliquet molestie tellus. Aenean',4,'Shared','at, nisi. Cum sociis natoque penatibus et magnis dis parturient',108,2,3,1000);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100016,'nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc',2,'Shared','quis,',214,4,5,1001);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100017,'adipiscing, enim mi tempor lorem, eget mollis lectus pede et',10,'Private','Praesent eu nulla at sem',225,2,3,1002);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100018,'eu',8,'Private','luctus ut, pellentesque eget, dictum placerat,',230,2,3,1003);
INSERT INTO Pricing (PricingID,Rules,NumberOfGuests,HomeType,Amenities,DailyCost,HostID,PropertyID,RoomID) VALUES (100019,'sollicitudin',7,'Private','egestas. Duis ac arcu. Nunc mauris. Morbi non sapien',214,4,5,1004);




INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5000,'Armand Dejesus','2019-07-26','2019-10-21','2019-10-30',5,100000,null,3);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5001,'Curran Bright','2019-03-18','2019-04-15','2019-04-30',7,100001,null,2);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5003,'Vernon Black','2019-04-14','2019-05-12','2019-05-20',1,100003,null,5);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5005,'Bevis Mcpherson','2020-03-01','2020-03-22','2020-04-11',5,100005,null,2);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5006,'Cairo Townsend','2019-03-15','2020-01-25','2020-01-30',6,100006,null,1);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5007,'Geoffrey Morse','2020-01-21','2020-02-21','2020-02-23',8,100007,null,3);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5008,'Griffin Durham','2019-08-27','2019-12-28','2020-01-05',10,100008,null,8);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5009,'Oscar Chang','2020-01-14','2020-01-20','2020-01-25',9,100009,null,1);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5010,'Sawyer Coleman','2020-02-11','2020-05-11','2020-05-13',3,100010,null,3);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5011,'Marvin Chang','2019-07-20','2019-08-14','2019-08-24',4,100011,null,1);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5012,'Jesse Kirk','2019-09-28','2019-10-18','2019-11-09',3,100012,null,8);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5013,'Odysseus Garcia','2020-04-14','2020-06-10','2020-06-12',7,100013,null,7);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5014,'Ferdinand Robinson','2020-05-09','2020-07-08','2020-07-10',8,100014,null,7);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5015,'Zane Key','2020-07-27','2020-06-01','2020-06-24',9,100015,null,4);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5016,'Tyler Benjamin','2020-04-18','2020-04-25','2020-09-16',6,100016,null,2);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5017,'Logan Langley','2020-09-01','2020-09-28','2020-10-04',3,100017,null,9);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5018,'Lionel Terry','2019-03-15','2019-04-06','2019-04-13',2,100018,null,7);
INSERT INTO Rental_Agreement (OrderID,Signature,SigningDate,StartDate,EndDate,GuestID,PricingID,TotalPrice,OccupancyRate) VALUES (5019,'Zeus Gibbs','2019-12-05','2020-01-09','2020-01-12',1,100019,null,7);


INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1627041,'1','Debit','Approved',190,1,5,5000);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1679011,'1','Check','Completed',427,1,7,5001);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1664040,'1','Cash','Completed',205,3,1,5003);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1624012,'0','Check','Pending',151,4,5,5005);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1605102,'0','Credit','Pending',197,5,6,5006);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1687021,'1','Cash','Completed',109,6,8,5007);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1691022,'0','Check','Declined',225,5,10,5008);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1616091,'0','Credit','Declined',424,7,9,5009);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1658052,'0','Cash','Pending',453,1,3,5010);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1693091,'1','Cash','Completed',185,8,4,5011);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1670080,'1','Check','Completed',395,9,3,5012);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1675022,'0','Check','Declined',356,10,7,5013);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1649122,'0','Debit','Declined',110,10,8,5014);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1619072,'0','Cash','Declined',292,3,7,5015);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1693110,'1','Credit','Approved',123,8,6,5016);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1688092,'1','Debit','Approved',154,9,3,5017);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1620101,'1','Cash','Completed',107,10,2,5018);
INSERT INTO Payment (PaymentID,PaymentAccepted,PaymentType,PaymentStatus,TotalPrice,HostID,GuestID,OrderID) VALUES (1692021,'1','Check','Completed',174,10,1,5019);



INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (1,2,10,1,3,'metus. Aliquam erat volutpat. Nulla',5000);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (2,10,1,7,6,'nonummy ipsum non',5001);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (4,8,10,3,4,'in aliquet lobortis, nisi nibh',5003);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (6,3,8,10,6,'gravida molestie arcu. Sed',5005);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (7,2,6,7,7,'sed, hendrerit',5006);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (8,10,1,10,5,'pellentesque eget, dictum placerat, augue.',5007);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (9,4,3,2,2,'arcu. Vestibulum ante',5008);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (10,1,3,4,4,'ipsum',5009);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (11,10,10,6,2,'aliquet diam.',5010);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (12,6,7,9,5,'non nisi. Aenean eget metus.',5011);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (13,8,5,2,5,'nisi.',5012);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (14,10,10,8,9,'posuere at, velit. Cras',5013);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (15,3,9,9,6,'quis diam.',5014);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (16,9,2,8,5,'sodales. Mauris blandit enim consequat purus. Maecenas',5015);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (17,3,10,5,6,'accumsan convallis,',5016);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (18,6,4,9,1,'non, hendrerit id, ante. Nunc mauris sapien,',5017);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (19,9,4,6,3,'semper erat, in consectetuer',5018);
INSERT INTO Review (ReviewID,Communication,Cleanliness,TheValue,OverallRating,TheComment,OrderID) VALUES (20,9,2,8,10,'molestie',5019);


INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-375-624-7472',1);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-571-565-8229',2);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-276-792-0142',3);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-373-544-4752',4);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-466-870-9011',5);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-100-654-1116',6);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-580-203-4539',7);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-627-702-8790',8);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-853-439-9085',9);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-385-535-1455',10);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-757-106-8720',1);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-235-346-4544',2);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-946-577-1777',3);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-141-510-0565',4);
INSERT INTO Host_Phone (PhoneNumber,HostID) VALUES ('1-678-523-0460',5);


INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-324-981-8037',1);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-743-261-3161',2);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-323-623-4337',3);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-287-332-8923',4);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-310-273-3494',5);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-485-997-5922',6);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-606-230-8275',7);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-678-915-9099',8);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-380-296-8958',9);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-391-628-8859',10);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-592-538-9428',1);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-647-897-4746',2);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-553-803-5427',3);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-476-708-3682',4);
INSERT INTO Guest_Phone (PhoneNumber,GuestID) VALUES ('1-677-639-2490',5);


INSERT INTO Host_Email (Email,HostID) VALUES ('Morbi.accumsan@magnaDuisdignissim.com',1);
INSERT INTO Host_Email (Email,HostID) VALUES ('a.felis.ullamcorper@mattisInteger.com',2);
INSERT INTO Host_Email (Email,HostID) VALUES ('magnis.dis.parturient@Nunclaoreetlectus.edu',3);
INSERT INTO Host_Email (Email,HostID) VALUES ('pellentesque.Sed@cursusinhendrerit.com',4);
INSERT INTO Host_Email (Email,HostID) VALUES ('auctor.quis@atliberoMorbi.com',5);
INSERT INTO Host_Email (Email,HostID) VALUES ('quam@velitdui.org',6);
INSERT INTO Host_Email (Email,HostID) VALUES ('ultrices@vitaeorci.ca',7);
INSERT INTO Host_Email (Email,HostID) VALUES ('dui.Suspendisse.ac@magnis.net',8);
INSERT INTO Host_Email (Email,HostID) VALUES ('nunc@sapienNuncpulvinar.net',9);
INSERT INTO Host_Email (Email,HostID) VALUES ('dolor@faucibusleoin.ca',10);
INSERT INTO Host_Email (Email,HostID) VALUES ('magna.Ut@vehiculaaliquetlibero.org',1);
INSERT INTO Host_Email (Email,HostID) VALUES ('massa.Integer.vitae@urnaUttincidunt.com',2);
INSERT INTO Host_Email (Email,HostID) VALUES ('Nullam@sagittissemper.edu',3);
INSERT INTO Host_Email (Email,HostID) VALUES ('nec.tellus.Nunc@felisDonectempor.ca',4);
INSERT INTO Host_Email (Email,HostID) VALUES ('risus@tincidunt.com',5);
