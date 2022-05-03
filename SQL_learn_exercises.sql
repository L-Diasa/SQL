-- These are my solutions to problems on www.sql-ex.com

-- Exercise: 1 
-- Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
-- Result set: model, speed, hd.
SELECT model, speed, hd 
FROM PC 
WHERE price < 500

-- Exercise: 2 (Serge I: 2002-09-21)
-- List all printer makers. Result set: maker.
SELECT DISTINCT maker 
FROM Product
WHERE type='Printer'

-- Exercise: 3 (Serge I: 2002-09-30)
-- Find the model number, RAM and screen size of the laptops with prices over $1000.
SELECT model, ram, screen
FROM laptop
WHERE price > 1000

-- Exercise: 4 (Serge I: 2002-09-21)
-- Find all records from the Printer table containing data about color printers.
SELECT *
FROM printer
WHERE color = 'y'

-- Exercise: 5 (Serge I: 2002-09-30)
-- Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.
SELECT model, speed, hd
FROM pc
WHERE price < 600 AND (cd = '12x' OR cd = '24x')

-- xercise: 6 (Serge I: 2002-10-28)
-- For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.
SELECT DISTINCT Product.maker, Laptop.speed
FROM Product INNER JOIN
 Laptop ON Laptop.model = Product.model
WHERE Laptop.hd >= 10

-- Exercise: 7 (Serge I: 2002-11-02)
-- Get the models and prices for all commercially available products (of any type) produced by maker B.
SELECT Product.model, price
FROM Product INNER JOIN
 Laptop ON Laptop.model = Product.model
WHERE maker = 'B'
UNION
SELECT Product.model, price
FROM Product INNER JOIN
 PC ON PC.model = Product.model
WHERE maker = 'B'
UNION
SELECT Product.model, price
FROM Product INNER JOIN
 Printer ON Printer.model = Product.model
WHERE maker = 'B'

-- Exercise: 8 (Serge I: 2003-02-03)
-- Find the makers producing PCs but not laptops
SELECT maker from Product
WHERE type = 'PC'
EXCEPT
SELECT maker from Product
WHERE type = 'Laptop'

-- Exercise: 9 (Serge I: 2002-11-02)
-- Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.
SELECT DISTINCT maker 
FROM Product
JOIN 
 PC ON PC.model = Product.model
WHERE PC.speed >= 450

-- Exercise: 10 (Serge I: 2002-09-23)
-- Find the printer models having the highest price. Result set: model, price.
SELECT model, price
FROM printer
WHERE price = (SELECT MAX(price) 
 FROM printer
 )

-- Exercise: 11 (Serge I: 2002-11-02)
-- Find out the average speed of PCs.
SELECT AVG(speed) AS avg_speed 
FROM PC

-- Exercise: 12 (Serge I: 2002-11-02)
-- Find out the average speed of the laptops priced over $1000
SELECT AVG(speed)
FROM laptop
WHERE price > 1000

-- Exercise: 13 (Serge I: 2002-11-02)
-- Find out the average speed of the PCs produced by maker A.
SELECT AVG(speed) AS avg_speed
FROM PC 
JOIN Product
ON Product.model = PC.model
WHERE maker = 'A'

-- Exercise: 14 (Serge I: 2002-11-05)
-- For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
SELECT Ships.class, name, country
FROM Ships
INNER JOIN Classes
ON Classes.class = Ships.class
WHERE numGuns >= 10

-- Exercise: 15 (Serge I: 2003-02-03)
-- Get hard drive capacities that are identical for two or more PCs.
-- Result set: hd.
SELECT hd
FROM PC
GROUP BY hd
HAVING COUNT(hd) >= 2

-- Exercise: 16 (Serge I: 2003-02-03)
-- Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
-- Result set: model with the bigger number, model with the smaller number, speed, and RAM.
SELECT DISTINCT pc1.model, pc2.model, pc2.speed, pc2.ram
FROM pc pc1 , pc pc2
WHERE  pc1.speed=pc2.speed AND pc1.ram=pc2.ram AND pc1.model > pc2.model

-- Exercise: 17 (Serge I: 2003-02-03)
-- Get the laptop models that have a speed smaller than the speed of any PC.
-- Result set: type, model, speed.
SELECT DISTINCT type, l.model, l.speed
FROM Laptop l
JOIN Product p
ON l.model = p.model
WHERE l.speed < ALL(SELECT speed FROM PC)

-- Exercise: 18 (Serge I: 2003-02-03)
-- Find the makers of the cheapest color printers.
-- Result set: maker, price.
SELECT DISTINCT Product.maker, price
FROM printer
INNER JOIN Product ON
printer.model = product.model
WHERE price = 
   (SELECT MIN(price) FROM printer WHERE color = 'y')
AND color = 'y'

-- Exercise: 19 (Serge I: 2003-02-13)
-- For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
-- Result set: maker, average screen size.
SELECT maker, AVG(screen) AS avg_screen
FROM Product JOIN 
laptop on laptop.model = Product.model
GROUP BY maker

-- Exercise: 20 (Serge I: 2003-02-13)
-- Find the makers producing at least three distinct models of PCs.
-- Result set: maker, number of PC models.
SELECT maker, COUNT(DISTINCT model) AS count_model
FROM Product 
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(DISTINCT model) >= 3

-- Exercise: 21 (Serge I: 2003-02-13)
-- Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.
SELECT maker, MAX(price)
FROM Product
INNER JOIN PC ON PC.model = Product.model
GROUP BY maker

-- Exercise: 22 (Serge I: 2003-02-13)
-- For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
-- Result set: speed, average price.
SELECT speed, AVG(price)
FROM PC
Where speed > 600
GROUP BY speed

