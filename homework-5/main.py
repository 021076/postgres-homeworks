import json

import psycopg2

from config import config


def main():
    script_file = 'fill_db.sql'
    json_file = 'suppliers.json'
    db_name = 'my_new_db'

    params = config()
    conn = None

    create_database(params, db_name)
    print(f"БД {db_name} успешно создана")

    params.update({'dbname': db_name})
    try:
        with psycopg2.connect(**params) as conn:
            with conn.cursor() as cursor:
                execute_sql_script(cursor, script_file)
                print(f"БД {db_name} успешно заполнена")

                create_suppliers_table(cursor)
                print("Таблица suppliers успешно создана")

                suppliers_list_dict = get_suppliers_data(json_file)
                print("Файл прочитан")
                insert_suppliers_data(cursor, suppliers_list_dict)
                print("Данные в suppliers успешно добавлены")

                add_foreign_keys(cursor, json_file)
                print(f"FOREIGN KEY успешно добавлены")

    except(Exception, psycopg2.Error) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()


def create_database(params, db_name) -> None:
    """Создает новую базу данных."""
    conn_params = psycopg2.connect(**params)
    cursor = conn_params.cursor()
    conn_params.autocommit = True
    try:
        cursor.execute("CREATE DATABASE " + db_name)
    except psycopg2.Error as err:
        print(err)
    finally:
        cursor.close()
        conn_params.close()


def execute_sql_script(cursor, script_file) -> None:
    """Выполняет скрипт из файла для заполнения БД данными."""
    try:
        cursor.execute(open(script_file, "r").read())
    except psycopg2.Error as err:
        print(err)


def create_suppliers_table(cursor) -> None:
    """Создает таблицу suppliers."""
    table_name = 'suppliers'
    param_table = (
        f"id_supplier smallint PRIMARY KEY, company_name varchar(40), contact_name varchar(30), contact_post varchar(30),"
        f"country varchar(15), region varchar(15), postal_code varchar(10), city varchar(15), address varchar(60), "
        f"phone varchar(24), fax varchar(24), homepage text, products text")
    try:
        cursor.execute(f"CREATE TABLE {table_name} ({param_table})")
    except psycopg2.Error as err:
        print(err)


def get_suppliers_data(json_file) -> list[dict]:
    """Извлекает данные о поставщиках из JSON-файла и возвращает список словарей с соответствующей информацией."""
    try:
        open(json_file)
    except FileNotFoundError:
        raise FileNotFoundError(f"Файл {json_file} не найден")
    else:
        with open(json_file) as file:
            data = json.load(file)
            suppliers_list_dict = []
            id_num = 0
            for supplier in data:
                id_supplier = id_num + 1
                company_name = str(supplier["company_name"])
                contact = supplier["contact"].split(',')
                contact_name = contact[0].lstrip()
                contact_post = contact[1].lstrip()
                full_address = supplier["address"].split(';')
                country = full_address[0].lstrip()
                region = full_address[1].lstrip()
                postal_code = full_address[2].lstrip()
                city = full_address[3].lstrip()
                address = full_address[4].lstrip()
                phone = str(supplier["phone"])
                fax = str(supplier["fax"])
                homepage = str(supplier["homepage"])
                products = "; ".join(supplier["products"])
                supplier_info = {
                    "id_supplier": id_supplier,
                    "company_name": company_name,
                    "contact_name": contact_name,
                    "contact_post": contact_post,
                    "country": country,
                    "region": region,
                    "postal_code": postal_code,
                    "city": city,
                    "address": address,
                    "phone": phone,
                    "fax": fax,
                    "homepage": homepage,
                    "products": products
                }
                id_num += 1
                suppliers_list_dict.append(supplier_info)
            return suppliers_list_dict


def insert_suppliers_data(cursor, suppliers_list_dict: list[dict]) -> None:
    """Добавляет данные из suppliers в таблицу suppliers."""
    try:
        for s in suppliers_list_dict:
            param = (
                s.get("id_supplier"), s.get("company_name"), s.get("contact_name"), s.get("contact_post"),
                s.get("country"), s.get("region"),
                s.get("postal_code"), s.get("city"), s.get("address"), s.get("phone"), s.get("fax"), s.get("homepage"),
                s.get("products"))
            cursor.execute(f"INSERT INTO suppliers VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", param)
    except psycopg2.Error as err:
        print(err)


def add_foreign_keys(cursor, json_file) -> None:
    """Добавляет foreign key со ссылкой на supplier_id в таблицу products."""
    param_table = (
        f"id_supplier smallint REFERENCES suppliers(id_supplier) NOT NULL, product_name text UNIQUE")
    try:
        cursor.execute(f"CREATE TABLE products_keys ({param_table})")
    except psycopg2.Error as err:
        print(err)
    try:
        open(json_file)
    except FileNotFoundError:
        raise FileNotFoundError(f"Файл не найден")
    else:
        with (open(json_file) as file):
            data = json.load(file)
            # print(json.dumps(data, indent=2, ensure_ascii=False))
            id = 0
            for supplier in data:
                id_supplier = id + 1
                products = supplier["products"]
                for p in products:
                    product_key = (id_supplier, p)
                    # print(product_key)
                    # table_name = 'products_keys'
                    # param_table = (
                    #     f"id_supplier smallint REFERENCES suppliers(id_supplier) NOT NULL, product_name text")
                    try:
                        # cursor.execute(f"CREATE TABLE products_keys ({param_table})")
                        cursor.execute(f"INSERT INTO products_keys VALUES (%s, %s)", product_key)
                        # cursor.execute(f"ALTER TABLE suppliers ADD CONSTRAINT fk_supplier_product FOREIGN KEY(id_supplier) REFERENCES products_keys(product_name)")
                    except psycopg2.Error as err:
                        print(err)
                id += 1
    try:
        # cursor.execute(f"CREATE TABLE products_keys ({param_table})")
        # cursor.execute(f"INSERT INTO products_keys VALUES (%s, %s)", product_key)
        cursor.execute(
            f"ALTER TABLE products ADD CONSTRAINT fk_supplier_product FOREIGN KEY(product_name) REFERENCES products_keys(product_name)")
    except psycopg2.Error as err:
        print(err)


if __name__ == '__main__':
    main()
