USE OOVEO_Salon


--1.	Display Maximum Price (obtained from the maximum price of all treatment), Minimum Price (obtained from minimum price of all treatment), and Average Price (obtained by rounding the average value of Price in 2 decimal format). 

SELECT MAX(MsTreatment.Price) AS 'Maximum Price', MIN(MsTreatment.Price) AS 'Minimum Price', ROUND(CAST(AVG(MsTreatment.Price) AS NUMERIC(38,2)),0) AS 'Average Price' FROM MsTreatment

--2.	Display StaffPosition, Gender (obtained from first character of staff’s gender), and Average Salary (obtained by adding ‘Rp.’ in front of the average of StaffSalary in 2 decimal format).

SELECT MsStaff.StaffPosition, LEFT(MsStaff.StaffGender,1) AS Gender,  'Rp. ' +CAST(CAST(AVG(MsStaff.StaffSalary) AS DECIMAL(18,2)) AS VARCHAR) AS 'Average Salary'
FROM MsStaff
GROUP BY MsStaff.StaffPosition, MsStaff.StaffGender


--3.	Display TransactionDate (obtained from TransactionDate in ‘Mon dd,yyyy’ format), and Total Transaction per Day (obtained from the total number of transaction).

SELECT CONVERT(VARCHAR, TransactionDate, 107) AS 'Transaction Date', COUNT(TransactionID) AS 'Total Transaction per Day'
FROM HeaderSalonServices
GROUP BY TransactionDate

--4.	Display CustomerGender (obtained from customer’s gender in uppercase format), and Total Transaction (obtained from the total number of transaction).

SELECT UPPER(MsCustomer.CustomerGender) AS CustomerGender, COUNT(HeaderSalonServices.TransactionId) AS 'Total Transaction'
FROM MsCustomer
JOIN HeaderSalonServices
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
GROUP BY MsCustomer.CustomerGender

--5.	Display TreatmentTypeName, and Total Transaction (obtained from the total number of transaction). Then sort the data in descending format based on the total of transaction.

SELECT MsTreatmentType.TreatmentTypeName, COUNT(HeaderSalonServices.TransactionId) AS 'Total Transaaction'
FROM MsTreatmentType
JOIN MsTreatment
ON MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
JOIN DetailSalonServices
ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
JOIN HeaderSalonServices
ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
GROUP BY MsTreatmentType.TreatmentTypeName
ORDER BY COUNT(HeaderSalonServices.TransactionId) DESC


--6.	Display Date (obtained from TransactionDate in ‘dd mon yyyy’ format), Revenue per Day (obtained by adding ‘Rp. ’ in front of the total of price) for every transaction which Revenue Per Day is between 1000000 and 5000000.

SELECT CONVERT(VARCHAR, HeaderSalonServices.TransactionDate, 106) AS 'Date', 'Rp. ' + CAST(SUM(MsTreatment.Price) AS VARCHAR) AS 'Revenue per Day'
FROM HeaderSalonServices
JOIN DetailSalonServices
ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
JOIN MsTreatment
ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
GROUP BY HeaderSalonServices.TransactionDate
HAVING SUM(MsTreatment.Price) BETWEEN 1000000 AND 5000000

--7.	Display ID (obtained by replacing ‘TT0’ in TreatmentTypeID with ‘Treatment Type’), TreatmentTypeName, and Total Treatment per Type (obtained from the total number of treatment and ended with ‘ Treatment ’) for treatment type that consists of more than 5 treatments. Then sort the data in descending format based on Total Treatment per Type.

SELECT REPLACE(MsTreatmentType.TreatmentTypeId, 'TT0', 'Treatment Type ') AS ID, 
		MsTreatmentType.TreatmentTypeName,
		CAST(COUNT(MsTreatment.TreatmentId) AS VARCHAR) + ' Treatment' AS 'Total Treatment per Type' 
	FROM MsTreatmentType
	JOIN MsTreatment
	ON MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
	GROUP BY MsTreatmentType.TreatmentTypeId, MsTreatmentType.TreatmentTypeName
	HAVING COUNT(MsTreatment.TreatmentId) > 5
	ORDER BY COUNT(MsTreatment.TreatmentId) DESC

--8.	Display StaffName (obtained from first character of staff’s name until character before space), TransactionID, and Total Treatment per Transaction (obtained from the total number of treatment).

SELECT LEFT(MsStaff.StaffName, CHARINDEX(' ', StaffName)) AS StaffName, HeaderSalonServices.TransactionId, COUNT(MsTreatment.TreatmentId) AS ' Total Treatment per Transaction'
FROM MsStaff
JOIN HeaderSalonServices
ON HeaderSalonServices.StaffId = MsStaff.StaffId
JOIN DetailSalonServices
ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
JOIN MsTreatment
ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
GROUP BY StaffName, HeaderSalonServices.TransactionId


--9.	Display TransactionDate, CustomerName, TreatmentName, and Price for every transaction which happened on ‘Thursday’ and handled by Staff whose name contains the word ‘Ryan’. Then order the data based on TransactionDate and CustomerName in ascending format.

SELECT HeaderSalonServices.TransactionDate, MsCustomer.CustomerName, MsTreatment.TreatmentName, MsTreatment.Price
FROM MsCustomer
JOIN HeaderSalonServices
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
JOIN DetailSalonServices
ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
JOIN MsTreatment
ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
JOIN MsStaff
ON MsStaff.StaffId = HeaderSalonServices.StaffId
WHERE DATENAME(WEEKDAY,HeaderSalonServices.TransactionDate) = 'Thursday' AND MsStaff.StaffName LIKE '%ryan%' 
ORDER BY TransactionDate, CustomerName ASC;

--10.	Display TransactionDate, CustomerName, and TotalPrice (obtained from the total amount of price) for every transaction that happened after 20th day. Then order the data based on TransactionDate in ascending format.

SELECT HeaderSalonServices.TransactionDate, MsCustomer.CustomerName, SUM(MsTreatment.Price) AS 'TotalPrice'
FROM HeaderSalonServices
JOIN MsCustomer
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId 
JOIN DetailSalonServices
ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId

JOIN MsTreatment
ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
WHERE DATEPART(DD, HeaderSalonServices.TransactionDate) > 20
GROUP BY HeaderSalonServices.TransactionDate, MsCustomer.CustomerName
ORDER BY HeaderSalonServices.TransactionDate ASC

