create database jeevan_raksha_pharmacy;

use jeevan_raksha_pharmacy;

create table customers (
    customer_id int primary key,
    name varchar(100) not null,
    phone varchar(15),
    city varchar(50)
);

create table suppliers (
    supplier_id int primary key,
    supplier_name varchar(100) not null,
    contact_person varchar(100),
    phone varchar(15)
);

create table medicines (
    medicine_id int primary key,
    name varchar(100) not null,
    category varchar(50),
    price decimal(10,2) not null,
    stock_quantity int not null,
    expiry_date date,
    supplier_id int,
    foreign key (supplier_id)
        references suppliers(supplier_id)
);

create table orders (
    order_id int primary key,
    customer_id int not null,
    order_date date not null,
    total_amount decimal(10,2) not null,
    payment_mode varchar(20) not null,
    foreign key (customer_id)
        references customers(customer_id)
);

create table order_items (
    item_id int primary key,
    order_id int not null,
    medicine_id int not null,
    quantity int not null,
    subtotal decimal(10,2) not null,
    foreign key (order_id)
        references orders(order_id),
    foreign key (medicine_id)
        references medicines(medicine_id)
);

insert into customers (customer_id, name, phone, city) values
    (1, 'ravi', '9876500001', 'mumbai'),
    (2, 'sita', '9876500002', 'hyderabad'),
    (3, 'arjun', '9876500003', 'mumbai'),
    (4, 'priya', '9876500004', 'vijayawada'),
    (5, 'kiran', '9876500005', 'rajahmundry');
    
    insert into suppliers (supplier_id, supplier_name, contact_person, phone) values
    (1, 'apollo distributors', 'anil', '9000000001'),
    (2, 'medplus suppliers', 'suresh', '9000000002'),
    (3, 'healthcare agencies', 'meena', '9000000003');
    
    insert into medicines
    (medicine_id, name, category, price, stock_quantity, expiry_date, supplier_id) values
    (1, 'paracetamol', 'tablet', 20.00, 200, '2027-12-31', 1),
    (2, 'cough syrup', 'syrup', 120.00, 35, '2027-08-31', 1),
    (3, 'vitamin c', 'tablet', 80.00, 120, '2028-03-31', 2),
    (4, 'antibiotic injection', 'injection', 250.00, 20, '2027-06-30', 2),
    (5, 'antacid syrup', 'syrup', 90.00, 45, '2027-11-30', 1),
    (6, 'bandage', 'medical supply', 40.00, 75, '2029-01-31', 3);
    
    insert into orders
    (order_id, customer_id, order_date, total_amount, payment_mode) values
    (101, 1, '2026-10-01', 540.00, 'upi'),
    (102, 2, '2026-10-02', 240.00, 'cash'),
    (103, 1, '2026-10-05', 600.00, 'card'),
    (104, 3, '2026-10-07', 1100.00, 'upi'),
    (105, 4, '2026-10-10', 150.00, 'cash'),
    (106, 5, '2026-10-12', 450.00, 'card');
    
    insert into order_items
    (item_id, order_id, medicine_id, quantity, subtotal) values
    (1, 101, 1, 5, 100.00),
    (2, 101, 2, 2, 240.00),
    (3, 101, 3, 2, 160.00),
    (4, 102, 1, 3, 60.00),
    (5, 102, 5, 2, 180.00),
    (6, 103, 3, 5, 400.00),
    (7, 103, 5, 2, 180.00),
    (8, 104, 4, 4, 1000.00),
    (9, 104, 1, 5, 100.00),
    (10, 105, 6, 2, 80.00),
    (11, 106, 2, 3, 360.00),
    (12, 106, 1, 4, 80.00);
    
    #query 1
    #Retrieve the name and city of all customers.
    select name, city
    from customers;
    
    #query 2 
    #Find the names of medicines that are Syrup or Injection.
    select name as medicine_name, category
    from medicines
    where category in ('syrup', 'injection');
    
    #query 3 
    #List all orders where the total amount is greater than ₹500.
    select *
    from orders
    where total_amount > 500;
    
    #query 4
    #Find the phone numbers of all customers living in Mumbai.
    select phone
    from customers
    where city = 'mumbai';
    
    #query 5
    #Count how many medicines are supplied by Apollo Distributors.
    select count(*) as medicine_count
    from medicines m
    join suppliers s
    on m.supplier_id = s.supplier_id
    where s.supplier_name = 'apollo distributors';
    
    #query 6
    #List the customer name, order date, and total amount for every order.
    select
    c.name as customer_name,
    o.order_date,
    o.total_amount
    from orders o
    join customers c
    on o.customer_id = c.customer_id
    order by o.order_date;
    
    #query 7
    #Calculate the total money earned through each payment mode: UPI, Card, and Cash.
    select
    payment_mode,
    sum(total_amount) as total_revenue
    from orders
    group by payment_mode;
    
    #query 8
    #Which medicine has been sold the most in terms of total quantity?
    select
    m.name as medicine_name,
    sum(oi.quantity) as total_quantity_sold
    from order_items oi
    join medicines m
    on oi.medicine_id = m.medicine_id
    group by m.medicine_id, m.name
    order by total_quantity_sold desc
    limit 1;
    
    #query 9
    #List the names of customers who have spent more than ₹1,000 across all their orders.
    select
    c.name as customer_name,
    sum(o.total_amount) as total_spent
    from customers c
    join orders o
    on c.customer_id = o.customer_id
    group by c.customer_id, c.name
    having sum(o.total_amount) > 1000;
    
    #query 10
    #List the medicine name, stock quantity, and supplier name for medicines that have fewer than 50 units left in stock.
    select
    m.name as medicine_name,
    m.stock_quantity,
    s.supplier_name
    from medicines m
    join suppliers s
    on m.supplier_id = s.supplier_id
    where m.stock_quantity < 50;
    