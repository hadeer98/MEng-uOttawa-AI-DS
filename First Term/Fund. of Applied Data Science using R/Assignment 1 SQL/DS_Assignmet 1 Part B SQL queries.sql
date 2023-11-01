use HSD_DW
go

/****************Part B 2a***************************/
select distinct PRODUCT_SALES.CustomerID ,CUSTOMER.FullName from PRODUCT_SALES
join CUSTOMER on CUSTOMER.CustomerID=PRODUCT_SALES.CustomerID
join Product on PRODUCT_SALES.ProductNumber=Product.ProductNumber
group by TimeID ,PRODUCT_SALES.CustomerID,CUSTOMER.FullName
having COUNT(PRODUCT_SALES.ProductNumber)>=5
/******************Part B 2b**************************/
with largest as(
select sum(PRODUCT_SALES.Total) as summition,CUSTOMER.CustomerID from PRODUCT_SALES
join CUSTOMER on CUSTOMER.CustomerID=PRODUCT_SALES.CustomerID
group by CUSTOMER.CustomerID
)
select c.* ,largest.CustomerID from largest ,CUSTOMER as c
where largest.CustomerID=c.CustomerID AND largest.summition IN(select max(largest.summition)from largest) 
use HSD_DW
go

/******************** part B 2c********************/
Select y.Year ,sum(Total) from PRODUCT_SALES as S,TIMELINE as Y
where S.TimeID=Y.TimeID
group by Rollup(y.Year)

/************************************/

-- Quarter -

SELECT CUSTOMER.City,TIMELINE.Quarter_int, TIMELINE.year, SUM(PRODUCT_SALES.Total) as Total FROM 
CUSTOMER INNER JOIN PRODUCT_SALES ON CUSTOMER.CustomerID = PRODUCT_SALES.CustomerID
INNER JOIN TIMELINE ON PRODUCT_SALES.TimeID = TIMELINE.TimeID
GROUP BY City, TIMELINE.Quarter_int,TIMELINE.year
HAVING TIMELINE.Quarter_int = 2 and TIMELINE.year = 2018

SELECT PRODUCT.ProductType,TIMELINE.Quarter_int, TIMELINE.year, SUM(PRODUCT_SALES.Total) as Total FROM 
PRODUCT INNER JOIN PRODUCT_SALES ON PRODUCT.ProductNumber = PRODUCT_SALES.ProductNumber
INNER JOIN TIMELINE ON PRODUCT_SALES.TimeID = TIMELINE.TimeID
GROUP BY PRODUCT.ProductType, TIMELINE.Quarter_int,TIMELINE.year
HAVING TIMELINE.Quarter_int = 2 and TIMELINE.year = 2018

-- Drill Down 

SELECT CUSTOMER.City,TIMELINE.Month_int, TIMELINE.year, SUM(PRODUCT_SALES.Total) as Total FROM 
CUSTOMER INNER JOIN PRODUCT_SALES ON CUSTOMER.CustomerID = PRODUCT_SALES.CustomerID
INNER JOIN TIMELINE ON PRODUCT_SALES.TimeID = TIMELINE.TimeID
GROUP BY City, TIMELINE.Quarter_int,TIMELINE.year,TIMELINE.Month_int
HAVING TIMELINE.Quarter_int = 2 and TIMELINE.year = 2018
order by total

SELECT PRODUCT.ProductType,TIMELINE.Month_int, TIMELINE.year, SUM(PRODUCT_SALES.Total) as Total FROM 
PRODUCT INNER JOIN PRODUCT_SALES ON PRODUCT.ProductNumber = PRODUCT_SALES.ProductNumber
INNER JOIN TIMELINE ON PRODUCT_SALES.TimeID = TIMELINE.TimeID
GROUP BY PRODUCT.ProductType, TIMELINE.Quarter_int,TIMELINE.year,TIMELINE.Month_int 
HAVING TIMELINE.Quarter_int = 2 and TIMELINE.year = 2018