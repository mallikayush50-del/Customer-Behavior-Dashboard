select * from customer 
limit 20;


-- 1 what is the total a revenue genrated by male vs female customer?
select gender,sum(purchase_amount) as revenue from customer
group by gender;

--Q2 which customers used a discount but still spent more than the average purchase amount?
SELECT customer_id,purchase_amount ,(select AVG(purchase_amount) from customer) as AVG from customer
where discount_applied='Yes' and purchase_amount >=(select AVG(purchase_amount) from customer)

--Q3 which are the top 5 products with the highest average review rating?
SELECT item_purchased,ROUND(avg(review_rating),2)as "Average review rating" from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

--Q4 comapre the average purchase amount between standard and express shipping?

select shipping_type ,ROUND(avg(purchase_amount),2)as  "Average purchase amount" from customer
where shipping_type IN ('Express' , 'Standard')
group by shipping_type;

--Q5 Do subscribed customers spend more?comapare average spend and 
--total revenue between subscribers and non-subscribers
select subscription_status,count(customer_id) as total_customer,ROUND(avg(purchase_amount),2) as average ,sum(purchase_amount) as total_revenue
from customer
where subscription_status IN ('Yes','No')
group by subscription_status;

--Q6 which 5 products have the highest percentage of purchase with discount applied?
select item_purchased,
ROUND(sum(case when discount_applied ='Yes' then 1 else 0 end) * 100/count(*),2) as discount_rate from customer
group by item_purchased
order by discount_rate desc
limit 5;

--Q7 segment customers into new,returning, and loyal based on 
--thier total number of previous purchases and show the count of each segment.
with customer_type as(
select customer_id,previous_purchases,
case when previous_purchases =1 then 'New'
     when previous_purchases between 2 and 10 then 'returning'
	 else 'Loyal'
	 End as "customer_segment"
	 from customer
	 )
select customer_segment,count(*) from customer_type
group by customer_segment
order by count(*) desc;

--Q8 What are the top 3 most purchased product within each category?
with item_count as (
select category,item_purchased,count(customer_id) as total_customer,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category,item_purchased
)
select item_rank,category,item_purchased,total_customer
from item_count
where item_rank <=3;


--Q9 Are customers who are repeat buyers (more than 5 previous purchases) also
--likey to subscribe?
SELECT subscription_status,count(customer_id) as repeat_buyers from customer
where previous_purchases > 5
group by subscription_status;

--what is the revenue contribution of each age group?
select age_group,sum(purchase_amount) as revenue
from customer
group by age_group
order by revenue desc;

