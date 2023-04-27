--------------------------------
--TO BE EXECUTED IN SSMS (NOT ONLINE LAB-WEBSITES):

CREATE DATABASE [EmpDb]
 ON  PRIMARY ( NAME = N'EmpDb', FILENAME = N'E:\Data\EmpDb.mdf')
 LOG ON ( NAME = N'EmpDb_log', FILENAME = N'E:\Data\EmpDb_log.ldf' )

ALTER DATABASE [EmpDb] SET RECOVERY SIMPLE 
GO

USE [EmpDb]
GO

print db_name()  --View database-name in use.
--------------------------------


--SAMPLE TABLES WITH DATA:
--------------------------

--Create emp table:
create table emp (
	eid	int 	 NOT NULL PRIMARY KEY,
	ename	varchar(100)	,
	jobtitle	varchar(100)	,
	managerid	int	,
	hiredate	date	,
	salary	money	,
	commission	decimal(2,2)	,
	did	int ,
	rid int
)			

insert into emp (eid,ename,jobtitle,managerid,hiredate,salary,commission,did,rid)
	Values
	(	68319, 'Kylie', 'President', 68319, '2009-11-18', 60000.00, NULL , 10	, NULL ),
	(	66928, 'Bob', 'General Manager', 68319, '2013-05-01', 27500.00, 0.33 , 10	, NULL ),
	(	67832, 'Clare', 'Technical Manager', 68319, '2011-06-09', 25500.00, NULL , 10	, NULL ),
	(	65646, 'John', 'Sales Manager', 68319, '2014-04-02', 29570.00, NULL , 10	, NULL ),
	(	67858, 'Scarlet', 'Analyst', 65646, '2017-04-19', 3100.00, NULL , 20	, NULL ),
	(	69324, 'Mark', 'DBA', 67832, '2012-01-23', 1900.00, NULL , 20	, NULL ),
	(	69062, 'Frank', 'Analyst', 65646, '2011-12-03', 3100.00, NULL , 20	, NULL ),
	(	63679, 'Sandra', 'Developer', 69062, '2010-12-18', 2900.00, NULL , 20	, NULL ),
	(	64989, 'Irene', 'Sales Representative', 66928, '2018-02-20', 1700.00, 0.1, 30	, 1 ),
	(	65271, 'Dwayne', 'Sales Representative', 66928, '2011-02-22', 1350.00, 0.05, 30	, 2 ),
	(	66564, 'Gerogia', 'Sales Representative', 66928, '2011-09-28', 1400.00, 0.02, 30	, 1 ),
	(	66569, 'Matt', 'Sales Representative', 66928, '2019-01-28', 1325.00, 0.02, 30	, 2 ),
	(	66571, 'Raj', 'Sales Representative', 66928, '2013-02-15', 1190.00, 0.02, 30	, 5 ),
	(	68454, 'Tucker', 'Sales Representative', 66928, '2011-09-08', 1600.00, 0.01, 30	, 3 ),
	(	68455, 'Sam', 'Sales Representative', 66928, '2020-09-18', 1400.00, 0.01, 30	, 4 ),
	(	68736, 'Andy', 'Technical Support', 67858, '2017-05-23', 1200.00, NULL , 20	, NULL ),
	(	69000, 'Julie', 'Sales Apprentice', 66928, '2011-12-03', 950.00, NULL , 30 , 4	)

--Create dept table:
CREATE TABLE [dbo].[dept](
	[did] [int] NOT NULL,
	[DeptName] [nchar](30) NULL
)

INSERT INTO dept ([did],[DeptName])
VALUES
	(10,	'Mgmt'),
	(20,	'Tech'),
	(30,	'Sales'),
	(40,	'Procurement')
    
--Create region table:
CREATE TABLE [dbo].[region](
	[rid] [int] NOT NULL,
	[RegionName] [nchar](30) NULL
)

INSERT INTO region ([rid],[RegionName])
VALUES
	(1,	'Americas'),
	(2,	'Europe'),
	(3,	'Australias'),
	(4,	'Africa'),
	(5,	'Asia'),
	(6,	'Antarctica')

-------------------------------------------------------
SELECT * FROM emp
SELECT * FROM dept
SELECT * FROM region
-------------------------------------------------------




Queries from the Lab:
---------------------

--Delete whole table:
--DROP TABLE emp

--Wipe out whole data from table:
--Truncate table emp

--Change region-id from 4 to 5:
update region
set rid=5
WHERE regionname = 'Asia'

--Create relation between Emp & Dept table on 'did' column:
ALTER TABLE emp
add CONSTRAINT fkey_did
FOREIGN key (did) REFERENCES dept(did)

--Add Primary key to the Dept table:
ALTER TABLE dept
add CONSTRAINT pkey_did PRIMARY KEY(did)

--Get all details of a table (in SSMS):
sp_help dept

--List Constraint details of specified table:
SELECT TABLE_NAME, CONSTRAINT_TYPE,CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME='emp'

--List those earning over £25,000:
SELECT ename,salary,did FROM emp
WHERE salary > 25000

--List dept-names along ename:
SELECT e.ename, e.did, d.DeptName FROM emp AS e
	JOIN dept AS d
    	ON e.did = d.did

--All columns in descending order by Salary:
SELECT salary AS Sal, * FROM emp 
ORDER BY salary DESC

--Top salary only:
SELECT max(salary) FROM emp

--2nd highest salary:#
--Option-1:  INNER QUERY:
SELECT top 1 salary AS Sal, * FROM emp 
WHERE salary < (SELECT top 1 salary FROM emp ORDER BY salary DESC)
ORDER BY salary DESC

--Option-2:  OFFSET .. FETCH:
SELECT salary AS Sal, * FROM emp 
ORDER BY salary DESC
OFFSET 1 ROW FETCH NEXT 1 ROW ONLY;

--List emp joined after year 2015:
SELECT * from 	emp
WHERE hiredate > '20150101'

--List emp joined between 2012 and 2015:
SELECT * from 	emp
WHERE hiredate BETWEEN '20120101' AND '20160101'

--List emp joined in year 2011:
SELECT * from emp
WHERE Year(hiredate) = '2011'

--List emp-name, jobtitle, dept-name whose job-title starts with 'Sales':
SELECT e.ename, e.jobtitle, d.DeptName  from emp e
JOIN dept d ON e.did=d.did
WHERE e.jobtitle LIKE 'Sales%'

--Manager's name:
--Option:1 List emp-names with their Manager's name USING self-join:
SELECT e.ename, e.managerid, m.ename AS [Mgr-Name] from emp e
JOIN emp m ON e.managerid=m.eid
WHERE e.jobtitle LIKE 'Sales%'

--Option:2 List emp-names with their Manager's name USING inner query:
SELECT ename, managerid, (SELECT top 1 m.ename from emp m where e.managerid=m.eid) AS Mgr from emp e
WHERE e.jobtitle LIKE 'Sales%'



    