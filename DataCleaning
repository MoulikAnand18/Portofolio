--Cleaning Data in SQL

SELECT * FROM housing


--Standardize Date Format


ALTER  TABLE housing
Add SaleDates Date;

Update housing 
SET SaleDates = CONVERT(Date,SaleDate)


--Populate Property Address Data

SELECT *
From housing
--WHERE PropertyAddress is NULL
order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM housing a
JOIN housing b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM housing a
JOIN housing b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL




--Breaking out Address into individual columns(address,city,state)

SELECT PropertyAddress
FROM housing

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) AS City
From  housing

ALTER TABLE housing
ADD SplitAddress Nvarchar(255)

Update housing
SET SplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)



ALTER TABLE housing
ADD City Nvarchar(225)

Update housing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))



SELECT OwnerAddress
FROM housing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM housing


ALTER TABLE housing
ADD OwnerSplitAddress Nvarchar(255)

Update housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)



ALTER TABLE housing
ADD OwnerSplitCity Nvarchar(225)

Update housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE housing
ADD  OwnerSplitState Nvarchar(255)

Update housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


--Change Y or N to Yes or No in "Sold as Vacant" column

SELECT Distinct(SoldAsVacant),Count(SoldAsVacant)
FROM housing
Group by SoldAsVacant
Order by 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM housing

UPDATE housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




--REMOVING DUPLICATES
WITH RownNumCTE as (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			     UniqueID
				 ) row_num
FROM housing
)
SELECT *
FROM RownNumCTE
WHERE row_num>1
--ORDER BY PropertyAddress


--DELETE UNUSED COLUMNS


ALTER TABLE housing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE housing
DROP COLUMN SaleDate



