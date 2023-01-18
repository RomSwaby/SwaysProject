USE portfolio;
-- Visualizing the whole table I am working with.
SELECT * 
FROM coviddeaths
order by 3, 4; 

-- check on data type
desc coviddeaths;

-- change date format and datatype
update coviddeaths 
set date = STR_TO_DATE(date, "%m/%d/%Y");
alter table coviddeaths modify column date date;


-- change data type
alter table coviddeaths modify column total_deaths int;

alter table coviddeaths modify column new_deaths int;

alter table coviddeaths modify column total_cases int;

alter table coviddeaths modify column new_cases int;

alter table coviddeaths modify column new_tests int;

alter table coviddeaths modify column total_tests int;

alter table coviddeaths modify column total_vaccinations int;

alter table coviddeaths modify column people_vaccinated int;

alter table coviddeaths modify column people_fully_vaccinated int;

alter table coviddeaths modify column new_vaccinations int;

alter table coviddeaths modify column population bigint;

-- make empty cells null 
update coviddeaths set total_deaths = null 
where total_deaths = '';

update coviddeaths set total_cases = null 
where total_cases = '';

update coviddeaths set continent = null 
where continent = '';

update coviddeaths set new_deaths = null 
where new_deaths = '';

update coviddeaths set new_cases = null 
where new_cases = '';

update coviddeaths set new_tests = null 
where new_tests = '';

update coviddeaths set total_tests = null 
where total_tests = '';

update coviddeaths set total_vaccinations = null 
where total_vaccinations = '';

update coviddeaths set people_vaccinated = null 
where people_vaccinated = '';

update coviddeaths set people_fully_vaccinated = null 
where people_fully_vaccinated = '';

update coviddeaths set new_vaccinations = null 
where new_vaccinations = '';

update coviddeaths set population = null 
where population = '';

-- select colomns necessary for project 
select location, date, total_cases,new_cases, total_deaths, population  
from coviddeaths 
order by 1, 2;


-- Global Cases, Deaths and Death Percent of Cases
select Continent, sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths, 
round(sum(new_deaths)/sum(new_cases) * 100, 2) as DeathPercent
from coviddeaths 
where continent is null
group by continent
order by 1, 2;

-- Global Cases, Deaths and Death Percent of Cases by contienent 
select Continent, sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths, 
round(sum(new_deaths)/sum(new_cases) * 100, 2) as DeathPercent
from coviddeaths 
where continent is not null
group by continent
order by 1, 2;

-- Global Cases, Deaths and Death Percent of Cases by Countries 
select Location, sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths, 
round(sum(new_deaths)/sum(new_cases) * 100, 2) as DeathPercent
from coviddeaths 
where continent is not null
group by Location
order by 1, 2;

-- Global Population Infected by Covidp per location 
select location, date, sum(new_cases) as Total_Cases, population, 
round(sum(new_cases)/population * 100, 2) as PercentofPopulationInfected
from coviddeaths
where location not in ('World', 'European Union', 'International') 
and continent is not null
group by location, population, date
order by PercentofPopulationInfected desc;

-- Global Population Infected by Covid per Continent
select location, sum(new_cases) as Total_Cases, population, 
round(sum(new_cases)/population * 100, 2) as PercentofPopulationInfected
from coviddeaths
where continent is null 
group by location, population
order by PercentofPopulationInfected desc;


-- Perecent of death by Location 
select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
round(sum(new_deaths)/sum(new_cases)*100, 2) as DeathPercent
from coviddeaths 
where continent is not null
Group by location
order by 1, 2;

-- Perecent of death by Continent 
select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
round(sum(new_deaths)/sum(new_cases)*100, 2) as DeathPercent
from coviddeaths 
where continent is null
Group by location
order by 1, 2;

-- World Data on vaccination rate
select location, date, max(people_fully_vaccinated) as People_vaxinated, 
max(population) as Population, round(max(people_fully_vaccinated)/
max(population) *100, 2) as Vaccination_rate from coviddeaths
where continent is null
group by location, date
order by People_vaxinated desc;

-- World Data on vaccination rate per country
select location, date, max(people_fully_vaccinated) as People_vaxinated, 
max(population) as Population, round(max(people_fully_vaccinated)/
max(population) *100, 2) as Vaccination_rate from coviddeaths
where continent is not null
group by location, date
order by People_vaxinated desc;




-- Populations vs New Vaccinations 
-- Using CTE
with popvsvax (continent, location, date, population, new_vaccinations, Rolling_Vax_Count)
as 
(select continent, location, date, population,
new_vaccinations, sum(new_vaccinations) over 
(partition by location order by location, date) as Rolling_Vax_Count
from coviddeaths
where continent is not null)
select *, (Rolling_Vax_Count/population * 100) from popvsvax;

-- Populations vs New Vaccinations 
-- Using Temp Table 
drop table if exists Percentofpopulationvaccinated;
Create TEMPORARY Table Percentofpopulationvaccinated
(
continent text, location text, 
date date, population int,
new_vaccinations int, Rolling_Vax_Count int
);

insert into Percentofpopulationvaccinated
select continent, location, date, population,
new_vaccinations, sum(new_vaccinations) over 
(partition by location order by location, date) as Rolling_Vax_Count
from coviddeaths
where continent is not null;

select *, (Rolling_Vax_Count/population * 100) 
from Percentofpopulationvaccinated;


