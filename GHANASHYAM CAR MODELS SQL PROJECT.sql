use modelcarsdb;

/*------------*Part 1: Customer and Office Data Analysis--------------*/

 /* Task 1: Customer Data Analysis */
 
 /* a.Total number of customers*/
 select count(*) as Total_Customers
 from customers;
/*Interpretation: The total number of customers in the database is 122 */

/*b.Top 10 customers by credit limit*/
select CustomerName,Creditlimit
from customers
order by Creditlimit desc
limit 10;
/*Interpretation: In this task we identified the top 10 customers with the highest credit limits.
The customer 'Euro+ Shopping Channel' has the highest credit limit and that is 227600 */

/*c.Average credit limit for customers in each country*/
select country,avg(Creditlimit) as Average_Credit_Limit
from customers
group by country;

/*Interpretation: In this task we found the average credit limit for customers in each country.The country France has the highest
credit limit among the all country and that is 77691.66.*/

/*d.Total number of customers in each state. */
select state ,count(*) as Total_Customers_In_State
from customers
group by state;
/*Interpretation:In this task we analyzed the distribution of customers across states.*/

/*e.Customer information with contact details. */
select customerName,contactFirstName,contactLastName,phone,AddressLine1,city,state,country,postalCode
from customers;
/*Interpretation: Here we etrieved detailed customer information with contact details.*/

/*f.Customers who haven't placed any orders. */
select customerName
from customers
where customerNumber not in (select distinct customerNumber from orders);
/*Interpretation: Here we identified customers who haven't placed any orders.*/

/*g.Total sales for each customer.*/
select c.customerName,c.customerNumber,sum(od.quantityOrdered*od.priceEach) as Total_Sales
from customers c
join orders o join orderdetails od
on c.customerNumber=o.customerNumber
and o.orderNumber=od.orderNumber
group by customerNumber,c.customerName
order by Total_Sales desc;

/*Interpretation: We calculated total sales for each customer.The customer 'Euro+ Shopping Channel' has the highest total 
sales and is 820689.54 and he customer 'Boards & Toys Co.' has the lowest total sales and is 7918.60 */

/*h.List of customers with their assigned sales representatives. */
select c.CustomerName, e.FirstName AS SalesRepFirstName, e.LastName AS SalesRepLastName
FROM Customers c
join Employees e ON c.SalesRepEmployeeNumber = e.EmployeeNumber; 

/*Interpretation:We have listed customers with their assigned sales representatives.*/

/*i.Customer information with their most recent payment details. */
select c.customerName, p.checkNumber, p.paymentDate, p.amount
from customers c
join payments p ON c.CustomerNumber = p.CustomerNumber
order by p.paymentDate desc
limit 5;
/*Interpretation: We have retrieved customer information with their most recent payment details.
The customer 'Reims Collectables' has the highest amount in most recent payment details and is 46656.94 .*/

/*j.Customers who have exceeded their credit limit. */
select CustomerName, CreditLimit, Amount
from Customers
join Payments ON Customers.CustomerNumber = Payments.CustomerNumber
group by CustomerName,CreditLimit,Amount
having CreditLimit < SUM(Amount);
/*Interpretation: In this task we  identified customers who have exceeded their credit limit.The customer
'Dragon Souveniers, Ltd.' have exceeded the credit limit and it's credit limit is 103800. */

/*k.Names of all customers who have placed an order for a product from a specific product line. */
select distinct c.CustomerName
from Customers c
join Orders o ON c.CustomerNumber = o.CustomerNumber
join OrderDetails od ON o.OrderNumber = od.OrderNumber
join Products p ON od.ProductCode = p.ProductCode
join ProductLines pl ON p.ProductLine = pl.ProductLine
where pl.ProductLine= 'Ships';
/*Interpretation: We found names of customers who ordered from 'Ships' productline */


/*l.Names of all customers who have placed an order for the most expensive product. */
select distinct c.CustomerName,p.BuyPrice 
from Customers c
join Orders o ON c.CustomerNumber = o.CustomerNumber
join OrderDetails od ON o.OrderNumber = od.OrderNumber
join Products p ON od.ProductCode = p.ProductCode
order by p.BuyPrice desc
limit 1;
/*Interpretation: We identified customers who ordered the most expensive product and the customer 'Baane Mini Imports'
has ordered the most expensive product and its ordered price 103.42. */

/*m.Names of all customers who work for the same office as their sales representative. */
select c.CustomerName, e.FirstName AS SalesRepFirstName, e.LastName AS SalesRepLastName
from Customers c
join Employees e ON c.SalesRepEmployeeNumber = e.EmployeeNumber;
/*Interpretation: In this task we found customers working in the same office as their sales representative.*/

/*-----------------------Summary of Task 1 Interpretations-------------------
In the customer data analysis, we found that there are a total of 122 customers in the database. 
The top 10 customers with the highest credit limits were identified, with 'Euro+ Shopping Channel' having the 
highest limit at 227,600. 
We also calculated the average credit limit for customers in each country, revealing that France has the 
highest average credit limit among all countries at 77,691.66. 
We analyzed the distribution of customers across states and retrieved detailed customer information, 
including those who haven't placed any orders. 
Total sales for each customer were calculated, and 'Euro+ Shopping Channel' had the highest total sales at 820,689.54. 
The analysis included listing customers with their assigned sales representatives and retrieving customer information
with their most recent payment details. 
'Reims Collectables' had the highest amount in the most recent payment details at 46,656.94. 
Customers who exceeded their credit limit, ordered from the 'Ships' product line, and the one who ordered 
the most expensive product were also identified. 
Lastly, we found customers working in the same office as their sales representative, providing insights 
into customer-sales representative relationships.
*/

/*Task 2: Office Data Analysis */
/*a.List of  all offices with their basic information. */
select * from Offices;
/*Interpretation: Here we provided basic information on all offices.*/

/*b.Number of employees working in each office*/
select OfficeCode, COUNT(*) AS Number_of_Employees
from Employees
group by OfficeCode;
/*Interpretation:Here we counted the number of employees in each office.The office code having 1 has maximum number of
employeses and that is 6.*/

/*c.Offices with less than a certain number of employees*/
select OfficeCode, COUNT(*) AS Num_of_employees
from Employees
group by OfficeCode
having Num_of_employees < 4;
/*Interpretation:The office code having 2,3,5 and 7 has less than 4 number of employees. */

/*d.List of offices along with their assigned territories.*/
select o.OfficeCode,o.Territory
from Offices o;
/*Interpretations:we have listed offices along with their assigned territories.*/

/*e. Offices that have no employees assigned to them.*/
select o.OfficeCode
from Offices o
join Employees e ON o.OfficeCode = e.OfficeCode
where e.EmployeeNumber IS NULL;
/*Interpretation:From this task we found all the offices are assigned with certain number of employees.*/

/*f.The most profitable office based on total sales. */
select o.OfficeCode, o.City, SUM(od.QuantityOrdered * od.PriceEach) AS Total_Sales
from Offices o
join Employees e ON o.OfficeCode = e.OfficeCode
join Customers c ON e.EmployeeNumber = c.SalesRepEmployeeNumber
join Orders odr ON c.CustomerNumber = odr.CustomerNumber
join OrderDetails od ON odr.OrderNumber = od.OrderNumber
group by o.OfficeCode, o.City
order by  Total_Sales desc
limit 1;
/*Interpretation:The office code having 4 is the most profitable office based on total sales who belongs to Paris and 
it's total sales is 3083761.58.*/

/*g.Total number of offices*/
select COUNT(*) as Number_of_offices
from Offices;
/*Interpretation:From this task we found there are total 7 offices in the database.*/

/*h.Office with the highest number of employees*/
select OfficeCode, COUNT(*) as emp_count
from Employees
group by OfficeCode
order by emp_count desc
limit 1;
/*Interpretation:We found the office with the highest number of employees.The office code having 1 has the 
highest number of employees and is 6.*/

/*i.Average credit limit for customers in each office*/
select e.OfficeCode, avg(c.CreditLimit) as Avg_Credit_Limit
from Employees e
join Customers c ON e.EmployeeNumber = c.SalesRepEmployeeNumber
group by e.OfficeCode;
/*Interpretation: Here we calculated the average credit limit for customers in each office.The office code 4 has
the highest average credit limit and is 82924.13 .The office code 2 has the lowest average credit limit and is 77725.*/

/*j.Number of offices in each country.*/
select Country, COUNT(distinct OfficeCode) AS Num_of_offices
from Offices o
group by Country
order by Num_of_offices desc ;
/*Interpretation: Here we found number of offices in each country.USA has the maximum number of offices and is 3.*/

/*---------------------------------Summary of Task 2-------------------------------------
In looking at the office data, we first got basic details about all the offices. 
Then,we checked how many employees work in each office, finding that some offices have fewer than four employees. 
We also saw the territories assigned to each office.
The most profitable office, based on total sales, is in Paris with Office Code 4.
Overall, there are 7 offices in the database. 
The office with Code 1 has the most employees. 
We also figured out the average credit limit for customers in each office, showing differences between offices.
Lastly, we saw that the USA has the most offices.
This information helps the company make smart decisions about its offices.
*/


/*---------------------------Part 2 -------------------------*/
  /*Task 1: Employee Data Analysis */
  
/*a.Total number of employees*/
select COUNT(*) AS Total_Num_of_Emps
from Employees;
/*Interpretation:Here we found total number of employees.There are 23 employees are working .*/

/*b.Number of employees in each office. */
select OfficeCode, COUNT(*) AS Number_of_employees
from Employees
group by  OfficeCode;
/*Interpretation: Here We counted the number of employees in each office.The office code 1 has the maximum number of
employees and is 6.*/

/*c.List of all employees with their basic information. */
select *from Employees;
/*Interpretation:In the task we listed all employees with their basic information.*/

/*d.Number of employees holding each job title*/
select JobTitle, COUNT(*) AS Emp_Count
from Employees
group by JobTitle 
order by Emp_Count desc;
/*Interpretation:Here also we counted the number of employees holding each job title.The job title 'Sales Rep' has 
the maximum numer of employees and is 17.All the other job title has only one employee. */

/*e.Employees who don't have a manager*/
select *from Employees
where ReportsTo is null;
/*Interpretation:Here identified employees who don't have a manager.The employee number 1002 has don't have manager.*/

/*f.List of employees along with their assigned offices. */
select e.EmployeeNumber, e.FirstName, e.LastName, e.JobTitle, o.OfficeCode, o.City
from Employees e
join Offices o ON e.OfficeCode = o.OfficeCode;
/*Interpretation:In this task we have listed employees along with their assigned offices.*/

/*g.Sales representatives with the highest number of customers.*/
select concat(e.FirstName,' ',e.LastName) as Full_name,COUNT(c.CustomerNumber) AS CustomerCount
from Employees e
JOIN Customers c ON e.EmployeeNumber = c.SalesRepEmployeeNumber
where e.JobTitle = 'Sales Rep'
group by e.EmployeeNumber
order by CustomerCount desc
limit 1;
/*Interpretation:Here we identified sales representatives with the highest number of customers.The sales representatives
'Pamela Castillo' has the highest number of employees and is 10.*/

/*h.Most profitable sales representative based on total sales. */
select concat(e.FirstName,' ',e.LastName) as Full_name,SUM(od.QuantityOrdered * od.PriceEach) AS Total_Sales
from Employees e
join Customers c ON e.EmployeeNumber = c.SalesRepEmployeeNumber
join Orders o ON c.CustomerNumber = o.CustomerNumber
join OrderDetails od ON o.OrderNumber = od.OrderNumber
group by e.EmployeeNumber
order by Total_Sales desc
limit 1;
/*Interpretation:In this task we found the most profitable sales representative based on total sales.The sales representative 
'Gerard Hernandez' is most the profitable representative and it's total sales is 125877.81.*/

/*i.Names of all employees who have sold more than the average sales amount for their office.*/
select e.FirstName, e.LastName
from Employees e
join Customers c ON e.EmployeeNumber = c.SalesRepEmployeeNumber
join Orders o ON c.CustomerNumber = o.CustomerNumber
join OrderDetails od ON o.OrderNumber = od.OrderNumber
group by e.EmployeeNumber
having SUM(od.QuantityOrdered * od.PriceEach) > AVG(od.QuantityOrdered * od.PriceEach);
/*Interpretation:Here we identified employees who sold more than the average sales amount for their office.*/

/*---------------------------------------Summary of Task 1------------------------------
We looked at employee data and found there are 23 employees in total. 
Office Code 1 has the most employees with 6. 
We listed all employees and counted how many have each job title, with 'Sales Rep' being the most common (17 employees).
We also found an employee (number 1002) without a manager. The list includes employees and their offices.
For sales reps, 'Pamela Castillo' has the most customers (10), and 'Gerard Hernandez' is the top performer with $125,877.81 in total sales. 
Lastly, we found employees who sold more than the average for their office. 
These insights help the company understand its workforce and make informed decisions.


/*  Task 2: Product Data Analysis  */

/*a.List of all products with their basic information. */
select *from Products;
/*Interpretation:Here we have listed all products with their basic information.*/

/*b.List of all products with their product lines information. */
select p.*, pl.ProductLine
from Products p
join ProductLines pl ON p.ProductLine = pl.ProductLine;
/*Interpretation:Here we have listed all products with their product lines information.*/

/*c.Number of products in each product line. */
 select ProductLine, COUNT(*) AS Product_Count
from Products
group by ProductLine
order by Product_Count desc;
/*Interpretation:Here we counted the number of products in each product line.The product line 'Classic Cars' has the 
highest number of products and is 38.The product line 'Trains' has the lowest number of products and is 3.*/

/*d. Product line with the highest average product price.*/
select ProductLine, avg(BuyPrice) AS Avg_Product_Price
from Products
group by ProductLine
order by  Avg_Product_Price desc
limit 1;
/*Interpretations:Here we found the product line with the highest average product price.The product line 'Classic Cars' has the 
product line with highest average product price and is 64.44.*/

/*e.Products with a price above or below a certain amount (MSRP should be between 50 and 100). */
select *from Products
where MSRP between 50 and 100;
/*Interpretations:Here we found products with a price between 50 and 100.*/

/*f.Total sales amount for each product line*/
select p.ProductLine, SUM(od.QuantityOrdered * od.PriceEach) AS Total_Sales
from Products p
join OrderDetails od ON p.ProductCode = od.ProductCode
group by p.ProductLine
order by Total_Sales desc;
/*Interpretation:Here we  calculated total sales amount for each product line.The product line 'Classic Cars' has the highest 
total_sales and is 3853922.49.*/

/*g.Products with low inventory levels (less than a specific threshold value 10 of quantityInStock). */
select *from Products
where QuantityInStock < 10;
/*Interpretation:Here we have tried to found products with less than quantity of 10.But there are no products based 
on this condition.*/

/*h.List of products along with their descriptions.*/
 select ProductCode, ProductName, ProductDescription
from Products;
/*Interpretation:Here we are showing list of products along with their descriptions.*/

/*i.The most expensive product based on MSRP. */
select *from Products
order by MSRP desc
limit 1;
/*Interpretation:Here we identified most expensive product based on MSRP.The product code 'S10_1949'  has 
the most expensive product and it's MSRP is 241.30.*/

/*j.Total sales for each product. */
select p.ProductCode, p.ProductName, SUM(od.QuantityOrdered * od.PriceEach) AS Total_Sales
from Products p
join OrderDetails od ON p.ProductCode = od.ProductCode
group by p.ProductCode, p.ProductName
order by Total_Sales desc;
/*Interpretation:Here we are calculated total sales for each product. The product code 'S18_3232' has the highest 
total sales and is 276839.98.*/


/*k.Best-selling products based on total sales. */
select p.ProductCode, p.ProductName, SUM(od.QuantityOrdered) AS TotalUnitsSold
from Products p
join OrderDetails od ON p.ProductCode = od.ProductCode
group by p.ProductCode, p.ProductName
order by TotalUnitsSold desc
limit 10;
/*Interpretation:Here we identified the best-selling products based on total sales.The product code 'S18_3232'
has the based selling products and the total 1808 number of units are sold for this code.*/

/*l.Most profitable product line based on total sales. */
select p.ProductLine, SUM(od.QuantityOrdered * od.PriceEach) AS Total_Sales
from Products p
join OrderDetails od ON p.ProductCode = od.ProductCode
group by p.ProductLine
order by Total_Sales desc
limit 1;
/*Interpretation:Here we identified the most profitable product line.The product line 'Classic Cars' is the most profitable
product line and its' total sales is 3853922.49.*/

/*m.Best-selling product within each product line. */
select p.ProductLine, p.ProductName, SUM(od.QuantityOrdered) AS Quantity_sold
from Products p
join OrderDetails od ON p.ProductCode = od.ProductCode
group by p.ProductLine, p.ProductName
order by Quantity_sold desc;
/*Interpretation:Here we found the best-selling product within each product line.*/

/*n.Products with low inventory levels (less than a threshold value 10 of quantityInStock) 
within specific product lines ('Classic Cars', 'Motorcycles').*/
select *from Products
where QuantityInStock < 10 and  ProductLine in ('Classic Cars', 'Motorcycles');
/*Interpretations: Here we have tried to phase some information less than 10 number of products and the product line 
are in 'Classic Cars' and 'Motorcycles'.Based on this conditon we have not found any information.*/

/*o.Names of all products that have been ordered by more than 10 customers .*/
select p.ProductCode, p.ProductName
from Products p
join OrderDetails od ON p.ProductCode = od.ProductCode
join Orders o ON od.OrderNumber = o.OrderNumber
group by p.ProductCode, p.ProductName
having count(distinct o.CustomerNumber) > 10;
/*Interpretation:Here we have found products ordered by more than 10 customers.*/

/*p.Names of all products that have been ordered more than the average number of orders */
select p.ProductCode, p.ProductName
from Products p
join OrderDetails od ON p.ProductCode = od.ProductCode
group by p.ProductCode, p.ProductName
having count(od.OrderNumber) > (select avg(Order_Count) from (select ProductCode, count(distinct OrderNumber) AS Order_Count 
from OrderDetails group by ProductCode) AS Avg_Orders_Per_Product);
/*Interpretation:Here we found names of all products that have been ordered more than the average number of orders */

/*---------------------------------Summary of Task 2----------------------------------
In the analysis of product data, we first listed all products with their basic information and then provided 
details on each product line. 
We counted the number of products in each product line, with 'Classic Cars' having the most (38). 
We identified the product line with the highest average price, which turned out to be 'Classic Cars' as well. 
Products with prices between 50 and 100 were listed. 
Total sales for each product line were calculated, revealing 'Classic Cars' as the highest-selling category. 
We looked for products with low inventory (less than 10), but none were found. 
The most expensive product based on MSRP was identified as 'S10_1949.' 
Total sales for each product and the best-selling products were determined. 
The most profitable product line was 'Classic Cars.' Additionally, we found the best-selling product within 
ach product line. While attempting to identify low-inventory products in specific lines ('Classic Cars' and 'Motorcycles'),
 no information was found. Finally, we listed products ordered by more than 10 customers and products ordered more than 
 the average number of orders. 
 These findings offer valuable insights into product performance, sales, and inventory levels.


/*-----------------------Part 3--------------------*/
 /*Task 1: Order Data Analysis */
 
 /*a.List of all orders with their basic information */
 select *from Orders;
 /*Interpretation:Here we have listed of all orders with their basic information .*/
 
 /*b.All order details for a particular order (order number=12345). */
 select *
from OrderDetails
where OrderNumber = 10101;
/*Interpretation:Here we have tried to found all order details of order number =10101.*/

/*c. All order details for a particular product. */
select *
from OrderDetails
where ProductCode = 'S24_3969';
/*Interpretation:Here we have tried to found all order details of product code ='S24_3969'.*/

/*d.Total quantity ordered for a particular product */
SELECT ProductCode, SUM(QuantityOrdered) AS Total_quantity_ordered
FROM OrderDetails
WHERE ProductCode = 'S10_1949'
GROUP BY ProductCode;
/*Interpretation: Here we found total quantity ordered of product code='S10_1949'.*/

/*e.All orders placed on a particular date . */
select *from Orders
where OrderDate = '2003-02-17';
/*Interpretation:Here we have found all orders placed on order date '2003-02-17'.*/

/*f.All orders placed by a particular customer.*/
select *from Orders
where CustomerNumber = 148;
/*Interpretation:Here we have found all orders placed by CustomerNumber = 148.*/


/*g.Find the total number of orders placed in a particular month */
select COUNT(*) AS TotalOrders
from Orders
where OrderDate between '2003-04-02' and '2003-05-02';
/*Interpretation:Here we found the total number of orders placed from '2003-04-02' to '2003-05-02'.*/

/*h.Average order amount for each customer. */
select c.customerNumber,avg(QuantityOrdered * PriceEach) as avg_amount
from customers c
join orders o join orderdetails od
on c.customerNumber=o.customerNumber
and o.orderNumber=od.orderNumber
group by c.customerNumber
order by avg_amount desc ;
/*Interpretation:Here we found  the average order amount for each customer.The customer number 455 has the highest 
average amount and that is 4139.92*/

/*i.Number of orders placed in each month*/
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Month
order by Total_Orders desc;
/*Interpretation:Here found number of orders placed in each month.In the month november of year 2004 has the 
highest orders and is 33.*/

/*j.Orders that are still pending shipment */
select *from Orders
where Status = 'In Process';
/*Interpretaion:Here we identified orders which are pending.*/

