--total revenue by male vs female
select gender,sum(purchase_amount) as total_revenue
from customer
group by gender
order by total_revenue desc;
select * from customer;
--which customer used discount but still spend more than average 
select customer_id,purchase_amount
from customer
where discount_applied='Yes' and purchase_amount>=
(SELECT round(avg(purchase_amount),2) FROM customer);

--Top 5 produch with highest average review rating
select item_purchased,round(avg(review_rating::numeric),2) as avg_rating
from customer
group by item_purchased
order by avg_rating desc
limit 5;
--Compare the average purchase amount between Standard and Express Shipping
select shipping_type,round(avg(purchase_amount),2)
from customer
where shipping_type in('Standard','Express')
group by shipping_type;

--Q5. Do subscribed customers spend more? Compare average spend and total revenue 
--between subscribers and non-subscribers.
select subscription_status,count(customer_id) as customers
,sum(purchase_amount) as revenue,round(avg(purchase_amount),2) as avg_spend
from customer
group by subscription_status;

--Q6. Which 5 products have the highest percentage of purchases with discounts applied?
SELECT item_purchased,
round(100*sum(case when discount_applied='Yes' then 1 else 0 end)/count(*),2) as discount_percent
from customer
group by item_purchased
order by discount_percent desc
limit 5;

--Q7. Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 
with customer_type as (
select customer_id,previous_purchases,
case
when previous_purchases=1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from customer 
)
select customer_segment,count(customer_id)
from customer_type
group by customer_segment;

--Q8. What are the top 3 most purchased products within each category? 
with item_count as(
select item_purchased,category,count(customer_id) as total_orders,
ROW_NUMBER()OVER(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category,item_purchased)
select item_rank,category,total_orders
from item_count 
where item_rank<=3;

--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status,count(customer_id)
from customer
where previous_purchases>5
group by subscription_status;

--Q10. What is the revenue contribution of each age group? 
select age_group,sum(purchase_amount) as total_revenue 
from customer
group by age_group
order by total_revenue desc;


