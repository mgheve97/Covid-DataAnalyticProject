-- 1
select SUM(new_cases) as 'Total Cases', SUM(cast(new_deaths as bigint)) as total_deaths
,SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from [PortfolioProject]..['Covid-Deaths']
where continent is not null
order by 1,2

--2
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [PortfolioProject]..['Covid-Deaths']
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [PortfolioProject]..['Covid-Deaths']
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--4
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [PortfolioProject]..['Covid-Deaths']
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--5
Select Location, date, population, total_cases, total_deaths
From [PortfolioProject]..['Covid-Deaths']
--Where location like '%states%'
where continent is not null 
order by 1,2


--6
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [PortfolioProject]..['Covid-Deaths'] dea
Join [PortfolioProject]..['Covid-Vaccination'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac

--7
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [PortfolioProject]..['Covid-Deaths']
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc