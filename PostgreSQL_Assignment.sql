
--  create a table named books with the following columns:
--  id: integer, primary key, auto increment
--  title: string, not null
--  author: string, not null
--  price: decimal, not null, check that price >= 0
--  stock: integer, not null, check that stock >= 0
--  published_year: integer, not null, check that published_year >= 1000 and <= current year

CREATE TABLE books (
    id SERIAL PRIMARY KEY,                          
    title VARCHAR(255) NOT NULL,                      
    author VARCHAR(255) NOT NULL,                   
    price DECIMAL(10, 2) CHECK (price >= 0) NOT NULL, 
    stock INT CHECK (stock >= 0) NOT NULL,            
    published_year INT CHECK (published_year >= 1000 AND published_year <= EXTRACT(YEAR FROM CURRENT_DATE)),  
    CONSTRAINT unique_title_author UNIQUE (title, author)  
);



-- insert some data into the books table
INSERT INTO books (id, title, author, price, stock, published_year) VALUES
(1, 'The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
(2, 'Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
(3, 'You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),  
(4, 'Refactoring', 'Martin Fowler', 50.00, 3, 1999),
(5, 'Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

-- select all rows from the books table
SELECT * FROM books;





--  create a table named customers with the following columns:
--  id: integer, primary key, auto increment
--  name: string, not null
--  email: string, not null, unique
--  joined_date: date, default to current date

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,                         
    name VARCHAR(255) NOT NULL,                       
    email VARCHAR(255) UNIQUE NOT NULL,                
    joined_date DATE DEFAULT CURRENT_DATE            
);

-- insert some data into the customers table
INSERT INTO customers (id, name, email, joined_date) VALUES
(1, 'Alice', 'alice@email.com', '2023-01-10'),
(2, 'Bob', 'bob@email.com', '2022-05-15'),
(3, 'Charlie', 'charlie@email.com', '2023-06-20');

-- select all rows from the customers table
SELECT * FROM customers;




--  create a table named orders with the following columns:
--  id: integer, primary key, auto increment
--  customer_id: integer, not null, references customers(id) on delete cascade
--  book_id: integer, not null, references books(id) on delete cascade
--  quantity: integer, not null, check that quantity > 0
--  order_date: timestamp, default to current timestamp

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,                          
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,  
    book_id INT REFERENCES books(id) ON DELETE CASCADE,  
    quantity INT CHECK (quantity > 0) NOT NULL,     
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP   
);


-- insert some data into the orders table
INSERT INTO orders (id, customer_id, book_id, quantity, order_date) VALUES
(1, 1, 2, 1, '2024-03-10'),
(2, 2, 1, 1, '2024-02-20'),
(3, 1, 3, 2, '2024-03-05');

-- select all rows from the orders table
SELECT * FROM orders;





-- problem 1: Find books that are out of stock.

SELECT title FROM books WHERE stock = 0;


-- problem 2: Retrieve the most expensive book in the store.

SELECT * FROM books ORDER BY price DESC LIMIT 1;

-- problem 3:  Find the total number of orders placed by each customer.

SELECT c.name, COUNT(o.id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id;

-- problem 4: Calculate the total revenue generated from book sales.

SELECT SUM(price * quantity) AS total_revenue
FROM books b
JOIN orders o ON b.id = o.book_id;

-- problem 5: List all customers who have placed more than one order.

SELECT c.name, COUNT(o.id) AS orders_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id
HAVING COUNT(o.id) > 1;

-- problem 6:  Find the average price of books in the store.
SELECT ROUND(AVG(price), 2) AS avg_book_price
FROM books;
