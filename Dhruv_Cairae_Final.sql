/*Dhruv Cairae */

/* General

ALL FIELDS IN OUTPUT MUST HAVE A COLUMN NAME (5%)

Answer Yes/No to the following question (1%):
The code in this script represents my individual effort only. 
I will not give or receive any form of assistance for this final.

Answer: 

*/
--YES

/* #1: Specify AdventureWorks as the current database (1%) */
USE AdventureWorks2019

/* Part A
Use [HumanResources].[Employee] table to answer #2-#3 below */

		/* #2 (4%): 
		In a single query:
	
		(a) Select the first 100 records for the following fields:
			[BusinessEntityID]
		  ,[NationalIDNumber]
		  ,[OrganizationLevel]
		  ,[JobTitle]
		  ,[BirthDate]
		  ,[MaritalStatus]
		  ,[Gender]
		  ,[HireDate]
		  ,[SalariedFlag]
		  ,[VacationHours]
		  ,[SickLeaveHours]
		  ,[CurrentFlag]
		(b) Return the following column aliases for the following fields. 
			If no alias is requested, simply return the original field name.
			(i) alias of LEVEL for [OrganizationLevel]
			(ii) alias of JOB TITLE for [JobTitle]
			(iii) alias of DATE_HIRED for [HireDate]
		*/

SELECT TOP 100 [BusinessEntityID]
		  ,[NationalIDNumber]
		  ,[OrganizationLevel] AS 'LEVEL'
		  ,[JobTitle] AS 'JOB TITLE'
		  ,[BirthDate]
		  ,[MaritalStatus]
		  ,[Gender]
		  ,[HireDate] AS 'DATE_HIRED'
		  ,[SalariedFlag]
		  ,[VacationHours]
		  ,[SickLeaveHours]
		  ,[CurrentFlag]
FROM [HumanResources].[Employee]

		/* #3 (4%): 
		In a single query:
	
		(a) Return ALL records for the fields listed in #2a.
		(b) Use the same aliases as specificed in #2b.
		(c) Limit records to current employees only (CurrentFlag = 1). 
		(d) Insert them into a local temporary table using
			SELECT ... INTO. 
		*/
SELECT     [BusinessEntityID]
		  ,[NationalIDNumber]
		  ,[OrganizationLevel] AS 'LEVEL'
		  ,[JobTitle] AS 'JOB TITLE'
		  ,[BirthDate]
		  ,[MaritalStatus]
		  ,[Gender]
		  ,[HireDate] AS 'DATE_HIRED'
		  ,[SalariedFlag]
		  ,[VacationHours]
		  ,[SickLeaveHours]
		  ,[CurrentFlag]
INTO New_Employee
FROM [HumanResources].[Employee]
WHERE [CurrentFlag]=1

/* Part B
Use the temporary table created in Part A, #3 to answer questions #4-#11 below */

		/* #4 (3%): 
		In a single query using the COUNT() function, answer the following question:

		How many records have a NULL value for Organization Level?

		Reminder: all fields must have a column name in the output.
		*/

SELECT COUNT(*) AS 'Expression1'
FROM New_Employee
WHERE LEVEL IS NULL

		/* #5 (4%): 
		In a single query:

		(a) Count the number of records for each value of Job Title.
		(b) Limit the output to the 10 job titles with the highest counts.
		*/

SELECT TOP 10 COUNT(*) AS 'Expression2',[JOB TITLE]
FROM New_Employee
GROUP BY [JOB TITLE]
ORDER BY Expression2 DESC

		/* #6 (5%): 
		In a single query:

		(a) Count the number of records for unique combinations of
			values across the Job Title and Organization Level fields.
		(b) Limit the output to job titles & organization levels 
			with only one record in the table.
		(c) Order results by organization level least to greatest, 
		then job title in alphabetical order.
		*/

SELECT DISTINCT [JOB TITLE],[LEVEL], COUNT(*) AS 'Expression3'
FROM New_Employee
GROUP BY [JOB TITLE],[LEVEL]
HAVING COUNT(*)=1
ORDER BY [LEVEL] DESC ,[JOB TITLE]

