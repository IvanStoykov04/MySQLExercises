CREATE DATABASE insuranceCompany;
USE insuranceCompany;



CREATE TABLE employees(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL, 
position VARCHAR(100) NOT NULL,
insuranceCompany_id INT NOT NULL,
FOREIGN KEY (insuranceCompany_id) REFERENCES insuranceCompany(id)
);

CREATE TABLE insuranceCompany(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE customers(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
egn VARCHAR(10) NOT NULL UNIQUE,
phone VARCHAR(10) NOT NULL UNIQUE,
email VARCHAR(50) NOT NULL UNIQUE,
insuranceCompany_id INT NOT NULL,
FOREIGN KEY (insuranceCompany_id) REFERENCES insuranceCompany(id)
);

CREATE TABLE insurance(
id INT AUTO_INCREMENT PRIMARY KEY,
price DOUBLE NOT NULL,
description VARCHAR(100) NOT NULL,
insuranceType ENUM('authocasco','grazdanska','zlopoluka','zivot','imushtestvo') NOT NULL
);

CREATE TABLE insurancePolicy(
id INT AUTO_INCREMENT PRIMARY KEY,
startDate DATE NOT NULL,
endDate DATE NOT NULL,
sumInsurance DOUBLE NOT NULL,
customers_id INT NOT NULL,
insurance_id INT NOT NULL,
FOREIGN KEY (insurance_id) REFERENCES insurance(id),
FOREIGN KEY (customers_id) REFERENCES customers(id)
);


CREATE TABLE salaryPayments(
id INT AUTO_INCREMENT PRIMARY KEY,
salaryAmount DOUBLE NOT NULL,
monthlyBonus DOUBLE NOT NULL,
dateOfPayments DATETIME NOT NULL,
yearOfPayments YEAR NOT NULL,
insuranceCompany_id INT NOT NULL,
employees_id INT NOT NULL,
FOREIGN KEY (employees_id) REFERENCES employees(id),
FOREIGN KEY (insuranceCompany_id) REFERENCES insuranceCompany(id)
);





CREATE VIEW infoView2 AS
SELECT customers.name AS customersName,insuranceCompany.name AS companyName,insurance.insuranceType,employees.name as nameOfemployee
FROM customers 
JOIN insuranceCompany
ON customers.insuranceCompany_id = insuranceCompany.id
JOIN insurance
ON customers.id IN (
SELECT insurancePolicy.customers_id FROM insurancePolicy
WHERE insurancePolicy.insurance_id=insurance.id)
JOIN employees
ON customers.insuranceCompany_id IN (
SELECT insuranceCompany.id FROM insuranceCompany
WHERE insuranceCompany.id=employees.insuranceCompany_id);





SELECT employees.name, salaryPayments.monthlyBonus
FROM employees LEFT JOIN salaryPayments
ON employees.id = salaryPayments.employees_id
WHERE salaryPayments.dateOfPayments='2024-02-24'
ORDER BY employees.name;



SELECT SUM(insurancePolicy.sumInsurance) AS sum,employees.name
FROM employees
JOIN insuranceCompany
ON employees.insuranceCompany_id=insuranceCompany.id
JOIN customers 
ON insuranceCompany.id=customers.insuranceCompany_id
JOIN insurancePolicy
ON customers.id=insurancePolicy.customers_id
JOIN insurance
ON insurancePolicy.insurance_id=insurance.id
WHERE insurance.insuranceType='grazdanska'
GROUP BY employees.id,insuranceCompany.id,customers.id,insurancePolicy.id,insurance.id
HAVING sum>AVG(insurance.price);

/*когато използваме вложен select пръскачаме таблицата, която играе роля на връзка между другите две и не може да се изведе нейната информация(играе роля на посредник) 
SELECT insuranceCompany.name
FROM employees 
JOIN customers
ON employees.insuranceCompany_id IN(
SELECT insuranceCompany.id FROM insuranceCompany
WHERE customers.insuranceCompany_id = insuranceCompany.id)
JOIN insurance
ON customers.id IN (
SELECT insurancePolicy.customers_id FROM insurancePolicy
WHERE insurancePolicy.insurance_id=insurance.id);
*/