-- Exercise: 23 (Serge I: 2003-02-14)
-- Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
-- Result set: maker
SELECT maker
FROM Product
INNER JOIN PC ON product.model = PC.model
WHERE speed >= 750
INTERSECT
SELECT maker
FROM Product
INNER JOIN Laptop ON product.model = Laptop.model
WHERE speed >= 750

-- Exercise: 24 (Serge I: 2003-02-03)
-- List the models of any type having the highest price of all products present in the database.
With all_products AS(
SELECT model, price FROM pc 
UNION
SELECT model, price FROM laptop
UNION
SELECT model, price FROM Printer
)

SELECT model
FROM all_products
WHERE price = (SELECT MAX(price) FROM all_products)

-- Exercise: 25 (Serge I: 2003-02-14)
-- Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
-- Result set: maker.
SELECT DISTINCT maker
FROM product
WHERE type = 'printer'
AND maker IN(SELECT maker FROM product
WHERE model IN(SELECT model FROM PC
WHERE ram = (SELECT MIN(RAM) from PC)
AND
speed = (SELECT MAX(speed) FROM PC
WHERE RAM = (SELECT MIN(RAM) from PC)
)))

-- Exercise: 26 (Serge I: 2003-02-14)
-- Find out the average price of PCs and laptops produced by maker A.
-- Result set: one overall average price for all items.
SELECT AVG(price) AS AVG_price 
FROM
(SELECT price 
FROM PC 
INNER JOIN Product 
ON Product.model = PC.model 
WHERE maker='A'

UnIoN aLl

SELECT Laptop.price 
FROM Laptop 
INNER JOIN Product 
ON Product.model = Laptop.model 
WHERE maker='A'
) o_onEEdSnAMeT_T

-- Exercise: 27 (Serge I: 2003-02-03)
-- Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
-- Result set: maker, average HDD capacity.
SELECT maker, AVG(hd)
FROM Product
INNER JOIN PC
ON PC.model = Product.model
WHERE product.maker IN(SELECT maker FROM Product WHERE type = 'printer')
GROUP BY maker

-- Exercise: 28 (Serge I: 2012-05-04)
-- Using Product table, find out the number of makers who produce only one model.
SELECT COUNT(*) as qty FROM
(SELECT DISTINCT maker
FROM Product
GROUP BY maker
Having COUNT(model) = 1) makers

-- Exercise: 29 (Serge I: 2003-02-14)
-- Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense).
-- Use Income_o and Outcome_o tables.
SELECT
CASE
WHEN i.point IS NULL 
THEN o.point
ELSE i.point
END AS point,
CASE 
WHEN i.date IS NULL 
THEN o.date
ELSE i.date
END AS date,
inc AS income,
out AS expense
FROM Income_o i
FULL JOIN Outcome_o o
ON i.point = o.point AND i.date = o.date

-- Exercise: 30 (Serge I: 2003-02-14)
-- Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of times a day for each collection point [i.e. the code column is the primary key], display a table with one corresponding row for each operating date of each collection point.
-- Result set: point, date, total payout per day (out), total money intake per day (inc).
-- Missing values are considered to be NULL.

SELECT  
  CASE 
    WHEN a.point IS NULL THEN b.point 
    ELSE a.point 
  END AS point, 
  CASE 
    WHEN a.date IS NULL THEN b.date 
    ELSE a.date 
  END AS date, 
  payout, 
  intake
FROM(SELECT point, 
            date, 
            SUM(out) as payout
     FROM outcome
     GROUP BY point,date) a
FULL JOIN (SELECT point, 
           date, 
           SUM(inc) as intake
           FROM income
           GROUP BY point,date) b 
  ON b.date = a.date 
  AND b.point = a.point

-- Exercise: 31 (Serge I: 2002-10-22)
-- For ship classes with a gun caliber of 16 in. or more, display the class and the country.
SELECT class, country
FROM Classes
WHERE bore >=16

-- Exercise: 32 (Serge I: 2003-02-17)
-- One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw).
-- Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.
WITH mws AS
(SELECT country, (POWER(bores.bore, 3.0)/2.0) as mw
FROM (SELECT country, bore, name
FROM classes c
JOIN ships s
ON s.class = c.class
UNION
SELECT country, bore, ship
FROM classes c
JOIN Outcomes o
ON o.ship = c.class) bores
)
SELECT country, CAST(AVG(mw) AS NUMERIC(6,2))
FROM mws
GROUP BY country

-- Exercise: 33 (Serge I: 2002-11-02)
-- Get the ships sunk in the North Atlantic battle.
-- Result set: ship.
SELECT ship
FROM Outcomes
WHERE result = 'sunk' AND battle = 'North Atlantic'

-- Exercise: 34 (Serge I: 2002-11-04)
-- In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons.
-- Get the ships violating this treaty (only consider ships for which the year of launch is known).
-- List the names of the ships.
SELECT name
FROM ships
INNER JOIN classes
ON Classes.class = ships.class
WHERE launched >=1922 AND type = 'bb' AND displacement > 35000

-- Exercise: 35 (qwrqwr: 2012-11-23)
-- Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.
-- Result set: model, type.
SELECT model, type
FROM product
WHERE model NOT LIKE '%[^0-9]%' 
OR model NOT LIKE '%[^a-z]%'
OR model NOT LIKE '%[^A-Z]%'

-- Exercise: 36 (Serge I: 2003-02-17)
-- List the names of lead ships in the database (including the Outcomes table).
SELECT class 
FROM Ships
WHERE name=class
UNION
SELECT s.class 
FROM Classes s
INNER JOIN Outcomes o
ON o.ship = s.class

-- Exercise: 38 (Serge I: 2003-02-19)
-- Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’).
SELECT country
FROM classes 
WHERE type = 'bb'
INTERSECT
SELECT country
FROM classes 
WHERE type = 'bc'
