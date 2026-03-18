-- Monday Coffee -- Data analysis-- 

select * from customers;
select * from city;
select * from products;
select * from sales;

-- Question 1 -- find count of coffee customers in each city --
--  Analysis - top 5 cities in coffee customers is 1. Delhi 2. Mumbai 3. Kolkata 4.Bangalore 5. Chennai--    
select city_name,
 round(
 (population*0.25)/1000000,
 2) as coffee_customer_in_millions,
 city_rank
from city
order by  2 desc;


--  Question 2 - Total revenue from Coffee sales-- 
--  Analysis - top cities in coffee revenue is 
-- 1. Pune
-- 2. chennai
-- 3. Bangalore
-- 4. jaipur 
-- 5. Delhi--
select 
c.city_name,
sum(s.total)as Total_Revenue
from sales s
join customers cu
on s.customer_id=cu.customer_id
join city c
on cu.city_id=c.city_id
 where extract(year from s.sale_date)= 2023
	and extract(quarter from s.sale_date) = 4
group by c.city_name
order by sum(total) desc;

-- Question 3 - Count of Sales per Product--
-- Analysis  top 10 products with most sales
-- 1. Cold Brew Coffee Pack (6 Bottles)--
-- 2. Cold Brew Coffee Pack (6 Bottles)--
-- 3. Instant Coffee Powder (100g)--
-- 4. Coffee Beans (500g)-- 
-- 5. Tote Bag with Coffee Design-- 
-- 6. Vanilla Coffee Syrup (250ml)--
-- 7. Coffee Art Print-- 
-- 8. Organic Green Coffee Beans (500g)-- 
-- 9. Cold Brew Concentrate (500ml) -- 
-- 10. Flavored Coffee Pods (Pack of 10)-- 

select P.product_name , count(s.sale_id) as Sales_Count 
from products P
join sales s 
on p.product_id=s.product_id
group by P.product_name
order by Sales_Count desc;

-- Question 4  - Average Sales per city -
-- what is the average sales amount per customer in each city? --
-- Top 5 cities per  average sales amount per customer is 
-- 1. Pune
-- 2. Chennai
-- 3. Bangalore
-- 4. Jaipur
-- 5. Delhi --
select 
c.city_name,
sum(s.total)as Total_Revenue,
count(distinct s.customer_id) as Total_Customers,
round(sum(s.total)/count(distinct s.customer_id),2) as Avg_revenue_per_customer
from sales s
join customers cu
on s.customer_id=cu.customer_id
join city c
on cu.city_id=c.city_id
group by c.city_name
order by sum(total) desc;

-- Question 5  Top selling Products by City --
-- what are top 3 selling products per city  -- 
-- Top 4 produncts in most cities are 
-- 1. Cold Brew Coffee Pack (6 Bottles)
-- 2. Ground Espresso Coffee (250g)
-- 3. Instant Coffee Powder (100g)
-- 4. Coffee Beans (500g)-- 

select *
from 
	(select ci.city_name,
		p.product_name,
		count(s.sale_id) Total_orders,
		dense_rank() over(partition by ci.city_name  order by count(s.sale_id)  desc ) as  rnk 
	from sales s 
	join customers c 
	on c.customer_id=s.customer_id
	join city ci
	on ci.city_id=c.city_id
	join products p 
	on p.product_id = s.product_id
	group by ci.city_name, p.product_name)
as t1 
where rnk <= 3 ;

-- Question 6 - customer segmentation by city 
-- how many unique customers are there in each city
 select ci.city_name,
		count(distinct c.customer_id) Unique_customers
 from city ci 
	join customers c
	on ci.city_id=c.city_id
	join sales s
    on c.customer_id = s.customer_id
    join products p 
	on p.product_id = s.product_id
    where s.product_id in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
    group by ci.city_name 
    ;
    
    -- Question 7  Average sale vs Rent 
    -- find each city , their avg rent and avg sale--
    
    select ci.city_name,
		avg(s.total) Average_sales,
        ci.estimated_rent Average_rent
    from city ci 
    join customers c 
    on c.city_id = ci.city_id
    join sales s 
    on  s.customer_id= c.customer_id
    group by ci.city_name , ci.estimated_rent;
    
    -- Question 8  Monthly Growth Rate 
    -- Sales growth rate : calculate the growth or decline over a different period of time monthly 
    
    select ci.city_name,
   -- extract(month from s.sale_date) Month,
    extract(year from s.sale_date) Year,
    avg(s.total) Avg_sales
    from sales s
    join customers c 
    on c.customer_id=s.customer_id
    join city ci
    on ci.city_id=c.city_id
    group by ci.city_name,extract(month from s.sale_date),extract(year from s.sale_date)
    order by ci.city_name,extract(year from s.sale_date),extract(month from s.sale_date);
    
    
    -- Recommendation 
    -- City 1 : Pune 
    -- Reason 1- Avg rent per customer is very less
    --        2- Pune has highest total revenue
    --        3- Avg sale per customer is also high 
    --  City 2 : Delhi 
    --  Reason 1- Highest coffee consumers whidh is 7.7 millions 
    --         2- Highest total customers which is 69
    --         3- Avg rent per customer is low ie 330 rupees
    --  City 3 : Chennai
    -- Reason 1-  Avg sale per cussstomer is high ie) 22500
    --        2-  High population of coffee consumers ie) 2.75 million 
    --        3.  Rent is comparitively low than other cities.