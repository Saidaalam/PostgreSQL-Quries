-- TABLE CREATION

-- Create 'customers' table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    joined_date DATE
);

-- Create 'books' table
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100),
    price NUMERIC(6, 2),
    published_date DATE
);

-- Create 'orders' table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    book_id INTEGER REFERENCES books(id),
    quantity INTEGER NOT NULL,
    order_date DATE
);

-- SAMPLE DATA INSERTION

-- Insert sample customers
INSERT INTO customers (name, email, joined_date) VALUES
('Alice', 'alice@email.com', '2023-01-10'),
('Bob', 'bob@email.com', '2022-05-15'),
('Charlie', 'charlie@email.com', '2023-06-20'),
('David', 'david@email.com', '2022-08-01'),
('Eva', 'eva@email.com', '2023-09-14'),
('Frank', 'frank@email.com', '2024-01-25'),
('Grace', 'grace@email.com', '2023-12-11');

-- Insert sample books
INSERT INTO books (title, author, price, published_date) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 9.99, '1925-04-10'),
('1984', 'George Orwell', 12.50, '1949-06-08'),
('To Kill a Mockingbird', 'Harper Lee', 10.75, '1960-07-11'),
('The Catcher in the Rye', 'J.D. Salinger', 11.20, '1951-07-16'),
('The Hobbit', 'J.R.R. Tolkien', 15.00, '1937-09-21'),
('Pride and Prejudice', 'Jane Austen', 8.90, '1813-01-28'),
('The Alchemist', 'Paulo Coelho', 13.45, '1988-05-01'),
('Brave New World', 'Aldous Huxley', 14.25, '1932-08-30'),
('Moby Dick', 'Herman Melville', 10.00, '1851-10-18'),
('War and Peace', 'Leo Tolstoy', 19.99, '1869-01-01');

-- Insert sample orders
INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(3, 1, 1, '2024-03-15'),
(4, 2, 1, '2024-03-18'),
(2, 4, 2, '2024-03-19'),
(5, 3, 1, '2024-03-21'),
(1, 7, 1, '2024-03-22'),
(6, 6, 2, '2024-03-23'),
(7, 9, 1, '2024-03-24'),
(1, 10, 1, '2024-03-25'),
(4, 1, 1, '2024-03-26');

-- SQL QUERIES WITH COMMENTS

-- 1. Find books that are out of stock
SELECT title
FROM books
WHERE stock = 0;

-- 2. Retrieve the most expensive book in the store
SELECT *
FROM books
ORDER BY price DESC
LIMIT 1;

-- 3. Find the total number of orders placed by each customer
SELECT c.name, COUNT(o.id) AS total_orders
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name;

-- 4. Calculate the total revenue generated from book sales
SELECT SUM(b.price * o.quantity) AS total_revenue
FROM orders o
JOIN books b ON o.book_id = b.id;

-- 5. List all customers who have placed more than one order
SELECT c.name, COUNT(o.id) AS orders_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.id) > 1;

-- 6. Find the average price of books in the store
SELECT ROUND(AVG(price), 2) AS avg_book_price
FROM books;

-- 7. Increase the price of all books published before 2000 by 10%
UPDATE books
SET price = ROUND(price * 1.10, 2)
WHERE published_year < 2000;

-- 8. Delete customers who haven't placed any orders
DELETE FROM customers
WHERE id NOT IN (
  SELECT DISTINCT customer_id FROM orders
);
