/*
Dataset: Covid-19
The dataset contains information about new cases, recovered cases, total deaths, vaccination status,etc  of 219 different countries from Jan 2020 till April 2021.

Skills Used: Joins, CTE's, Windows Functions,Window Functions with AggregateFunctions, Converting Data Types, Aggregate Functions
*/ 


-- Percentage of population infected with covid
select location, date, total_cases,(total_cases/population)*100 as InfectedPercentage from
[Portfolio Project-1]..CovidDeaths$
where location in ('India','United States')
order by date;


-- Percentage of people dying who are infected with Covid
select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from [Portfolio Project-1]..CovidDeaths$
where location in ('India','United States')
order by date;


-- Top 10 Countries with Highest Infection Rate as compared to population
select top 10 location,population,max(total_cases) as HighestCases,max(total_cases/population)*100 as InfectedPercentage from
[Portfolio Project-1]..CovidDeaths$
group by location,population
order by InfectedPercentage desc;


-- Top 10 Countries with highest deaths due to covid
select top 10 location,max(cast(total_deaths as int)) as MaxTotalDeaths from
[Portfolio Project-1]..CovidDeaths$
where continent is not null
group by location
order by MaxTotalDeaths desc;


-- Total cases , Total Deaths across the world each day
select date, sum(new_cases) as TotalNewCases,sum(cast(new_deaths as int)) as TotalDeaths
from [Portfolio Project-1]..CovidDeaths$
where continent is not null
group by date
order by date;


-- Vaccinated people for each day for every location
Select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
sum(convert(int,vaccine.new_vaccinations)) over(Partition by death.location order by death.location,death.date) from [Portfolio Project-1]..CovidDeaths$ as death
join [Portfolio Project-1]..CovidVaccinations$ as vaccine
on death.date = vaccine.date and death.location = vaccine.location
where death.continent is not null
order by 2,3;

-- Total population that got vaccinated for every continent
Select death.continent, sum(death.population) as Totalpopulation, sum(cast(vaccine.new_vaccinations as int)) as Vaccinated from [Portfolio Project-1]..CovidDeaths$ as death
join [Portfolio Project-1]..CovidVaccinations$ as vaccine
on death.date = vaccine.date and death.location = vaccine.location
where death.continent is not null
group by death.continent
order by 1,2;