--Numerically it may seem the other way round but the greatest organization level is the CEO and other C level executives
-- Hierarchy of level is inverted as far as number of the level is concerned. 

		/* #7 (5%): 
		Imagine you are querying this data as of 
		October 1, 2021, and the data are current. 
		In a single query:

		(a) Use the datediff() function to return the number of months
			between today (10/01/2021) and the date the employee
			was hired.
		(b) Also return BusinessEntityID, the hire date, and the job title.
		(c) Using the same function from (a), limit the output to employees who have 
			worked at the company for at least 120 months (note your logic should 
			use months, but this is approximately 10 years).
		(d) Order results by months employed greatest to least, hire date earliest to
			latest, and then job title alphabetically.
		*/

SELECT DATEDIFF(MONTH,DATE_HIRED,'10/01/2021') AS 'Expression4',DATE_HIRED,BusinessEntityID,[JOB TITLE]
FROM New_Employee
GROUP BY DATE_HIRED,[JOB TITLE],BusinessEntityID
HAVING DATEDIFF(MONTH,DATE_HIRED,'10/01/2021')>120
ORDER BY Expression4 DESC, DATE_HIRED, [JOB TITLE]

		/* #8 (3%): 
		Answer the following in a comment:

		Explore the output for date hired in #7. If you removed the 
		first sort criteria (months employed), would the order of 
		the results be the same? Why or why not?
		*/

/*The order of results would not change. The second sort criterion of ordering by DATE_HIRED has the exact same impact
as ordering in a descending manner for the number of months, vice-versa not necessarily true in cases where number of months 
might be the same. By ordering in ascending order of DATE_HIRED the number of months is by default ordered in a descending order
on account of how we have calculated the months as difference between 01-October-2021 and DATE_HIRED*/

		/* #9 (3%): 
		Answer the following in a comment:

		Explore the output for date hired in #7. If you removed the 
		last sort criteria (job title), could you guarantee the
		same order of the results ? Why or why not?
		*/

/* The same output cannot be guaranteed. This is because for values with same hiring date and consequently the same
difference in months from 1-October-2021 the ordering of Job Title may not be in ascending order by default, therefore 
ordering results by Job Title and not ordering results by Job Title may not have the same order of results. */

		/*#10 (7%)
		In a single query:

		(a) Count the number of records for each value of Gender.
		(b) Limit the query to employees who are salaried (SalariedFlag = 1).
		(c) Additionally limit to employees with an organization level
			of 1, 2, 3 or NULL.
		(d) Order output by Gender in descending order.
		*/

SELECT COUNT(*) AS 'Expression5', Gender
FROM New_Employee
WHERE SalariedFlag=1 AND (LEVEL=1 OR LEVEL=2 OR LEVEL=3 OR LEVEL IS NULL)
GROUP BY GENDER
ORDER BY Gender DESC

		/*#11 (3%)
		Using the SELECT clause as a calculator and
		the output from #10, return
		the ratio of males to females.

		Then, in a comment, interpret the output.

		Here's an example SELECT clause that performs this operation:
			SELECT x/y 
		I'm asking you to type x and y directly from output in #10.

		Note you'll also need a column alias.
		*/

SELECT CAST(30 AS float)/CAST(19 AS float) AS 'Expression6'
/* The number of salaried men out number salaried women in the ratio well above 1.5:1, 
at organization levels one, two or three or without an organizational level
specified in the table. */

/* Part C
Use the [HumanResources].[EmployeePayHistory] table for questions #12-15 */

		/* #12 (4%)
		In a single query:
	
		(a) Count the number of records for each BusinessEntityID.
		(b) Return values for BusinessEntityID that have more than 1 record
		in the table source.
		(c) Order by BusinessEntityID in ascending order.
		*/

SELECT COUNT(*) AS 'Expression7', BusinessEntityID
FROM [HumanResources].[EmployeePayHistory]
GROUP BY BusinessEntityID
HAVING COUNT(*)>1
ORDER BY BusinessEntityID

		/* #13 (4%)
		Based on output from #12, note the smallest value of
		BusinessEntityID with more than one record.

		For this value of BusinessEntityID, in a single query:
		(a) Return fields [BusinessEntityID], [RateChangeDate], and [Rate].
		(b) Sort output by [RateChangeDate] from the most recent date to the earliest.
		*/

