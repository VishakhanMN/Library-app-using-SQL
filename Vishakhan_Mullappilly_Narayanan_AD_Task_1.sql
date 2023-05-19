CREATE DATABASE LibraryDB;

CREATE TABLE MemberDetail(
UserId int NOT NULL IDENTITY(1,1) PRIMARY KEY,
FirstName nvarchar(50) NOT NULL,
MiddleName nvarchar(50) NULL,
LastName nvarchar(50) NOT NULL,
Address1 nvarchar(50) NOT NULL,
Address2 nvarchar(50) NULL,
Address3 nvarchar(50) NULL,
Postcode nvarchar(50) NOT NULL,
DateOfBirth date NOT NULL,
Email nvarchar(100) NULL,
Telephone bigint NULL,
MembershipStartDate date NOT NULL,
MembershipEndDate date NULL
);

CREATE TABLE UserDetail(
UserDetailId int NOT NULL IDENTITY(100,1) PRIMARY KEY,
UserId int NOT NULL,
Username nvarchar(50) NOT NULL,
Password nvarchar(50) NOT NULL
);


CREATE TABLE LibraryItems(
ItemId int NOT NULL IDENTITY(1000,1) PRIMARY KEY,
Title nvarchar(100) NOT NULL,
Type nvarchar(50) NOT NULL,
Author nvarchar(100) NOT NULL,
YearOfPublication date NOT NULL,
AddedDate date NOT NULL,
AvailabilityStatus nvarchar(20) NOT NULL,
LostDate date NULL,
ISBN int NULL
);

CREATE TABLE Loan(
LoanId int NOT NULL IDENTITY(10000,1) PRIMARY KEY,
UserId int NOT NULL,
ItemId int NOT NULL,
IssueDate date NOT NULL,
DueDate date NOT NULL,
ReturnedDate date NULL,
OverdueStatus nvarchar(20) NOT NULL
);


CREATE TABLE Overdue(
OverdueId int NOT NULL IDENTITY(100000,1) PRIMARY KEY,
Userid int NOT NULL,
Itemid int NOT NULL,
LoanId int NOT NULL,
AmountRepaid money NOT NULL,
ModeOfPayment nvarchar(10) NOT NULL,
RepaymentDate date NOT NULL,
Balance money NOT NULL,
Fine money NOT NULL
);


ALTER TABLE Overdue
ADD FOREIGN KEY (UserId) REFERENCES MemberDetail(UserId);

ALTER TABLE Overdue
ADD FOREIGN KEY (ItemId) REFERENCES LibraryItems(ItemId);

ALTER TABLE Overdue
ADD FOREIGN KEY (LoanId) REFERENCES Loan(LoanId);

ALTER TABLE Loan
ADD FOREIGN KEY (UserId) REFERENCES MemberDetail(UserId);

ALTER TABLE Loan
ADD FOREIGN KEY (ItemId) REFERENCES LibraryItems(ItemId);

ALTER TABLE UserDetail
ADD FOREIGN KEY (UserId) REFERENCES MemberDetail(UserId);

ALTER TABLE Loan
ADD CONSTRAINT check_issue_date check (IssueDate < DueDate);

ALTER TABLE Loan
ADD CONSTRAINT set_overduestats check (OverdueStatus IN ('Overdue','Not overdue') );

ALTER TABLE Overdue
ADD CONSTRAINT set_mode_of_payment check (ModeOfPayment IN ('Cash','Card') );

ALTER TABLE Overdue
ADD CONSTRAINT set_fine check (Fine = AmountRepaid + Balance );

ALTER TABLE LibraryItems
ADD CONSTRAINT set_availability_stats check (AvailabilityStatus IN ('Available','On loan','Removed','Lost') );

ALTER TABLE UserDetail
ADD CONSTRAINT protect_user_info check (Password != Username);


---------------------------------1.2c-----------------------------------------------

