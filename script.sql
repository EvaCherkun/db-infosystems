-- Створення таблиці для категорій
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Створення таблиці для книг
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    category_id INT REFERENCES categories(category_id),
    price DECIMAL(10, 2) NOT NULL
);

-- Створення таблиці для продажів
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id),
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL
);


INSERT INTO books (book_id, title, author, price, category_id, stock) 
VALUES 
(1, 'День страждань', 'Містер Тан', 220.00, 1, 10),
(2, 'Есенціалізм. Мистецтво визначати пріоритети', 'Грег Маккеон', 430.00, 2, 5),
(3, 'Квартира на двох', 'Бет О’Лірі', 300.00, 3, 7);


-- Вибірка всіх книг
SELECT * FROM books;

-- Вибірка всіх продажів з інформацією про книгу
SELECT s.sale_id, b.title, s.sale_date, s.quantity, s.total_price
FROM sales s
JOIN books b ON s.book_id = b.book_id;


-- Оновлення ціни книги
UPDATE books SET price = 17.99 WHERE book_id = 1;


-- Видалення продажу
DELETE FROM sales WHERE sale_id = 1;
