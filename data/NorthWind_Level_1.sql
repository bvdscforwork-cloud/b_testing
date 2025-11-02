# 1. Liệt kê 10 sản phẩm đầu tiên (id, name, unit_price) sắp xếp giá giảm.
SELECT *
FROM product
order by unitPrice desc
limit 10;

# 2. Top 5 khách hàng có nhiều đơn nhất (đếm orders).
select c.custId, c.contactName, No_of_orders
from customer as c INNER JOIN
(
select custId, COUNT(DISTINCT(orderId)) as No_of_orders
from salesorder 
group by custId
order by No_of_orders desc
limit 10
) as cte
ON c.custId = cte.custId;

# 3. Đếm số sản phẩm đang bán (discontinued=0) theo mỗi category
select ca.categoryName, COUNT(DISTINCT(p.productName)) as no_of_products
from product as p INNER JOIN category as ca
ON p.categoryId = ca.categoryId
where p.discontinued = 0
group by ca.categoryName;

# 4.Danh sách đơn chưa giao (shipped_date IS NULL) và quốc gia giao hàng.
select orderId, shipCountry
from salesorder
where shippedDate is null;

# 5. 5 sản phẩm hết hàng (units_in_stock=0) có giá cao nhất.
select productName, unitsInStock, unitPrice
from product
where unitsInStock is null
order by unitPrice desc
limit 10;

# 6. Tổng doanh thu đơn hàng cho mỗi đơn hàng
select orderId, ROUND(SUM((unitPrice*quantity)*(1-discount)),2) as order_revenue
from orderdetail as o
group by orderId;

# 7. Top 3 quốc gia có nhiều khách hàng nhất.
select country, COUNT(DISTINCT(custId)) as No_of_Customers
from customer
group by country
limit 3;

# 8. TOP 10 nhân viên lớn tuổi nhất
select concat(titleOfCourtesy, lastname, ' ', firstname) as full_name, birthDate, ROUND(DATEDIFF(CURDATE(), birthDate)/365,0) as age
from employee
order by age
limit 10;

# 10. Tìm những sản phẩm chưa order trong 6 tháng gần nhất
select p.productId, p.productName
from product as p INNER JOIN
(
	select DISTINCT(o.productId)
	from orderdetail as o
	where not exists (
		select *
		from salesorder as s
		where o.orderId = s.orderId and datediff(CURDATE(), orderDate) < 180
		)
) as cte
on p.productId = cte.productId