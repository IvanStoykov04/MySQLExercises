CREATE DATABASE library;
USE library;

CREATE TABLE userRole(
id INT AUTO_INCREMENT PRIMARY KEY,
roleName ENUM('admin','librarian','student','teacher') NOT NULL
);

CREATE TABLE users(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
egn VARCHAR(10) NOT NULL UNIQUE,
pass VARCHAR(50) NOT NULL UNIQUE,
phone VARCHAR(10) NOT NULL UNIQUE,
email VARCHAR(20) NOT NULL UNIQUE,
userRole_id INT NOT NULL,
FOREIGN KEY (userRole_id) REFERENCES userRole(id)
);

CREATE TABLE authors(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
info VARCHAR(50) 
);

CREATE TABLE genres(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL
);


CREATE TABLE publishers(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
adress VARCHAR(50) NOT NULL
);


CREATE TABLE books(
id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(50) NOT NULL,
description VARCHAR(50) NOT NULL,
publisher_id INT NOT NULL,
FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);

CREATE TABLE bookGenre(
id INT AUTO_INCREMENT PRIMARY KEY,
genre_id INT NOT NULL,
books_id INT NOT NULL,
FOREIGN KEY (genre_id) REFERENCES genres (id),
FOREIGN KEY (books_id) REFERENCES books (id)
);

CREATE TABLE authorBook(
id INT AUTO_INCREMENT PRIMARY KEY,
book_id INT NOT NULL,
authors_id INT NOT NULL,
FOREIGN KEY (book_id) REFERENCES books (id),
FOREIGN KEY (authors_id) REFERENCES authors (id)
);

CREATE TABLE loanBooks(
id INT AUTO_INCREMENT PRIMARY KEY,
date DATETIME NOT NULL DEFAULT NOW(),
books_id INT NOT NULL,
user_id INT NOT NULL,
FOREIGN KEY (books_id) REFERENCES books(id),
FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE VIEW bookViewFinalVersion AS
SELECT books.title,books.description,authors.name as authorsName,genres.name As genresName,publishers.name As publishersName
FROM books 
JOIN authors 
ON books.id IN(
SELECT book_id FROM authorBook
WHERE authors_id =authors.id)
JOIN genres
ON books.id IN(
SELECT books_id FROM bookGenre
WHERE genre_id =genres.id)
JOIN publishers 
ON publishers.id =publisher_id;




SELECT books.title, publishers.name
FROM books 
LEFT JOIN publishers
ON publisher_id=publishers.id
UNION
SELECT books.title, publishers.name
FROM books
RIGHT JOIN publishers
ON publisher_id=publishers.id;




SELECT books.title, authors.name
FROM books JOIN authors
ON books.id IN(
SELECT book_id FROM authorBook
WHERE authors_id =authors.id)
GROUP BY authors.name,books.title
HAVING COUNT(authors.id)>=2
ORDER BY books.title;








SELECT users.name AS student_name, users.phone AS phone_number, users.email AS email_address, COUNT(*) AS books_taken
FROM users
JOIN loanBooks ON users.id = loanBooks.user_id
JOIN books ON loanBooks.books_id = books.id
JOIN publishers ON books.publisher_id = publishers.id
WHERE users.userRole_id = (SELECT id FROM userRole WHERE roleName = 'student')
    AND publishers.name = 'ТУ София'
GROUP BY users.id
HAVING COUNT(*) > 5;



