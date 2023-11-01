use HSD_DW
go

CREATE TABLE CUSTOMER (
    CustomerID int NOT NULL PRIMARY KEY,
    FullName varchar(255) NOT NULL,
    Email varchar(255),
	PhoneAreaCode int,
	City varchar(255),
	State varchar(255),
	ZIP int
);

CREATE TABLE TIMELINE (
    TimeID int NOT NULL PRIMARY KEY,
    TDate Date,
	Month_int int,
    Month_text varchar(255),
	Quarter_int int,
	Quarter_text varchar(255),
	Year int
);

CREATE TABLE Product (
    ProductNumber varchar(40) NOT NULL PRIMARY KEY,
    ProductType varchar(255),
	ProductName varchar(255),
);

CREATE TABLE PRODUCT_SALES (
    TimeID int NOT NULL Foreign key references TIMELINE(TimeID),
	CustomerID int NOT NULL Foreign key references CUSTOMER (CustomerID),
	ProductNumber varchar(40) NOT NULL Foreign key references Product(ProductNumber),
	Quantity int ,
	UnitPrice float,
	Total float
);

