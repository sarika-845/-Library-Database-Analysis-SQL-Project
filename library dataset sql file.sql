CREATE DATABASE library_db;
USE library_db;

CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) 
    REFERENCES tbl_publisher(publisher_PublisherName)
);

CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) 
    REFERENCES tbl_book(book_BookID)
);

CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

CREATE TABLE tbl_book_copies (
    book_copies_CopiesID  INT AUTO_INCREMENT PRIMARY KEY,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) 
    REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) 
    REFERENCES tbl_library_branch(library_branch_BranchID)
);

CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);

SELECT * FROM tbl_borrower;


CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);


select * from  tbl_publisher;

select * from tbl_book;

select * from tbl_book_authors;

select * from tbl_book_copies;

TRUNCATE TABLE tbl_book_copies;

SELECT book_BookID FROM tbl_book ORDER BY book_BookID;

SELECT library_branch_BranchID, library_branch_BranchName
FROM tbl_library_branch;

INSERT INTO tbl_library_branch
(library_branch_BranchName, library_branch_BranchAddress)
VALUES
('Sharpstown', 'Sharpstown Address'),
('Central', 'Central Address');

SELECT * FROM tbl_library_branch;

TRUNCATE TABLE tbl_book_copies;
SELECT * FROM tbl_book_copies;

SELECT book_BookID FROM tbl_book;

SELECT borrower_CardNo FROM tbl_borrower;


TRUNCATE TABLE tbl_book_loans;

SELECT * FROM tbl_borrower;

-- Qestion 1
SELECT 
    lb.library_branch_BranchName,
    b.book_Title,
    bc.book_copies_No_Of_Copies AS Total_Copies
FROM tbl_book b
JOIN tbl_book_copies bc
    ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
  AND lb.library_branch_BranchName = 'Sharpstown';
  
  -- Question 2
  SELECT 
    lb.library_branch_BranchName,
    bc.book_copies_No_Of_Copies AS Total_Copies
FROM tbl_book b
JOIN tbl_book_copies bc
    ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe';

-- Question 3
SELECT 
    br.borrower_BorrowerName
FROM tbl_borrower br
LEFT JOIN tbl_book_loans bl
    ON br.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_LoansID IS NULL;

-- Question 4
SELECT 
    b.book_Title,
    br.borrower_BorrowerName,
    br.borrower_BorrowerAddress
FROM tbl_library_branch lb
LEFT JOIN tbl_book_loans bl
    ON lb.library_branch_BranchID = bl.book_loans_BranchID
LEFT JOIN tbl_book b
    ON bl.book_loans_BookID = b.book_BookID
LEFT JOIN tbl_borrower br
    ON bl.book_loans_CardNo = br.borrower_CardNo
WHERE lb.library_branch_BranchName = 'Sharpstown';

-- Question 5
SELECT 
    lb.library_branch_BranchName,
    COUNT(bl.book_loans_LoansID) AS Total_Books_Loaned
FROM tbl_library_branch lb
LEFT JOIN tbl_book_loans bl
    ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY lb.library_branch_BranchName;

-- Question 6
SELECT 
    br.borrower_BorrowerName,
    br.borrower_BorrowerAddress,
    COUNT(bl.book_loans_LoansID) AS Books_Checked_Out
FROM tbl_borrower br
JOIN tbl_book_loans bl
    ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY 
    br.borrower_BorrowerName,
    br.borrower_BorrowerAddress
HAVING COUNT(bl.book_loans_LoansID) > 5;

-- Question 7
SELECT 
    b.book_Title,
    bc.book_copies_No_Of_Copies AS Total_Copies
FROM tbl_book b
JOIN tbl_book_authors ba
    ON b.book_BookID = ba.book_authors_BookID
JOIN tbl_book_copies bc
    ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE ba.book_authors_AuthorName = 'Stephen King'
  AND lb.library_branch_BranchName = 'Central';



