use assignment_1
-- =========================
-- 1. Customer
-- =========================
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone_Number VARCHAR(20) UNIQUE,
    Registration_Date DATE NOT NULL
);

-- =========================
-- 2. Social Media Platform
-- =========================
CREATE TABLE Social_Media_Platform (
    PlatformID INT PRIMARY KEY,
    Platform_Name VARCHAR(50) NOT NULL UNIQUE
);

-- =========================
-- 3. Category
-- =========================
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL UNIQUE
);

-- =========================
-- 4. Product
-- =========================
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- =========================
-- 5. Advertisement
-- =========================
CREATE TABLE Advertisement (
    AdID INT PRIMARY KEY,
    Campaign_Name VARCHAR(100) NOT NULL,
    PlatformID INT NOT NULL,
    FOREIGN KEY (PlatformID) REFERENCES Social_Media_Platform(PlatformID)
);

-- =========================
-- 6. Customer Order
-- =========================
CREATE TABLE Customer_Order (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    AdID INT NULL,
    Order_Date DATE NOT NULL,
    Total_Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (AdID) REFERENCES Advertisement(AdID)
);

-- =========================
-- 7. Ad View
-- =========================
CREATE TABLE Ad_View (
    ViewID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    AdID INT NOT NULL,
    View_Time DATETIME NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (AdID) REFERENCES Advertisement(AdID)
);

-- =========================
-- 8. Ad Click
-- =========================
CREATE TABLE Ad_Click (
    ClickID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    AdID INT NOT NULL,
    Click_Time DATETIME NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (AdID) REFERENCES Advertisement(AdID)
);

-- =========================
-- 9. Order Detail 
-- =========================
CREATE TABLE Order_Detail (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Customer_Order(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- =========================
-- 10. Payment
-- =========================
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    Payment_Method VARCHAR(50) NOT NULL,
    Payment_Date DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Customer_Order(OrderID)
);
