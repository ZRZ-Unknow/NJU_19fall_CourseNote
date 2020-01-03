CREATE DATABASE experiment1;
use experiment1;
#1
CREATE TABLE Customers
(
    cid Char(4) NOT NULL,
    cname Char(20) NOT NULL,
    city Char(20),
    discnt real,
    PRIMARY KEY(cid)
);
CREATE TABLE Agents
(
    aid Char(3) NOT NULL,
    aname Char(20) NOT NULL,
    city Char(20),
    perc smallint,
    PRIMARY KEY(aid)
);
CREATE TABLE Products
(
    pid Char(3) NOT NULL,
    pname Char(20) NOT NULL,
    city Char(20),
    quantity int NOT NULL,
    price real NOT NULL,
    PRIMARY KEY(pid)
);
CREATE TABLE Orders
(
    ordno int NOT NULL,
    orddate Date NOT NULL,
    cid Char(4) NOT NULL,
    aid Char(3) NOT NULL,
    pid Char(3) NOT NULL,
    qty int,
    dols real,
    PRIMARY KEY(ordno)
);
#2
INSERT INTO Customers
VALUES
('c001', 'Tiptop', 'Duluth', 10.00),
('c002', 'Basics', 'Dallas', 12.00),
('c003', 'Allied', 'Dallas', 8.00),
('c004', 'ACME', 'Duluth', 8.00),
('c006', 'ACME', 'Kyoto', 0.00);

INSERT INTO Agents
VALUES
('a01', 'Smith', 'New York', 6),
('a02', 'Jones', 'Newark',   6),
('a03', 'Brown', 'Tokyo',    7),
('a04', 'Gray',  'New York', 6),
('a05', 'Otasi', 'Duluth',   5),
('a06', 'Smith', 'Dallas',   5);

INSERT INTO Products
VALUES
('p01', 'comb',   'Dallas', 111400, 0.50),
('p02', 'brush',  'Newark', 203000, 0.50),
('p03', 'razor',  'Duluth', 150600, 1.00),
('p04', 'pen',    'Duluth', 125300, 1.00),
('p05', 'pencil',  'Dallas', 221400, 1.00),
('p06', 'folder',  'Dallas', 123100, 2.00),
('p07', 'case',   'Newark', 100500, 1.00);

INSERT INTO Orders
VALUES
(1011, '2016-01-08', 'c001', 'a01', 'p01', 1000, 450.00),
(1012, '2016-01-12', 'c001', 'a01', 'p01', 1000, 450.00),
(1019, '2016-02-24', 'c001', 'a02', 'p02', 400,  180.00),
(1017, '2016-02-10', 'c001', 'a06', 'p03', 600,  540.00),
(1018, '2016-02-16', 'c001', 'a03', 'p04', 600,  540.00),
(1023, '2016-03-12', 'c001', 'a04', 'p05', 500,  450.00),
(1022, '2016-03-08', 'c001', 'a05', 'p06', 400,  720.00),
(1025, '2016-04-07', 'c001', 'a05', 'p07', 800,  720.00),
(1013, '2016-01-13', 'c002', 'a03', 'p03', 1000, 880.00),
(1026, '2016-05-20', 'c002', 'a05', 'p03', 800,  704.00),
(1015, '2016-01-23', 'c003', 'a03', 'p05', 1200, 1104.00),
(1014, '2016-01-18', 'c003', 'a03', 'p05', 1200, 1104.00),
(1021, '2016-02-28', 'c004', 'a06', 'p01', 1000, 460.00),
(1016, '2016-01-25', 'c006', 'a01', 'p01', 1000, 500.00),
(1020, '2016-02-05', 'c006', 'a03', 'p07', 600,  600.00),
(1024, '2016-03-12', 'c006', 'a06', 'p01', 800,  400.00);


#3.1
SELECT a1.aid  FROM Agents a1
where a1.aid not in 
(
    SELECT o1.aid 
    from Customers C1, Orders O1
    where C1.cid=O1.cid and C1.city='Duluth'
);

#3.2
SELECT O1.aid FROM Orders O1, Customers C1
where O1.cid=C1.cid and (C1.city='Duluth' or C1.city='Kyoto')
and not exists
(
    SELECT * from Customers C2
    where (C2.city='Duluth' or C2.city='Kyoto') and C2.cid not in
    (
        select O2.cid from Orders O2
        where O2.aid=O1.aid and O2.pid=O1.pid
    )
);

#3.3
SELECT distinct O1.cid from Orders O1
where O1.cid not in
(
     select O2.cid from Orders O2
     where O2.aid!='a03' and O2.aid!='a05'
);


#3.4
select P1.pid from Products P1
where not exists
(
    select * from customers c1
    where P1.pid not in
    (
        select O1.pid from Orders O1
        where O1.cid=C1.cid
    )
);
select * from
(
  select o1.aid,o1.pid,sum(o1.qty) as sumqty from orders o1
  group by o1.aid,o1.pid 
  having sumqty>1000
  order by sumqty desc
  limit 3
)q;


#3.5
create table max select o1.cid,o1.orddate from orders o1
where o1.orddate>=ALL(select o2.orddate from orders o2 where o2.cid=o1.cid);
create table temp select o1.cid,o1.orddate from orders o1 left join max on o1.cid=max.cid where o1.orddate!=max.orddate;
insert into max select t.cid,t.orddate from temp t
where t.orddate>=all(select t1.orddate from temp t1 where t1.cid=t.cid);
select * from max 
order by cid,orddate ;
drop table max;drop table temp;

#3.6
select p1.pid from products p1
where not exists
(
  select * from customers c1
  where c1.city='Dallas' and c1.cid not in
  (
    select o1.cid from orders o1
    where o1.pid=p1.pid
  )
);

#3.7
select a1.aid,a1.perc from agents a1
where not exists
(
    select * from customers c1
    where c1.city='Duluth' and c1.cid not in
    (
	    select o1.cid from orders o1
        where o1.aid=a1.aid
    )
)
order by a1.perc desc;

#3.8
select o1.pid from Orders o1,customers c1,agents a1
where o1.cid=c1.cid and o1.aid=a1.aid and c1.city=a1.city;

#3.9
select * from agents a1
where a1.perc in 
(
  select max(a2.perc) from agents a2
);

select * from agents a1
where a1.perc in 
(
  select a2.perc from agents a2
  where a2.perc not in
  ( 
    select a3.perc from agents a3,agents a4
    where a3.perc<a4.perc
  )
);

#3.10
select o1.cid,sum(o1.dols) from orders o1
where o1.cid not in
(
  select o2.cid from orders o2
  where o2.aid<>'a03'
)group by o1.cid;

#3.11
select q.pid,q.cid from
(
  select o1.pid,o1.aid,sum(o1.qty) as sumqty from orders o1
  group by o1.aid,o1.pid 
  having sumqty>1000
  order by o1.pid
  limit 3
)q;

#3.12
select distinct q.cid from
(
  select o1.cid,o1.pid,avg(o1.qty) as avgqty from orders o1
  group by o1.cid,o1.pid
)q
where q.avgqty>=300;

#4
drop table orders;
drop table customers;
drop table agents;
drop table products;













