use portfolio;

desc housing;

-- Standardize Date Format
select SaleDate from housing;
update housing set SaleDate = STR_TO_DATE(SaleDate, "%m/%d/%Y");
alter table housing modify column SaleDate date;

-- Remove Errors from sales price ',' and '$'
select distinct (locate('$', Saleprice)) from housing;
select distinct (locate(',', Saleprice)) from housing;
-- update table
 update housing set SalePrice = replace(saleprice, ',', '');
 
 update housing set SalePrice = replace(saleprice, '$', '');

-- Change Columns from text to INT
ALTER TABLE `Portfolio`.`housing` 
CHANGE COLUMN `Acreage` `Acreage` DOUBLE NULL DEFAULT NULL ,
CHANGE COLUMN `LandValue` `LandValue` INT NULL DEFAULT NULL ,
CHANGE COLUMN `BuildingValue` `BuildingValue` INT NULL DEFAULT NULL ,
CHANGE COLUMN `TotalValue` `TotalValue` INT NULL DEFAULT NULL ,
CHANGE COLUMN `YearBuilt` `YearBuilt` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Bedrooms` `Bedrooms` INT NULL DEFAULT NULL ,
CHANGE COLUMN `FullBath` `FullBath` INT NULL DEFAULT NULL ,
CHANGE COLUMN `HalfBath` `HalfBath` INT NULL DEFAULT NULL ,
CHANGE COLUMN `SalePrice` `SalePrice` INT NULL DEFAULT NULL ;

-- Replacing empty cells with null
update housing set UniqueID = null 
where UniqueID = '';
 
update housing set ParcelID = null 
where ParcelID = '';
 
update housing set LandUse = null 
where LandUse = '';
 
update housing set PropertyAddress = null 
where PropertyAddress = ''; 


update housing set SaleDate = null 
where SaleDate = '';
 
update housing set SalePrice = null 
where SalePrice  = '';

update housing set LegalReference  = null 
where LegalReference = '';


update housing set SoldAsVacant  = null 
where SoldAsVacant = '';
 
update housing set OwnerName  = null 
where OwnerName = '';

update housing set OwnerAddress  = null 
where OwnerAddress = '';
 
update housing set Acreage = null 
where Acreage = '';
 
update housing set TaxDistrict = null 
where TaxDistrict = '';
 
 
update housing set LandValue = null 
where LandValue = '';

update housing set BuildingValue = null 
where BuildingValue = '';

update housing set TotalValue = null 
where TotalValue = '';


update housing set YearBuilt = null 
where YearBuilt = '';


update housing set Bedrooms = null 
where Bedrooms = '';


update housing set FullBath = null 
where FullBath = '';
 
update housing set HalfBath = null 
where HalfBath = '';


-- Slect the property address
select a.ParcelID, a.PropertyAddress, 
b.ParcelID, b.PropertyAddress, IFNULL(
 a.PropertyAddress, b.PropertyAddress) from housing a
join housing b on a.ParcelID = b.ParcelID 
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;


-- Create Temp table to self join and then update null values in PropertyAddress 

drop table if exists housing2;
Create TEMPORARY Table housing2
(
UniqueID INT, PropertyAddress text, ParcelID text, NIll text
);

insert into housing2
select UniqueID, PropertyAddress, ParcelID, IFNULL(
 PropertyAddress, PropertyAddress) as NILL from housing;

select *
from housing2
join housing on housing.ParcelID = housing2.ParcelID 
and housing.UniqueID <> housing2.UniqueID
where housing.PropertyAddress is null;

update housing join housing2 on housing.ParcelID = housing2.ParcelID 
and housing.UniqueID <> housing2.UniqueID
set housing.PropertyAddress = NILL
where housing.PropertyAddress is null;

-- Verify Null values were resolved 
select propertyaddress from housing
where propertyaddress is null; 


-- Seperating Address into Individual Columns looking for deliminer
select propertyaddress from housing; 

select substring(propertyaddress, 1, 
locate(',', propertyaddress) -1) as Address,


 substring(propertyaddress, 
locate(',', propertyaddress) +2, length(propertyaddress)) as Address
from housing;

-- Add Collumns where the seperated address will be inserted 
alter table housing add Property_Address text;

update housing set Property_Address = substring(propertyaddress, 1, 
locate(',', propertyaddress) -1);


alter table housing add PropertyCity text;

update housing set PropertyCity =  substring(propertyaddress, 
locate(',', propertyaddress) +1, length(propertyaddress));

select propertyaddress, property_address, PropertyCity from housing;


-- Seperate OwnerAddress into individual colums for more usable data
######
alter table housing add Owner_City_State text;

update housing set Owner_City_State = substring(owneraddress, 
locate(',', owneraddress) +2, length(owneraddress));
######
alter table housing add Owner_Address text;

update housing set Owner_Address = substring(owneraddress, 1, 
locate(',', owneraddress) -1);
--
alter table housing add OwnerCity text;

update housing set OwnerCity = substring(Owner_City_State, 1, 
locate(',', Owner_City_State) -1);

--
alter table housing add OwnerState text;

update housing set OwnerState = substring(Owner_City_State, 
locate(',', Owner_City_State) +2, length(Owner_City_State));

--
select ownerstate, ownercity, owneraddress from housing;


-- SouldAsVacant 
select distinct soldasvacant, count(soldasvacant)
 from housing
 group by soldasvacant
 order by 2;
 
 
 select soldasvacant, 
 case 
 when soldasvacant = 'Y' then 'Yes'
 when soldasvacant = 'N' then 'No'
 else soldasvacant end
 from housing;
 
 
 update housing set soldasvacant = case 
 when soldasvacant = 'Y' then 'Yes'
 when soldasvacant = 'N' then 'No'
 else soldasvacant end;
 
 
 -- Check Duplicates 
 
 select  *, row_number() over(partition by 
 ParcelID, 
 PropertyAddress, 
 SalePrice, 
 SaleDate,
 LegalReference
 order by UniqueID) as row_num 
 from housing 
 order by ParcelID;
 

 -- Create CTE to check number of duplicates 
 
 with row_numCTE as ( 
 select  *, row_number() over(partition by 
 ParcelID, 
 PropertyAddress, 
 SalePrice, 
 SaleDate,
 LegalReference
 order by UniqueID) as row_num 
 from housing)
 Select * from row_numCTE
 where row_num > 1;
 
 -- Create CTE and delete Duplicated Rows
 
  with row_numCTE as ( 
 select  *, row_number() over(partition by 
 ParcelID, 
 PropertyAddress, 
 SalePrice, 
 SaleDate,
 LegalReference
) as row_num 
 from housing)
 Delete from row_numCTE
 where row_num > 1;
 
 -- unnecessary columns 
 
select * from housing;

alter table housing drop column OwnerAddress, 
drop column TaxDistrict, 
drop column PropertyAddress;

alter table housing drop column Owner_City_State;