GO
CREATE OR ALTER PROCEDURE UserInfo
@FirstName nvarchar(50),
@MiddleName nvarchar(50) = NULL,
@LastName nvarchar(50),
@Add1 nvarchar(50),
@Add2 nvarchar(50) = NULL,
@Add3 nvarchar(50) = NULL,
@Postcode nvarchar(50),
@DOB date,
@Email nvarchar(100) = NULL,
@Telephone bigint = NULL,
@MembershipStartDate date,
@MembershipEndDate date = NULL
AS
BEGIN
INSERT INTO MemberDetail
VALUES(@FirstName,@MiddleName,@LastName,@Add1,@Add2,@Add3,@Postcode,@DOB,@Email,@Telephone,@MembershipStartDate,@MembershipEndDate)
END

EXEC UserInfo 
@FirstName = 'Vishakhan',@LastName='MN', @Add1 = '26 Shirley Avenue', @Add3 ='Salford', @Postcode = 'M7 3QY',@DOB ='1994-12-08',
@MembershipStartDate = '2012-08-09';

EXEC UserInfo 
@FirstName = 'John',@LastName='Dawn', @Add1 = '20 Shirley Street', @Add3 ='Manchester', @Postcode = 'M7 3YH',@DOB ='1987-12-30',
@MembershipStartDate = '2000-08-11';

EXEC UserInfo 
@FirstName = 'Eden',@LastName='Hazard', @Add1 = '20 Regent Street', @Add2='FallowEarth' , @Add3 ='Chelsea', @Postcode = 'C7 3JH',@DOB ='1989-02-14',
@MembershipStartDate = '2010-06-09';

EXEC UserInfo 
@FirstName = 'Marcus',@MiddleName='Myth', @LastName='Rashford', @Add1 = '99 Weaste Street', @Add3 ='Manchester', @Postcode = 'M1 6VC',@DOB ='1990-04-19',
@MembershipStartDate = '2015-01-01',@Email = 'mythMarcus@gmail.com', @Telephone=7784587458;

EXEC UserInfo 
@FirstName = 'Cristiano',@MiddleName='Legend', @LastName='Roanldo', @Add1 = '7 Real Street', @Add3 ='Manchester', @Postcode = 'M1 7YY',@DOB ='1985-02-05',
@MembershipStartDate = '2012-05-06',@Email = 'legendcr7@gmail.com', @Telephone=8789375038;

EXEC UserInfo 
@FirstName = 'Lisandro',@MiddleName='Butcher', @LastName='Martinez', @Add1 = '12 Ajax Lane', @Add3 ='Manchester', @Postcode = 'M1 5YT',@DOB ='1994-07-13',
@MembershipStartDate = '2017-11-12',@Email = 'manuButcher21@gmail.com';

EXEC UserInfo 
@FirstName = 'David',@MiddleName='De', @LastName='Gea', @Add1 = '12 Athletico Lane', @Add3 ='Manchester', @Postcode = 'M2 8NT',@DOB ='1992-11-04',
@MembershipStartDate = '2014-03-12',@Email = 'wall@gmail.com';

Select * from MemberDetail;

INSERT INTO LibraryItems
Values('Beloved','Book','John','2005-05-27','2006-03-19','Removed','2010-10-11',3);

--------------------------1.2d----------------------------------
GO
CREATE PROCEDURE updateUserDetail
    @value NVARCHAR(100),
	@userId INT,
    @columnName VARCHAR(50)
