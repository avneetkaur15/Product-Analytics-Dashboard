CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product VARCHAR(100),
    category VARCHAR(100),
    cost_price NUMERIC(10,2),
    sale_price NUMERIC(10,2),
    brand VARCHAR(100),
    description TEXT,
    image_url TEXT
);

CREATE TABLE product_sales (
    date DATE,
    customer_type VARCHAR(50),
    country VARCHAR(100),
    product_id VARCHAR(10),
    discount_band VARCHAR(20),
    units_sold INT
);

CREATE TABLE discount_rates (
    month VARCHAR(20),
    discount_band VARCHAR(20),
    discount INT
);


with cte as (
select 
	p.product_id,
	p.product,
	p.category,
	p.brand,
	p.cost_price,
	p.sale_price,
	p.description,
	p.image_url,
	ps.date,
	ps.customer_type,
	ps.country,
	ps.discount_band,
	ps.units_sold,
	(sale_price * units_sold) as Revenue,
	(cost_price * units_sold) as Total_Cost,
	to_char(date,'Month') as month,
	to_char(date,'YYYY') as year
from products p
join product_sales ps
on p.product_id = ps.product_id)

select 
	c.*,
	dr.discount,
	round((1-discount::numeric/100)*revenue,6) as discount_revenue,
	(round((1-discount::numeric/100)*revenue,6)-Total_cost) as profit
from cte c
join discount_rates dr 
on trim(c.month) = trim(dr.month) and trim(lower(c.discount_band)) = trim(lower(dr.discount_band))
