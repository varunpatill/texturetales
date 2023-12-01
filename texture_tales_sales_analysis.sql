use texture_tales;

SELECT * FROM texture_tales.product_details;
SELECT * FROM texture_tales.product_hierarchy;
SELECT * FROM texture_tales.product_prices;
SELECT * FROM texture_tales.sales;

-- 1. What was the total quantity sold for all products?

select s.prod_id,pd.product_name,sum(s.qty) as sales_count from sales s join product_details pd 
on s.prod_id = pd.product_id
group by pd.product_name,s.prod_id
order by sales_count desc; 

-- 2. What is the total generated revenue for all products before discounts?

select sum(price*qty) as total_revenue_before_discounts from sales;

-- 3. What was the total discount amount for all products?

select sum(price*qty*discount) as total_discount_amount from sales;

-- 4. How many unique transactions were there?

select count(distinct txn_id) as total_unique_transactions from sales;

-- 5. What are the average unique products purchased in each transaction?

with cte_transcation as (
	select txn_id, count(distinct prod_id) as product_count from sales group by txn_id)
    select round(avg(product_count)) as average_unique_products_purchased from cte_transcation;
    
-- 6. What is the average discount value per transaction?

with cte_avg_transaction as (
	select txn_id, sum(price*qty*discount)/100 as total_avg_discount from sales group by txn_id)
    select round(avg(total_avg_discount)) as average_discount_value_per_transaction from cte_avg_transaction;
    
-- 7. What is the average revenue for member transactions and nonmember transactions?

with cte_avg_transaction as (
	select member,txn_id, sum(price*qty) as revenue from sales group by member,txn_id)
    select member,round(avg(revenue),2) as average_revenue_for_meeber_non_member from cte_avg_transaction
    group by member;
    
-- 8. What are the top 3 products by total revenue before discount?

select pd.product_name,sum(s.price*s.qty) as total_revenue from sales s
join product_details pd on pd.product_id = s.prod_id
group by pd.product_name
order by 2 desc limit 3;

-- 9. What are the total quantity, revenue and discount for each segment?

select pd.segment_name,sum(s.qty) as total_quantity, sum(s.price*s.qty) as total_revenue,sum(s.qty*s.price*s.discount)/100 as total_discount
from product_details pd join sales s on pd.product_id = s.prod_id
group by pd.segment_name
order by total_revenue ;

-- 10. What is the top selling product for each segment?

select pd.product_name, sum(s.qty*s.price) as total_revenue from product_details pd
join sales s  on pd.product_id = s.prod_id
group by pd.product_name
order by 2 desc
limit 1;

-- 11. What are the total quantity, revenue and discount for each category?

select pd.category_name,sum(s.qty) as total_quantity, sum(s.price*s.qty) as total_revenue,sum(s.qty*s.price*s.discount)/100 as total_discount
from product_details pd join sales s on pd.product_id = s.prod_id
group by pd.category_name
order by total_revenue desc;

-- 12. What is the top selling product for each category?

select pd.category_name, sum(s.qty*s.price) as total_revenue from product_details pd
join sales s  on pd.product_id = s.prod_id
group by pd.category_name
order by 2 desc;