AS
BEGIN
	IF @columnName = 'FirstName'
	BEGIN
    UPDATE MemberDetail
    SET FirstName = @value
    WHERE UserId = @userId
	END
	ELSE IF @columnName = 'LastName'
		BEGIN
		UPDATE MemberDetail
		SET LastName = @value
		WHERE UserId = @userId
		END
	ELSE IF @columnName = 'MiddleName'
	BEGIN
	UPDATE MemberDetail
	SET MiddleName = @value
	WHERE UserId = @userId
	END
	ELSE IF @columnName = 'Address1'
		BEGIN
		UPDATE MemberDetail
		SET Address1 = @value
		WHERE UserId = @userId
		END
	ELSE IF @columnName = 'Address2'
	BEGIN
	UPDATE MemberDetail
	SET Address2 = @value
	WHERE UserId = @userId
	END
	ELSE IF @columnName = 'Address3'
		BEGIN
		UPDATE MemberDetail
		SET Address3 = @value
		WHERE UserId = @userId
		END
	ELSE IF @columnName = 'Postcode'
	BEGIN
	UPDATE MemberDetail
	SET Postcode = @value
	WHERE UserId = @userId
	END
	ELSE IF @columnName = 'Email'
		BEGIN
		UPDATE MemberDetail
		SET Email = @value
		WHERE UserId = @userId
		END
END

GO
CREATE PROCEDURE updateUserDateDetail
    @dateValue date,
	@userId INT,
    @columnName VARCHAR(50)
AS
BEGIN
IF @columnName = 'DateOfBirth'
	BEGIN
    UPDATE MemberDetail
    SET DateOfBirth = @dateValue
    WHERE UserId = @userId
	END
	ELSE IF @columnName = 'MembershipStartDate'
		BEGIN
		UPDATE MemberDetail
		SET MembershipStartDate = @dateValue
		WHERE UserId = @userId
		END
	ELSE IF @columnName = 'MembershipEndDate'
	BEGIN
	UPDATE MemberDetail
	SET MembershipEndDate = @dateValue
	WHERE UserId = @userId
	END
END
GO


EXEC updateUserDetail @value = '25 Littleton Road', @userId = 1, @columnName = 'Address1';
EXEC updateUserDateDetail @dateValue = '1998-12-12', @userId = 1, @columnName = 'DateOfBirth';


----------------------------1.2a------------------------------------------

GO
CREATE OR ALTER PROCEDURE getMatchingTitleName
    @getTitle nvarchar(200)
AS
BEGIN
    SELECT * FROM LibraryItems
	WHERE Title like '%'+ @getTitle + '%'
	ORDER BY YearOfPublication DESC
END
GO

EXEC getMatchingTitleName @getTitle='Christie'


----------------------------1.2b------------------------------------------
GO
CREATE OR ALTER FUNCTION getLoanDetail()
RETURNS TABLE AS
RETURN(SELECT k.Title,k.Type,l.DueDate,k.Author,k.YearOfPublication as 'Publication Year',u.FirstName,j.Username
FROM Loan l 
INNER JOIN LibraryItems k
ON l.ItemId = k.ItemId
INNER JOIN MemberDetail u
ON u.UserId = l.UserId
INNER JOIN UserDetail j
ON j.UserId = u.UserId
WHERE DATEDIFF(day, GETDATE(),l.DueDate) BETWEEN 0 AND 5
  AND l.ReturnedDate IS NULL)
GO

Select * from getLoanDetail();

----------------------------------1.3-----------------------------------------------------
GO

CREATE OR ALTER VIEW loanHistory AS
SELECT l.*,m.FirstName,k.Title,k.Type,u.Username
from Loan l
INNER JOIN LibraryItems k
ON k.ItemId = l.ItemId
INNER JOIN MemberDetail m
ON m.UserId = l.UserId
INNER JOIN UserDetail u
ON u.UserId = l.UserId

GO

Select * from loanHistory;
----------------------------------1.4-----------------------------------------------------
GO
CREATE OR ALTER TRIGGER statusUpdate on Loan FOR UPDATE
AS
BEGIN
	DECLARE @id int;
	DECLARE @returnDate date;
	SET @id=(Select ItemId from INSERTED)
	SET @returnDate = (Select ReturnedDate from INSERTED)
	IF(@returnDate IS NOT NULL)
		BEGIN
		Update LibraryItems SET AvailabilityStatus = 'Available' Where ItemId = @id;
		END
END
GO


Select * from LibraryItems;

