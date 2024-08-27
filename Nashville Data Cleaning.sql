--Cleaning Data

select * from NashvilleHousing

--Standardized Date
select SaleDate, CONVERT(Date, SaleDate) from NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date

update NashvilleHousing 
set SaleDateConverted=CONVERT(Date, SaleDate)


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

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255)

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress=SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress)-1)

update NashvilleHousing
set PropertySplitCity=SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress)+1, LEN(propertyAddress))


--Handling OwnerAddress
select OwnerAddress from NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3)

update NashvilleHousing
set OwnerSplitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)

update NashvilleHousing
set OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)


--Changing Y and N to Yes and No for SoldAsVacant column
select distinct SoldAsVacant, count(SoldAsVacant) 
from NashvilleHousing
group by SoldAsVacant
order by 2

update NashvilleHousing
set SoldAsVacant = case 
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end
---------------------------------------------------------------

--Remove Duplicates
select * from NashvilleHousing

WITH cte as(
select *,
ROW_NUMBER() over(partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
				  order by UniqueID) as row_num
from NashvilleHousing
)	
select * from cte 
delete row_num>1
--order by PropertyAddress


--Delete Unused Columns
select * from NashvilleHousing

alter table NashvilleHousing
drop column SaleDate, PropetryAddress, OwnerAddress, TaxDiscription

