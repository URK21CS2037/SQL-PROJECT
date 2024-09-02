-- schema.sql

-- Create Authors Table
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    birth_year INT
);

-- Create Books Table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    published_year INT,
    genre VARCHAR(100),
    available_copies INT DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Create Patrons Table
CREATE TABLE Patrons (
    patron_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(15)
);

-- Create Loans Table
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    patron_id INT,
    loan_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (patron_id) REFERENCES Patrons(patron_id)
);
-- insert_data.sql

-- Insert Authors
INSERT INTO Authors (name, birth_year) VALUES
('George Orwell', 1903),
('J.K. Rowling', 1965);

-- Insert Books
INSERT INTO Books (title, author_id, published_year, genre, available_copies) VALUES
('1984', 1, 1949, 'Dystopian', 3),
('Harry Potter and the Sorcerer\'s Stone', 2, 1997, 'Fantasy', 5);

-- Insert Patrons
INSERT INTO Patrons (name, email, phone_number) VALUES
('Alice Smith', 'alice.smith@example.com', '555-1234'),
('Bob Johnson', 'bob.johnson@example.com', '555-5678');

-- Insert Loans
INSERT INTO Loans (book_id, patron_id, loan_date) VALUES
(1, 1, '2024-08-01'),
(2, 2, '2024-08-10');
-- queries.sql

-- List all books with their authors
SELECT b.title, a.name AS author_name
FROM Books b
JOIN Authors a ON b.author_id = a.author_id;

-- Find overdue loans (assuming overdue is defined as more than 30 days from the loan date)
SELECT l.loan_id, b.title, p.name AS patron_name, l.loan_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Patrons p ON l.patron_id = p.patron_id
WHERE l.return_date IS NULL AND l.loan_date < CURDATE() - INTERVAL 30 DAY;

-- Update available copies of a book (example: decrement available copies for a specific book)
UPDATE Books
SET available_copies = available_copies - 1
WHERE book_id = 1;

-- Return a book (example: update return date and increment available copies)
UPDATE Loans
SET return_date = CURDATE()
WHERE loan_id = 1;

UPDATE Books
SET available_copies = available_copies + 1
WHERE book_id = (SELECT book_id FROM Loans WHERE loan_id = 1);