Select * from Loan;

Update Loan
SET ReturnedDate = '2023-04-28'
Where LoanId = 10002;

Select * from LibraryItems;

----------------------------------1.5-----------------------------------------------------

GO
CREATE OR ALTER FUNCTION loanCount(@getDate AS date)
RETURNS INT
AS
BEGIN
RETURN(Select COUNT(*) AS 'Loan Count' from Loan
Where IssueDate = @getDate)
END
GO

Select dbo.loanCount('2023-01-01') AS 'Loans history for this day'
----------------------------------1.6-----------------------------------------------------

GO
CREATE OR ALTER PROCEDURE InsertMemberSpecificDetails
@userId int,
@username nvarchar(50),
@password nvarchar(50)
AS
BEGIN
INSERT INTO UserDetail
VALUES(@userId,@username,@password)
END
GO

EXEC InsertMemberSpecificDetails @userId=1,@username='khan77',@password='Manu4l!fe';

EXEC InsertMemberSpecificDetails @userId=2,@username='john65',@password='Freestyle123';

EXEC InsertMemberSpecificDetails @userId=3,@username='eden9',@password='BurgerLover123';

EXEC InsertMemberSpecificDetails @userId=4,@username='sirMarcus10',@password='youthManu7';

EXEC InsertMemberSpecificDetails @userId=5,@username='cr7',@password='kingForever';

EXEC InsertMemberSpecificDetails @userId=6,@username='butcherManu56',@password='wallOfManchester56';

EXEC InsertMemberSpecificDetails @userId=7,@username='wallManu',@password='greatWallOfManuGK123';

Select * from UserDetail;


GO
CREATE OR ALTER PROCEDURE InsertLibraryItems
@title nvarchar(100),
@type nvarchar(50),
@author nvarchar(100),
@publicationYear date,
@addedDate date,
@status nvarchar(20),
@lostDate date = NULL,
@isbn int = NULL
AS
BEGIN
INSERT INTO LibraryItems
VALUES(@title,@type,@author,@publicationYear,@addedDate,@status,@lostDate,@isbn)
END
GO

EXEC InsertLibraryItems @title='Agatha Christie',@type ='book',@author='Agatha Christie',@publicationYear='2000-01-01',@addedDate='2020-01-01',
@status='Available',@isbn = 87648829;

EXEC InsertLibraryItems @title='Godly Christie',@type ='journal',@author='Agatha Christie',@publicationYear='2010-04-11',@addedDate='2019-11-19',
@status='Available'

EXEC InsertLibraryItems @title='Old Monk',@type ='journal',@author='Chris',@publicationYear='2010-12-08',@addedDate='2018-04-12',
@status='On Loan';

EXEC InsertLibraryItems @title='Ridley Bear',@type ='DVD',@author='Frashny',@publicationYear='2012-05-02',@addedDate='2011-03-22',
@status='Removed',@lostDate ='2021-12-12';

EXEC InsertLibraryItems @title='Cocaine Shark',@type ='Book',@author='Nyla',@publicationYear='2003-06-01',@addedDate='2011-03-22',
@status='Available',@isbn = 43865439;

EXEC InsertLibraryItems @title='Interstellar',@type ='DVD',@author='Nolan',@publicationYear='2018-03-21',@addedDate='2020-03-09',
@status='Lost',@lostDate='2023-03-12';

EXEC InsertLibraryItems @title='Gladiators',@type ='Book',@author='Godfrey',@publicationYear='1998-12-01',@addedDate='2000-04-07',
@status='On Loan',@isbn = 3485634

EXEC InsertLibraryItems @title='Classic 11',@type ='Journal',@author='Frysbee',@publicationYear='1988-10-03',@addedDate='2004-02-19',
@status='On Loan',@isbn = 2349058

EXEC InsertLibraryItems @title='Classic Osho',@type ='Book',@author='Osho',@publicationYear='1999-12-01',@addedDate='2003-12-19',
@status='On Loan',@isbn = 2349642

