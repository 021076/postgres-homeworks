-- 1. Создать таблицу student с полями student_id serial, first_name varchar, last_name varchar, birthday date, phone varchar
--import psycopg2
--conn_params = psycopg2.connect(host="127.0.0.1", database="Northwind", user="postgres", password="bd_pyt", client_encoding="utf-8")
--cursor = conn_params.cursor()
--conn_params.autocommit = True
--cursor.execute("CREATE TABLE student (student_id serial, first_name varchar, last_name varchar, birthday date, phone varchar)")
--conn_params.close()

CREATE TABLE student
(student_id serial,
first_name varchar,
last_name varchar,
birthday date,
phone varchar
);

--проверка
SELECT table_catalog, table_schema, table_name FROM information_schema.tables WHERE table_name = 'student'
--"table_catalog","table_schema","table_name"
--"northwind","public","student"

-- 2. Добавить в таблицу student колонку middle_name varchar
ALTER TABLE student ADD COLUMN middle_name varchar;

--проверка
SELECT column_name, column_default, data_type FROM INFORMATION_SCHEMA. WHERE table_name = 'student';
--"column_name","column_default","data_type"
--"student_id","nextval('student_student_id_seq'::regclass)","integer"
--"first_name",NULL,"character varying"
--"last_name",NULL,"character varying"
--"birthday",NULL,"date"
--"phone",NULL,"character varying"
--***"middle_name",NULL,"character varying"***


-- 3. Удалить колонку middle_name
ALTER TABLE student DROP COLUMN middle_name;

--проверка
SELECT column_name, column_default, data_type FROM INFORMATION_SCHEMA. WHERE table_name = 'student';
--"column_name","column_default","data_type"
--"student_id","nextval('student_student_id_seq'::regclass)","integer"
--"first_name",NULL,"character varying"
--"last_name",NULL,"character varying"
--"birthday",NULL,"date"
--"phone",NULL,"character varying"


-- 4. Переименовать колонку birthday в birth_date
ALTER TABLE student RENAME birthday TO birth_date;

--проверка
SELECT column_name, column_default, data_type FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'student';
--"column_name","column_default","data_type"
--"student_id","nextval('student_student_id_seq'::regclass)","integer"
--"first_name",NULL,"character varying"
--"last_name",NULL,"character varying"
--***"birth_day",NULL,"date"***
--"phone",NULL,"character varying"


-- 5. Изменить тип данных колонки phone на varchar(32)
ALTER TABLE student ALTER COLUMN phone SET DATA TYPE varchar(32);

--проверка до изменений
SELECT column_name, column_default, data_type, character_maximum_length FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'student';
--"column_name","column_default","data_type","character_maximum_length"
--"student_id","nextval('student_student_id_seq'::regclass)","integer",NULL
--"first_name",NULL,"character varying",NULL
--"last_name",NULL,"character varying",NULL
--"birth_date",NULL,"date",NULL
--***"phone",NULL,"character varying",NULL***
--проверка после изменений
SELECT column_name, column_default, data_type, character_maximum_length FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'student';
--"column_name","column_default","data_type","character_maximum_length"
--"student_id","nextval('student_student_id_seq'::regclass)","integer",NULL
--"first_name",NULL,"character varying",NULL
--"last_name",NULL,"character varying",NULL
--"birth_date",NULL,"date",NULL
--***"phone",NULL,"character varying",32***


-- 6. Вставить три любых записи с автогенерацией идентификатора
INSERT INTO student
(first_name, last_name, birth_date, phone)
VALUES
('Первый', 'Студент', '2000-11-03', '+79991234578'),
('Вторая', 'Студентка', '1995-10-21', '+79993692514'),
('Третий', 'Курсант', '2002-05-07', '+79992581245');

--проверка
 select * from student
--"student_id","first_name","last_name","birth_date","phone"
--1,"Первый","Студент","2000-11-03","+79991234578"
--2,"Вторая","Студентка","1995-10-21","+79993692514"
--3,"Третий","Курсант","2002-05-07","+79992581245"


-- 7. Удалить все данные из таблицы со сбросом идентификатор в исходное состояние
TRUNCATE TABLE student RESTART IDENTITY;

--проверка
 select count(*) from student
--"count"
--"0"
