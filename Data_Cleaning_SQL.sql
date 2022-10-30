/****** Script for SelectTopNRows command from SSMS  ******/
Select *
FROM Data_Cleaning_SQL.dbo.Housing_data

Select saleDateConverted, CONVERT(Date,SaleDate)
From Data_Cleaning_SQL.dbo.Housing_data

Update Housing_data
SET SaleDate =CONVERT(Date,SaleDate)

ALTER TABLE Housing_data
Add SaleDateConverted Date;

Update Housing_data
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address data

Select *
From Housing_data
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing_data a
JOIN Housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing_data a
JOIN Housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Housing_data


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From Housing_data

ALTER TABLE Housing_data
Add PropertySplitAddress Nvarchar(255);

Update Housing_data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Housing_data
Add PropertySplitCity Nvarchar(255);

Update Housing_data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From Data_Cleaning_SQL.dbo.Housing_data

Select OwnerAddress
From Data_Cleaning_SQL.dbo.Housing_data

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Data_Cleaning_SQL.dbo.Housing_data


ALTER TABLE Housing_data
Add OwnerSplitAddress Nvarchar(255);


Update Housing_data
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Housing_data
Add OwnerSplitCity Nvarchar(255);

Update Housing_data
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Housing_data
Add OwnerSplitState Nvarchar(255);

Update Housing_data
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From Data_Cleaning_SQL.dbo.Housing_data

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Data_Cleaning_SQL.dbo.Housing_data
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Data_Cleaning_SQL.dbo.Housing_data


Update Housing_data
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates

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

From Data_Cleaning_SQL.dbo.Housing_data

--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From Data_Cleaning_SQL.dbo.Housing_data

-- Delete Unused Columns



Select *
From Data_Cleaning_SQL.dbo.Housing_data

ALTER TABLE Data_Cleaning_SQL.dbo.Housing_data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From Data_Cleaning_SQL.dbo.Housing_data