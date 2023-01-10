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

-- Total cases vs total deaths
-- likelihood of dying if you caught covid globally 
select location, date, total_deaths, total_cases, 
round(total_deaths/total_cases * 100, 2) as DeathPercent
from coviddeaths 
having DeathPercent >= .1
order by 1, 2;


-- Total cases vs total deaths
-- likelihood of dying if you caught covid United States
select location, date, total_deaths, total_cases, 
round(total_deaths/total_cases * 100, 2) as DeathPercent
from coviddeaths 
where location like '%states%'
having DeathPercent >= 1 
order by 1, 2;

-- Total cases vs population
-- likelihood of dying if you caught covid globally 
select location, date, total_cases, population, 
round(total_cases/population * 100, 2) as PercentofPopulation
from coviddeaths
having PercentofPopulation >= 1
order by 1, 2;

-- Countries with the highest infection rate 
select location, population, max(total_cases) as HighestInfection, 
round(max(total_cases/population * 100), 2) as PercentofPopulation
from coviddeaths
group by location, population
having PercentofPopulation >= 1
order by PercentofPopulation desc;


-- View of infection rate
Create view Infectionrate as 
select location, population, max(total_cases) as HighestInfection, 
round(max(total_cases/population * 100), 2) as PercentofPopulation
from coviddeaths
group by location, population
having PercentofPopulation >= 1
order by PercentofPopulation desc;

-- Countries with the highest death count
select location, max(Total_deaths) as TotalDeathCnt
from coviddeaths
where continent is not null
group by location
order by TotalDeathCnt desc;



-- Looking at global numbers 
select continent, max(Total_deaths) as TotalDeathCnt
from coviddeaths
where continent is not null
group by continent
order by TotalDeathCnt desc;

-- Perecent of death by continent 
select continent, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
round(sum(new_deaths)/sum(new_cases)*100, 2) as DeathPercent
from coviddeaths 
where continent is not null
Group by continent 
order by 1, 2;


-- View for death rate
create view deathrate as 
select continent, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
round(sum(new_deaths)/sum(new_cases)*100, 2) as DeathPercent
from coviddeaths 
where continent is not null
Group by continent 
order by 1, 2;


-- change date format and datatype
update covidvaccinations 
set date = STR_TO_DATE(date, "%m/%d/%Y");
alter table covidvaccinations modify column date date;


-- World Data on vaccination rate
select location, max(people_fully_vaccinated) as People_vaxinated, 
max(population) as Population, round(max(people_fully_vaccinated)/
max(population) *100, 2) as Vaccination_rate from coviddeaths
group by location
having People_vaxinated is not null
order by location;


-- View for vax rate
create view GlobalVaxRate as 
select location, max(people_fully_vaccinated) as People_vaxinated, 
max(population) as Population, round(max(people_fully_vaccinated)/
max(population) *100, 2) as Vaccination_rate from coviddeaths
group by location
having People_vaxinated is not null
order by location;


-- Total Populations vs new vaccinations 
select continent, location, date, population,
new_vaccinations, sum(new_vaccinations) over 
(partition by location order by location, date) as Rolling_Vax_Count
from coviddeaths
where continent is not null
order by 2, 3;

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



