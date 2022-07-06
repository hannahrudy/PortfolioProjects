/*
Covid 19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


Select *
From PortfolioProject1..CovidDeaths
Where continent is not null
Order By 3,4

--Selecting data I'll be starting with--

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths
Where continent is not null
order by 1,2

--Total Cases vs Total Deaths--
--Shows likelihood of dying if you contract covid in a given country--

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2

--Total Cases vs Population--
--Shows percent of population infected with covid--

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject1..CovidDeaths
--where location like '%states%'
order by 1,2

--Countries with Highest Infection Rate compared to population--

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc

--Countries with Highest Death Count per Population--
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
--where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc


--BREAKING THINGS DOWN BY CONTINENT--

--showing continents with highest death count per population--

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS--

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
where continent is not null 
--group by date
order by 1,2


--Total Population vs Vaccinations--
--Shows Percentage of Population that has recieved at least one Covid Vaccine--

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Using CTE to perform Calculation on Partition By in previous query--

With PopvsVac (Continent, location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Using Temp Table to perform Calculation on Partition By in previous query--

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating View to store data for later vissualizatons

--View to visualize percent of people vaccinated

 Create View PercentPopulationVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


--View to visualize percent people who died of covid 

Create View PercentPopulationDied as
Select dea.continent, dea.location, dea.date, dea.population, dea.total_deaths
, SUM(CONVERT(int, dea.total_deaths)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleDied
--, (RollingPeopleDied/population)*100
from PortfolioProject1..CovidDeaths dea
where dea.continent is not null 

--View to visualiza percent of people infected

Create View PercentPopulationInfected as
Select dea.continent, dea.location, dea.date, dea.population, dea.total_cases 
, SUM(CONVERT(int, dea.total_cases)) OVER (partition by dea.location order by dea.location, dea.date)as RollingPeopleInfected
--,(dea.total_cases/population)*100 
From PortfolioProject1..CovidDeaths dea
where dea.continent is not null