Use covid;
-- Visualizing the whole table I am working with.
SELECT * 
FROM cvus_ order by submission_date; 

-- select columns necessary for project 
select state, submission_date, tot_cases, conf_cases, 
new_case, tot_death, conf_death, new_death 
from cvus_ 
order by submission_date;

-- looking at total cases vs total death

select state, submission_date, tot_cases, tot_death,
round ((tot_cases/tot_death)*100, 1) as Death_Percentage from cvus_ 
where submission_date >= "2020-01-22"
order by submission_date;
#Likely hood of getting covid and dying from it at a specific time

-- created a COLUMN called year to join State_pop on
alter table cvus_ modify column year varchar(50);

-- Change data type of submission_date and year
alter table cvus_ add year datetime;
alter table cvus_ modify column submission_date datetime;

-- Fill new column year with years extracted from submission_date column
update cvus_ set year = year(submission_date);


-- Show states with the highest covid death count 
Select state, MAX(tot_death) as Tot_deathCnt
from cvus_
group by state
order by Tot_deathCnt desc;

-- States with the highest covid case count 
Select state, MAX(tot_cases) as Total_caseCnt
from cvus_
group by state
order by Total_caseCnt desc;

-- Showing Deaths and Cases in the US by date 
Select submission_date, SUM(new_death) as Death, sum(new_case) as Cases, 
round(SUM(new_death)/sum(new_case)*100, 2) as DeathPercent  from cvus_
group by submission_date
order by 1, 2;


-- Total deaths, total cases and deaths per cases in the US 
-- Showing deathPercent greater than .99%
Select state, SUM(new_death) as Death, sum(new_case) as Cases, 
round(SUM(new_death)/sum(new_case)*100, 2) as DeathPercent  from cvus_
group by state
having DeathPercent >= 1 
order by DeathPercent desc;


-- States with highest covid infection rate per year
select state_pop.state as state, state_pop.year as year, 
sum(new_case) as total_cases,
round(avg(population_estimate), 0) as population, 
round(sum(new_case)/avg(population_estimate)*100, 2) 
as Percentofdeath from state_pop
join cvus_ on cvus_.state = state_pop.state
group by state, year
order by Percentofdeath desc;

-- View of Infection rate 
create view Infectionrate as 
select state_pop.state as state, state_pop.year as year, 
sum(new_case) as total_cases,
round(avg(population_estimate), 0) as population, 
round(sum(new_case)/avg(population_estimate)*100, 2) 
as Percentofdeath from state_pop
join cvus_ on cvus_.state = state_pop.state
group by state, year
order by Percentofdeath desc;


-- States with highest rate of covid death/cases per year
select state as state, year, 
sum(new_death) as total_death, 
sum(new_case) as total_cases, 
round(sum(new_death)/sum(new_case)*100, 2) 
as Percentofdeath from cvus_ 
group by state, year
order by Percentofdeath desc;


-- States with highest rate of covid death/population per year 
select state_pop.state as state, state_pop.year as year, 
sum(new_death) as total_death, 
round(avg(population_estimate), 0) as population, 
round(sum(new_death)/avg(population_estimate)*100, 2) 
as Percentofdeath from state_pop
join cvus_ on cvus_.state = state_pop.state
group by state, year
order by Percentofdeath desc;

-- View of covid deaths per cases 
create view StatesDeathperCases as 
select state_pop.state as state, state_pop.year as year, 
sum(new_death) as total_death, 
round(avg(population_estimate), 0) as population, 
round(sum(new_death)/avg(population_estimate)*100, 2) 
as Percentofdeath from state_pop
join cvus_ on cvus_.state = state_pop.state
group by state, year
order by Percentofdeath desc;

-- View of Covid deaths vs Population 
Create view StatesCoviddeathPop as 
select state_pop.state as state, state_pop.year as year, 
sum(new_death) as total_death, 
round(avg(population_estimate), 0) as population, 
round(sum(new_death)/avg(population_estimate)*100, 2) 
as Percentofdeath from state_pop
join cvus_ on cvus_.state = state_pop.state
group by state, year
order by Percentofdeath desc;

-- Update state value from New York to New York state 
update state_pop set state_name = 'New York State'
where state_name = 'New York';

-- State vaccination rate per year
select State_name as State, state_pop.year, round(max(people_fully_vaccinated), 0) 
as People_Vaccinated, max(population_estimate) as Population, 
round(max(people_fully_vaccinated)/max(population_estimate) * 100, 2) as 
Vaccination_Rate from us_state_vaccinations join state_pop on 
us_state_vaccinations.location = state_pop.State_name and 
state_pop.year = us_state_vaccinations.year
group by State_name, state_pop.year
having Vaccination_Rate is not null
order by state;

-- View of Vaccination rate by state per year 
create view StatesVaxRate as
select State_name as State, state_pop.year, round(max(people_fully_vaccinated), 0) 
as People_Vaccinated, max(population_estimate) as Population, 
round(max(people_fully_vaccinated)/max(population_estimate) * 100, 2) as 
Vaccination_Rate from us_state_vaccinations join state_pop on 
us_state_vaccinations.location = state_pop.State_name and 
state_pop.year = us_state_vaccinations.year
group by State_name, state_pop.year
having Vaccination_Rate is not null
order by state;


-- US percent of vaccination rate
select round(max(people_fully_vaccinated), 0) 
as People_Vaccinated, max(population_estimate) as Population, 
round(max(people_fully_vaccinated)/max(population_estimate) * 100, 2) as 
Vaccination_Rate from us_state_vaccinations join state_pop on 
us_state_vaccinations.location = state_pop.State_name and 
state_pop.year = us_state_vaccinations.year
having Vaccination_Rate is not null;
## off by 4%



##-- add extract year from date and make it a column to join us_state_vaccinations
alter table us_state_vaccinations add year datetime;
alter table us_state_vaccinations modify column year text;
alter table us_state_vaccinations modify column date date;
update us_state_vaccinations
set date = STR_TO_DATE(date, '%Y/%m/%d');
update us_state_vaccinations set year = year(date);



-- US percent of vaccination rate
select max(FULLY_VACCINATED_PERSONS)/max(POPULATION) as Vaccination_Rate from us_vax;

-- State Vaccination Rate
select state, max(FULLY_VACCINATED_PERSONS)/max(POPULATION) * 100 as Vaccination_Rate
from us_vax
group by state
having Vaccination_Rate is not null
order by state;


-- View US vaccinations

select location, max(total_vaccinations)
from us_state_vaccinations
group by location
order by location;




-- Turn empty cells into null values  in order to change the variable type 
update us_state_vaccinations set total_vaccinations = null 
where total_vaccinations = '';

alter table us_state_vaccinations modify column total_vaccinations int;



update us_vax
set date = STR_TO_DATE(DATE, "%m/%d/%Y");
alter table us_vax modify column DATE date;


-- Distribution vs Vaccinations 
select state_pop.state, state_pop.year,
 max(TOTAL_DOSES_DISTRIBUTED),
max(FULLY_VACCINATED_PERSONS)
from state_pop join us_vax on 
us_vax.state = state_pop.State_name
join cvus_ on cvus_.submission_date = us_vax.date
group by state, year
order by state;
          