SELECT [BusinessEntityID], [RateChangeDate],[Rate]
FROM [HumanResources].[EmployeePayHistory]
WHERE [BusinessEntityID]=4
ORDER BY [RateChangeDate] DESC

		/* #14 (2%)
		Note that the output from #13 above shows us changes in the employee's
		pay (dollars per hour). Assuming the data are current, 
		answer the following question in a comment:

		What is the employee's current rate of pay?
		*/

-- The employee's current rate of pay is 29.8462

		/* #15 (5%)
		For this query, we will assume that all pay changes for a given employee
		are incremental. In other words, their pay can only increase through
		time. 

		Under this assumption, if we return the maximum pay rate for each employee, 
		this will be the current pay rate for each employee.

		In a single query:
		(a) Return the maximum pay rate for each employee (BusinessEntityID).
		(b) Return the output to a local temporary table using SELECT ... INTO.
		*/

SELECT MAX(Rate) AS 'Expression8',BusinessEntityID 
INTO New
FROM [HumanResources].[EmployeePayHistory]
GROUP BY BusinessEntityID


/* Part D 
Use the temporary tables from Part A, #3 and Part C, #15 for questions #16-17 */

	/* #16 (10%)
	In a single query, perform a join that has the following properties:
	(a)	Return all fields from the temporary table in Part A, #3.
	(b) Return only the rate field from the temporary table in Part C, #15.
	(c) We want all the records from the table in Part A, #3 returned, regardless if 
	there is a match.
	(d) Join on field BusinessEntityID.
	(e) Order by pay rate from greatest to least.

	Answer this question in a comment: Who has the highest pay in the company?
	*/

SELECT New_Employee.[BusinessEntityID]
,New_Employee.[NationalIDNumber]
,New_Employee.[LEVEL]
,New_Employee.[JOB TITLE]
,New_Employee.[BirthDate]
,New_Employee.[MaritalStatus]
,New_Employee.[Gender]
,New_Employee.[DATE_HIRED]
,New_Employee.[SalariedFlag]
,New_Employee.[VacationHours]
,New_Employee.[SickLeaveHours]
,New_Employee.[CurrentFlag]
,New.Expression8
FROM New_Employee
LEFT JOIN  New ON New_Employee.BusinessEntityID=New.BusinessEntityID
ORDER BY New.Expression8 DESC

--The Chief Executive Officer with BusinessEntityID of 1 has he highest pay.

	/* #17 (10%)
	Using the same join from #16, perform the following in a single query:

	(a) Count the number of records for each value of Gender.
	(b) Return the average pay rate for each value of Gender.
	(c) Limit to employees with an organization level
		of that is NOT 1, 2 or NULL.
	(d) Order output by Gender in descending order.

	Answer this question in a comment: Which gender has the highest
	average pay?
	*/

SELECT COUNT(*) AS 'Expression9', New_Employee.[Gender],AVG(New.Expression8)AS 'Expression10'
FROM New_Employee
LEFT JOIN  New ON New_Employee.BusinessEntityID=New.BusinessEntityID
WHERE LEVEL!=1 OR LEVEL!=2 OR LEVEL IS NOT NULL
GROUP BY GENDER
ORDER BY Gender DESC

-- Women have a higher average pay

/* Part E
Use the temporary table from Part A, #3 and the [Person].[Person] 
table for questions #18-#19. */

	/* #18 (10%)
	In a single query, perform a join using the temporary table from Part A, #3 
	and the [Person].[Person] table.

	It must have the following properties:
	(a)	Return all fields from the temporary table in Part A, #3.
	(b) Return the PersonType, FirstName, MiddleName, and LastName fields
		from Person.Person.
	(c) We want all the records from the table in Part A, #3 returned, regardless if 
		there is a match.
	(d) Join on field BusinessEntityID.
	(e) Limit the query to return for employees who have more than 40 hours of
		vacation remaining.
	(f) Order by vacation hours from greatest to least, 
		then by hire date from earliest to latest.
	*/
