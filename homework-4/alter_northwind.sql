-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE PRODUCTS ADD CONSTRAINT UNIT_PRICE CHECK (UNIT_PRICE > 0);

--проверка
UPDATE products SET unit_price = 0 WHERE product_id=1
--ERROR:  Ошибочная строка содержит (1, Chai, 8, 1, 10 boxes x 30 bags, 0, 39, 0, 10, 1).новая строка в отношении "products" нарушает ограничение-проверку "unit_price"
--ОШИБКА:  новая строка в отношении "products" нарушает ограничение-проверку "unit_price"
--SQL-состояние: 23514
--Подробности: Ошибочная строка содержит (1, Chai, 8, 1, 10 boxes x 30 bags, 0, 39, 0, 10, 1).


-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1
ALTER TABLE products ADD CONSTRAINT discontinued CHECK (discontinued IN (0, 1));

--проверка
UPDATE products SET discontinued = 3 WHERE product_id=1
--ERROR:  Ошибочная строка содержит (1, Chai, 8, 1, 10 boxes x 30 bags, 18, 39, 0, 10, 3).новая строка в отношении "products" нарушает ограничение-проверку "discontinued"
--ОШИБКА:  новая строка в отношении "products" нарушает ограничение-проверку "discontinued"
--SQL-состояние: 23514
--Подробности: Ошибочная строка содержит (1, Chai, 8, 1, 10 boxes x 30 bags, 18, 39, 0, 10, 3).


-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)
SELECT * INTO discontinued_products FROM products WHERE discontinued = 1;

--проверки
SELECT table_catalog, table_schema, table_name FROM information_schema.tables WHERE table_name = 'discontinued_products'
--"table_catalog","table_schema","table_name"
--"northwind","public","discontinued_products"
SELECT * FROM discontinued_products
--"product_id","product_name","supplier_id","category_id","quantity_per_unit","unit_price","units_in_stock","units_on_order","reorder_level","discontinued"
--1,"Chai",8,1,"10 boxes x 30 bags","18",39,0,10,1
--2,"Chang",1,1,"24 - 12 oz bottles","19",17,40,25,1
--5,"Chef Anton's Gumbo Mix",2,2,"36 boxes","21.35",0,0,0,1
--9,"Mishi Kobe Niku",4,6,"18 - 500 g pkgs.","97",29,0,0,1
--17,"Alice Mutton",7,6,"20 - 1 kg tins","39",0,0,0,1
--24,"Guaraná Fantástica",10,1,"12 - 355 ml cans","4.5",20,0,0,1
--28,"Rössle Sauerkraut",12,7,"25 - 825 g cans","45.6",26,0,0,1
--29,"Thüringer Rostbratwurst",12,6,"50 bags x 30 sausgs.","123.79",0,0,0,1
--42,"Singaporean Hokkien Fried Mee",20,5,"32 - 1 kg pkgs.","14",26,0,0,1
--53,"Perth Pasties",24,6,"48 pieces","32.8",0,0,0,1


-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key.
-- Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.

--проверка перед удалением
SELECT COUNT(*) FROM products
--"count"
--"77"

--снятие ограничения на внешний ключ
ALTER TABLE order_details DROP CONSTRAINT fk_order_details_products;
--удаление из products товаров, снятых с продажи (discontinued = 1)
DELETE FROM products WHERE discontinued = 1

--проверка после удаления
SELECT COUNT(*) FROM products
--"count"
--"67"