EXEC InsertLibraryItems @title='Friends',@type ='Journal',@author='Joey',@publicationYear='2002-11-11',@addedDate='2016-08-23
',
@status='On Loan';

Select * from LibraryItems;

GO
CREATE PROCEDURE InsertLoanInfo
@userId int,
@itemId int,
@issueDate date,
@dueDate date,
@returnedDate date,
@overdueStats nvarchar(20)
AS
BEGIN
INSERT INTO Loan
VALUES(@userId,@itemId,@issueDate,@dueDate,@returnedDate,@overdueStats)
END
GO

EXEC InsertLoanInfo @userId = 2, @itemId = 1001, @issueDate = '2022-10-01', @dueDate = '2023-01-01', @returnedDate = '2022-11-30', @overdueStats = 'Not overdue';

EXEC InsertLoanInfo @userId = 3, @itemId = 1005, @issueDate = '2023-01-01', @dueDate = '2023-04-28', @returnedDate = NULL, @overdueStats = 'Not overdue';

EXEC InsertLoanInfo @userId = 4, @itemId = 1006, @issueDate = '2023-02-02', @dueDate = '2023-04-29', @returnedDate = NULL, @overdueStats = 'Not overdue';

EXEC InsertLoanInfo @userId = 5, @itemId = 1007, @issueDate = '2023-01-02', @dueDate = '2023-03-01', @returnedDate = NULL, @overdueStats = 'Overdue';

Select * from Loan;

GO
CREATE OR ALTER PROCEDURE InsertOverdueInfo
@userId int,
@itemId int,
@loanId int,
@amountRepaid money,
@paymentMode nvarchar(10),
@repaymentDate date,
@balance money,
@fine money
AS
BEGIN
INSERT INTO Overdue
VALUES(@userId,@itemId,@loanId,@amountRepaid,@paymentMode,@repaymentDate,@balance,@fine)
END
GO

EXEC InsertOverdueInfo @userId=5,@itemId=1007,@loanId=10003,@amountRepaid=120,@paymentMode='Cash',@repaymentDate='2023-04-12',@balance=250,@fine=370

Select * from Overdue

----------------------------------1.7-----------------------------------------------------
-------------------------filter based on availablity of books-----------------------------

GO
CREATE OR ALTER PROCEDURE knowAvailabilityOfItem
    @getStatus nvarchar(200)
AS
BEGIN
    SELECT * 
	FROM LibraryItems l 
	WHERE AvailabilityStatus LIKE '%'+ @getStatus +'%'
END
GO

EXEC knowAvailabilityOfItem @getStatus='Available'

------------------------------update ISBN ------------------------

GO
CREATE OR ALTER TRIGGER updateISBN on LibraryItems FOR INSERT
AS
BEGIN
	DECLARE @id int;
	DECLARE @Type nvarchar(100);
	SET @id=(Select ItemId from INSERTED)
	SET @Type = (Select Type from INSERTED)
	IF(@Type NOT LIKE '%book%')
		BEGIN
		Update LibraryItems SET ISBN = NULL  Where ItemId = @id;
		END
END
GO

----------------------disable user from logging in once the membership date ends---------------------

GO
CREATE OR ALTER TRIGGER disableUser on MemberDetail FOR Update
AS
BEGIN
	DECLARE @id int;
	DECLARE @membershipEndDate date;
	SET @id=(Select UserId from INSERTED)
	SET @membershipEndDate = (Select MembershipEndDate from INSERTED)
	IF(@membershipEndDate IS NOT NULL)
		BEGIN
		Update UserDetail SET Password = RAND(6)+'ABC'+RAND(3)  Where UserId = @id;
		END
END
GO

Select * from MemberDetail;
Select * from UserDetail;
Select * from LibraryItems;

Select * from Loan;

Select * from Overdue;

------Creating schema-----------
GO
CREATE SCHEMA BigDataTools;








