/*

Cleaning Data in SQL

*/


 SELECT *
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property ADDress data

 SELECT *
FROM  NashvilleHousing
--WHERE PropertyADDress is null
order by ParcelID



 SELECT a.ParcelID, a.PropertyADDress, b.ParcelID, b.PropertyADDress, ISNULL(a.PropertyADDress,b.PropertyADDress)
FROM  NashvilleHousing a
JOIN  NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyADDress is null


Update a
SET PropertyADDress = ISNULL(a.PropertyADDress,b.PropertyADDress)
FROM  NashvilleHousing a
JOIN  NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyADDress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out ADDress into Individual Columns (ADDress, City, State)


 SELECT PropertyADDress
FROM  NashvilleHousing
--WHERE PropertyADDress is null
--order by ParcelID

 SELECT
SUBSTRING(PropertyADDress, 1, CHARINDEX(',', PropertyADDress) -1 ) as ADDress
, SUBSTRING(PropertyADDress, CHARINDEX(',', PropertyADDress) + 1 , LEN(PropertyADDress)) as ADDress

FROM  NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitADDress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitADDress = SUBSTRING(PropertyADDress, 1, CHARINDEX(',', PropertyADDress) -1 )


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyADDress, CHARINDEX(',', PropertyADDress) + 1 , LEN(PropertyADDress))




 SELECT *
FROM  NashvilleHousing





 SELECT OwnerADDress
FROM  NashvilleHousing


 SELECT
PARSENAME(REPLACE(OwnerADDress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerADDress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerADDress, ',', '.') , 1)
FROM  NashvilleHousing



ALTER TABLE NashvilleHousing
ADD OwnerSplitADDress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitADDress = PARSENAME(REPLACE(OwnerADDress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerADDress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerADDress, ',', '.') , 1)



 SELECT *
FROM  NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


 SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM  NashvilleHousing
Group by SoldAsVacant
order by 2




 SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM  NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
 SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyADDress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM  NashvilleHousing
--order by ParcelID
)
 SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyADDress



 SELECT *
FROM  NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



 SELECT *
FROM  NashvilleHousing


ALTER TABLE  NashvilleHousing
DROP COLUMN OwnerADDress, TaxDistrict, PropertyADDress, SaleDate