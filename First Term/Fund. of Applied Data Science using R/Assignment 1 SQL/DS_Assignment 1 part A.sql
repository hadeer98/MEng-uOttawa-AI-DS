use VRG
Go
/*******************Part A a**********************************/
Select *
from TRANS
Where TRANS.DateSold IS NULL;

DELETE FROM TRANS
where DateSold IS Null
/*************Part A b*********************/
/*Note*/
select CONCAT(ARTIST.FirstName ,ARTIST.LastName) As Full_NAme ,Work.WorkId,Work.Title,Work.Medium,Work.ArtistID
from ARTIST,WORK 
WHERE ARTIST.ArtistID=WORK.ArtistID AND WORK.Title like '%Yellow%' OR WORK.Title like '%Blue%' OR WORK.Title like '%White%';
/*
select Year(TRANS.DateSold)AS YearOfSold, sum(TRANS.SalesPrice) AS SumOfSubTotal,avg(TRANS.SalesPrice) as AverageOfSubtotal 
from WORK, TRANS
Where  WORK.WorkID=TRANS.WorkID
Group by Year(TRANS.DateSold)
*/
/**********Part A c**************************/
select WORK.ArtistID,DateOfBirth,sum(TRANS.SalesPrice) AS SumOfSubTotal,avg(TRANS.SalesPrice) as AverageOfSubtotal 
from WORK
JOIN TRANS ON WORK.WorkID =TRANS.WorkID 
JOIN ARTIST ON ARTIST.ArtistID=WORK.ArtistID  
Group by WORK.ArtistID ,ARTIST.DateOfBirth
ORDER BY WORK.ArtistID
/****************Part A d**********************/
select WORK.Title,ARTIST.ArtistID,ARTIST.FirstName, Artist.Lastname, Work.WorkID
from WORK
JOIN TRANS ON WORK.WorkID =TRANS.WorkID 
JOIN ARTIST ON ARTIST.ArtistID=WORK.ArtistID 
where TRANS.SalesPrice>(select avg(TRANS.SalesPrice) from TRANS )
/****************Part A e***********************/
Update CUSTOMER
SET EmailAddress='Johnson.lynda@somewhere.com',EncryptedPassword='aax1xbB'
WHERE LastName='Johnson' and FirstName='Lynda'
/*******************Part A f*******************/

SELECT 
CUSTOMER.CustomerID,CUSTOMER.FirstName,CUSTOMER.LastName,
CUSTOMER.PhoneNumber,CUSTOMER.EmailAddress,CUSTOMER.EncryptedPassword,
CUSTOMER.State,CUSTOMER.ZIPorPostalCode,CUSTOMER.Country,
TRANS.DateSold,COALESCE(DATEDIFF(Day, LAG(TRANS.DateSold) OVER
(PARTITION BY TRANS.CustomerID  ORDER BY TRANS.DateSold),TRANS.DateSold),0)
as Days_Difference
from TRANS
inner join CUSTOMER 
on TRANS.CustomerID=CUSTOMER.CustomerID;
/*************************Part A g****************************/
CREATE VIEW CustomerTransactionSummary 
As 
Select Title,DateAcquired,DateSold,(SalesPrice-AcquisitionPrice) as Profit,CONCAT(CUSTOMER.FirstName,CUSTOMER.LastName) as FullName
from TRANS
JOIN WORK ON WORK.WorkID =TRANS.WorkID 
JOIN CUSTOMER ON CUSTOMER.CustomerID=TRANS.CustomerID
where WORK.WorkID=TRANS.WorkID AND TRANS.AskingPrice>20000
Order by TRANS.AskingPrice desc OFFSET 0 rows

select * from CustomerTransactionSummary

/********************* Part A h *********************/
WITH Purchase_new (CustomerID,MinAcquisitionDate,MaxAcquisitionDate)  
	AS  
	(  
		SELECT 
		CustomerID,
	MIN(TRANS.DateAcquired) AS MinAcquisitionDate,
	MAX(TRANS.DateAcquired) AS MaxAcquisitionDate 
	FROM  TRANS
	GROUP BY TRANS.CustomerID
	)  

	select
	TransactionID,DateAcquired,Purchase_new.CustomerID,Customer.LastName,
	Customer.FirstName,MinAcquisitionDate,MaxAcquisitionDate,
	CASE
	WHEN Medium='High Quality Limited Print' THEN 1
	WHEN Medium ='Color Aquatint' THEN 2
	WHEN Medium ='Water Color and Ink' THEN 3
	WHEN Medium ='Oil and Collage' THEN 4
	ELSE 5 END AS Medium

	into #Purchase
	FROM Purchase_new 

	INNER JOIN CUSTOMER ON
	Purchase_new.CustomerID = CUSTOMER.CustomerID
	INNER JOIN TRANS ON
	Purchase_new.CustomerID = TRANS.CustomerID
	INNER JOIN WORK ON
	TRANS.WorkID = WORK.WorkID

	where Year(DateAcquired)>=2015 AND Year(DateAcquired)<=2017
	select * from #Purchase