--Cleaning Data

select * from NashvilleHousing

--Standardized Date
select SaleDate, CONVERT(Date, SaleDate) from NashvilleHousing

update NashvilleHousing set SaleDate=CONVERT(Date, SaleDate)

--Populate property Address data
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a 
set a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into separate columns(Address, City, State)
select PropertyAddress from NashvilleHousing

select SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress)-1) as Address,
SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress)+1, LEN(propertyAddress)) as City
from NashvilleHousing


