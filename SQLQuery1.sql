SELECT * FROM 
CovidDeaths
WHERE continent is not null
Order By 3,4

--SELECT *
--FROM CovidVaccinations
--ORDER BY 3,4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
Order BY 1,2

-- Total cases vs Total deaths

SELECT Location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 As DeathPercentage
FROM CovidDeaths
--WHERE Location LIKE '%India%'
Order BY 1,2


--Total Cases vs Population
SELECT Location, date, total_cases,  population, (total_cases/population)*100 As PeopleInfected
FROM CovidDeaths
--WHERE Location LIKE '%India%'
Order BY 1,2



--Looking at countries with highest infection rate

SELECT Location, MAX(total_cases) AS InfectionCount,  population, (MAX(total_cases/population))*100 As PeopleInfected
FROM CovidDeaths
--WHERE Location LIKE '%India%'
GROUP BY Location, population
Order BY PeopleInfected DESC


SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
--WHERE Location LIKE '%India%'
WHERE continent is  null
GROUP BY Location
Order BY TotalDeathCount DESC



--Continent with highest death rate

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidDeaths
--WHERE Location LIKE '%India%'
WHERE continent is not null
GROUP BY continent
Order BY TotalDeathCount DESC


--GLOBAL NUMBERS



SELECT  date, SUM(new_cases) as total_cases,SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
--WHERE Location LIKE '%India%'
WHERE continent is not null
GROUP BY date
Order BY 1,2




-- Total Population vs Vaccination
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition By dea.location Order by dea.location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
Join CovidVaccinations vac
On dea.location= vac.location
and dea.date= vac.date
WHERE dea.continent is not null
Order BY 2,3




--USE CTE


WITH PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition By dea.location Order by dea.location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
Join CovidVaccinations vac
On dea.location= vac.location
and dea.date= vac.date
WHERE dea.continent is not null
)
--Order BY 2,3

SELECT *,(RollingPeopleVaccinated/Population)*100 AS VaccinatedPercentage
FROM PopvsVac


-- CREATING VIEW


Create View  PerecntageOfPopulationVaccinated as
WITH PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition By dea.location Order by dea.location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
Join CovidVaccinations vac
On dea.location= vac.location
and dea.date= vac.date
WHERE dea.continent is not null
)
--Order BY 2,3

SELECT *,(RollingPeopleVaccinated/Population)*100 AS VaccinatedPercentage
FROM PopvsVac







Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc