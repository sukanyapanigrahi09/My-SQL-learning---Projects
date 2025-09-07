--create a database
CREATE DATABASE OnlineBookStore;

--create books table 
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR (100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT
);

SELECT * FROM Books;

--create customer table
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR (50),
Country VARCHAR (150)
);

SELECT * FROM Customers;

--create order table
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Date Date,
Quantity INT,
Total_Amount NUMERIC(10,2)
);

SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID,	Title, Author,	Genre, Published_Year,	Price, Stock)
FROM 'C:\Users\Tnluser.PF308536\Downloads\Books.csv'
CSV HEADER;

--Import data into customers table
COPY Customers(Customer_ID,	Name, Email, Phone,	City, Country)
FROM 'C:\Users\Tnluser.PF308536\Downloads\Customers.csv'
CSV HEADER;

--Import data into orders table 
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\Tnluser.PF308536\Downloads\Orders.csv'
CSV HEADER;


--BASIC
-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE (published_year>'1950');

--			or 
SELECT * FROM Books
WHERE published_year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers
WHERE country='Canada'; 

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books available:
SELECT  
 SUM(stock) AS Total_stock
FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books ORDER BY price DESC LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $200:
SELECT * FROM Orders
WHERE total_amount>200;

-- 9) List all genres available in the Books table:
SELECT title, genre FROM Books;
--inorder to remove the repeated genre name 
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books ORDER BY stock ASC LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS Total_revenue FROM Orders;

--ADVANCE:
-- 1) Retrieve the total number of books sold for each genre:
SELECT * FROM orders;

SELECT b.genre, SUM(o.quantity) AS Total_quantity_sold
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_price
FROM Books
WHERE genre = 'Fantasy';


-- 3) List customers who have placed at least 2 orders:
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id)>=2;

--If we want to display the customer name then we have to JOIN both the tables
SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id)>=2;

-- 4) Find the most frequently ordered book:
SELECT Book_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY Book_id
ORDER BY order_count DESC;

--if we want to display the name of the books then we have to join the tables
SELECT o.Book_id, b.title, COUNT(o.order_id) AS order_count
FROM orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_Quantity_sold
FROM orders o
JOIN books b ON b.book_id=o.book_id
GROUP BY b.author;


-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT city, total_amount
FROM orders o
JOIN customers c ON c.customer_id=o.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;

CREATE DATABASE Hospital;

