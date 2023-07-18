select *
from portfolproject ..coviddeath
where continent is not null
order by 3,4;

--select *
--from portfolproject ..covidVaccination
--order by 3,4;
-- select data that we are going to be using
select location,date,total_cases,new_cases,total_deaths,population
from portfolproject ..coviddeath
order by 1,2;

-- looking at tatal caases vs total deaths
-- show likelihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths,(CAST(total_deaths as float)/cast(total_cases as float))*100 as deathpercentage 
from portfolproject ..coviddeath
where location like '%states%'
order by 1,2;

-- looking at total Cases vs Population
-- shows what percentage of population got covid
select location,date,total_cases,population,(CAST(total_cases as float)/cast(population as float))*100 as percentPopulationInfected 
from portfolproject ..coviddeath
where location like '%states%'
order by 1,2;

-- looking at countries with highest infection rate compared to population
select location,population,max(total_cases),max((CAST(total_cases as float)/cast(population as float)))*100 as percentPopulationInfected 
from portfolproject ..coviddeath
--where location like '%states%'
group by location,population
order by percentPopulationInfected desc;

--shoxing  countries with highest Death Count per Plpulation
select location,max(cast(total_deaths as int)) as TotalDeathCount
from portfolproject ..coviddeath
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc;

-- let's break things down by continent

--showing contintents with the highest death per population
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from portfolproject ..coviddeath
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc;

--global numbers
select date,sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(nullif(new_cases,0))*100 as percentPopulationInfected 
from portfolproject ..coviddeath
--where location like '%states%'
where continent is not null
group by date
order by 1,2;

--looking at total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVacinated
from portfolproject..coviddeath dea
join portfolproject..covidVaccination vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--use cte
with popvsvac(continent,location,date,population,new_vaccinations,rollingPeopleVacinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVacinated
from portfolproject..coviddeath dea
join portfolproject..covidVaccination vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3;
)
select *,(rollingPeopleVacinated/population)*100
from popvsvac

-- temp table 


-- create view for visualisation 
create view rollingPeopleVacinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVacinated
from portfolproject..coviddeath dea
join portfolproject..covidVaccination vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3;

-- create view showing contintents with the highest death per population
create view ShowingContintentsWithTheHighestDeathPerPopulation as
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from portfolproject ..coviddeath
--where location like '%states%'
where continent is not null
group by continent
--order by TotalDeathCount desc;

sp_help 'ShowingContintentsWithTheHighestDeathPerPopulation';


-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolproject ..coviddeath
--Where location like '%states%'
Group by Location, Population,date
order by PercentPopulationInfected desc







