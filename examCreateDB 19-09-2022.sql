--01. DDL

CREATE DATABASE Zoo
use Zoo

CREATE TABLE Owners(
Id int primary key identity
,[Name] varchar(50) not null
,PhoneNumber  varchar(15) not null
,[Address] varchar(50)  null
)

CREATE TABLE AnimalTypes(
Id int primary key identity
,AnimalType varchar(30) not null
)

CREATE TABLE Cages(
Id int primary key identity
,AnimalTypeId int  FOREIGN KEY REFERENCES AnimalTypes(Id)not null
)

CREATE TABLE Animals(
Id int primary key identity
,[Name] varchar(30) not null
,BirthDate Date not null
,OwnerId int  FOREIGN KEY REFERENCES Owners(Id) null
,AnimalTypeId int FOREIGN KEY REFERENCES AnimalTypes(Id) not null
)

CREATE TABLE AnimalsCages(
CageId int  FOREIGN KEY REFERENCES Cages(Id) Not null
,AnimalId int  FOREIGN KEY REFERENCES  Animals(Id)not null
,CONSTRAINT PK_IdCageAnimal PRIMARY KEY (CageId,AnimalId)
)

CREATE TABLE VolunteersDepartments(
Id int primary key identity
,DepartmentName varchar(30) not null
)

CREATE TABLE Volunteers(
Id int primary key identity
,[Name] varchar(50) not null
, PhoneNumber varchar(15) not null
,[Address] varchar(50) null
,AnimalId int foreign key references Animals(Id) null
,DepartmentId int foreign key references VolunteersDepartments(Id)not null
)
go




