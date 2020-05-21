DROP DATABASE IF EXISTS similar_properties;
CREATE DATABASE similar_properties;

USE similar_properties;

-- This will represent the cities presented for a recommended home
CREATE TABLE LOCATION (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  location NOT NULL VARCHAR(25)
);

CREATE TABLE PROPERTY (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  rating NOT NULL DECIMAL(3,2) UNSIGNED,
  property_type NOT NULL VARCHAR(25),
  bed_num NOT NULL TINYINT UNSIGNED,
  description NOT NULL VARCHAR(255),
  price_per_night NOT NULL SMALLINT UNSIGNED,
  awsBlockUrl NOT NULL VARCHAR(255),

  location_id INT NOT NULL
  CONSTRAINT fk_location_id FOREIGN KEY (location_id) REFERENCES location(id)
);

-- Research S3 / Cloudflare

-- GET /properties/:id/similarHomes

-- METHODOLOGY 1:
-- PART 1 - GET THE 12 Properties
-- SELECT * FROM PROPERTY
  -- inner join LOCATION on PROPERTY.location_id=LOCATION.id
  -- WHERE location_id = (SELECT location_id from PROPERTY where id=${id})
  -- ORDER BY rating desc
  -- LIMIT 12

-- PART 2 - GET THE PICTURES FOR EACH PROPERTY
  -- Recurse through the properties until we reach the end of the array
  -- Base Case: we're at the end of the properties array
  -- During each step of recursion, query the db for the photos
  -- Assign the array of strings to the current property
  -- SELECT * FROM PHOTOS
    -- WHERE PHOTOS.property_id =${currentPropertyInRecursion.id}

-- METHODOLGY 2:
-- PART 1 - GET THE 12 PROPERTIES AND ALL OF THE PHOTOS
  -- SELECT * FROM PROPERTY
    -- inner join LOCATION on PROPERTY.location_id=LOCATION.id
    -- inner join PHOTOS on PHOTOS.property_id=PROPERTY.id
    -- WHERE location_id = (SELECT location_id from PROPERTY where id=${id})
-- PART 2 - PROCESS THE DATA RECEIVED FROM THE DB AND FORMAT FOR API RESPONSE
  -- CREATE AN OBJECT TO KEEP TRACK OF PROPERTY IDS THAT HAVE BEEN UTILIZED
  -- Create a result array
  -- Loop through MYSQL response, for each id that hasn't been entered yet, generate an object, push into resultArr
  -- Loop again through MYSQL, pushing into photo urls into the appropriate property
  -- Sort the results array by rating
  -- Slice the array to include 12 items
  -- Send back response