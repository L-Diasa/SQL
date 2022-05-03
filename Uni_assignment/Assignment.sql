 -- Northwoods University Desig - First Part

create database NorthwoodsDatabase

use NorthwoodsDatabase
create table Students(
  ID int primary key,
  name varchar(50),
  stdAddress varchar(50),
  mobileNum varchar(50),
  stdClass varchar(15) not null check(stdClass in('freshman', 'sophomore', 'junior', 'senior')),
  stdDOB date,
  PIN int,
  stdAdvisor varchar(20)
)

use NorthwoodsDatabase
create table Courses(
	ID int not null primary key,
	callNumber varchar(10),
	name varchar (20),
	courseCredit int,
	location varchar(50),
	courseDuration varchar(50),
	maxEnrollment int,
	instructorId int foreign key references Instructors(ID),
	offeredTerm varchar (50),
)

use NorthwoodsDatabase
create table Instructors(
	ID int not null primary key,
	name varchar (20),
	officeLocation varchar(30),
	mobileNum varchar (20),
	rank varchar (30),
	PIN int
)

use NorthwoodsDatabase
create table StdCourseData(
	ID int not null primary key identity,
	StdID int foreign key references Students(ID),
	CourseId int foreign key references Courses(ID),
	Grade float
)

-- Simple Querie - Second Part

-- 2.1
select descriptions, category from alp_item

-- 2.2
select item_id, item_size, price, quantity_on_hand from alp_inventory
where price < 100

-- 2.3
select item_id, price, quantity_on_hand from alp_inventory
where quantity_on_hand > 30

-- 2.4
select firstname, lastname, mi, city from alp_customer
where city = 'Washburn' or city = 'Silver Lake'

-- 2.5
select distinct price from alp_inventory

-- 2.6
select inv_id, price, quantity_on_hand from alp_inventory
where quantity_on_hand > 0

-- 2.7
select order_id, order_date from alp_orders
where order_date < '2007/11/01'

-- 2.8
select item_id, quantity_on_hand from alp_inventory
where alp_color = 'Coral' or alp_color = 'Olive' and quantity_on_hand < 105

-- 2.9
select * from alp_item
where descriptions like '%Fleece%'

-- 2.10
select item_id, price from alp_inventory
where item_size is NULL or alp_color is NULL

-- 2.11
select COUNT(order_id) from alp_orders
where order_date = '2007/11/10'

-- 2.12
select order_id, inv_id, sum(order_price*qty) as ExtPrice
from alp_orderline
group by order_id, inv_id

-- 2.13
select order_id, COUNT(distinct item_id) from alp_orderline as o
join alp_inventory as i
on o.inv_id = i.inv_id
Group by order_id

-- 2.14
select distinct o.cust_id, Count(order_id) as orders from alp_orders as o
join alp_customer as c
on o.cust_id = c.cust_id
group by o.cust_id
having Count(order_id) > 1

-- 2.15
select order_id, (order_price * qty) as orderTotal from alp_orderline
where (order_price * qty)>100
order by orderTotal asc

-- 2.16
select Min(price) as minimum, max(price) as maximum, avg(price) as average from alp_inventory

-- 2.17
select * from alp_inventory
where price > (select avg(price) from alp_inventory)


-- dvanced Queries - Third Part

-- 3.1
select inv_id, alp_color from alp_inventory
where alp_color = (select alp_color from alp_inventory
where inv_id = 23)

-- 3.2
select inv_id, price from alp_inventory -- maybe fixme
where price > (select avg(price) from alp_inventory)

-- 3.3
select inv_id, descriptions, item_size, alp_color, price
from alp_inventory as inv
left join alp_item as it
on inv.item_id = it.item_id

-- 3.4
select * from alp_orders
select * from alp_customer

select order_id, order_date, firstname
from alp_orders as o
join alp_customer as c
on o.cust_id = c.cust_id

