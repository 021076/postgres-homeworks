-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника,
-- работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London,
-- а доставку заказа ведет компания United Package (company_name в табл shippers)
Select c.company_name, concat(e.first_name, ' ', e.last_name) as employee
from customers c, employees e, orders o, shippers s
where c.city = e.city and e.city= 'London'
and o.customer_id = c.customer_id and e.employee_id=o.employee_id
and s.shipper_id = o.ship_via and s.company_name = 'United Package'

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
select p.product_name, p.units_in_stock, s.contact_name, s.phone
from products p, suppliers s
where p.supplier_id = s.supplier_id
and p.discontinued = 0 and units_in_stock < 25
and p.category_id in (select category_id from categories where category_name in ('Dairy Products','Condiments'))
order by units_in_stock

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
select company_name from customers where customer_id not in (select customer_id from orders)

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц
-- (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
select product_name from products where product_id in (select product_id from order_details where quantity = 10)