SELECT New_Employee.[BusinessEntityID]
,New_Employee.[NationalIDNumber]
,New_Employee.[LEVEL]
,New_Employee.[JOB TITLE]
,New_Employee.[BirthDate]
,New_Employee.[MaritalStatus]
,New_Employee.[Gender]
,New_Employee.[DATE_HIRED]
,New_Employee.[SalariedFlag]
,New_Employee.[VacationHours]
,New_Employee.[SickLeaveHours]
,New_Employee.[CurrentFlag]
,[Person].[Person].PersonType,[Person].[Person].FirstName,[Person].[Person].MiddleName,[Person].[Person].LastName 
FROM New_Employee
LEFT JOIN  [Person].[Person] ON New_Employee.BusinessEntityID=[Person].[Person].BusinessEntityID
WHERE New_Employee.[VacationHours]>40
ORDER BY New_Employee.[VacationHours] DESC, New_Employee.[DATE_HIRED]

	/* #19 (7%)
	Answer the following question using a query:

	Are there any values of BusinessEntityID in the join in #18
	that are unmatched in the [Person].[Person] table?

	Then answer the following question in a comment: Could the answer be
	different depending on the field from [Person].[Person] we use to
	search for unmatched values?
	*/

SELECT COUNT(*) AS 'Expression11'
FROM New_Employee
RIGHT JOIN  [Person].[Person] ON New_Employee.BusinessEntityID=[Person].[Person].BusinessEntityID
WHERE New_Employee.CurrentFlag!=1 OR New_Employee.CurrentFlag IS NULL

/*The number of unmatched values as such will not change with the field used to search for unmatched values,
number of unmatched values might change if a different primary key is used to join the tables. 
Either the number of unmatched values identified is
correct and accurate or it is not, it cannot depend on the field used to search for the unmatched values */

/* Part F  
Optional - Extra Credit (7%)

	With a single query:
	
	Use one or more of the following tables:
	(a) Temporary table from Part A, #3.
	(b) Temporary table from Part C, #15.
	(c) [Person].[Person]
	
	Write a query to tell us something about the data. You can
	use one of the tables, two, or all three.

	Then, in a comment, tell us what the data show. Results should 
	be ordered intuitively.
		
	Points will be awarded based on:
	(a) The complexity of ARRIVING AT the insight, not on the insight itself.
		Note an insight that relies on information from two tables is likely
		to be more complex than one that relies on information from a single table.
	(b) The accuracy and richness of the interpretation. If you can arrive at multiple
		insights from your single query, this is preferable to an interpretation of 
		just one of the insights.
	*/


SELECT COUNT(*) AS 'Expression12', New_Employee.[Gender],[Person].[Person].PersonType, MaritalStatus, AVG(New.Expression8)AS 'Expression13',
MAX(New.Expression8)AS 'Expression14'
FROM((New_Employee
INNER JOIN  New ON New_Employee.BusinessEntityID=New.BusinessEntityID)
INNER JOIN [Person].[Person] ON New_Employee.BusinessEntityID=[Person].[Person].BusinessEntityID)
GROUP BY New_Employee.[Gender],[Person].PersonType,MaritalStatus
ORDER BY Expression13 DESC, New_Employee.[Gender],[Person].[Person].PersonType

/* 
SP- Sales People, EM-Employee Non-Sales. The highest average pay is for female married sales people, followed by married male sales people.
The highest is not very far from the mean for Sales People which means the outliers have had limited impact and compared to other employees
more equity for the sales staff is expected. Average and Maximum for Single sales people is the same for both genders, the only sub-category,
probably because single sales people are interns. Interestingly for non-sales employee its the single people with higher average pay, however
the maximum salaries could be driving the average and it may not be a equitable representation. The average pay is again, higher for females 
than the males within categories of single or married. The non-sales single male earns on an average slightly higher than the non-sales
married female while the lowest average is for married males who are non-sales employee. As long as the Person Type and 
Marital Status is the same, it is evident that Females have a higher average pay. */