-- 3.5
select ord.order_id, order_date
from alp_orders as ord
join alp_orderline as ordlin
on ord.order_id = ordlin.order_id
join alp_inventory as inv
on inv.inv_id = ordlin.inv_id
join alp_item as item
on item.item_id = inv.item_id
where item.descriptions = 'Men''s Expedition Parka'

-- 3.6
select i.inv_id, (order_price*qty) as extPrice, quantity_on_hand
from alp_orderline as o
right join alp_inventory  as i
on o.inv_id = i.inv_id
where order_id = 6

-- 3.7
select item_id,SUM(quantity_on_hand) as TOTal from alp_inventory
group by item_id


-- 3.8
select distinct inv_id, SUM(qty) as TotalQuantitySold
from alp_orderline
group by inv_id

-- 3.9
select orders.order_id,firstname, SUM(order_price) as totalPrice
from alp_orders as orders
inner join alp_orderline as line
on orders.order_id = line.order_id
inner join alp_customer as cust
on orders.cust_id = cust.cust_id
group by orders.order_id, firstname

-- 3.10
select * from alp_inventory
where inv_id not in (select inv_id from alp_shipping)

-- 3.11
select * from alp_inventory as i
full outer join alp_backorder as b
on i.inv_id = b.inv_id
where backorder_id is not NULL

-- 3.12
select firstname, lastname, (order_price*qty) as orderTotal
from alp_customer as c
join alp_orders as o
on c.cust_id = o.cust_id
join alp_orderline as ord
on ord.order_id = o.order_id
where o.order_id = 5

-- 3.13
select inv_id, descriptions, price, alp_color from alp_inventory as inv
join alp_item as i
on inv.item_id = i.item_id
where price = (select min(price) from alp_inventory)

-- 3.14
select * from alp_item
select * from alp_customer

select firstname, lastname, email, SUM(order_price*qty) as orderTotal
from alp_orders as ord
join alp_orderline as ordlin
on ord.order_id = ordlin.order_id
join alp_customer  as cust
on cust.cust_id = ord.cust_id
group by firstname, lastname, email

-- 3.15
select firstname, lastname, email, SUM(order_price*qty) as orderTotal
from alp_orders as ord
join alp_orderline as ordlin
on ord.order_id = ordlin.order_id
right join alp_customer  as cust
on cust.cust_id = ord.cust_id
group by firstname, lastname, email

-- Procedures and Triggers - Fourth Part

-- Procedure 1:
CREATE PROCEDURE sp_UpdateInventory
    @inv_id int,
    @qty int
AS
BEGIN
UPDATE dbo.alp_inventory SET quantity_on_hand += @qty WHERE inv_id = @inv_id
END
GO

-- Procedure 2:
CREATE PROCEDURE sp_InsertOrder
    @order_date date,
    @payment varchar(50),
    @cust_id int,
    @alp_ordersource varchar(50)
AS
BEGIN
INSERT INTO dbo.alp_orders values(@order_date, @payment, @cust_id, @alp_ordersource)
END

-- Procedure 3:
CREATE PROCEDURE sp_UpdateColor
    @old_color varchar(50),
    @new_color varchar(50)
AS
BEGIN
UPDATE dbo.alp_inventory SET alp_color = @new_color WHERE alp_color = @old_color
END
GO

-- Procedure 4:
CREATE PROCEDURE sp_CancelOrder
    @order_id int
AS
BEGIN
DELETE FROM dbo.alp_orders WHERE order_id = @order_id

END
GO

EXEC sp_CancelOrder 6
SELECT * FROM dbo.alp_orders
SELECT * FROM dbo.alp_orderline
GO

-- Procedure 5:
CREATE PROCEDURE sp_CalcOrderTotal
    @order_id int,
    @order_total decimal(6,2) OUTPUT
AS
BEGIN
SELECT @order_total = SUM(order_price) FROM dbo.alp_orderline WHERE order_id = @order_id
END
GO

DECLARE @Total decimal(6,2)
EXEC sp_CalcOrderTotal 5, @Total OUTPUT

PRINT @Total
GO

