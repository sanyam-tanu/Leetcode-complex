/*Customer retention refers to the ability of a company or product to retain its customers 
over some specified period. High customer retention means customers of the product or business tend 
to return to, continue to buy or in some other way not defect to another product or business, or to non-use entirely. 
Company programs to retain customers: Zomato Pro , Cashbacks, Reward Programs etc.*/

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(9,3,'2020-03-20',150)
,(10,4,'2020-03-20',150)
,(11,5,'2020-03-20',150)

(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)




-- Method 1 ; Retention rate
select month_date, sum( diff_month) from 
(select *, month(order_date) as month_date, lag(order_date,1, order_date) over (partition by cust_id order by order_date) next_order
, DATEDIFF(month, (lag(order_date,1, order_date) over (partition by cust_id order by order_date)), order_date) as diff_month
from transactions)a
where diff_month in (0,1)
group by month_date 


-- Method 2 : Retention Rate
select --month(a.order_date), a.cust_id 
 month(this_month.order_date) month_date, count(last_month.cust_id) from transactions this_month
left join transactions last_month on this_month.cust_id=last_month.cust_id and datediff(month, last_month.order_date, this_month.order_date)=1
group by  month(this_month.order_date)

--====================

-- Customer Churn : Just opposite to customer retention. In customer retention we checked customers who ordered this month and next month whereas in churn wee see 
-- customers who have ordered this month and noth ordered next month.


select month(last_month.order_date), count(last_month.cust_id) --month(this_month.order_date) month_date, count(last_month.cust_id) 
from transactions last_month
left join transactions this_month  on this_month.cust_id=last_month.cust_id and datediff(month, last_month.order_date, this_month.order_date)=1
where this_month.order_date is null
group by month(last_month.order_date)

delete from transactions where month(order_date)=3
