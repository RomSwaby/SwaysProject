Use covid;
-- Visualizing the whole table I am working with.
SELECT * 
FROM cvus_; 

desc cvus_;

-- created a COLUMN called year to join State_pop on
alter table cvus_ modify column year varchar(50);

-- Change data type of submission_date and year
alter table cvus_ add year datetime;
alter table cvus_ modify column submission_date date;

update cvus_
set submission_date = STR_TO_DATE(submission_date, "%m/%d/%Y");

-- Fill new column year with years extracted from submission_date column
update cvus_ set year = year(submission_date);


INSERT INTO state_pop (State_name, state, year, population_estimate)
VALUES ('Pennsylvania', 'PA', 2020, 13002689);

INSERT INTO state_pop (State_name, state, year, population_estimate)
VALUES ('Pennsylvania', 'PA', 2021, 13012059);

INSERT INTO state_pop (State_name, state, year, population_estimate)
VALUES ('Pennsylvania', 'PA', 2022, 12972008);

-- Update state value from New York to New York state 
update state_pop set state_name = 'New York State'
where state_name = 'New York';


alter table us_state_vaccinations modify column people_fully_vaccinated int;
update us_state_vaccinations set people_fully_vaccinated = null 
where people_fully_vaccinated = '';
desc us_state_vaccinations;

-- Turn empty cells into null values  in order to change the variable type 
update us_state_vaccinations set total_vaccinations = null 
where total_vaccinations = '';

alter table us_state_vaccinations modify column total_vaccinations int;

update us_vax
set date = STR_TO_DATE(DATE, "%m/%d/%Y");
alter table us_vax modify column DATE date;


##-- add extract year from date and make it a column to join us_state_vaccinations
alter table us_state_vaccinations add year datetime;
alter table us_state_vaccinations modify column year text;
alter table us_state_vaccinations modify column date date;
update us_state_vaccinations
set date = STR_TO_DATE(date, '%Y/%m/%d');
update us_state_vaccinations set year = year(date);
update uvus_
set date = STR_TO_DATE(date, '%Y/%m/%d');

#1
-- States with highest covid infection rate per year
select state_pop.state as state, 
sum(new_case) as total_cases,
round(avg(population_estimate), 0) as population, 
sum(new_case)/(avg(population_estimate))*100 
as Infectionrate from state_pop
join cvus_ on cvus_.state = state_pop.state and 
cvus_.year = state_pop.year
group by state
order by state desc;

#2
-- States with highest rate of covid death/cases per year
select state as state, year, 
sum(new_death) as total_death, 
sum(new_case) as total_cases, 
round(sum(new_death)/sum(new_case)*100, 2) 
as Percentofdeath from cvus_ 
group by state, year
order by Percentofdeath desc;


-- States with highest rate of covid death/population per year 
select submission_date, state_pop.state as state, state_pop.year as year, 
sum(new_death) as total_death, 
round(avg(population_estimate), 0) as population, 
round(sum(new_death)/avg(population_estimate)*100, 2) 
as Percentofdeath from state_pop
join cvus_ on cvus_.state = state_pop.state
group by state, year , submission_date
order by Percentofdeath desc;

select state_pop.state as state, 
sum(new_death) as total_death, 
round(avg(population_estimate), 0) as population, 
round(sum(new_death)/avg(population_estimate)*100, 2) 
as Percentofdeath from state_pop
join cvus_ on cvus_.state = state_pop.state
group by state
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

-- State vaccination
select State, round(max(people_fully_vaccinated), 0) 
as People_Vaccinated, max(population_estimate) as Population, 
round(max(people_fully_vaccinated)/max(population_estimate) * 100, 2) as 
Vaccination_Rate from us_state_vaccinations join state_pop on 
us_state_vaccinations.location = state_pop.State_name 
group by State
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

