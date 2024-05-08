CREATE DATABASE test;
USE test;
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    position VARCHAR(255)
);

CREATE TABLE salarypayments (
    id INT PRIMARY KEY,
    employee_id INT,
    salaryAmount DECIMAL(10, 2),
    montlyBonus DECIMAL(10, 2),
    yearOfPayment INT,
    monthOfPayment INT,
    dateOfPayment DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE deals (
    id INT PRIMARY KEY,
    dealDate DATE,
    paymentTime TIME,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE adds (
    id INT PRIMARY KEY,
    publicationDate DATE,
    isActual BOOLEAN,
    property_id INT,
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

CREATE TABLE ads_actions (
    ad_id INT,
    action_id INT,
    PRIMARY KEY (ad_id, action_id),
    FOREIGN KEY (ad_id) REFERENCES adds(id),
    FOREIGN KEY (action_id) REFERENCES actions(id)
);

CREATE TABLE properties (
    id INT PRIMARY KEY,
    area DECIMAL(10, 2),
    price DECIMAL(10, 2),
    location VARCHAR(255),
    description TEXT,
    type_id INT,
    customer_id INT,
    FOREIGN KEY (type_id) REFERENCES types(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE types (
    id INT PRIMARY KEY,
    typeName VARCHAR(255)
);

CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255)
);


-- zadacha 1
CREATE VIEW monthlyDeals AS
SELECT customers.name, customers.phone, properties.location, properties.area, properties.price,employees.name
FROM customers
JOIN properties ON 
customer.id=properties.customers_id
JOIN ads 
ON PROPERTIES.ID=ADS.PROPERTIES_ID
JOIN deals
ON ads.id=deals.ads_id
JOIN employees
ON employees.id=deals.employees_id
WHERE MONTH(deals.delDate)=MONTH(CURRENT_DATE) AND properties.area>100
ORDER BY price;


-- zadacha 2
DELIMITER |
CREATE PROCEDURE comissionPayment(IN month DATE,IN year YEAR)
BEGIN
DECLARE continue handler FOR NOT FOUND set finished = 1;
DECLARE dealsCursror CURSOR FOR salaryPayments
SELECT * FROM deals 
WHERE deals.month=month AND deals.year=year;
IF(deals.price<100 000)
THEN salaryPayments.monthBonus=0.02*deals.price;
ELSE salaryPayments.monthBonus=0.05*deals.price;
END IF;
END;
|
DELIMITER ;


-- ZADACHA 3
DELIMITER |
CREATE TRIGGER trigerProdajba BEFORE INSERT ON ads
FOR EACH ROW
BEGIN
declare usageaZ INT;
DECLARE discount DECIMAL(10,2);
SELECT count(*) INTO usageAz FROM ADS 
WHERE customer.id=NEW.customer.id;
IF (usegaz BETWEEN 1 AND 5)
THEN set di7scount=0.005;
ELSE set discount=0.01;
END IF;
IF (useg>0)
THEN CALL sendEmailToCustomer();
END IF;
END;
| delimiter ;

-- zad4

DELIMITER |
CREATE TRIGGER triger2 BEFORE INSERT ON ads
FOR EACH ROW 
BEGIN
DECLARE activeAd INT;
SELECT count(*) INTO activeAd FROM ads
WHERE customer.id=NEW.customer.id and ads.ISACTUAL=1;
IF (activeAd>2)
THEN  SIGNAL specialty
      SET MESSAGE_TEXT = 'An error occurred';
END IF;
END;
| DELIMITER ;





-- ZADACHI OT UPR
-- ZAD 1


DELIMITER |
CREATE PROCEDURE publisherBooks(IN countBook INT)
BEGIN
SELECT publishers.name, publishers.id, COUNT(books.id) FROM publishers
JOIN books
ON publishers.ibooks.publisher_id
GROUP BY book.id
HAVING countBook=books.count AND publisher.id=books.publisher_id;
END;
| 
DELIMITER ;

DELIMITER |
CREATE PROCEDURE dve (IN readerId INT)
BEGIN
DECLARE count Int;
SELECT publisher.name,COUNT(BOOKS.ID) AS countBook FROM publisher
JOIN books
ON publisher.id=books.pubishers_id;
end;
|
delimiter ;



DELIMITER |
CREATE TRIGGER edno BEFORE INSERT ON tasks
for each row
BEGIN
DECLARE HOURS INT;
SELECT SUM(hours) AS h INTO HOURS FROM tasks
WHERE employee.id=NEW.employee_ID;
IF(h>176)
THEN CALL SendEmailToDepartment;
END IF;
END;
| DELIMITER ;






