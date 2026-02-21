SELECT TOP (1000) [Customer_ID]
      ,[Age]
      ,[Gender]
      ,[Item_Purchased]
      ,[Category]
      ,[Purchase_Amount_USD]
      ,[Location]
      ,[Size]
      ,[Color]
      ,[Season]
      ,[Review_Rating]
      ,[Subscription_Status]
      ,[Payment_Method]
      ,[Shipping_Type]
      ,[Discount_Applied]
      ,[Promo_Code_Used]
      ,[Previous_Purchases]
      ,[Preferred_Payment_Method]
      ,[Frequency_of_Purchases]
  FROM [customer_behavior].[dbo].[shopping_trends]



  select Gender, SUM(purchase_amount_USD) as revenue 
  from dbo.shopping_trends
  group by Gender



   select customer_id, purchase_amount_USD
  from dbo.shopping_trends
  where Discount_Applied ='Yes' and Purchase_Amount_USD >= (select AVG(Purchase_Amount_USD) from dbo.shopping_trends)



   select top 5
  item_purchased, 
  ROUND(AVG(cast(review_rating as numeric)), 2) as [Average Product Rating]
  from dbo.shopping_trends
  group by Item_Purchased
  order by AVG(Review_Rating) desc;



  select shipping_type,
  ROUND(AVG(purchase_amount_USD),2)
  FROM dbo.shopping_trends
  where Shipping_Type in ('Standard','Express')
  group by Shipping_Type



  select subscription_status,
  COUNT(customer_id) as total_customers,
  ROUND(AVG(purchase_amount_USD),2) AS avg_spend,
  ROUND(SUM(purchase_amount_USD),2) AS total_revenue
  from dbo.shopping_trends
  group by Subscription_Status
  order by total_revenue, avg_spend desc;



  select top 5
  item_purchased,
  ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate
  from dbo.shopping_trends
  group by Item_Purchased
  order by discount_rate desc;
  


  with customer_type as (
  select customer_id, previous_purchases,
  CASE
  WHEN previous_purchases = 1 THEN 'New'
  WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
  ELSE 'Loyal'
  END AS customer_segment
  from dbo.shopping_trends
  )
  select customer_segment, count(*) as "Number of Customers"
  from customer_type
  group by customer_segment



  with item_counts as (
  select category,
  item_purchased,
  COUNT(customer_id) as total_orders,
  ROW_NUMBER() over(partition by category order by count(customer_id)DESC) as item_rank
  from dbo.shopping_trends
  group by category, item_purchased
  )

  select item_rank, category, item_purchased, total_orders
  from item_counts
  where item_rank <= 3;



  select subscription_status,
  count(customer_id) as repeat_buyers
  from dbo.shopping_trends
  where Previous_Purchases > 5
  group by Subscription_Status



  select Age,
  SUM(Purchase_Amount_USD) as total_revenue
  from dbo.shopping_trends
  group by age
  order by total_revenue desc;
