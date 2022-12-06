--/Queries Used for Tableau Film Permit Project/


--Which borough will have the most filmings take place

select borough, count(*)
as totalpermitsperborough
from dbo.nycfilmpermits
group by borough
order by totalpermitsperborough desc;

--Which ZipCode does the most filmings take place

select [ZipCode(s)], count(*) 
as totalpermitsperzip
from dbo.nycfilmpermits
where [ZipCode(s)] is not null
group by [ZipCode(s)]
order by totalpermitsperzip desc;

--Which precinct does the most filmings take place

select [PolicePrecinct(s)], count(*) 
as totalpermitsperprecinct
from dbo.nycfilmpermits
where [PolicePrecinct(s)] is not null
group by [PolicePrecinct(s)]
order by totalpermitsperprecinct desc;

--What parking location is most used for film crews

select parkingheld, count(*)
as totalused
from dbo.nycfilmpermits
group by parkingheld
order by totalused desc;

--What type of shoot is most common

select category, count(*)
as totaltype
from dbo.nycfilmpermits
group by category
order by totaltype desc;
