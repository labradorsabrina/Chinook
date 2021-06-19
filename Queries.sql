--All the tracks that have a length of 5,000,000 milliseconds or more
SELECT Name
FROM Track
WHERE Milliseconds > 5000000

--All the invoices whose total is between $5 and $15 dollars
SELECT *
FROM Invoice
WHERE Total > 5 AND Total < 15;

--All the customers from the following States: RJ, DF, AB, BC, CA, WA, NY.
SELECT *
FROM Customers
WHERE State IN ("RJ", "DF", "AB", "BC", "CA", "WA", "NY");

--All the invoices for customer 56 and 58 where the total was between $1.00 and $5.00.
SELECT *
FROM Invoices
WHERE CustomerId IN ("56", "58") AND Total > 1 AND Total < 5;

--All the tracks whose name starts with 'All'
SELECT *
FROM Tracks
WHERE Name LIKE "All%";

--All the customer emails that start with "J" and are from gmail.com
SELECT Email
FROM Customers
WHERE Email LIKE "J%@gmail.com";

--All the invoices from the billing city Brasília, Edmonton, and Vancouver and sort in descending order by invoice ID.
SELECT *
FROM Invoice
WHERE BillingCity IN ("Brasília", "Edmonton", "Vancouver")
ORDER BY InvoiceId DESC;

--Show the number of orders placed by each customer (hint: this is found in the invoices table) and sort the result by the number of orders in descending order.
SELECT CustomerId, COUNT(InvoiceId) AS Orders
FROM Invoice
GROUP BY CustomerId
ORDER BY Orders DESC;

--Find the albums with 12 or more tracks
SELECT AlbumId, COUNT(TrackId) 
FROM Track
GROUP BY AlbumId
HAVING COUNT(TrackId) >= 12
ORDER BY COUNT(TrackId) DESC;

--How many albums does the artist Led Zeppelin have? 
SELECT COUNT(AlbumId) AS LedZeppelin
FROM album
WHERE ArtistId IN (SELECT ArtistId FROM artist WHERE Name = "Led Zeppelin");

--List of album titles and the unit prices for the artist "Audioslave"
SELECT tra.AlbumId
	,tra.Name
	,tra.TrackiD
	,alb.title
	,tra.unitprice
	#tra.unitprice*count(Tra.TrackId) as TOTALPRICEALB
FROM track tra
INNER JOIN album alb ON alb.albumId = tra.albumId
WHERE alb.ArtistId IN (SELECT ArtistId FROM artist WHERE Name = "Audioslave");

--Are there any customers who does not have an invoice?
SELECT COUNT(*) AS CustomersNoInvoice
FROM Customer
WHERE CustomerId NOT IN (SELECT CustomerId FROM invoice);

--Total price for each album
SELECT AL.Title, SUM(TR.UnitPrice)
FROM album AS AL
INNER JOIN track AS TR ON AL.AlbumId = TR.AlbumId
GROUP BY AL.Title;
--WHERE AL.Title = "Big Ones";

--How many records are created when you apply a Cartesian join to the invoice and invoice items table?
SELECT  IV.InvoiceId, II.InvoiceId
FROM invoice AS IV, invoiceLine AS II;

--Using a subquery, find the names of all the tracks for the album "Californication".
SELECT TrackId, Name
FROM track
WHERE AlbumId IN (SELECT AlbumId FROM album WHERE Title = 'Californication');

--Find the total number of invoices for each customer along with the customer's full name, city and email
SELECT COUNT(IV.InvoiceId) AS TotalInvoices, 
        CONCAT(CT.LastName, " ", CT.FirstName) AS FullName,
        CT.City,
        CT.Email
FROM invoice AS IV
INNER JOIN customer AS CT ON IV.customerId = CT.customerId
GROUP BY IV.customerId
ORDER BY TotalInvoices;

--Retrieve the track name, album, artistID, and trackID for all the albums
SELECT TR.name as TrackName,
		TR.albumId,
        AL.Title,
        AL.artistID,
        TR.trackID
FROM track AS TR
INNER JOIN album AS AL ON TR.albumId = AL.albumId;

--Retrieve a list with the managers last name, and the last name of the employees who report to him or her
SELECT
    EM.LastName AS EmployeeLastName
   ,MA.LastName AS ManagerLastName
FROM Employee AS EM
INNER JOIN Employee AS MA ON EM.ReportsTo = MA.EmployeeId
ORDER BY ManagerLastName;

--Find the name and ID of the artists who do not have albums. 
SELECT AR.Name, AR.ArtistId
FROM artist AS AR
LEFT JOIN album AS AL ON AL.ArtistId = AR.ArtistId
WHERE AL.AlbumId IS NULL;

--See if there are any customers who have a different city listed in their billing city versus their customer city.
SELECT C.CustomerId
FROM Customer AS C
INNER JOIN invoice AS I ON C.CustomerId = I.CustomerId
WHERE BillingCity <> City;

--UNION to create a list of all the employee's and customer's first names and last names ordered by the last name in descending order
SELECT FirstName, LastName FROM Employee
UNION
SELECT FirstName, LastName FROM Customer
ORDER BY LastName DESC;


--Pull a list of customer ids with the customer’s full name, and address, along with combining their city and country together. Be sure to make a space in between these two and make it UPPER CASE. (e.g. LOS ANGELES USA)
SELECT CustomerId
    ,CONCAT(FirstName," ",LastName) AS FullName
    ,CONCAT(Address,", ",UPPER(City)," - ",UPPER(Country)) AS Address
FROM Customer;

--Create a new employee user id by combining the first 4 letters of the employee’s first name with the first 2 letters of the employee’s last name. Make the new field lower case and pull each individual step to show your work.
SELECT LOWER(SUBSTR(FirstName, 1, 4)) || LOWER(SUBSTR(LastName, 1, 2)) AS NewUserID
        ,CONCAT(FirstName," ",LastName) AS FullName
FROM Employee;

--Show a list of employees who have worked for the company for 15 or more years using the current date function. Sort by lastname ascending.
SELECT FirstName
        ,LastName
        ,TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) AS Years
FROM Employee
WHERE TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) >= 15
ORDER BY LastName ASC

--Profiling the Customers table
SELECT 
    SUM(CASE WHEN Phone is null then 1 else 0 end) AS Phone 
    ,SUM(CASE WHEN PostalCode is null then 1 else 0 end) AS PostalCode
    ,SUM(CASE WHEN Address is null then 1 else 0 end) AS Address
    ,SUM(CASE WHEN Fax is null then 1 else 0 end) AS Fax
    ,SUM(CASE WHEN Company is null then 1 else 0 end) AS Company
    ,SUM(CASE WHEN FirstName is null then 1 else 0 end) AS FirstName
FROM Customer;

--Find the cities with the most customers and rank in descending order.
SELECT City, COUNT(*) AS Count
FROM Customer
GROUP BY City
ORDER BY COUNT(*) DESC;

--Create a new customer invoice id by combining a customer’s invoice id with their first and last name while ordering your query in the following order: firstname, lastname, and invoiceID.
SELECT CONCAT(C.FirstName, C.LastName, I.InvoiceId) AS NewInvoiceID
FROM Invoice AS I
INNER JOIN Customer AS C ON C.CustomerId = I.CustomerId;