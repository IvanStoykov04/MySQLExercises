DROP DATABASE IF EXISTS theater;
CREATE DATABASE theater;
USE theater;

CREATE TABLE theater(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
city VARCHAR(100) NOT NULL,
UNIQUE(name,city)
);

CREATE TABLE screen(
id INT NOT NULL,
type ENUM('normal','deluxe','VIP') NOT NULL,
theater_id INT NOT NULL,
FOREIGN KEY (theater_id) REFERENCES theater(id),
PRIMARY KEY(id,theater_id)
);

CREATE TABLE movie(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
year YEAR NOT NULL,
country VARCHAR(100) NOT NULL
);



CREATE TABLE projection(
time DATETIME NOT NULL,
countVisitor INT UNSIGNED NOT NULL,
movie_id INT NOT NULL,
screen_id INT NOT NULL,
theater_id INT NOT NULL,
FOREIGN KEY (movie_id) REFERENCES movie(id),
FOREIGN KEY (screen_id,theater_id) REFERENCES screen(id,theater_id),
PRIMARY KEY(time,screen_id,theater_id)
);

INSERT INTO theater(name,city)
VALUES('Arena Sofia','Sofia'),('Kino arena The Mall','Sofia'),('Kino arena Paradise Mall','Sofia'),('Arena Plovdiv','Plovdiv');

INSERT INTO movie(name,year,country)
VALUES('Fast and furious 7',2,'USA'),('Wildlings',1,'Bulgaria'),('Downfall',4,'Germany'),('The boogyeman',1,'USA');

INSERT INTO screen(id,type,theater_id)
VALUES(2,'normal',1),(5,'VIP',2),(6,'deluxe',3);

INSERT INTO projection(time,countVisitor,movie_id,screen_id,theater_id)
VALUES('2024-02-03 15:30:00',34,1,2,1),('2025-05-19 20:00:00',22,2,6,3),('2025-09-08 22:30:00',45,4,5,2);

INSERT INTO projection(time,countVisitor,movie_id,screen_id,theater_id)
VALUES('2025-02-03 15:30:00',15,1,5,2);

INSERT INTO projection(time,countVisitor,movie_id,screen_id,theater_id)
VALUES('2023-10-03 12:30:00',66,1,5,2);


-- some requests


SELECT  theater.name, screen.id, projection.time
FROM theater JOIN screen
ON theater.id=screen.theater_id
JOIN projection
ON (screen.id,screen.theater_id)=(projection.screen_id,projection.theater_id)
WHERE screen.type IN ('deluxe','VIP') AND projection.movie_id IN (
SELECT movie.id 
FROM movie
WHERE name='Fast and Furious 7')
ORDER BY theater.name, screen.id;


SELECT SUM(countVisitor)
FROM projection 
WHERE (screen_id,theater_id) IN(
SELECT screen.id,theater_id
FROM screen
WHERE type='VIP'
AND theater_id IN (
SELECT theater.id
FROM theater
WHERE name='Kino arena The Mall'))
AND movie_id IN (
SELECT movie.id
FROM movie
WHERE name='Fast and furious'
);