/*k.List of orders along with customer details. */
select o.*, c.*
from Orders o
join Customers c ON o.CustomerNumber = c.CustomerNumber;
/*Interpretations:Here we have listed orders along with customer details.*/

/*l.Most recent orders (based on order date). */
select *from Orders
order by OrderDate desc
limit 5;
/*Interpretation:Here we have found most recent orders.The most orders are in between order date '2005-05-31'and '2005-06-08'.*/


/*m.Total sales for each order */
select OrderNumber, SUM(QuantityOrdered * PriceEach) AS Total_Sales
from OrderDetails
group by OrderNumber
order by Total_Sales desc;

/*Interpretation: Here we have found total sales for each order.The order number4 10165 has the highest total sales and 
is 67392.85*/

/*n.Highest-value order based on total sales */
select OrderNumber, SUM(QuantityOrdered * PriceEach) AS Total_Sales
FROM OrderDetails
group by OrderNumber
order by Total_Sales desc
limit 1;
/*Interpretation:Here we have found the highest-value order based on total sales.The order number 10165
has the highest total sales and is 67392.85.*/

/*o.List of all orders with their corresponding order details */
select o.*, od.*
from Orders o
join OrderDetails od ON o.OrderNumber = od.OrderNumber;
/*Interpretation:Here we have listed ll orders with their corresponding order details */

/*p.List of the most frequently ordered products.*/
select ProductCode, COUNT(*) AS OrderCount
from OrderDetails
group by ProductCode
order by OrderCount desc
limit 10;
/*Interpretation:Here we have found most frequently ordered products.The product code 'S18_3232'
has the maximum orders and is 53.*/
 
 /*q.Total revenue for each order.*/
 select OrderNumber, SUM(QuantityOrdered * PriceEach) AS Total_Revenue
from OrderDetails
group by OrderNumber
order by Total_Revenue desc;
/*Interpretation:Here ae have found total revenue for each order.The order number 10165 has the highest total revenue 
and is 67392.85.*/


/*r.Most profitable orders based on total revenue.*/
select OrderNumber, SUM(QuantityOrdered * PriceEach) AS TotalRevenue
from OrderDetails
group by OrderNumber
order by TotalRevenue desc
limit 5;
/*Interpretation:Here we found most profitable orders based on total revenue.The order number 10165 has 
the highest total revenue and is 67392.85 */

/*s.List of all orders with detailed product information. */
select o.OrderNumber, o.OrderDate, od.*
from Orders o
join OrderDetails od ON o.OrderNumber = od.OrderNumber;
/*Interpretation:Here we have listed of all orders with detailed product information.*/

/*t.Orders with delayed shipping */
select *from Orders
where ShippedDate > RequiredDate;
/*Interpretation:Here we found orders with delayed shippig.The order number 10165 has deplayed shipping.*/

/*u.Most popular product combinations within orders.*/
select odr1.ProductCode AS Product_1, odr2.ProductCode AS Product_2, COUNT(*) AS Num_of_order
from OrderDetails odr1
join OrderDetails odr2 ON odr1.OrderNumber = odr2.OrderNumber AND odr1.ProductCode < odr2.ProductCode
group by Product_1, Product_2
order by Num_of_order desc
limit 10;
/*Interpretation:Here we have found most popular product combinations within orders.The product code 'S50_1341'
and 'S700_1691' has the highest number of order and is 28.*/

/*v.Revenue for each order and identifying the top 10 most profitable. */
select  OrderNumber, SUM(QuantityOrdered * PriceEach) AS Total_Revenue
from OrderDetails
group by OrderNumber
order by Total_Revenue desc
limit 10;
/*Interpretation:Here we found revenue for each order and identified the top 10 most profitable.The
order number 10165 has the highest total revenue among this 10 most profitable order number  and is 67392.85.*/

/*---------------------------------------Summary of Task 1-----------------------------------
In the order data analysis, we thoroughly examined various aspects.
We started by listing all orders and exploring specific ones like order number 10101 and product code 'S24_3969.' 
We calculated total quantities, checked orders on specific dates or by certain customers, and found the highest 
average order amount for customer number 455. 
Monthly order counts, pending shipments, and detailed customer order lists were also covered. 
We delved into the most recent orders, total sales per order, and identified high-value and profitable orders. 
The analysis included insights into frequently ordered products, delayed shipments, and popular product combinations. 
Finally, we assessed revenue for each order, highlighting the top 10 most profitable ones. 
Overall, this analysis provides a comprehensive view of order trends, customer behaviors, and revenue patterns.































