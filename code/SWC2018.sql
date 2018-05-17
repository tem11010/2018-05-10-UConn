---------- Selecting Data ----------


-- Select 2 columns from Person table
SELECT personal, family FROM Person;

-- SQL is case insensitive
-- By convention, we use SQL keywords in all caps
select PerSOnal, family fROm Person;


-- Select all fields (* is a wildcard for all)
SELECT * FROM Person;

-- Fields can be selected in any order, even multiple times
SELECT id, id, family, personal FROM Person;


---------- Sorting ----------


-- Order by a column (ID)
SELECT * FROM Person ORDER BY id;

-- Order by two columns, first descending, second ascending
-- NOTE: Better to always specify ASC (the default)
SELECT * FROM Person ORDER BY id DESC, personal ASC;


---------- Filtering ----------


-- Only select data where the site is DR-1
SELECT * FROM Visited WHERE site = 'DR-1';

-- The WHERE clause (filter) can have multiple things
SELECT * FROM Visited WHERE site = 'DR-1' AND dated < '1930-01-01';

-- Order of operations matters: 
-- Need parentheses here to pick salinity measurements by either lake or roe 
SELECT * FROM Survey WHERE quant = 'sal' AND (person = 'lake' OR person = 'roe');


---------- Combining Data from Multiple Tables ----------


-- Joining two tables
-- Combines rows where Site.name is the same as Visited.site
-- Here, Site.name is a "primary key" in the sites table (unique)
-- Visited.site is a "foreign key", because it refers to another table (Site)
SELECT * FROM Site JOIN Visited ON Site.name = Visited.site;

-- We need latitude, longitude, date, quant, reading
-- This requires joining three tables together
-- We can specify specific fields using Table.field notation
SELECT Site.lat, Site.long, Visited.dated, Survey.quant, Survey.reading
FROM Site JOIN Visited JOIN Survey
ON Site.name = Visited.Site
AND Visited.id = Survey.taken;


---------- Creating Tables ----------


-- This drops a table
-- CAREFUL: there is no backup!
DROP TABLE Site;

-- Check to see if it is gone
SELECT * FROM Site;

-- Here's how we recreate a table
-- Note that each field name gets a specific data type (text, real, integer)
CREATE TABLE Site (name text, lat real, long real);


---------- Inserting Data ----------


-- The following inserts 3 records in the sites table
-- Note: This must have the same number of values as there are fields
-- Generally, the values should be the correct datatype too, or the database may store empty cells
INSERT INTO Site VALUES('DR-1', -49.85, -128.42);
INSERT INTO Site VALUES('DR-3', -47.15, -126.72);
INSERT INTO Site VALUES('MSK-4', -48.87, -123.40);


---------- Updating Data ----------


-- Update a pre-existing row (or rows).  
-- This will change any rows that match the WHERE clause
-- CAREFUL: there is no backup!
UPDATE Site SET lat = -47.87, long = -122.4 WHERE name = 'MSK-4';

-- To be safe, it's good form to use a SELECT query with the same where clause first before updating
-- That way, you can make sure you're updating exactly what you want to
SELECT * FROM Site WHERE name = 'MSK-4';


---------- Deleting Data ----------


-- Delete a record
-- CAREFUL: there is no backup!
-- The same applies as for UPDATE: test your WHERE clause first
DELETE FROM Site WHERE long = -128.42;
