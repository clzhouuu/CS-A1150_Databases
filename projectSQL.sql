-- CREATE TABLE commands for defining the database schema
CREATE TABLE PostalCode(
    postalCode TEXT NOT NULL PRIMARY KEY
);

CREATE TABLE Customer(
    customerNumber TEXT NOT NULL,
    name TEXT,
    address TEXT,
    email TEXT,
    phoneNumber TEXT,
    postalCode TEXT REFERENCES PostalCode(postalCode),
    PRIMARY KEY (customerNumber)
);

CREATE TABLE Store(
    storeID TEXT NOT NULL PRIMARY KEY,
    name,
    address TEXT
);

CREATE TABLE Route(
    routeID TEXT NOT NULL PRIMARY KEY,
    max INTEGER NOT NULL,
    weekDays TEXT CHECK (weekDays IN ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')),
    time TEXT NOT NULL,
    storeID TEXT NOT NULL,
    FOREIGN KEY (storeID) REFERENCES Store(storeID)
);

CREATE TABLE Delivery(
    deliveryID TEXT NOT NULL PRIMARY KEY,
    time TEXT NOT NULL,
    date TEXT NOT NULL,
    routeID TEXT REFERENCES Route(routeID)
);

CREATE TABLE Orderr(
    orderID TEXT NOT NULL,
    status TEXT CHECK (status IN ('shipped', 'in preparation')), 
    substitutionGranted INT CHECK (substitutionGranted IN (0, 1)), 
    deliveryTime TEXT, 
    routeID TEXT NOT NULL, 
    employeeID TEXT NOT NULL, 
    intervalID TEXT, 
    customerNumber TEXT NOT NULL, 
    count INT, 
    discount INT CHECK (discount >= 0 AND discount <= 100), 
    date TEXT NOT NULL, 
    deliveryID TEXT REFERENCES Delivery(deliveryID),
    storeID TEXT REFERENCES Store(storeID),
    PRIMARY KEY (orderID)
); 

CREATE TABLE Collector(
    employeeID TEXT NOT NULL PRIMARY KEY, 
    name TEXT NOT NULL, 
    phoneNumber TEXT NOT NULL, 
    ordersPerHour INTEGER NOT NULL, 
    storeID TEXT REFERENCES Store(storeID)
);

CREATE TABLE Interval(
    intervalID TEXT NOT NULL PRIMARY KEY,
    date TEXT NOT NULL, 
    startTime TEXT NOT NULL, 
    duration TEXT NOT NULL,
    storeID TEXT NOT NULL REFERENCES Store(storeID)
);

CREATE TABLE Box(
    number TEXT NOT NULL PRIMARY KEY, 
    temperature REAL, 
    orderID TEXT NOT NULL
);

CREATE TABLE Diet(
    dietType TEXT NOT NULL PRIMARY KEY
);

CREATE TABLE Products(
    productID TEXT NOT NULL PRIMARY KEY, 
    temperature REAL, 
    price REAL CHECK (price > 0.0), 
    name TEXT, 
    protein REAL, 
    energy REAL, 
    fat REAL, 
    carbohydrates REAL, 
    inStock INT CHECK (inStock IN (0, 1))
);

CREATE TABLE OldPrice(
    productID TEXT REFERENCES Products(productID),
    time TEXT NOT NULL, 
    date TEXT NOT NULL,
    price REAL NOT NULL,
    PRIMARY KEY (productID, time, date)
);

CREATE TABLE ReplacedInfo(
    replacementID TEXT NOT NULL PRIMARY KEY, 
    replacementProduct NOT NULL, 
    replacedProduct NOT NULL
);

CREATE TABLE Ingredient(
    material TEXT PRIMARY KEY
);

CREATE TABLE SelectionOf(
    productID REFERENCES Products(productID), 
    storeID REFERENCES Store(storeID),
    PRIMARY KEY (productID, storeID)
);

CREATE TABLE StoredIn(
    number TEXT REFERENCES Box(number),
    productID TEXT REFERENCES Products(productID),
    weight REAL,
    amount INT,
    material TEXT,
    PRIMARY KEY (number, productID)
);

CREATE TABLE WorkingAt(
    employeeID TEXT REFERENCES Collector(employeeID),
    intervalID TEXT REFERENCES Interval(intervalID),
    PRIMARY KEY (employeeID, intervalID)
);

CREATE TABLE DeliversTo(
    routeID TEXT REFERENCES Route(routeID), 
    postalCode TEXT REFERENCES PostalCode(postalCode),
    PRIMARY KEY (routeID, postalCode)
);

CREATE TABLE ReplacementOf(
    replacementID TEXT REFERENCES ReplacedInfo(replacementID),
    orderID TEXT REFERENCES Orderr(orderID),
    PRIMARY KEY (replacementID, orderID)
);

CREATE TABLE InOrder (
    orderID TEXT REFERENCES Orderr(orderID), 
    productID TEXT REFERENCES Products(productID),
    quantity INT NOT NULL,
    PRIMARY KEY (orderID, productID)
);

CREATE TABLE ReplacementFor(
    ReplacementProductID TEXT REFERENCES Products(productID),
    ReplacedProductID TEXT REFERENCES Products(productID),
    PRIMARY KEY (ReplacementProductID, ReplacedProductID)
);

CREATE TABLE DietOf(
    dietType TEXT REFERENCES Diet(dietType),
    productID TEXT REFERENCES Products(productID),
    PRIMARY KEY (dietType, productID)
);


-- Inserting initial data into the tables
INSERT INTO PostalCode (postalCode)
VALUES
    ('90210'),
    ('12345'),
    ('54321'),
    ('67890'),
    ('13579'),
    ('24680'),
    ('97531'),
    ('36912'),
    ('15937'),
    ('78543');

INSERT INTO Store (storeID, name, address)
VALUES 
    ('store001', 'Kmarket', '123 Otakaari'),
    ('store002', 'Smarket', '456 JMT');

INSERT INTO Route (routeID, max, weekDays, time, storeID)
VALUES
    ('route001', 50, 'monday', '10:00', 'store001'),
    ('route002', 40, 'tuesday', '11:00', 'store001'),
    ('route003', 60, 'wednesday', '12:00', 'store002'),
    ('route004', 70, 'thursday', '13:00', 'store002');

INSERT INTO DeliversTo (routeID, postalCode)
VALUES
    ('route001', '90210'),
    ('route002', '12345'),
    ('route003', '54321'),
    ('route004', '67890'),
    ('route001', '13579'),
    ('route002', '24680'),
    ('route003', '97531'),
    ('route004', '36912'),
    ('route001', '15937'),
    ('route002', '78543');

INSERT INTO Customer (customerNumber, name, address, email, phoneNumber, postalCode)
VALUES
    ('Cust001', 'John Doe', '123 Oak Avenue', 'john@example.com', '555-1234', '90210'),
    ('Cust002', 'Jane Smith', '456 Maple Street', 'jane@example.com', '555-5678', '12345'),
    ('Cust003', 'Alice Johnson', '789 Pine Road', 'alice@example.com', '555-9876', '54321'),
    ('Cust004', 'Michael Brown', '321 Cedar Lane', 'michael@example.com', '555-4321', '67890'),
    ('Cust005', 'Emily Davis', '654 Birch Street', 'emily@example.com', '555-8765', '13579'),
    ('Cust006', 'William Wilson', '987 Elm Avenue', 'william@example.com', '555-2468', '24680'),
    ('Cust007', 'Olivia Taylor', '159 Walnut Road', 'olivia@example.com', '555-1357', '97531'),
    ('Cust008', 'James Lee', '357 Hickory Lane', 'james@example.com', '555-3691', '36912'),
    ('Cust009', 'Emma Martinez', '753 Sycamore Drive', 'emma@example.com', '555-1593', '15937'),
    ('Cust010', 'Daniel Rodriguez', '852 Pine Street', 'daniel@example.com', '555-7854', '78543');

INSERT INTO Products (productID, temperature, price, name, protein, energy, fat, carbohydrates, inStock)
VALUES
    ('prod001', 4.0, 2.99, 'Milk', 3.2, 42, 2.0, 30, 1),
    ('prod002', 4.0, 1.99, 'Milk', 2.8, 38, 1.5, 28, 1),
    ('prod003', 4.0, 3.49, 'Bread', 4.0, 60, 3.5, 40, 1),
    ('prod004', 4.0, 2.99, 'Bread', 8.0, 280, 2.0, 50, 1),
    ('prod005', -18.0, 5.99, 'Eggs', 5.0, 200, 10.0, 25, 1),
    ('prod006', 4.0, 1.49, 'Eggs', 6.0, 70, 5.0, 0, 1),
    ('prod007', 25.0, 2.99, 'Soda', 0, 120, 0, 30, 1),
    ('prod008', 4.0, 4.99, 'Orange Juice', 1.0, 45, 0, 10, 1),
    ('prod009', -18.0, 3.99, 'Frozen Pizza', 15.0, 500, 20.0, 40, 1),
    ('prod010', 4.0, 2.49, 'Cheese', 7.0, 110, 9.0, 0, 1);

-- Populate ReplacementFor table based on replacement information
INSERT INTO ReplacementFor (ReplacementProductID, ReplacedProductID)
VALUES
    ('prod002', 'prod001'),  -- Customer 001: Replace prod001 with prod002
    ('prod006', 'prod005'),  -- Customer 003 and 006: Replace prod005 with prod006
    ('prod004', 'prod003');  -- Customer 007: Replace prod003 with prod004

-- Insert sample ingredients
INSERT INTO Ingredient (material) VALUES
    ('Flour'),
    ('Sugar'),
    ('Salt'),
    ('Milk'),
    ('Eggs');

-- Insert sample associations between products and stores
INSERT INTO SelectionOf (productID, storeID) VALUES
    ('prod001', 'store001'),
    ('prod002', 'store001'),
    ('prod003', 'store001'),
    ('prod004', 'store001'),
    ('prod005', 'store001'),
    ('prod006', 'store001'),
    ('prod007', 'store001'),
    ('prod008', 'store001'),
    ('prod009', 'store001'),
    ('prod010', 'store001'),
    ('prod003', 'store002'),
    ('prod004', 'store002'),
    ('prod005', 'store002'),
    ('prod006', 'store002'),
    ('prod007', 'store002'),
    ('prod008', 'store002'),
    ('prod010', 'store002');

-- Update product prices
UPDATE Products
SET price = 3.49
WHERE productID = 'prod001';

UPDATE Products
SET price = 3.60
WHERE productID = 'prod001';

UPDATE Products
SET price = 3.89
WHERE productID = 'prod001';

UPDATE Products
SET price = 3.19
WHERE productID = 'prod001';

UPDATE Products
SET price = 2.79
WHERE productID = 'prod002';

UPDATE Products
SET price = 4.99
WHERE productID = 'prod003';

UPDATE Products
SET price = 5.99
WHERE productID = 'prod004';

UPDATE Products
SET price = 2.29
WHERE productID = 'prod005';

UPDATE Products
SET price = 6.49
WHERE productID = 'prod006';

INSERT INTO OldPrice (productID, time, date, price)
VALUES
    ('prod001', '10:00', '2024-05-01', 3.49),
    ('prod001', '9:00', '2024-05-01', 3.60),
    ('prod001', '5:00', '2024-05-01', 3.89),
    ('prod001', '21:00', '2024-05-01', 3.19),
    ('prod002', '10:00', '2024-05-01', 2.79),
    ('prod003', '10:00', '2024-05-01', 4.99),
    ('prod004', '10:00', '2024-05-01', 5.99),
    ('prod005', '10:00', '2024-05-01', 2.29);

INSERT INTO Delivery (deliveryID, time, date, routeID)
VALUES
    ('delivery001', '10:30', '2024-05-06', 'route001'),
    ('delivery002', '11:30', '2024-05-07', 'route002'),
    ('delivery003', '12:30', '2024-05-08', 'route003'),
    ('delivery004', '13:30', '2024-05-09', 'route004'),
    ('delivery005', '10:30', '2024-05-06', 'route001');

INSERT INTO Orderr (orderID, status, substitutionGranted, deliveryTime, routeID, employeeID, intervalID, customerNumber, count, discount, date, deliveryID, storeID)
VALUES
    ('order001', 'in preparation', 1, '17:00', 'route001', 'emp001', NULL, 'Cust001', 1, 0, '2024-05-05', 'delivery001', 'store001'),
    ('order002', 'shipped', 0, NULL, 'route002', 'emp002', NULL, 'Cust001', 1, 0, '2024-05-06', 'delivery002', 'store001'),
    ('order003', 'shipped', 1, NULL, 'route003', 'emp003', NULL, 'Cust002', 1, 0, '2024-05-07', 'delivery003', 'store002'),
    ('order004', 'in preparation', 0, NULL, 'route004', 'emp004', NULL, 'Cust002', 1, 0, '2024-05-08', 'delivery004', 'store002'),
    ('order005', 'in preparation', 0, '17:00', 'route001', 'emp005', NULL, 'Cust003', 1, 0, '2024-05-09', 'delivery001', 'store001'),
    ('order006', 'in preparation', 1, '17:00', 'route002', 'emp006', NULL, 'Cust003', 1, 0, '2024-05-10', 'delivery002', 'store001'),
    ('order007', 'shipped', 1, NULL, 'route003', 'emp007', NULL, 'Cust004', 1, 0, '2024-05-11', 'delivery003', 'store002'),
    ('order008', 'shipped', 0, NULL, 'route004', 'emp008', NULL, 'Cust004', 1, 0, '2024-05-12', 'delivery004', 'store002'),
    ('order009', 'in preparation', 0, NULL, 'route001', 'emp009', NULL, 'Cust005', 1, 0, '2024-05-13', 'delivery001', 'store001'),
    ('order010', 'in preparation', 1, NULL, 'route002', 'emp010', NULL, 'Cust005', 1, 0, '2024-05-14', 'delivery002', 'store001'),
    ('order011', 'in preparation', 0, '17:00', 'route003', 'emp011', NULL, 'Cust006', 1, 0, '2024-05-15', 'delivery003', 'store002'),
    ('order012', 'in preparation', 1, NULL, 'route004', 'emp012', NULL, 'Cust006', 1, 0, '2024-05-16', 'delivery004', 'store002'),
    ('order013', 'shipped', 1, NULL, 'route001', 'emp013', NULL, 'Cust007', 1, 0, '2024-05-17', 'delivery001', 'store001'),
    ('order014', 'in preparation', 0, NULL, 'route002', 'emp014', NULL, 'Cust007', 1, 0, '2024-05-18', 'delivery002', 'store001'),
    ('order015', 'in preparation', 0, NULL, 'route003', 'emp015', NULL, 'Cust008', 1, 0, '2024-05-19', 'delivery003', 'store002'),
    ('order016', 'in preparation', 1, '17:00', 'route004', 'emp016', NULL, 'Cust008', 1, 0, '2024-05-20', 'delivery004', 'store002'),
    ('order017', 'in preparation', 1, NULL, 'route001', 'emp017', NULL, 'Cust009', 1, 0, '2024-05-21', 'delivery001', 'store001'),
    ('order018', 'shipped', 0, '17:00', 'route002', 'emp018', NULL, 'Cust009', 1, 0, '2024-05-22', 'delivery002', 'store001'),
    ('order019', 'shipped', 0, NULL, 'route003', 'emp019', NULL, 'Cust010', 1, 0, '2024-05-23', 'delivery003', 'store002'),
    ('order020', 'shipped', 1, NULL, 'route004', 'emp020', NULL, 'Cust010', 1, 0, '2024-05-24', 'delivery004', 'store002');

-- Intervals for Store 001
INSERT INTO Interval (intervalID, date, startTime, duration, storeID)
VALUES
    ('interval001', '2024-05-05', '09:00', '02:00', 'store001'),
    ('interval002', '2024-05-06', '10:00', '02:00', 'store001');

-- Intervals for Store 002
INSERT INTO Interval (intervalID, date, startTime, duration, storeID)
VALUES
    ('interval003', '2024-05-07', '11:00', '02:00', 'store002'),
    ('interval004', '2024-05-08', '12:00', '02:00', 'store002');

-- Collectors for Store 001
INSERT INTO Collector (employeeID, name, phoneNumber, ordersPerHour, storeID)
VALUES
    ('emp001', 'John Collector', '555-1111', 10, 'store001'),
    ('emp002', 'Jane Collector', '555-2222', 8, 'store001');

-- Collectors for Store 002
INSERT INTO Collector (employeeID, name, phoneNumber, ordersPerHour, storeID)
VALUES
    ('emp003', 'Bob Collector', '555-3333', 12, 'store002'),
    ('emp004', 'Alice Collector', '555-4444', 9, 'store002');

-- Assigning collectors to intervals
INSERT INTO WorkingAt (employeeID, intervalID)
VALUES
    ('emp001', 'interval001'),
    ('emp002', 'interval001'),
    ('emp002', 'interval002'),
    ('emp003', 'interval003'),
    ('emp003', 'interval004'),
    ('emp004', 'interval003');

-- Create boxes for storing products
INSERT INTO Box (number, temperature, orderID)
VALUES
    ('box001', 4.0, 'order001'),
    ('box002', 3.5, 'order002'),
    ('box003', 4.0, 'order003'),
    ('box004', 3.5, 'order004'),
    ('box005', 4.0, 'order005'),
    ('box006', 3.5, 'order006'),
    ('box007', 4.0, 'order007'),
    ('box008', 3.5, 'order008'),
    ('box009', 4.0, 'order009'),
    ('box010', 3.5, 'order010');

 -- Create diets
INSERT INTO Diet (dietType)
VALUES
    ('Lactose-Free'),
    ('Vegan'),
    ('Gluten-Free'),
    ('Keto'),
    ('Low-Sodium');

-- Assign diets to products
INSERT INTO DietOf (dietType, productID)
VALUES
    ('Lactose-Free', 'prod001'),
    ('Keto', 'prod002'),
    ('Gluten-Free', 'prod003'),
    ('Keto', 'prod004');

-- Create replacement information
INSERT INTO ReplacedInfo (replacementID, replacementProduct, replacedProduct)
VALUES
    -- Customer 001
    ('replace001', 'prod002', 'prod001'),
    -- Customer 003
    ('replace002', 'prod006', 'prod005'),
    -- Customer 006
    ('replace003', 'prod006', 'prod005'),
    -- Customer 007
    ('replace004', 'prod004', 'prod003'),
    -- Customer 009
    ('replace005', 'prod002', 'prod001'),
    -- Customer 010
    ('replace006', 'prod006', 'prod005');

INSERT INTO StoredIn (number, productID, weight, amount, material)
VALUES
    ('box001', 'prod001', 1.5, 10, 'Plastic'),
    ('box002', 'prod002', 1.0, 20, 'Cardboard'),
    ('box003', 'prod003', 2.0, 15, 'Metal'),
    ('box001', 'prod004', 1.8, 8, 'Plastic'),
    ('box002', 'prod005', 1.2, 12, 'Cardboard'),
    ('box003', 'prod006', 2.5, 5, 'Metal');

INSERT INTO InOrder (orderID, productID, quantity)
VALUES
    ('order001', 'prod001', 2),
    ('order001', 'prod002', 3),
    ('order002', 'prod003', 1),
    ('order002', 'prod004', 2),
    ('order003', 'prod005', 1),
    ('order003', 'prod006', 1),
    ('order004', 'prod001', 3),
    ('order004', 'prod002', 2),
    ('order005', 'prod003', 1),
    ('order005', 'prod004', 1),
    ('order006', 'prod005', 2),
    ('order006', 'prod006', 3),
    ('order007', 'prod001', 1),
    ('order007', 'prod002', 2),
    ('order008', 'prod003', 2),
    ('order008', 'prod004', 1),
    ('order009', 'prod005', 3),
    ('order009', 'prod006', 2),
    ('order010', 'prod001', 2),
    ('order010', 'prod002', 3);

INSERT INTO ReplacementOf (replacementID, orderID)
VALUES
    ('replace001', 'order001'),
    ('replace002', 'order003'),
    ('replace003', 'order006'),
    ('replace004', 'order007'),
    ('replace005', 'order009'),
    ('replace006', 'order010');


-- Typical queries
SELECT SUM(price*quantity)
FROM Orderr NATURAL JOIN (InOrder NATURAL JOIN Products)
WHERE orderID = 'order001';

SELECT *
FROM Orderr
WHERE orderID = 'order001'; 

SELECT SUM(duration)
FROM Interval NATURAL JOIN (WorkingAt NATURAL JOIN Collector ) 
WHERE employeeID = 'emp001' AND date >= DATE('now', '-30 day'); 

SELECT time, date, price
FROM OldPrice 
WHERE productID = 'prod001';

SELECT productID
FROM (SELECT productID, COUNT(quantity) AS C
    FROM Orderr NATURAL JOIN (InOrder NATURAL JOIN Products) 
    WHERE name = 'Milk'
    GROUP BY productID
    ORDER BY C DESC
    LIMIT 1);

SELECT routeID, COUNT(*)
FROM Orderr
WHERE storeID = 'store001' AND date >= DATE('now', '-30 day')
GROUP BY routeID;

SELECT storeID, Count(orderID)
FROM Store NATURAL JOIN Orderr
WHERE date >= DATE('now', '-30 day')
GROUP BY storeID;

SELECT deliveryTime, COUNT(*)
FROM Orderr 
WHERE status = 'in preparation'
GROUP BY deliveryTime;

SELECT productID, name
FROM Products NATURAL JOIN SelectionOf
WHERE inStock = 1 AND storeID = 'store001';

SELECT productID
FROM (Products NATURAL JOIN DietOf) NATURAL JOIN SelectionOf
WHERE name = 'Milk' AND dietType = 'Lactose-Free' AND inStock = 1 AND storeID = 'order001';

SELECT *
FROM Products 
WHERE name = 'Milk';

SELECT COUNT(*)
FROM Products
WHERE name = 'Bread';

SELECT replacedProduct
FROM ReplacedInfo NATURAL JOIN ReplacementOf
WHERE orderID = 'order001';

SELECT COUNT(*)
FROM Collector AS C JOIN Store AS S ON C.storeID = S.storeID
WHERE C.storeID  = 'store001';

SELECT productID, storeID, name, storeID
FROM (DietOf NATURAL JOIN SelectionOf) NATURAL JOIN Products
WHERE dietType = 'Lactose-Free';


-- Indexing
CREATE INDEX EmployeeIndex1 ON Collector(name);
CREATE INDEX EmployeeIndex2 ON Collector(employeeID);

CREATE INDEX ProductIndex1 ON Products(name);
CREATE INDEX ProductIndex2 ON Products(productID);

CREATE INDEX OrderIndex ON Orderr(orderID);

CREATE INDEX RouteIndex ON Route(routeID);

CREATE INDEX CustomerIndex ON Customer(customerNumber);


-- View definition
CREATE VIEW CustomersProducts AS
SELECT Products.productID, name, customerNumber
FROM Products NATURAL JOIN (InOrder NATURAL JOIN (Orderr NATURAL JOIN OrderOf))
WHERE Orderr.status = 'in preparation';
