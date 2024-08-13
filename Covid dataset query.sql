select * from CovidDeaths order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths order by 1,2

--Looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from CovidDeaths 
where location='India' order by 1,2

-- Looking at percent of people affected by covid
select location, date, total_cases, population, (total_cases/population)*100 as CovidPercent
from CovidDeaths where location = 'India' order by 1,2

-- Looking at countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestCovidCount, max(total_cases/population)*100 as CovidPercent
from CovidDeaths group by location, population 
order by CovidPercent desc

-- Countries with highest death count 
select location, max(cast(total_deaths as int)) TotalDeathCount
from CovidDeaths where continent is not null
group by location 
order by TotalDeathCount desc

-- Total deaths by continent
select location, max(cast(total_deaths as int)) TotalDeathCount
from CovidDeaths where continent is null
group by location 
order by TotalDeathCount desc

-- Total deaths by continent
select continent, max(cast(total_deaths as int)) TotalDeathCount
from CovidDeaths where continent is not null
group by continent 
order by TotalDeathCount desc

-- Global data per sday
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercent
from CovidDeaths 
where continent is not null 
group by date
order by 1

-- Total population vs Vaccinations
select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
sum(convert(int,va.new_vaccinations)) over (partition by de.location order by de.location, de.date) as PeopleVaccinated
from CovidDeaths de join CovidVaccinations va
on de.location=va.location and de.date=va.date
where de.continent is not null
order by 2,3

with popVac (Continent, Location, Date, Population, Vaccinations, PeopleVaccinated)
as
(
select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
sum(convert(int,va.new_vaccinations)) over (partition by de.location order by de.location, de.date)
from CovidDeaths de join CovidVaccinations va
on de.location=va.location and de.date=va.date
where de.continent is not null
)
select *, (PeopleVaccinated/Population)*100 from popVac order by Location, Date


--Creating View to store data for later visualization
Create View PercentPopulationVaccinated as
select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
sum(convert(int,va.new_vaccinations)) over (partition by de.location order by de.location, de.date) as PeopleVaccinated
from CovidDeaths de join CovidVaccinations va
on de.location=va.location and de.date=va.date
where de.continent is not null




