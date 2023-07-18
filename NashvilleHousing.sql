-- overview
select *
from portfolproject..Nashville 

--standardize date format
select SaleDateCONVERT ,CONVERT(date,SaleDate)
from portfolproject..Nashville

update Nashville
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE Nashville
add SaleDateCONVERT date;

update Nashville
SET SaleDateCONVERT = CONVERT(date,SaleDate)

--Populate Property Address data

select *
from portfolproject..Nashville
--where Propertyaddress is null
order by ParcelID



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from portfolproject..Nashville a
join portfolproject..Nashville b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID] 
where a.PropertyAddress is null

update a
set propertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from portfolproject..Nashville a
join portfolproject..Nashville b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID] 
where a.PropertyAddress is null

-- Breaking out Address into Individual Columms(address, city, state)

select propertyAddress
from portfolproject..Nashville

select
SUBSTRING(propertyAddress, 1,CHARINDEX(',',propertyAddress) -1) as Address
 ,SUBSTRING(propertyAddress ,CHARINDEX(',',propertyAddress) +1, LEN(propertyAddress) ) as city
from portfolproject..Nashville

ALTER TABLE Nashville
add ProperSplitAddress Nvarchar(255);

update Nashville
SET ProperSplitAddress = SUBSTRING(propertyAddress, 1,CHARINDEX(',',propertyAddress) -1)

ALTER TABLE Nashville
add ProperSplitcity Nvarchar(255);

update Nashville
SET ProperSplitcity = SUBSTRING(propertyAddress ,CHARINDEX(',',propertyAddress) +1, LEN(propertyAddress))


--
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from portfolproject..Nashville

ALTER TABLE portfolproject..Nashville
add ownerplitcityaddress Nvarchar(255)

update portfolproject..Nashville
SET ownerplitcityaddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE portfolproject..Nashville
add ownerSplitcity Nvarchar(255);

update portfolproject..Nashville
SET ownerSplitcity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE portfolproject..Nashville
add ownerSplitstate Nvarchar(255);

update portfolproject..Nashville
SET ownerSplitstate = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select*
from portfolproject..Nashville

-- change Y and N to yes and no in "sold as vacant" field


Select SoldAsVacant,
 case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end
from portfolproject..Nashville

update portfolproject..Nashville
SET SoldAsVacant =
 case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end

Select SoldAsVacant,count(SoldAsVacant) 
from portfolproject..Nashville
group by SoldAsVacant


--remove duplicates














