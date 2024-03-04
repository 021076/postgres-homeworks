"""Скрипт для заполнения данными таблиц в БД Postgres."""
import csv
import psycopg2


def read_csv(csv_file):
    with open(csv_file, encoding='windows-1251', ) as f:
        reader = csv.reader(f)
        next(reader)
        list_row = []
        for row in reader:
            # print(row)
            list_row.append(row)
    return list_row


customer_list = []
customer_rows = read_csv("north_data/customers_data.csv")
# print(customer_rows)
for r in list(customer_rows):
    customer_rows_tuple = (str(r[0]), str(r[1]), str(r[2]))
    customer_list.append(customer_rows_tuple)
print(customer_list)
# customer (customer_id varchar(5) PRIMARY KEY,company_name varchar(100),contact_name varchar(100)

employee_list = []
employee_rows = read_csv("north_data/employees_data.csv")
# print(employee_rows)
for r in list(employee_rows):
    employee_rows_tuple = (int(r[0]), str(r[1]), str(r[2]), str(r[3]), str(r[4]), str(r[5]))
    employee_list.append(employee_rows_tuple)
# print(employee_list)
# employee (employee_id smallserial PRIMARY KEY,first_name  varchar(100),last_name  varchar(100),
#           title  varchar(100),birth_date date,notes text)

orders_list = []
order_rows = read_csv("north_data/orders_data.csv")
# print(order_rows)
for r in list(order_rows):
    order_rows_tuple = (int(r[0]), str(r[1]), int(r[2]), str(r[3]), str(r[4]))
    orders_list.append(order_rows_tuple)
# print(orders_list)
# orders (order_id smallserial PRIMARY KEY,customer_id varchar(5) REFERENCES customer(customer_id) NOT NULL,
#          employee_id smallserial REFERENCES employee(employee_id) NOT NULL,order_date date,ship_city varchar(100));

conn_params = psycopg2.connect(host="localhost",
                               database="north",
                               user="postgres",
                               password="bd_pyt"
                               )
try:
    with conn_params:
        with conn_params.cursor() as cur:
            cur.executemany("INSERT INTO customer VALUES (%s, %s, %s)", customer_list)
            cur.executemany("INSERT INTO employee VALUES (%s, %s, %s, %s, %s, %s)", employee_list)
            cur.executemany("INSERT INTO orders VALUES (%s, %s, %s, %s, %s)", orders_list)
finally:
    conn_params.close()
