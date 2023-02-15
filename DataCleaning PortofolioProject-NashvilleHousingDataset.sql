
-------------Data Cleaning Nashville Housing Dataset
Select *
from DataCleaningPortofolioProject..DCHousing


----------------------------Date---------------------------------------
--View the Date and Change Date Format
Select SaleDate, CONVERT(Date,SaleDate) as DateFormat
from DataCleaningPortofolioProject..DCHousing

-----Update Date Column 
Update DCHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE DCHousing
Add SaleDateConverted Date;

Update DCHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate) as DateFormat
from DataCleaningPortofolioProject..DCHousing



-----------------------------------Property Address------------------------------

Select PropertyAddress
from DataCleaningPortofolioProject..DCHousing

Select *
from DataCleaningPortofolioProject..DCHousing
order by ParcelID


-----Remove the Null Property Address
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from DataCleaningPortofolioProject..DCHousing a
JOIN DataCleaningPortofolioProject..DCHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from DataCleaningPortofolioProject..DCHousing a
JOIN DataCleaningPortofolioProject..DCHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from DataCleaningPortofolioProject..DCHousing a
JOIN DataCleaningPortofolioProject..DCHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

-----Check the Update (the Null PropertyAddress)
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from DataCleaningPortofolioProject..DCHousing a
JOIN DataCleaningPortofolioProject..DCHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null


-----Separate Property Address for more Detail by Each Column
Select PropertyAddress 
from DataCleaningPortofolioProject..DCHousing

Select 
PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2),
PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)
from DataCleaningPortofolioProject..DCHousing

ALTER TABLE DCHousing
Add PropertyAddressStreet nvarchar(255);

Update DCHousing
SET PropertyAddressStreet = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)

ALTER TABLE DCHousing
Add PropertyCity nvarchar(255);

Update DCHousing
SET PropertyCity = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)


-----Check PropertyAddress Separation Details
Select * 
from DataCleaningPortofolioProject..DCHousing


-----Separate Owner Address for more Detail by Each Column
Select OwnerAddress 
from DataCleaningPortofolioProject..DCHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from DataCleaningPortofolioProject..DCHousing

ALTER TABLE DCHousing
Add OwnerAddressStreet nvarchar(255);

Update DCHousing
SET OwnerAddressStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE DCHousing
Add OwnerAddressCity nvarchar(255);

Update DCHousing
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE DCHousing
Add OwnerAddressState nvarchar(255);

Update DCHousing
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-----Check OwnerAddress Separation Details
Select * 
from DataCleaningPortofolioProject..DCHousing


--------------------------------------------SoldAsVacant-------------------------------------

-----Change the Yes and No SoldAsVacant
Select Distinct (SoldAsVacant), Count (SoldAsVacant) as Amount
from DataCleaningPortofolioProject..DCHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE
When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
from DataCleaningPortofolioProject..DCHousing

-----Update SoldAsVacant Column 
UPDATE DCHousing
SET SoldAsVacant = 
CASE
When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

-----Check the Updates
Select Distinct (SoldAsVacant), Count (SoldAsVacant) as Amount
from DataCleaningPortofolioProject..DCHousing
Group by SoldAsVacant
Order by 2

Select * 
from DataCleaningPortofolioProject..DCHousing


---------------------------------------Removing--------------------------
Select * 
from DataCleaningPortofolioProject..DCHousing

-----View the Doubles
Select*,
ROW_NUMBER() OVER (
PARTITION BY
ParcelID, 
PropertyAddress,
Saledate,
SalePrice,
LegalReference
ORDER BY UniqueID) 
row_num
from DataCleaningPortofolioProject..DCHousing


WITH RowNumCTE as (
Select*,
ROW_NUMBER() OVER (
PARTITION BY
ParcelID, 
PropertyAddress,
Saledate,
SalePrice,
LegalReference
ORDER BY UniqueID) 
row_num
from DataCleaningPortofolioProject..DCHousing)

Select *
from RowNumCTE
Where row_num >1
Order By PropertyAddress


-----Remove the Doubles 
WITH RowNumCTE as (
Select*,
ROW_NUMBER() OVER (
PARTITION BY
ParcelID, 
PropertyAddress,
Saledate,
SalePrice,
LegalReference
ORDER BY UniqueID) 
row_num
from DataCleaningPortofolioProject..DCHousing)

DELETE
from RowNumCTE
Where row_num >1


-----Check
WITH RowNumCTE as (
Select*,
ROW_NUMBER() OVER (
PARTITION BY
ParcelID, 
PropertyAddress,
Saledate,
SalePrice,
LegalReference
ORDER BY UniqueID) 
row_num
from DataCleaningPortofolioProject..DCHousing)

Select*
from RowNumCTE
Where row_num > 1


-------------------------Delete Unused Column--------------------------------
Select *
from DataCleaningPortofolioProject..DCHousing

ALTER TABLE DataCleaningPortofolioProject..DCHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress

-----Check
Select *
from DataCleaningPortofolioProject..DCHousing