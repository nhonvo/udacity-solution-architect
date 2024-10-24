CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),
       species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);

INSERT INTO pet (name, owner, species, sex, birth, death)
VALUES 
    ('Fluffy1', 'Harold', 'Dog', 'M', '2012-06-15', NULL),
    ('Whiskers1', 'Susan', 'Cat', 'F', '2018-09-22', NULL),
    ('Tweety1', 'Jim', 'Bird', 'F', '2015-04-03', '2023-05-12');

SELECT * FROM pet;