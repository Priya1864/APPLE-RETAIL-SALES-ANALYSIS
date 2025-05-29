create table category(category_id varchar(20) primary key,	category_name varchar(32));
select*from category;
create table store(store_id varchar(20) primary key,store_name varchar(70),	city varchar(50),	country varchar(50));
select*from store;
drop table if exists warranty;
create table products(product_id varchar(10) primary key,	product_name varchar(100),	category_id	 varchar(50),constraint fk foreign key (category_id) references category(category_id),launch_date date,	price decimal);
select*from products;
create table sales(sales_id VARCHAR(20) primary key,	sale_date DATE,	store_id  VARCHAR (20),constraint fk foreign key (store_id) references store(store_id),product_id VARCHAR(20),
constraint fm foreign key (product_id) references products(product_id),quantity INT);
select*from sales;
CREATE TABLE WARRANTY(claim_id VARCHAR(10) primary key,	claim_date DATE,	sales_id VARCHAR(20),constraint fk foreign key (sales_id) references sales(sales_id)	,repair_status VARCHAR(50));
select*from warranty;
DELETE FROM WARRANTY;



SELECT 
    w.claim_id,
    w.claim_date,
    s.sale_date,
    (w.claim_date - s.sale_date) AS days_difference
FROM 
    warranty w
JOIN 
    sales s ON w.sales_id = s.sales_id
ORDER BY 
    days_difference desc ;


SELECT 
    COUNT(*) AS total_claims,
    MIN(c.claim_date - s.sale_date) AS min_days,
    MAX(c.claim_date - s.sale_date) AS max_days,
    AVG(c.claim_date - s.sale_date) AS avg_days
FROM warranty c
JOIN sales s ON c.sales_id = s.sales_id;



SELECT 
    CASE 
        WHEN (c.claim_date - s.sale_date) <= 90 THEN '0-90 days'
        WHEN (c.claim_date - s.sale_date) <= 180 THEN '91-180 days'
        WHEN (c.claim_date - s.sale_date) <= 270 THEN '181-270 days'
        ELSE '271-365 days'
    END AS claim_bucket,
    COUNT(*) AS total_claims
FROM warranty c
JOIN sales s ON c.sales_id = s.sales_id
GROUP BY claim_bucket
ORDER BY claim_bucket;



SELECT 
    c.claim_id,
    s.sales_id,
    s.sale_date,
    c.claim_date,
    (c.claim_date - s.sale_date) AS days_to_claim
FROM warranty c
JOIN sales s ON c.sales_id = s.sales_id
WHERE (c.claim_date - s.sale_date) <= 90;








select *from sales
where product_id='p-44';--64milisec
create index salesproductid on  sales(product_id);

select *from sales
where store_id='ST-32'; --470
create index salesstoreid on sales(store_id);
create index salessaledate on sales(sale_date);




---find the no of stores in each country
select country,count(*) as noofstores from store
group by 1
order by 2 desc;

--calculated the total no of units sold by each store
select store_name,country,sum(quantity) as sold from store s
join sales ss
on s.store_id=ss.store_id
group by 1,2
order by 3 desc;


--identitfy how many sales occured in dec 2023
select  count(*) as salesoccured,to_char ( sale_date,'mm-yyyy') as month  from sales
where  to_char( sale_date,'mm-yyyy') ='11-2016' 
group by 2;

--determine how many stores have never had warranty claim feild;
select  count(*) as store from store 
where store_id not in(select  distinct store_id from sales s join warranty w
on s.sales_id=w.sales_id);


----calculated the percentage of waraanty claims marked as 'warranty void'
--no of claims that as/total_claim 
select  repair_status ,round(count(claim_id) /(select count(*) from warranty)::numeric*100.0 ,2) as qwarrantitypercentage
from warranty
where repair_status='Pending'
group by 1;

select repair_status,round(count(claim_id)/(select count(*) from warranty)::numeric*100.0 ,2)as percentage from warranty
group by 1;



--identityfy which store had the highest total units sold in the last year
select  ss.store_id,store_name,sum(quantity) as unitsold,city  from store s
 left join sales ss
 on s.store_id=ss.store_id
 where sale_date>=current_date -interval '1 year'
 group by 1,2,4
 order by 3 desc
 limit 1;


--count the number of unique products sold in last year
select count(distinct product_id) as sold from sales 
where sale_date>=current_date-interval '1year';



--find the avg price  of products for each category
select  p.category_id,category_name,round(avg(price) ,2)as avgprice from products p
join category c on c.category_id=p.category_id
group by 1,2
order by 3 desc;

----how many warranty claims were filed in 2020??
select count(distinct claim_id),claim_date from warranty
where extract(year from claim_date)=2020
group by 2;

--for each store identify the best-selling day based on highest quantity sold
 select * from(select *,rank() over(partition by store_id order by sold desc) as rnk from(select store_id,sum(quantity) as sold ,to_char(sale_date,'day') from sales
group by 1,3
order by 1, 2 desc) t) m
where rnk=1;



--identityfy the latest selling product in each country for each year based on  units sold

WITH productrank AS (
  SELECT 
    ss.country,
    EXTRACT(YEAR FROM s.sale_date) AS year,
    p.product_name,
    SUM(s.quantity) AS units_sold,
    RANK() OVER (
      PARTITION BY ss.country, EXTRACT(YEAR FROM s.sale_date) 
      ORDER BY SUM(s.quantity) DESC
    ) AS rnk
  FROM sales s
  JOIN products p ON p.product_id = s.product_id
  JOIN store ss ON s.store_id = ss.store_id
  GROUP BY ss.country, year, p.product_name
)
SELECT *
FROM productrank
WHERE rnk = 1;



