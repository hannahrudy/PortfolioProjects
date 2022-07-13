/*
Cleaning Data in SQL Queries
*/

Select * 
From PortfolioProject1.dbo.NashvilleHousing

-------------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject1.dbo.NashvilleHousing


Update PortfolioProject1.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

--If it doesn't update properly

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject1.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------------------------------------------

--Populate Property Address Data

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing a
Join PortfolioProject1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <>  b.[UniqueID ]
	where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing a
Join PortfolioProject1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <>  b.[UniqueID ]
	where a.PropertyAddress is null


---------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject1.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as address ,
Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject1.dbo.NashvilleHousing


Alter Table PortfolioProject1.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter TABLE PortfolioProject1.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject1.dbo.NashvilleHousing



Select OwnerAddress
From PortfolioProject1.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)
From PortfolioProject1.dbo.NashvilleHousing



Alter Table PortfolioProject1.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)



Alter TABLE PortfolioProject1.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)



Alter Table PortfolioProject1.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)




Select *
From PortfolioProject1.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(soldasvacant), count(soldasvacant)
from PortfolioProject1.dbo.NashvilleHousing
group by soldasvacant
order by 2




Select soldasvacant
, CASE When soldasvacant = 'Y' THEN 'Yes'
       When soldasvacant = 'N' THEN 'No'
	   ELSE soldasvacant
	   END
From PortfolioProject1.dbo.NashvilleHousing


Update PortfolioProject1.dbo.NashvilleHousing
SET soldasvacant = CASE When soldasvacant = 'Y' THEN 'Yes'
	When soldasvacant = 'N' THEN 'No'
	ELSE soldasvacant
	END





------------------------------------------------------------------------------------------------------------------------------


--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject1.dbo.NashvilleHousing
--order by parcelid
)
Select *
From RowNumCTE
Where row_num > 1
--Order by propertyaddress


Select *
From PortfolioProject1.dbo.NashvilleHousing




-----------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns



Select *
From PortfolioProject1.dbo.NashvilleHousing


ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress, SaleDate