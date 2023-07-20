--Changing data in SQL queries

select *
from PortfolioProject..NashvilleHousing

--Standardize date Format

select SaleDateConverted, convert(Date, SaleDate)
from PortfolioProject..NashvilleHousing


update NashvilleHousing
Set SaleDate = convert(Date, SaleDate)

Alter Table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date, SaleDate)


--populate property Address data

select *
from PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
order by parcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join  PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.propertyAddress, b. PropertyAddress)
from PortfolioProject..NashvilleHousing a
join  PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null



--Breaking out Address into Individual Columns (Address, city, State)


Select PropertyAddress
from PortfolioProject..NashvilleHousing
--where propertyaddress is nul
--order by parcelID


-- Removing comma(,) from propertyAddress
select 
SUBSTRING(propertyAddress, 1, CHARINDEX(',',propertyAddress)-1) as Address
, SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress)+1, Len(propertyAddress))as Address
from NashvilleHousing



Alter Table NashvilleHousing
add Propertysplitaddress Nvarchar(255);

Update NashvilleHousing
Set Propertysplitaddress= SUBSTRING(propertyAddress, 1, CHARINDEX(',',propertyAddress)-1)


Alter Table NashvilleHousing
add propertysplitcity Nvarchar(255);

Update NashvilleHousing
Set propertysplitcity = SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress)+1, Len(propertyAddress))



select*
from PortfolioProject..NashvilleHousing





select OwnerAddress
from PortfolioProject..NashvilleHousing

--Another way to do it

select
parsename(replace(owneraddress, ',','.' ), 3) as address
,parsename(replace(owneraddress, ',','.' ), 2) as city
,parsename(replace(owneraddress, ',','.' ), 1) as state
from PortfolioProject..NashvilleHousing




Alter Table portfolioproject..NashvilleHousing
add ownersplitaddress Nvarchar(255);

Update portfolioproject..NashvilleHousing
Set ownersplitaddress = parsename(replace(owneraddress, ',','.' ), 3)

Alter Table portfolioproject..NashvilleHousing
add ownersplitcity Nvarchar(255);

Update portfolioproject..NashvilleHousing
Set ownersplitcity = parsename(replace(owneraddress, ',','.' ), 2)

Alter Table portfolioproject..NashvilleHousing
add ownersplitstate Nvarchar(255);

Update portfolioproject..NashvilleHousing
Set ownersplitstate = parsename(replace(owneraddress, ',','.' ), 1)


--Change Y and N to Yes abd No in "Sold as Vacant" field

select Distinct(SoldAsVacant),count(soldasvacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2

Select soldasvacant,
case When SoldAsVacant = 'Y' then 'Yes'
When SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = case When SoldAsVacant = 'Y' then 'Yes'
When SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end




--Remove Duplicates (using CTE)


With RowNumCTE As(
Select *,
     Row_number() over (
     Partition by parcelID,
             propertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by
			   UniqueID
			   ) row_num

from PortfolioProject..NashvilleHousing
--order by ParcelID
)

select *
from RowNumCTE
Where row_num >1
--order by PropertyAddress 



--Delete Unused Columns


select *
From PortfolioProject..NashvilleHousing

ALTER Table portfolioproject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

ALTER Table portfolioproject..NashvilleHousing
Drop Column SaleDate