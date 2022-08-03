use Zoo
--05. Volunteers
SELECT  [Name],[PhoneNumber],[Address],AnimalId,DepartmentId FROM Volunteers as v
ORDER BY [Name],AnimalId,DepartmentId

GO

--06. Animals data
select a.Name, at.AnimalType, Convert( varchar,a.BirthDate,104 )as BirthDate from Animals as a
join AnimalTypes as [at] ON a.AnimalTypeId= at.Id
order by a.Name

go

--07. Owners and Their Animals
select top(5) o.Name as [Owner],count(*) as [CountOfAnimals] from Owners as o
join Animals as a ON o.Id= a.OwnerId
group by o.Name
order by count(*) desc, o.Name

go

--08. Owners, Animals and Cages
select Concat( o.Name,'-',a.Name)as OwnersAnimals,
o.PhoneNumber, ac.CageId
from Owners as o
join Animals as a ON o.Id= a.OwnerId
join AnimalsCages as ac ON a.Id= ac.AnimalId
join AnimalTypes as [at] ON a.AnimalTypeId= [at].Id
where at.AnimalType='Mammals'
order by o.Name,a.Name desc

go

--09. Volunteers in Sofia
SELECT v.Name,v.PhoneNumber, substring(v.Address,CHARINDEX(',',v.Address)+2,len(v.Address))as [Address]
FROM Volunteers as v
join VolunteersDepartments as vd ON v.DepartmentId=vd.Id
where vd.DepartmentName='Education program assistant'
and CHARINDEX ('Sofia', v.Address , 1 )<>0
order by v.Name

go

--10. Animals for Adoption
SELECT a.Name,DATEPART(YEAR, a.BirthDate)as BirthYear, ats.AnimalType FROM Animals as a
join AnimalTypes as ats ON a.AnimalTypeId=ats.Id
where a.OwnerId is null 
and ats.AnimalType <> 'Birds'
and DATEDIFF(year, a.BirthDate,'01/01/2022')<5
order by a.Name

go

--11. All Volunteers in a Department
CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(50))
returns int
as
	BEGIN
	DECLARE @result int;

	set @result=(Select count(*) from Volunteers as v
	join VolunteersDepartments as vd ON v.DepartmentId=vd.Id
	where vd.DepartmentName=@VolunteersDepartment)
	
	return @result;
	END 

go

--12. Animals with Owner or Not
CREATE or alter PROC  usp_AnimalsWithOwnersOrNot @AnimalName VARCHAR(30)
AS
	BEGIN 
		declare @ownerId int=(SELECT a.OwnerId FROM Animals as a
							where a.Name=@AnimalName)			

	  if(@ownerId is null)	
		  begin 
		  select @AnimalName as [Name], 'For adoption' as OwnersName	 
		  end
	 else
		  begin 
			 declare  @ownerName varchar(30)=(select o.Name from Owners as o
											 where o.Id=@ownerId)	 
			 select @AnimalName as [Name], @ownerName as OwnersName
		  end
	END
go

exec usp_AnimalsWithOwnersOrNot 'Hippo'

--this is from fastline32/Svetoslav Savov

--SELECT a.[Name],
--	       ISNULL(o.[Name],'For adoption') AS [OwnersName]
--      FROM [Animals] AS a 
--      LEFT JOIN [Owners] AS o 
--        ON a.[OwnerId] = o.[Id]
--     WHERE a.[Name] = 'Brown Bear'