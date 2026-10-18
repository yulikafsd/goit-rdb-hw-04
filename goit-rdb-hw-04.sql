-- Завдання 1
CREATE SCHEMA IF NOT EXISTS `LibraryManagement`;
USE `LibraryManagement`;

CREATE TABLE authors (
	author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(50) NOT NULL
);

CREATE TABLE genres (
	genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE books (
	book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    publication_year YEAR NOT NULL,
    author_id INT NOT NULL,
    genre_id INT NOT NULL,
    FOREIGN KEY (author_id) references authors(author_id), FOREIGN KEY (genre_id) references genres(genre_id)
);

CREATE TABLE users (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE borrowed_books (
	borrow_id INT auto_increment PRIMARY KEY,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
	borrow_date DATE NOT NULL,
	return_date DATE NULL,
	FOREIGN KEY (book_id) references books(book_id), FOREIGN KEY (user_id) references users(user_id)
);

-- Завдання 2

INSERT INTO authors (author_name) 
VALUES 
	('Taras Shevchenko'), 
    ('Pavlo Tychyna'), 
    ('Ivan Franko');

INSERT INTO genres (genre_name) 
VALUES 
	('poems'), 
    ('roman');

INSERT INTO books (title, publication_year, author_id, genre_id) 
VALUES 
	('Kobzar', 1904, 1, 1), 
    ('Sonyachni Klarnety', 1918, 2, 1), 
    ('Zakhar Berkut', 1903, 3, 2);

INSERT INTO users (username, email) 
VALUES 
	('John Doe', 'john@mail.com'), 
    ('Alex Smith', 'alex@gmail.com'), 
    ('Robert Star', 'rob@mail.com');

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) 
VALUES 
	(3, 1, '2026-10-02', '2026-10-02'), 
    (2, 3, '2026-10-12', '2026-10-19'), 
    (1, 2, '2026-09-05', '2026-09-12');

-- Завдання 3 (order_details, orders, customers, products, categories, employees, shippers, suppliers)

USE `goit-rdb-hw-03`;

SELECT * FROM order_details as od
INNER JOIN orders as o ON od.order_id = o.order_id
INNER JOIN products as p ON od.product_id = p.product_id
INNER JOIN customers as cs ON o.customer_id = cs.customer_id
INNER JOIN employees as e ON o.employee_id = e.employee_id
INNER JOIN shippers as sh ON o.shipper_id = sh.shipper_id
INNER JOIN categories as ct ON p.category_id = ct.category_id
INNER JOIN suppliers as sp ON p.supplier_id = sp.supplier_id;

-- Схлопуємо однакові стовпчики, якзо назви стовпчиків співпадають
SELECT * FROM order_details AS od
INNER JOIN orders AS o USING (order_id)
INNER JOIN products AS p USING (product_id)
INNER JOIN customers AS cs USING (customer_id)
INNER JOIN employees AS e USING (employee_id)
INNER JOIN shippers AS sh USING (shipper_id)
INNER JOIN categories AS ct USING (category_id)
INNER JOIN suppliers AS sp USING (supplier_id);

-- Завдання 4.1
/* Визначте, скільки рядків ви отримали */

SELECT COUNT(*) FROM order_details AS od
INNER JOIN orders AS o USING (order_id)
INNER JOIN products AS p USING (product_id)
INNER JOIN customers AS cs USING (customer_id)
INNER JOIN employees AS e USING (employee_id)
INNER JOIN shippers AS sh USING (shipper_id)
INNER JOIN categories AS ct USING (category_id)
INNER JOIN suppliers AS sp USING (supplier_id);

-- Завдання 4.2
/* Змініть декілька операторів INNER на LEFT чи RIGHT. */

SELECT COUNT(*) FROM order_details AS od
LEFT JOIN orders AS o USING (order_id)
LEFT JOIN products AS p USING (product_id)
LEFT JOIN customers AS cs USING (customer_id)
LEFT JOIN employees AS e USING (employee_id)
LEFT JOIN shippers AS sh USING (shipper_id)
LEFT JOIN categories AS ct USING (category_id)
LEFT JOIN suppliers AS sp USING (supplier_id);

/* Визначте, що відбувається з кількістю рядків. Чому? Напишіть відповідь у текстовому файлі. */

/* Обидва запити - з INNER JOIN та LEFT JOIN повертають 518 рядків - результат збігається, оскільки базовою таблицею 
виступає order_details, а усі наступні з'єднання будуються послідовно від уже існуючих замовлених позицій, в яких 
однозначно є покупець, товар з виробником та категорією, працівник, який обробив замовлення, та постачальник.
Тобто кожен запис у order_details має валідні зовнішні ключі, які 100% існують у дочірніх таблицях, і жодне з полів 
зв'язку не містить значень NULL. Відповідно, оператор LEFT JOIN не створює жодного додаткового рядка з незбіжними даними.
Клієнти, які зареєстровані, але ще не зробили жодного замовлення, у вибірку не потрапляють, оскільки зв'язок іде від факту продажу.
*/

-- Завдання 4.3
/* Oберіть тільки ті рядки, де employee_id > 3 та ≤ 10. */

SELECT * FROM order_details AS od
LEFT JOIN orders AS o USING (order_id)
LEFT JOIN products AS p USING (product_id)
LEFT JOIN customers AS cs USING (customer_id)
LEFT JOIN employees AS e USING (employee_id)
LEFT JOIN shippers AS sh USING (shipper_id)
LEFT JOIN categories AS ct USING (category_id)
LEFT JOIN suppliers AS sp USING (supplier_id)
WHERE employee_id > 3 AND employee_id <= 10;

-- Завдання 4.4
/* Згрупуйте за іменем категорії, порахуйте кількість рядків у групі, 
середню кількість товару (кількість товару знаходиться в order_details.quantity) */

SELECT 
	ct.name AS category_name, 
    COUNT(*) AS total_rows, 
    AVG(od.quantity) as average_quantity
    FROM order_details AS od
LEFT JOIN orders AS o USING (order_id)
LEFT JOIN products AS p USING (product_id)
LEFT JOIN customers AS cs USING (customer_id)
LEFT JOIN employees AS e USING (employee_id)
LEFT JOIN shippers AS sh USING (shipper_id)
LEFT JOIN categories AS ct USING (category_id)
LEFT JOIN suppliers AS sp USING (supplier_id)
WHERE employee_id > 3 AND employee_id <= 10
GROUP BY ct.name;

-- Завдання 4.5
/* Відфільтруйте рядки, де середня кількість товару більша за 21. */

SELECT 
	ct.name AS category_name, 
    COUNT(*) AS total_rows, 
    AVG(od.quantity) as average_quantity
    FROM order_details AS od
LEFT JOIN orders AS o USING (order_id)
LEFT JOIN products AS p USING (product_id)
LEFT JOIN customers AS cs USING (customer_id)
LEFT JOIN employees AS e USING (employee_id)
LEFT JOIN shippers AS sh USING (shipper_id)
LEFT JOIN categories AS ct USING (category_id)
LEFT JOIN suppliers AS sp USING (supplier_id)
WHERE employee_id > 3 AND employee_id <= 10
GROUP BY ct.name
HAVING average_quantity > 21;

-- Завдання 4.6
/* Відсортуйте рядки за спаданням кількості рядків. */

SELECT 
	ct.name AS category_name, 
    COUNT(*) AS total_rows, 
    AVG(od.quantity) as average_quantity
    FROM order_details AS od
LEFT JOIN orders AS o USING (order_id)
LEFT JOIN products AS p USING (product_id)
LEFT JOIN customers AS cs USING (customer_id)
LEFT JOIN employees AS e USING (employee_id)
LEFT JOIN shippers AS sh USING (shipper_id)
LEFT JOIN categories AS ct USING (category_id)
LEFT JOIN suppliers AS sp USING (supplier_id)
WHERE employee_id > 3 AND employee_id <= 10
GROUP BY ct.name
HAVING average_quantity > 21
ORDER BY total_rows DESC;

-- Завдання 4.7
/* Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком. */

SELECT 
	ct.name AS category_name, 
    COUNT(*) AS total_rows, 
    AVG(od.quantity) as average_quantity
    FROM order_details AS od
LEFT JOIN orders AS o USING (order_id)
LEFT JOIN products AS p USING (product_id)
LEFT JOIN customers AS cs USING (customer_id)
LEFT JOIN employees AS e USING (employee_id)
LEFT JOIN shippers AS sh USING (shipper_id)
LEFT JOIN categories AS ct USING (category_id)
LEFT JOIN suppliers AS sp USING (supplier_id)
WHERE employee_id > 3 AND employee_id <= 10
GROUP BY ct.name
HAVING average_quantity > 21
ORDER BY total_rows DESC
LIMIT 4 OFFSET 1;