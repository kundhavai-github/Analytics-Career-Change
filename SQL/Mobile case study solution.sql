--SQL Advance Case Study

SELECT * from DIM_MANUFACTURER
SELECT * from DIM_MODEL
SELECT * from DIM_CUSTOMER
SELECT * from DIM_LOCATION
SELECT * from DIM_DATE
SELECT * from FACT_TRANSACTIONS


--Q1--BEGIN 
--List all the states in which we have customers who have bought cellphones from 2005 till today. 	

select distinct state from DIM_LOCATION l inner join FACT_TRANSACTIONS f on f.IDLocation = l.IDLocation
where year(f.Date) >= 2005 and year(getdate()) = 2022

--Q1--END

--Q2--BEGIN
--What state in the US is buying the most 'Samsung' cell phones
select top 1 state, sum(f.Quantity)[Sum of Qty] from DIM_LOCATION l
inner join FACT_TRANSACTIONS f on f.IDLocation=l.IDLocation
inner join DIM_MODEL m on m.IDModel = f.IDModel
inner join DIM_MANUFACTURER dm on m.IDManufacturer = dm.IDManufacturer
where dm.Manufacturer_Name ='Samsung' and l.Country = 'US'
group by l.State
Order by [Sum of Qty] desc
--Q2--END

--Q3--BEGIN      
--Show the number of transactions for each model per zip code per state.	
select m.Model_Name,l.State,l.ZipCode,count(f.IDCustomer)[Transaction Count] from DIM_LOCATION l 
inner join FACT_TRANSACTIONS f on f.IDLocation = l.IDLocation
inner join DIM_MODEL m on m.IDModel = f.IDModel
group by l.State,l.ZipCode,m.Model_Name

--Q3--END

--Q4--BEGIN
--Show the cheapest cellphone (Output should contain the price also)
select top 1 dm.Manufacturer_Name,m.Model_Name,min(f.TotalPrice)[Price] from DIM_LOCATION l 
inner join FACT_TRANSACTIONS f on f.IDLocation = l.IDLocation
inner join DIM_MODEL m on m.IDModel = f.IDModel
inner join DIM_MANUFACTURER dm on m.IDManufacturer = dm.IDManufacturer
group by m.Model_Name,dm.Manufacturer_Name
order by min(f.TotalPrice)
--Q4--END

--Q5--BEGIN
--Find out the average price for each model in the top5 manufacturers in 
--terms of sales quantity and order by average price.
select m.IDModel,avg(m.Unit_price)[Average Price] from DIM_LOCATION l 
inner join FACT_TRANSACTIONS f on f.IDLocation = l.IDLocation
inner join DIM_MODEL m on m.IDModel = f.IDModel
inner join DIM_MANUFACTURER dm on m.IDManufacturer = dm.IDManufacturer
where dm.Manufacturer_Name in 
(select top 5 mr.Manufacturer_Name from FACT_TRANSACTIONS ft
inner join DIM_MODEL mo on mo.IDModel = ft.IDModel inner join 
DIM_MANUFACTURER mr on mo.IDManufacturer = mr.IDManufacturer
group by mr.Manufacturer_Name
order by sum(ft.Quantity)
)
group by m.IDModel
order by [Average Price] 

--Q5--END

--Q6--BEGIN
--List the names of the customers and the average amount spent in 2009, 
--where the average is higher than 500
select c.Customer_Name,avg(f.TotalPrice)[Average Price > 500] from DIM_CUSTOMER c inner join FACT_TRANSACTIONS f
on f.IDCustomer = c.IDCustomer
where year(f.date) = 2009
group by c.Customer_Name
having avg(f.TotalPrice) > 500
order by avg(f.TotalPrice) desc

--Q6--END
	
--Q7--BEGIN  
--List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010	
select * from 
(SELECT TOP 5 Manufacturer_name
    FROM Fact_Transactions T1
    inner JOIN DIM_Model D1 ON T1.IDModel = D1.IDModel
    inner JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2008' 
    group by Manufacturer_name, Quantity 
    Order by  SUM(Quantity ) DESC  

    intersect

SELECT  TOP 5 Manufacturer_name
    FROM Fact_Transactions T1
    inner JOIN DIM_Model D1 ON T1.IDModel = D1.IDModel
    inner JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2009' 
    group by Manufacturer_name, Quantity 
    Order by  SUM(Quantity ) DESC  

    intersect

SELECT TOP 5 Manufacturer_name
    FROM Fact_Transactions T1
    inner JOIN DIM_Model D1 ON T1.IDModel = D1.IDModel
    inner JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2010' 
    group by Manufacturer_name, Quantity 
    Order by  SUM(Quantity ) DESC)	as A

--Q7--END	
--Q8--BEGIN

--Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010. 
SELECT  top 1 * 
 from
    (SELECT 
    TOP 2 Manufacturer_name,
    SUM(Quantity )  [2009 Sales]
    FROM Fact_Transactions T1
    LEFT JOIN DIM_Model D1 ON T1.IDModel = D1.IDModel
    LEFT JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2009' 
    group by Manufacturer_name, Quantity 
    Order by  SUM(Quantity ) DESC ) as A,


        (SELECT 
    Top 2 Manufacturer_name,
     SUM(Quantity ) [2010 sales]
    FROM Fact_Transactions T2
    LEFT JOIN DIM_Model DM ON T2.IDModel = DM.IDModel
    LEFT JOIN DIM_MANUFACTURER DM2  ON DM2.IDManufacturer = DM.IDManufacturer
    Where DATEPART(Year,date)='2010' 
    group by Manufacturer_name,Quantity
    Order by  SUM(Quantity )DESC ) as B


--Q8--END
--Q9--BEGIN
--Show the manufacturers that sold cellphones in 2010 but did not in 2009.
select Manufacturer_Name from FACT_TRANSACTIONS f inner join DIM_MODEL m on f.IDModel = m.IDModel
inner join DIM_MANUFACTURER dm on m.IDManufacturer = dm.IDManufacturer
where year(f.date) = 2010
except
select Manufacturer_Name from FACT_TRANSACTIONS f inner join DIM_MODEL m on f.IDModel = m.IDModel
inner join DIM_MANUFACTURER dm on m.IDManufacturer = dm.IDManufacturer
where year(f.date) = 2009
--Q9--END

--Q10--BEGIN
 --Find top 100 customers and their average spend, average quantity by each 
--year. Also find the percentage of change in their spend.	


















--Q10--END
	