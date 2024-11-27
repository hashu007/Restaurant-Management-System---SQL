use restaurant;

DROP table Customers;
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);
CREATE TABLE MenuItems (
    MenuItemID INT IDENTITY(1,1) PRIMARY KEY,
    ItemName VARCHAR(100),
    Price DECIMAL(10, 2)
);
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    MenuItemID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID)
);
CREATE TABLE Feedback (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    Comments TEXT,
    Rating INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Customers (Name, Email, Phone) VALUES
('John Doe', 'john@example.com', '1234567890'),
('Jane Smith', 'jane@example.com', '0987654321');

INSERT INTO MenuItems (ItemName, Price) VALUES
('Burger', 5.99 ),
('Pizza', 8.99 ),
('Pasta', 7.99 ),
('Salad', 4.99 );

INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-11-22 12:00:00'),
(2, '2024-11-22 12:30:00');

INSERT INTO OrderDetails (OrderID, MenuItemID, Quantity) VALUES
(1, 1, 2),  
(1, 2, 1),  
(2, 3, 1);

INSERT INTO Feedback (OrderID, Comments, Rating) VALUES
(1, 'Great food!', 5),
(2, 'Could be better.', 3);

SELECT * FROM MenuItems;

SELECT O.OrderID, O.OrderDate, OD.Quantity, MI.ItemName
FROM Orders O
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN MenuItems MI ON OD.MenuItemID = MI.MenuItemID
WHERE O.CustomerID = 1;

SELECT MI.ItemName, SUM(OD.Quantity * MI.Price) AS TotalSales
FROM OrderDetails OD
JOIN MenuItems MI ON OD.MenuItemID = MI.MenuItemID
WHERE MI.MenuItemID = 1 
GROUP BY MI.ItemName;

SELECT Comments, Rating
FROM Feedback
WHERE OrderID = 1;

SELECT MI.ItemName, SUM(OD.Quantity) AS TotalSold
FROM OrderDetails OD
JOIN MenuItems MI ON OD.MenuItemID = MI.MenuItemID
GROUP BY MI.ItemName
ORDER BY TotalSold DESC; 

SELECT 
    C.Name AS CustomerName,
    O.OrderID,
    O.OrderDate,
    MI.ItemName,
    OD.Quantity,
    F.Comments,
    F.Rating
FROM 
    Orders O
JOIN 
    Customers C ON O.CustomerID = C.CustomerID
JOIN 
    OrderDetails OD ON O.OrderID = OD.OrderID
JOIN 
    MenuItems MI ON OD.MenuItemID = MI.MenuItemID
LEFT JOIN 
    Feedback F ON O.OrderID = F.OrderID;