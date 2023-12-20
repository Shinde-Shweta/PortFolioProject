
select * from [PortfolioProfile].[dbo].[CovidDeaths]
where continent is not null
order by 3,4;

select * from [PortfolioProfile].[dbo].[CovidVaccinations]
order by 3,4;

select location, date, total_cases, new_cases, total_deaths , population
from [PortfolioProfile].[dbo].[CovidDeaths]
where continent is not null
order by 1,2;

----Looking at Total Cases vs Total Death

select location, date, total_cases, new_cases, total_deaths	, (total_deaths/total_cases)*100 as DeathPercentages
from [PortfolioProfile].[dbo].[CovidDeaths]
where location like '%states%' 
and continent is not null
order by 1,2;

----Looking at Total Cases vs Population
--shows what percentage of population got covid
select location, date, total_cases, Population	, (total_cases/population)*100 as PercentagesPopulationInfected
from [PortfolioProfile].[dbo].[CovidDeaths]
where location like '%states%'
and continent is not null
order by 1,2;

---Looking for countries with higesh infection rate
select location,Population,max(total_cases) as HigestInfection, Max((total_cases/population))*100 as PercentagesPopulationInfected
from [PortfolioProfile].[dbo].[CovidDeaths]
--where location like '%states%'
where continent is not null
Group by location, population
order by PercentagesPopulationInfected desc;

---Showing Countries with higest death count per population
select location,max(cast(total_deaths as int)) as totaldeathcount
from [PortfolioProfile].[dbo].[CovidDeaths]
--where location like '%states%'
where continent is not null
Group by location
order by totaldeathcount desc;

--Break down by continents 

select location,max(cast(total_deaths as int)) as totaldeathcount
from [PortfolioProfile].[dbo].[CovidDeaths]
--where location like '%states%'
where continent is  null
Group by location
order by totaldeathcount desc;

--Global Numbers
select-- date,
SUM(New_cases) as Total_Cases,
sum(cast(new_deaths as int)) as total_death , 
sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentages
from [PortfolioProfile].[dbo].[CovidDeaths]
--where location like '%states%'
where continent is not null
--Group by date
order by 1,2;

select dea.continent, dea.location, dea.date , population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from 
[PortfolioProfile].[dbo].[CovidDeaths] dea Join
 [PortfolioProfile].[dbo].[CovidVaccinations] vac on
 dea.location=vac.location and
 dea.date=vac.date
 where dea.continent is not null
 order by 2,3;

 ----USE CTE

 WITH popvsvac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
 as
 (
 select dea.continent, dea.location, dea.date , population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from 
[PortfolioProfile].[dbo].[CovidDeaths] dea Join
 [PortfolioProfile].[dbo].[CovidVaccinations] vac on
 dea.location=vac.location and
 dea.date=vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select * ,(RollingPeopleVaccinated/population)*100 as PrcentageVaccinated
 from popvsvac;

 --TEMP Table
  create table [PortfolioProfile].[dbo].[PercentPopulationVaccinated]
  (
  Continent nvarchar(255), 
  Location nvarchar(255), 
  Date datetime, 
  Population numeric, 
  new_vaccinations numeric,
  RollingPeopleVaccinated numeric
  );

  Insert into [PortfolioProfile].[dbo].[PercentPopulationVaccinated]
 select dea.continent, dea.location, dea.date , population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from 
[PortfolioProfile].[dbo].[CovidDeaths] dea Join
 [PortfolioProfile].[dbo].[CovidVaccinations] vac on
 dea.location=vac.location and
 dea.date=vac.date
 where dea.continent is not null
 --order by 2,3;
 
 select * ,(RollingPeopleVaccinated/population)*100
 from [PortfolioProfile].[dbo].[PercentPopulationVaccinated];

 ---Create view

 create view VPercentPopulationVaccinated as
  select dea.continent, dea.location, dea.date , population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from 
[PortfolioProfile].[dbo].[CovidDeaths] dea Join
 [PortfolioProfile].[dbo].[CovidVaccinations] vac on
 dea.location=vac.location and
 dea.date=vac.date
 where dea.continent is not null;
 --order by 2,3;

 select * from VPercentPopulationVaccinated;





