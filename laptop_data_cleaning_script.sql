DROP DATABASE IF EXISTS sql_project;

CREATE DATABASE IF NOT EXISTS sql_project;

USE sql_project;

SELECT * FROM laptopdata;

ALTER TABLE laptopdata RENAME laptops;

CREATE TABLE laptops_backup LIKE laptops;

INSERT INTO laptops_backup 
SELECT * FROM laptops;

-- To check details about your data 
SELECT * FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sql_project'
AND TABLE_NAME = 'laptops';

-- To check how much memory your data is occupying in Kb i.e. by default it shows memory occupied in bytes.
SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sql_project'
AND TABLE_NAME = 'laptops';

-- to get all column names that are present in our data
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'sql_project'
  AND TABLE_NAME = 'laptops';
  
  
-- to delete unnecessary columns [note: `(tilt) is used because we have space in the column name
ALTER TABLE laptops DROP COLUMN `Unnamed: 0`;

SELECT * FROM laptops;

-- to drop all rows where all column values are null
DELETE FROM laptops
WHERE Company IS NULL 
AND TypeName IS NULL
AND Inches IS NULL
AND ScreenResolution IS NULL
AND Cpu IS NULL
AND Ram IS NULL
AND Memory IS NULL
AND Gpu IS NULL
AND OpSys IS NULL
AND Weight IS NULL
AND Price IS NULL;

SELECT * FROM laptops;

SELECT DISTINCT Company FROM laptops; -- All values are correct so no need to change anything
SELECT DISTINCT TypeName FROM laptops; -- All values are correct so no need to change anything

-- Convert the datatype of `Inches` column from text to decimal
ALTER TABLE laptops MODIFY COLUMN Inches DECIMAL(10,1);
SELECT * FROM laptops;

-- Extract numerical value from `Ram` column and making it an integer
SELECT Ram, REPLACE(Ram,'GB',"") FROM laptops; -- to check before changing anything

UPDATE laptops
SET Ram = REPLACE(Ram,'GB',""); -- to remove the string 'GB'

ALTER TABLE laptops MODIFY COLUMN Ram INTEGER(5); -- Convert the datatype of `Ram` column from text to integer

SELECT DISTINCT Ram FROM laptops; -- to check the changed values

-- Applying same method on `Weight` Column
SELECT Weight, REPLACE(Weight,'kg',"") FROM laptops; -- to check before changing anything

UPDATE laptops
SET Weight = REPLACE(Weight,'kg',""); -- to remove the string 'kg'

ALTER TABLE laptops MODIFY COLUMN Weight DECIMAL(10,1); -- Convert the datatype of `Weight` column from text to decimal

/*The above code was throwing an error so therefore in order to check why it is throwing error
I tried to find the non numeric value in the column */
SELECT Weight FROM laptops
WHERE Weight REGEXP '[^0-9.]' OR Weight = ''; 

DELETE FROM laptops
WHERE weight = '?';

ALTER TABLE laptops MODIFY COLUMN Weight DECIMAL(10,2); -- Now ran this code again to convert the datatype of `Weight` column from text to decimal

SELECT DISTINCT Weight FROM laptops; -- to check the changed values

-- to Round Off the value of `Price` column
SELECT Price, ROUND(Price,0) from laptops; -- to check before changing anything

UPDATE laptops 
SET Price = ROUND(Price,0); -- to update the value

SELECT Price from laptops; -- to check the changed values

-- to create new categories for `OpSys` column.
SELECT DISTINCT OpSys FROM laptops; -- to see all available values

/* Let's create categories like:
windows : will contain all OS of windows
mac : will contain macOS
linux : will contain Linux OS
N/A : for 'No OS' values
other : will contain remaining values*/


SELECT OpSys, 
	   CASE 
		   WHEN LOWER(OpSys) LIKE 'windows%' THEN 'windows'
		   WHEN LOWER(OpSys) LIKE 'mac%' THEN 'mac'
		   WHEN LOWER(OpSys) LIKE 'linux' THEN 'linux'
		   WHEN LOWER(OpSys) LIKE 'no os' THEN 'N/A'
		   ELSE 'other'
       END AS OS
FROM laptops; -- to check before changing anything

UPDATE laptops
SET OpSys = CASE 
			   WHEN LOWER(OpSys) LIKE 'windows%' THEN 'windows'
			   WHEN LOWER(OpSys) LIKE 'mac%' THEN 'mac'
			   WHEN LOWER(OpSys) LIKE 'linux' THEN 'linux'
			   WHEN LOWER(OpSys) LIKE 'no os' THEN 'N/A'
			   ELSE 'other'
			END; -- to update the value

SELECT DISTINCT OpSys from laptops; -- to check the changed values

-- To create 1 new columns `gpu_brand` using `Gpu` column
ALTER TABLE laptops
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu;

SELECT * FROM laptops;

-- to add values in `gpu_brand` column
SELECT DISTINCT Gpu FROM laptops; -- to see all available values

SELECT Gpu, SUBSTRING_INDEX(Gpu," ",1) FROM laptops; -- to check before changing anything

UPDATE laptops
SET gpu_brand = SUBSTRING_INDEX(Gpu," ",1); -- to add the values

SELECT DISTINCT gpu_brand FROM laptops; -- to check the added values

-- now drop `Gpu` column
ALTER TABLE laptops DROP COLUMN Gpu;

-- To create 3 new columns `cpu_brand`,`cpu_name` and `cpu_speed` using `Cpu` column
ALTER TABLE laptops
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,2) AFTER cpu_name;

SELECT * FROM laptops;

-- to add values in `cpu_brand` column
SELECT DISTINCT Cpu FROM laptops;-- to see all available values
 
SELECT Cpu, SUBSTRING_INDEX(Cpu," ",1) FROM laptops;-- to check before changing anything

UPDATE laptops
SET cpu_brand = SUBSTRING_INDEX(Cpu," ",1); -- to add the values

SELECT DISTINCT cpu_brand FROM laptops; -- to check the added values

-- to add values in `cpu_speed` column
 
SELECT Cpu, REPLACE(SUBSTRING_INDEX(Cpu," ",-1),"GHz","") FROM laptops;-- to check before changing anything

UPDATE laptops
SET cpu_speed = REPLACE(SUBSTRING_INDEX(Cpu," ",-1),"GHz",""); -- to add the values

SELECT DISTINCT cpu_speed FROM laptops; -- to check the added values

-- to add values in `cpu_name` column
 
SELECT 
	Cpu, 
    REPLACE(SUBSTRING_INDEX(Cpu," ",3),cpu_brand,"")
FROM 
	laptops;-- to check before changing anything

UPDATE 
	laptops
SET 
	cpu_name = REPLACE(SUBSTRING_INDEX(Cpu," ",3),cpu_brand,""); -- to add the values

SELECT DISTINCT cpu_name FROM laptops; -- to check the added values

-- now drop `Cpu` column
ALTER TABLE laptops DROP COLUMN Cpu;

SELECT * FROM laptops;

-- To create 3 new columns `screen_height`, `screen_width` and `touchscreen` using `ScreenResolution` column

ALTER TABLE laptops 
ADD COLUMN resolution_height INTEGER(10) AFTER ScreenResolution,
ADD COLUMN resolution_width INTEGER(10) AFTER resolution_height,
ADD COLUMN touchscreen INTEGER(10) AFTER resolution_width,
ADD COLUMN ips_display INTEGER(10) AFTER resolution_width;

SELECT * FROM laptops;

-- to add values in `ScreenResolution` column
SELECT 
	DISTINCT ScreenResolution, 
    SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution," ",-1),"x",1), -- to get value before "x"
    SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution," ",-1),"x",-1)  -- to get value after "x"
FROM 
	laptops; -- to check values before adding them


UPDATE laptops
SET resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution," ",-1),"x",1);

UPDATE laptops
SET resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution," ",-1),"x",-1);

SELECT resolution_height, resolution_width FROM laptops;


SELECT 
	ScreenResolution, LOWER(ScreenResolution) LIKE "%touchscreen%"
FROM laptops;

UPDATE laptops
SET touchscreen = LOWER(ScreenResolution) LIKE "%touchscreen%";

SELECT * FROM laptops;

SELECT 
	ScreenResolution, LOWER(ScreenResolution) LIKE "%ips%"
FROM laptops;

UPDATE laptops
SET ips_display = LOWER(ScreenResolution) LIKE "%ips%";

SELECT * FROM laptops;

ALTER TABLE laptops
DROP COLUMN ScreenResolution;

SELECT * FROM laptops;

-- To create 3 new columns `memory_type`, `primary_storage` and `secondary_storage` using `Memory` column

ALTER TABLE laptops
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage VARCHAR(255) AFTER memory_type,
ADD COLUMN secondary_storage VARCHAR(255) AFTER primary_storage;

SELECT 
	DISTINCT Memory, 
    CASE
		WHEN LOWER(Memory) LIKE '%ssd%' AND LOWER(Memory) LIKE '%hdd%' THEN 'hybrid'
        WHEN LOWER(Memory) LIKE '%ssd%' AND LOWER(Memory) LIKE '%flash%' THEN 'hybrid'
        WHEN LOWER(Memory) LIKE '%flash%' AND LOWER(Memory) LIKE '%hdd%' THEN 'hybrid'
        WHEN LOWER(Memory) LIKE '%hybrid%' THEN 'hybrid'
		WHEN LOWER(Memory) LIKE '%ssd%' THEN 'ssd'
		WHEN LOWER(Memory) LIKE '%hdd%' THEN 'hdd'
		WHEN LOWER(Memory) LIKE '%flash%' THEN 'flash_storage'
		
		ELSE NULL
	END AS memory_type,
    CASE
		WHEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory," ",1),"[0-9]+") IS NULL THEN 0 -- if the storage is NULL then make the value as 0
        WHEN SUBSTRING_INDEX(Memory," ",1) LIKE "%TB%" THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory," ",1),"[0-9]+")*1024 -- if "TB" is present in the text data then multiply it by 1024 to convert it into "GB"
        ELSE REGEXP_SUBSTR(SUBSTRING_INDEX(Memory," ",1),"[0-9]+") -- to extract all the digits from text
	END AS primary_storage,
    CASE
		WHEN REGEXP_SUBSTR(REPLACE(Memory,SUBSTRING_INDEX(Memory,"+",1),""),"[0-9]+") IS NULL THEN 0 -- if the storage is NULL then make the value as 0
		WHEN REPLACE(Memory,SUBSTRING_INDEX(Memory,"+",1),"") LIKE "%TB%" THEN REGEXP_SUBSTR(REPLACE(Memory,SUBSTRING_INDEX(Memory,"+",1),""),"[0-9]+")*1024 -- if "TB" is present in the text data then multiply it by 1024 to convert it into "GB"
        ELSE REGEXP_SUBSTR(REPLACE(Memory,SUBSTRING_INDEX(Memory,"+",1),""),"[0-9]+") -- to extract all the digits from text
	END AS secondary_storage
FROM 
	laptops;
    
UPDATE laptops
SET memory_type = CASE
					WHEN LOWER(Memory) LIKE '%ssd%' AND LOWER(Memory) LIKE '%hdd%' THEN 'hybrid'
					WHEN LOWER(Memory) LIKE '%ssd%' AND LOWER(Memory) LIKE '%flash%' THEN 'hybrid'
					WHEN LOWER(Memory) LIKE '%flash%' AND LOWER(Memory) LIKE '%hdd%' THEN 'hybrid'
					WHEN LOWER(Memory) LIKE '%hybrid%' THEN 'hybrid'
					WHEN LOWER(Memory) LIKE '%ssd%' THEN 'ssd'
					WHEN LOWER(Memory) LIKE '%hdd%' THEN 'hdd'
					WHEN LOWER(Memory) LIKE '%flash%' THEN 'flash_storage'
					ELSE NULL
				  END; -- to add the values

SELECT DISTINCT memory_type FROM laptops;

UPDATE laptops
SET primary_storage = CASE
						WHEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory," ",1),"[0-9]+") IS NULL THEN 0 -- if the storage is NULL then make the value as 0
						WHEN SUBSTRING_INDEX(Memory," ",1) LIKE "%TB%" THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory," ",1),"[0-9]+")*1024 -- if "TB" is present in the text data then multiply it by 1024 to convert it into "GB"
						ELSE REGEXP_SUBSTR(SUBSTRING_INDEX(Memory," ",1),"[0-9]+") -- to extract all the digits from text
					  END; -- to add the values
	
SELECT DISTINCT primary_storage FROM laptops;

UPDATE laptops
SET secondary_storage = CASE
							WHEN REGEXP_SUBSTR(REPLACE(Memory,SUBSTRING_INDEX(Memory,"+",1),""),"[0-9]+") IS NULL THEN 0 -- if the storage is NULL then make the value as 0
							WHEN REPLACE(Memory,SUBSTRING_INDEX(Memory,"+",1),"") LIKE "%TB%" THEN REGEXP_SUBSTR(REPLACE(Memory,SUBSTRING_INDEX(Memory,"+",1),""),"[0-9]+")*1024 -- if "TB" is present in the text data then multiply it by 1024 to convert it into "GB"
							ELSE REGEXP_SUBSTR(REPLACE(Memory,SUBSTRING_INDEX(Memory,"+",1),""),"[0-9]+") -- to extract all the digits from text
						END; -- to add the values

SELECT DISTINCT secondary_storage FROM laptops;

ALTER TABLE laptops DROP COLUMN Memory;

SELECT * FROM laptops;

                        