---calculate how many warrantyclaims were field withing 180days of product_sale
select count(*) as warrantyclaims from warranty w
 left join sales s
on s.sales_id=w.sales_id
where claim_date-sale_date<=180

--determine the how many warranty claims filled for products launced in last two year
select product_name,count(claim_id) as noofclaim ,count(s.sales_id) as sales from warranty w 
  right join sales s
on s.sales_id=w.sales_id
join products  p
on p.product_id=s.product_id
where launch_date>=current_date - interval '2 years'
group by 1

---list the months in the last three years where sales exceeded 5000 uints in the usa
select  to_char(sale_date,'mm-yyyy') as month  ,sum(quantity) as sold from sales s join store ss
on s.store_id=ss.store_id
where country='USA' and sale_date >=current_date -interval '3 year'  
group by 1
having sum(quantity)>5000;
--identify the product category with the most warranty claims filed in the last two years.
select cc.category_name,count(claim_id)  as claims from sales s
join warranty w
on s.sales_id=w.sales_id
join products p
on p.product_id=s.product_id
join category cc
on p.category_id=cc.category_id
where claim_date>=current_date-interval'2year'
group by 1
order by 2 desc;



--determine the percentage chance of receving warranty claims after each purchases for each country

WITH country_sales AS (
  SELECT ss.country, SUM(s.quantity) AS total_sold
  FROM sales s
  JOIN store ss ON s.store_id = ss.store_id
  GROUP BY ss.country
),
claims_data AS (
  SELECT ss.country, COUNT(w.claim_id) AS claims
  FROM warranty w
  JOIN sales s ON s.sales_id = w.sales_id
  JOIN store ss ON s.store_id = ss.store_id
  GROUP BY ss.country
)
SELECT 
  cs.country,
  cd.claims,
  cs.total_sold,
  ROUND(cd.claims::NUMERIC / cs.total_sold * 100.0, 2) AS percentage
FROM country_sales cs
LEFT JOIN claims_data cd ON cs.country = cd.country
ORDER BY percentage DESC;


--analysze the year by year growth ratio fpr each store
select *,round((currentyearsale-lastyear)::numeric/lastyear::numeric*100.0 ,2)as growthratio 
from(select*,lag(currentyearsale,1) over(partition by store_name order by year) as lastyear 
from(select store_name ,extract(year from sale_date) as year ,sum(quantity*price) as currentyearsale from sales s
join store ss
on s.store_id=ss.store_id
join products p
on p.product_id=s.product_id
group by 1,2
order by 1,2)t)m
where lastyear is not null and year<>extract(year from current_date);



---calculated the correlations between product price and warranty claims for products sold in the last five years segemented by price range
select  count(claim_id ) as claims,
case when price<500 then 'less expensive product' when price between 500 and 1000 then 'mid range product' else 'expensive product' 
end as pricerange  from warranty w
 left join sales s
on s.sales_id=w.sales_id
join products p
on p.product_id=s.product_id
where claim_date>=current_date-interval'5year'
group by 2;


---identify the store with the highest percentage of paidrepaired claims realative to total claims filled
with paid as(select  s.store_id,count( claim_id) as totalpaidclaims from sales s
right join warranty w
on s.sales_id=w.sales_id
join store ss
on s.store_id=ss.store_id
where repair_status='Completed'
group by 1),
totalclaims as(select s.store_id,count( claim_id) as totalclaims from sales s
right join warranty w
on s.sales_id=w.sales_id
join store ss
on s.store_id=ss.store_id
group by 1)
select t.store_id, ss.store_name,t.totalclaims,m.totalpaidclaims ,round(m.totalpaidclaims::numeric/t.totalclaims::numeric*100.0,2) as pct 
from  paid m join totalclaims t on m.store_id=t.store_id
join store ss
on ss.store_id=t.store_id
order by  5 desc;


----write a query to calculated the monthly running total of sales for each store
with montlysales as(select  s.store_id,extract(year from sale_date) as year , extract(month from sale_date) as  month,
sum(quantity*price) as totalsales  from sales s
join store ss
on s.store_id=ss.store_id
join products p on p.product_id=s.product_id
group by 1,2,3
order by 1,2,3)
select store_id,month,year,totalsales,
sum(totalsales) over(partition by store_id order by year,month) as runningtotal from montlysales;


--analyze productsales trends over time,segmented into key products from launch  to 6 months,6-12 months,12-18 months 
-- Analyze product sales trends over time segmented into launch periods
SELECT 
    product_name,
    CASE 
        WHEN sale_date BETWEEN launch_date AND launch_date + INTERVAL '6 month' THEN '0-6 months'
        WHEN sale_date BETWEEN launch_date + INTERVAL '6 month' AND launch_date + INTERVAL '12 month' THEN '6-12 months'
        WHEN sale_date BETWEEN launch_date + INTERVAL '12 month' AND launch_date + INTERVAL '18 month' THEN '12-18 months'
        ELSE '18+' 
    END AS plc,
    SUM(quantity) AS productsold
FROM sales s
JOIN products p ON p.product_id = s.product_id
GROUP BY product_name, plc
ORDER BY product_name, productsold DESC;












