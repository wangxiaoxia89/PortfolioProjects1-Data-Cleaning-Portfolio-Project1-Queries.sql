
/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject1.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDate
From PortfolioProject1.dbo.NashvilleHousing


Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject1.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-- If it doesn't Update properly， let's do it this way

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select PropertyAddress
From PortfolioProject1.dbo.NashvilleHousing
where PropertyAddress is null

---Now Let's look at everything 

Select *
From PortfolioProject1.dbo.NashvilleHousing
where PropertyAddress is null

Select *
From PortfolioProject1.dbo.NashvilleHousing
---where PropertyAddress is null
order by ParcelID


Select a. ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


--- let's check where there is null 

Select a. ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET propertyAddress = ISNULL( a.PropertyAddress,b.PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject1.dbo.NashvilleHousing
---where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address

From PortfolioProject1.dbo.NashvilleHousing


----we can change the comma at the end of every address as well 

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
 CHARINDEX(',', PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing

---However , we can add - 1 to the charindex and the comma will be gone 

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1) as Address,
 CHARINDEX(',', PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing


-- we can also start from where the character is to get ride of the comma eg.,
---Note we can't seperate two values from one culumn without creating two other colunms

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress ) +1 , LEN(PropertyAddress)) as Address
From PortfolioProject1.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
Add ProperSplitAddress Nvarchar(255);

Update NashvilleHousing
SET ProperSplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1)



ALTER TABLE NashvilleHousing
Add ProperSplitCity Nvarchar(255);

Update NashvilleHousing
SET ProperSplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress ) +1 , LEN(PropertyAddress))


Select *
From PortfolioProject1.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProject1.dbo.NashvilleHousing

---using parsename

Select
PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)
From PortfolioProject1.dbo.NashvilleHousing

---- Lets go 3,2,1 and run

Select
PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
From PortfolioProject1.dbo.NashvilleHousing





ALTER TABLE NashvilleHousing
Add OwnerSplitAddress  Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)



ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)


Select *
From PortfolioProject1.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


--change Y and N to Yes and No in " Sold as Vacant" feild 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject1.dbo.NashvilleHousing
GRoup BY SoldAsVacant
Order by 2




Select SoldAsVacant
, CASE When SoldAsVacant ='Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
 From PortfolioProject1.dbo.NashvilleHousing



 ----lETS UPDATE
 Update NashvilleHousing
 SET SoldAsVacant = CASE When SoldAsVacant ='Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
 From PortfolioProject1.dbo.NashvilleHousing




 -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

---lETS write  A CTE


WITH RowNumCTE AS(
Select  *,
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
 --order by ParcelID
 )
 Select  *
 From RowNumCTE
Where row_num > 1
order by PropertyAddress



 Select  *
  From PortfolioProject1.dbo.NashvilleHousing



  ---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



 Select  *
  From PortfolioProject1.dbo.NashvilleHousing


 ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

